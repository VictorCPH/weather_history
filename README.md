## WeatherHistory
从 www.wunderground.com 获取天气历史数据，解析json response获得每小时的天气信息，存储到mysql数据库中

mysql数据表 weather_data 结构如下:

| Field        | Type  | describe                                      |
| ------------ | ----- | ---------------------------------------------
| year         | int   | 年份                                          |
| month        | int   | 月份                                          |
| day          | int   | 天数                                          |
| hour         | int   | 小时                                          |
| temperature  | float | 温度，单位：摄氏度                            |
| humidity     | int   | 湿度，单位：%                                 |
| windspeed    | float | 风速，单位：km/h                              |
| weatherType  | int   | snow: 1, rain: 2, fog: 3, hail:4, other: 0    |


## Usage
1. 安装gemfile中的依赖
```
bundle install --path vendor
```

2. 修改配置
```
cp .env.example .env
```
  参考.env中的说明以及自己的需求修改.env文件

3. 从 www.wunderground.com 获取天气信息，并解析存到mysql
```
bundle exec ruby get_weather_history.rb
```

4. 处理错误值，windspeed为0和-9999替换为平均值8.76（这步可选，可自行选择处理错误值的方法）
```
bundle exec ruby handle_error_value.rb
```


