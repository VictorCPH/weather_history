## WeatherHistory
从 www.wunderground.com 获取天气历史数据，解析json response获得每小时的天气信息，存储到mysql数据库中

mysql数据表 weather_data 结构如下:
+-------------+---------+------+-----+---------+-------+
| Field       | Type    | Null | Key | Default | Extra |
+-------------+---------+------+-----+---------+-------+
| year        | int(11) | YES  |     | NULL    |       |
| month       | int(11) | YES  |     | NULL    |       |
| day         | int(11) | YES  |     | NULL    |       |
| hour        | int(11) | YES  |     | NULL    |       |
| temperature | float   | YES  |     | NULL    |       |
| humidity    | int(11) | YES  |     | NULL    |       |
| windspeed   | float   | YES  |     | NULL    |       |
| weatherType | int(11) | YES  |     | NULL    |       |
+-------------+---------+------+-----+---------+-------+


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


