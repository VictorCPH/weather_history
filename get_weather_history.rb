require 'wunderground'
require 'dotenv'
require_relative 'resource_accessor'
Dotenv.load

w_api = Wunderground.new(ENV['WUNDERGROUND_APIKEY'])

start_time = Date.parse(ENV['START_TIME'])
end_time = Date.parse(ENV['END_TIME'])

resource_accessor = ResourceAccessor.new
resource_accessor.create_weather_table

def get_date start_time, end_time
  dates = []
  while start_time <= end_time
    dates.push start_time.strftime("%Y%m%d")
    start_time += 1
  end
  dates
end

dates = get_date(start_time, end_time)
country = ENV['COUNTRY']
city = ENV['CITY']

last_record_year = 0
last_record_month = 0
last_record_day = 0
last_record_hour = 0
last_record_windspeed = 0

dates.each do |date|
  puts date
  weather_history = w_api.history_for(date, country, city)

  history_json = weather_history['history']
  observations = history_json['observations']

  observations.each do |hour_record|
    year = hour_record['date']['year'].to_i
    month = hour_record['date']['mon'].to_i
    day = hour_record['date']['mday'].to_i
    hour = hour_record['date']['hour'].to_i
    temperature = hour_record['tempm'].to_f
    humidity = hour_record['hum'].to_i
    windspeed = hour_record['wspdm'].to_f

    if hour_record['snow'] == "1"
      weatherType = 1
    elsif hour_record['rain'] == "1"
      weatherType = 2
    elsif hour_record['fog'] == "1"
      weatherType = 3
    elsif hour_record['hail'] == "1"
      weatherType = 4
    else
      weatherType = 0
    end

    # 由于每个小时的天气信息可能存在多条记录，所以尽可能选择其中一条“最准确的”
    # 选择策略：解析每一条记录，若该条记录的（年月日时）与上一条记录一致,且上条记录的
    #           windspeed存在异常值-9999而本条记录的windspeed正常，则用本条记录替代上条记录
    if last_record_year == year && last_record_month == month \
      && last_record_day == day && last_record_hour == hour
      if last_record_windspeed.to_i == -9999 && windspeed.to_i != -9999
        resource_accessor.update(year, month, day, hour, temperature, humidity, windspeed, weatherType)
      end
    else
      resource_accessor.insert(year, month, day, hour, temperature, humidity, windspeed, weatherType)
    end

    last_record_year = year
    last_record_month = month
    last_record_day = day
    last_record_hour = hour
    last_record_windspeed = windspeed
  end
end

