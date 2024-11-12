import 'package:flutter/material.dart';

class ChatListView extends StatelessWidget {
  final Text title;
  final Widget message;
  const ChatListView({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: ListTile(
        title: title,
        titleTextStyle: const TextStyle(
          fontFamily: 'Doto',
          fontSize: 20,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              thickness: 0.5,
              indent: 0,
              endIndent: 100,
              color: Colors.white,
            ),
            message
          ],
        ),
      ),
    );
  }
}
