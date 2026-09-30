import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LLM App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();

  final List<Map<String, String>> messages = [];

  void sendMessage() {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add({
        'sender': 'user',
        'message': text,
      });

      messages.add({
        'sender': 'ai',
        'message': 'This is where our local LLM will respond 🤖',
      });
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LLM App 🤖'),
      ),

      body: Column(
        children: [

          // Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {

                final message = messages[index];
                final isUser = message['sender'] == 'user';

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.blue
                          : Colors.grey.shade200,

                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Text(
                      message['message']!,
                      style: TextStyle(
                        color: isUser
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Message input
          Padding(
            padding: const EdgeInsets.all(12),

            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: messageController,

                    decoration: InputDecoration(
                      hintText: 'Ask something...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),

                    onSubmitted: (_) => sendMessage(),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}