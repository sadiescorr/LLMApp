import 'package:flutter/foundation.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

// provider for local LLM.
class LocalLlmProvider extends ChangeNotifier implements LlmProvider {

  // stores all messages in our conversation.
  final List<ChatMessage> _history = [];

  // give LlmChatView access to our conversation.
  @override
  Iterable<ChatMessage> get history => _history;

  // allows the chat history to be changed.
  @override
  set history(Iterable<ChatMessage> messages) {
    _history
      ..clear()
      ..addAll(messages);

    // tell LlmChatView history changed.
    notifyListeners();
  }

  // Called when the user sends a message.
  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {

    // Add the user's message to our history.
    _history.add(
      ChatMessage.user(
        prompt,
        attachments,
      ),
    );

    // tell chat UI to update.
    notifyListeners();

    // TEMPORARY response.
    const response = 'Hello Sadie!';

    // add AI response to our history.
    _history.add(
      ChatMessage.llm()..text = response,
    );

    // tell chat UI about the new AI message.
    notifyListeners();

    // send response back to LlmChatView.
    yield response;
  }

  // generates a response without changing chat history.
  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {

    // Temporary response.
    yield 'Hello Sadie!';
  }
}