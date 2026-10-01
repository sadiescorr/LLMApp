// Imports Flutter's Material Design widgets.
// Scaffold, AppBar, TextField, buttons, etc.
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma_litertlm/flutter_gemma_litertlm.dart';

import 'providers/local_llm_provider.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

    // initalise Flutter Gemma
    const huggingFaceToken = String.fromEnvironment('HUGGINGFACE_TOKEN');

    await FlutterGemma.initialize(
        huggingFaceToken: huggingFaceToken.isEmpty ? null : huggingFaceToken,
        inferenceEngines: [
            LiteRtLmEngine(),
        ],
    );
	
	// runApp() tells Flutter which widget should be the root
    runApp(const MyApp());
}

Future<void> installModel() async {
  // Install the Gemma model from Hugging Face.
    await FlutterGemma.installModel(
        modelType: ModelType.gemmaIt,
        fileType: ModelFileType.litertlm,
    )
        .fromHuggingFace(
            'litert-community/Gemma3-1B-IT',
            file: 'gemma3-1b-it-int4.litertlm',
        )
        .install();
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

    @override
    State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
    // create LLM + keep alive while page open
    final LocalLlmProvider provider = LocalLlmProvider();

    @override
    Widget build(BuildContext context) {
        return Scaffold(appBar: AppBar(
            title: const Text('LLM App! By Sadie'),

            actions: [
                IconButton(onPressed: downloadModel, icon: const Icon(Icons.download)),
            ]
        ),
      // defined in provider/local_llm provider.dart
        body: LlmChatView(provider: provider
        )
        );
    }

    Future<void> downloadModel() async {
        // install Gemma model
        await installModel();

        setState(() {});
    }
}