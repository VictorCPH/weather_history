require 'mysql2'

class ResourceAccessor
  def initialize
    @client = Mysql2::Client.new(:host => ENV['HOST'], :username => ENV['USERNAME'],
                                 :password => ENV['PASSWORD'], :database => ENV['DATABASE'])
  end

  def create_weather_table
    @client.query("create table if not exists weather_data(
                    year integer,
                    month integer,
                    day integer,
                    hour integer,
                    temperature float,
                    humidity integer,
                    windspeed float,
                    weatherType integer
                )")
  end

  def update year, month, day, hour, temperature, humidity, windspeed, weatherType
    update_str = "update weather_data set temperature = #{temperature}, humidity = #{humidity},\
                   windspeed = #{windspeed}, weatherType = #{weatherType} where year = #{year} and \
                   month = #{month} and day = #{day} and hour = #{hour}"
    @client.query(update_str)
  end

  def insert year, month, day, hour, temperature, humidity, windspeed, weatherType
    @client.query("insert into weather_data values(#{year}, #{month}, #{day}, #{hour},
                 #{temperature}, #{humidity}, #{windspeed}, #{weatherType})")
  end

  def handle_windspeed_error_value
    @client.query("update weather_data set windspeed = 8.76 where abs(windspeed-(-9999)) <= 1e-6 or abs(windspeed-0) <= 1e-6")
  end
end
