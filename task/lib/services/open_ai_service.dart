import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiUrl = 'https://api.openai.com/v1/chat/completions';
  final String apiKey = ''
  ;

  Future<String> getResponse(String prompt) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4',
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes); // Decode properly
      final data = jsonDecode(decodedBody);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to fetch AI response: ${response.statusCode}');
    }
  }
}