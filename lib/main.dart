// Imports Flutter's Material Design widgets.
// Scaffold, AppBar, TextField, buttons, etc.
import 'package:flutter/material.dart';

void main() {
	
	// runApp() tells Flutter which widget should be the root
  	// (starting point)
  	runApp(const MyApp());
}

// MyApp is the main/root widget of our application.
// StatelessWidget = this widget doesn't
// change while the app is running.
class MyApp extends StatelessWidget {
	
	// Constructor for MyApp.

  	// "super.key" passes the widget's key to the parent class.
  	const MyApp({super.key});

	// builds UI 
 	@override
  	Widget build(BuildContext context) {

		// main wrapper, provides things like nav, fonts, deign, themes etc etc...
    	return MaterialApp(

			// Removes the "DEBUG" banner from corner
      		debugShowCheckedModeBanner: false,
      		title: 'LLM App',

			// control app appearance
      		theme: ThemeData(
        		useMaterial3: true,
      		),
			// home page - created below...
      		home: const ChatPage(),
    );
  }
}

// this is a stateful widget -- chat will change as the user sends messages!
// [] --> ["hello world"]

class ChatPage extends StatefulWidget {
	// constructor for chatpage
  	const ChatPage({super.key});

	// creates obj that stores changing state of screen
  	@override
  	State<ChatPage> createState() => _ChatPageState();
}

// private class; everything that can change wihtin ChatPage 
class _ChatPageState extends State<ChatPage> {

	// cont5rol + read what is in textbox
  	final TextEditingController messageController = TextEditingController();

	// stores all chat messages w/ a map of sender and message
 	final List<Map<String, String>> messages = [];

	// user presses button -> this function
  	void sendMessage() {

		// get text currently inside textbox 
    	final text = messageController.text.trim();

    	if (text.isEmpty) return;

		// tells flutter something has changed -- rebuild UI
		setState(() {
			messages.add({
				'sender': 'user',
				'message': text,
			});

			messages.add({
				'sender': 'ai',
				'message': 'This is where our local LLM will respond...',
			});
		});

		// empty after send
    	messageController.clear();
  	}
	
	// builds the visual interface for ChatPage
  	@override
  	Widget build(BuildContext context) {
		// basic Flutter screen structure
    	return Scaffold(
      		appBar: AppBar(
        	title: const Text('LLM App - Flutter Tutorial'),
      	),

      	body: Column(
        	children: [

			// messages
			Expanded(
				// scroll thropugh past messages
				child: ListView.builder(
				padding: const EdgeInsets.all(16),
				itemCount: messages.length,
				itemBuilder: (context, index) {
					// get current message
					final message = messages[index];
					// check if message sent by user
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