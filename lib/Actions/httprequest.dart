import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> _getPreciseAddress(double latitude, double longitude) async {
  final apiKey = 'YOUR_GOOGLE_API_KEY';
  final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['status'] == 'OK') {
      final results = data['results'] as List<dynamic>;
      if (results.isNotEmpty) {
        final address = results[0]['formatted_address'] as String;
        return address;
      }
    }
  }

  return null;
}
