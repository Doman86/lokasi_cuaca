class WeatherModel {
  final DateTime datetime;
  final String weather;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String imageUrl;

  WeatherModel({
    required this.datetime,
    required this.weather,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.imageUrl,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final dateTimeString =
        json['local_datetime']?.toString() ??
        json['datetime']?.toString() ??
        '';

    return WeatherModel(
      datetime: DateTime.tryParse(dateTimeString) ??
          DateTime.now(),

      weather:
          json['weather_desc']?.toString() ??
          'Tidak diketahui',

      temperature:
          double.tryParse(
                json['t']?.toString() ?? '0',
              ) ??
              0,

      humidity:
          int.tryParse(
                json['hu']?.toString() ?? '0',
              ) ??
              0,

      windSpeed:
          double.tryParse(
                json['ws']?.toString() ?? '0',
              ) ??
              0,

      imageUrl:
          json['image']?.toString() ?? '',
    );
  }
}