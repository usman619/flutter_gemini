import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/models/chat_message_model.dart';
import 'package:flutter_gemini/repos/chat_repo.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatSuccessState(messages: const [])) {
    on<ChatGenerateNewTextMessageEvent>(chatGenerateNewTextMessageEvent);
  }
  bool generatingResponse = false;
  List<ChatMessageModel> messages = [];

  FutureOr<void> chatGenerateNewTextMessageEvent(
      ChatGenerateNewTextMessageEvent event, Emitter<ChatState> emit) async {
    messages.add(
      ChatMessageModel(
        role: "user",
        parts: [
          ChatPartModel(text: event.inputMessage),
        ],
      ),
    );
    emit(ChatSuccessState(messages: messages));
    generatingResponse = true;
    String generatedText = await ChatRepo.chatTextGenerationRepo(messages);
    if (generatedText.isNotEmpty) {
      messages.add(
        ChatMessageModel(
          role: 'model',
          parts: [
            ChatPartModel(text: generatedText),
          ],
        ),
      );
      emit(ChatSuccessState(messages: messages));
    }
    generatingResponse = false;
  }
}
