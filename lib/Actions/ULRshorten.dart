import 'package:http/http.dart' as http;
Future<String> shortenUrl(String longUrl) async {
  final response = await http.get(Uri.parse('http://tinyurl.com/api-create.php?url=$longUrl'));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to shorten URL');
  }
}