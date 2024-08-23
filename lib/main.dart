import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange)
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final OpenAIService openAIService = OpenAIService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
  }

  void _sendMessage() async {
    final text = _controller.text;
    if (text.isNotEmpty) {
      setState(() {
        messages.add({'sender': 'user', 'text': text});
      });
      _controller.clear();

      _scrollToBottom();

      final response = await openAIService.generateResponse(text);
      setState(() {
        messages.add({'sender': 'bot', 'text': response.trim()});
      });

      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 100),
                curve: Curves.easeOut,
                );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: message['sender'] == 'user'
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: message['sender'] == 'user'
                              ? Colors.blue[200]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                    child: MarkdownBody(data: message['text'] ?? '',
                        styleSheet: MarkdownStyleSheet(
                            p: GoogleFonts.notoSans(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w500
                                )
                            ),
                            code: GoogleFonts.jetBrainsMono(
                                textStyle: TextStyle(
                                    backgroundColor: Colors.grey[200],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                ),
                            ),
                            codeblockPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            codeblockDecoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10)
                            )
                        )
                    )
                    )],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your prompt',
                      hintStyle: TextStyle(
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

