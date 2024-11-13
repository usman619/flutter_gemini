import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String chatHintText;
  final Widget? imagePreview;
  const ChatTextField({
    super.key,
    required this.textEditingController,
    required this.chatHintText,
    this.imagePreview,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: TextField(
        controller: textEditingController,
        style: GoogleFonts.firaCode(
          fontSize: 16,
          color: Colors.black,
        ),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          hintText: chatHintText,
          hintStyle: GoogleFonts.firaCode(
            fontSize: 16,
            color: Colors.grey[400],
          ),
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
        minLines: 1,
        maxLines: 5,
      ),
    );
  }
}
