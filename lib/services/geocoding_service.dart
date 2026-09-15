import 'dart:convert';

import 'package:http/http.dart' as http;

class GeocodingResult {
  final double latitude;
  final double longitude;
  final String displayName;

  const GeocodingResult({
    required this.latitude,
    required this.longitude,
    required this.displayName,
  });
}

class GeocodingService {
  static const String _baseUrl =
      'https://nominatim.openstreetmap.org/search';

  Future<GeocodingResult?> searchLocation({
    required String village,
    required String district,
    required String regency,
    required String province,
  }) async {
    final queries = [
      '$village, $district, $regency, $province, Indonesia',
      '$village, $district, $regency, Indonesia',
      '$village, $regency, $province, Indonesia',
      '$village, $province, Indonesia',
    ];

    for (final query in queries) {
      final result = await _search(query);

      if (result != null) {
        return result;
      }

      await Future.delayed(
        const Duration(milliseconds: 1100),
      );
    }

    return null;
  }

  Future<GeocodingResult?> _search(String query) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'q': query,
        'format': 'jsonv2',
        'limit': '1',
        'countrycodes': 'id',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'User-Agent':
            'api_test2-flutter-weather-app/1.0',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil lokasi. '
        'Status: ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List || decoded.isEmpty) {
      return null;
    }

    final item = decoded.first;

    if (item is! Map<String, dynamic>) {
      return null;
    }

    final latitude = double.tryParse(
      item['lat']?.toString() ?? '',
    );

    final longitude = double.tryParse(
      item['lon']?.toString() ?? '',
    );

    if (latitude == null || longitude == null) {
      return null;
    }

    return GeocodingResult(
      latitude: latitude,
      longitude: longitude,
      displayName:
          item['display_name']?.toString() ??
          query,
    );
  }
}