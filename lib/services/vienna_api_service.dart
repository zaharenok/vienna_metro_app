import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/departure.dart';
import '../models/metro_line.dart';
import 'cache_service.dart';

class ViennaApiService {
  static const String _baseUrl = 'http://vtapi.floscodes.net/';
  static const int _requestTimeoutSeconds = 10;

  static Future<List<Departure>> getDepartures(
    String stationName, {
    MetroLineType? line,
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'departures_${stationName}_${line?.toString() ?? 'all'}';

    if (!forceRefresh) {
      final cached = await CacheService.getCache(cacheKey);
      if (cached != null) {
        final data = cached['data'] as List;
        return data
            .map((json) => Departure.fromJson(json as Map<String, dynamic>, stationName))
            .toList();
      }
    }

    try {
      var url = '$_baseUrl?station=$stationName&countdown';
      if (line != null) {
        url += '&line=${MetroLine.getLineName(line)}';
      }

      final response = await http.get(
        Uri.parse(url),
      ).timeout(Duration(seconds: _requestTimeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data is Map && data.containsKey('code')) {
          if (data['code'] == 429) {
            throw ApiRateLimitException(data['message'] as String);
          }
          throw ApiException('API Error: ${data['message']}');
        }

        if (data is List) {
          await CacheService.saveCache(cacheKey, data);
          
          return data
              .map((json) => Departure.fromJson(json as Map<String, dynamic>, stationName))
              .toList();
        }
        
        throw ApiException('Unexpected response format');
      } else if (response.statusCode == 429) {
        throw ApiRateLimitException('Too many requests. Please wait 30 seconds.');
      } else {
        throw ApiException('Failed to load departures: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      
      final cached = await CacheService.getCache(cacheKey);
      if (cached != null) {
        final data = cached['data'] as List;
        return data
            .map((json) => Departure.fromJson(json as Map<String, dynamic>, stationName))
            .toList();
      }
      
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  static Future<Map<String, double>?> getStationCoordinates(String stationName) async {
    final cacheKey = 'geodata_$stationName';

    final cached = await CacheService.getCache(cacheKey);
    if (cached != null) {
      return Map<String, double>.from(cached['data'] as Map);
    }

    try {
      final url = '$_baseUrl?station=$stationName&geodata';
      
      final response = await http.get(
        Uri.parse(url),
      ).timeout(Duration(seconds: _requestTimeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data is Map && data.containsKey('latitude') && data.containsKey('longitude')) {
          final coords = {
            'latitude': (data['latitude'] as num).toDouble(),
            'longitude': (data['longitude'] as num).toDouble(),
          };
          
          await CacheService.saveCache(cacheKey, coords);
          return coords;
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  
  @override
  String toString() => message;
}

class ApiRateLimitException extends ApiException {
  ApiRateLimitException(super.message);
}
