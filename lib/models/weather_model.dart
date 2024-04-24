class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;

  Weather({required this.temperature,required this.mainCondition, required this.cityName});

  factory Weather.formJson(Map<String, dynamic> json){
    return Weather(temperature: json['main']['temp'].toDouble(), mainCondition: json['weather'][0]['main'], cityName: json['name']);
  }
}