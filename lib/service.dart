import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env/env.dart';

class OpenAIService {
  final String apiKey = Env.apikey;
  List<Map<String, String>> conversationHistory = [
    {
      "role": "system",
      "content": "You are a helpful personal assistant named Amelia. You have the tone of 25 years old woman. Respond with Hello I am Amelia, a personal assistant who can help you with your day to day tasks. in the first response."
    }
  ];

  Future<String> generateResponse(String prompt) async {
    conversationHistory.add({"role": "user", "content": prompt});

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': conversationHistory,
        'max_tokens': 150,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
//      final data = jsonDecode(response.body);
      String assistantResponse = data['choices'][0]['message']['content'];
      conversationHistory.add({"role": "assistant", "content": assistantResponse});
      return assistantResponse;
    } else {
      throw Exception('Failed to generate response: ${response.body}');
    }
  }
}
