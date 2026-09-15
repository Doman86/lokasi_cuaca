import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherService {
  Future<List<WeatherModel>> getWeather(String adm4) async {
    if (adm4.isEmpty) {
      throw Exception(
        'Kode wilayah ADM4 tidak tersedia.',
      );
    }

    if (adm4.split('.').length != 4) {
      throw Exception(
        'Kode ADM4 tidak valid: $adm4',
      );
    }

    final url = Uri.parse(
      'https://api.bmkg.go.id/publik/'
      'prakiraan-cuaca?adm4=$adm4',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil data cuaca BMKG. '
        'Status: ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception(
        'Format data cuaca BMKG tidak valid.',
      );
    }

    final result = <WeatherModel>[];

    final dataList = decoded['data'];

    if (dataList is! List) {
      return result;
    }

    for (final item in dataList) {
      if (item is! Map<String, dynamic>) {
        continue;
      }

      final cuaca = item['cuaca'];

      if (cuaca is! List) {
        continue;
      }

      for (final day in cuaca) {
        if (day is! List) {
          continue;
        }

        for (final weather in day) {
          if (weather is Map<String, dynamic>) {
            result.add(
              WeatherModel.fromJson(weather),
            );
          }
        }
      }
    }

    result.sort(
      (a, b) => a.datetime.compareTo(b.datetime),
    );

    return result;
  }
}