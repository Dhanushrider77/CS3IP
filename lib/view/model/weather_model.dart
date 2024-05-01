class WeatherModel {
  final String temp;
  final String city;
  final String desc;
  final String main;
  WeatherModel.fromMap(Map<String, dynamic> json)
      : temp = json['main']['temp'].toString(),
        city = json['name'],
        desc = json['weather'][0]['description'],
        main = json['weather'][0]['main'];
}