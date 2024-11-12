import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/bloc/chat_bloc.dart';
import 'package:flutter_gemini/components/chat_list_view.dart';
import 'package:flutter_gemini/components/chat_text_field.dart';
import 'package:flutter_gemini/models/chat_message_model.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatBloc chatBloc = ChatBloc();
  TextEditingController textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool clearMessages = false;

  @override
  void initState() {
    super.initState();
    chatBloc.stream.listen((state) {
      if (state is ChatSuccessState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    textEditingController.dispose();
    chatBloc.close();
    super.dispose();
  }

  void _clearMessages(List<ChatMessageModel> messages) {
    setState(() {
      clearMessages = true;
    });
    // Fluttertoast.showToast(
    //   msg: 'Chat cleared!',
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: Colors.red,
    //   textColor: Colors.white,
    // );
    messages.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            "Chat Cleared!",
            style: GoogleFonts.firaCode(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home Page'),
      //   centerTitle: true,
      // ),
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case (ChatSuccessState):
              List<ChatMessageModel> messages =
                  (state as ChatSuccessState).messages;
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: const [
                        0.1,
                        0.6,
                      ],
                      colors: [
                        Colors.blue.shade800,
                        Colors.black,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Flutter Gemini",
                              style: TextStyle(fontSize: 24),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => _clearMessages(messages),
                                  icon: const Icon(
                                    Icons.clear_rounded,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            return ChatListView(
                              title: Text(messages[index].role == "user"
                                  ? "User 👤"
                                  : "Model 🤖"),
                              message: messages[index].role == "user"
                                  ? Text(
                                      messages[index].parts.first.text,
                                      style: GoogleFonts.firaCode(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    )
                                  : MarkdownBody(
                                      data: messages[index].parts.first.text,
                                      styleSheet: MarkdownStyleSheet(
                                        p: GoogleFonts.firaCode(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                        code: GoogleFonts.firaCode(
                                          fontSize: 16,
                                          color: Colors.grey[300],
                                          backgroundColor: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                      if (chatBloc.generatingResponse)
                        Wrap(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child:
                                  Lottie.asset('assets/loading/loading1.json'),
                            )
                          ],
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: ChatTextField(
                                textEditingController: textEditingController,
                                chatHintText: "Ask Gemini anything...",
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.image,
                                size: 35,
                              ),
                              color: Colors.white,
                            ),
                            IconButton(
                              onPressed: () {
                                if (textEditingController.text.isNotEmpty) {
                                  String text = textEditingController.text;
                                  textEditingController.clear();
                                  chatBloc.add(
                                    ChatGenerateNewTextMessageEvent(
                                        inputMessage: text),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.send,
                                size: 35,
                              ),
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );

            default:
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: const [
                      0.1,
                      0.6,
                    ],
                    colors: [
                      Colors.blue.shade800,
                      Colors.black,
                    ],
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Something went wrong!",
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    )
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
