import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/bloc/chat_bloc.dart';
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
  bool clear_messages = false;

  @override
  void initState() {
    super.initState();
  }

  void _clearMessages(List<ChatMessageModel> messages) {
    setState(() {
      clear_messages = true;
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
        content: Text("Chat Cleared!",
            style: GoogleFonts.firaCode(
              color: Colors.white,
            )),
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
                                // IconButton(
                                //   onPressed: () {},
                                //   icon: const Icon(
                                //     Icons.image_search,
                                //     size: 24,
                                //     color: Colors.white,
                                //   ),
                                // )
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.grey.withOpacity(0.1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    messages[index].role == "user"
                                        ? "User 👤"
                                        : "Model 🤖",
                                    style: GoogleFonts.firaCode(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 0.5,
                                    indent: 0,
                                    endIndent: 100,
                                    color: Colors.white,
                                  ),
                                  messages[index].role == "user"
                                      ? Text(
                                          messages[index].parts.first.text,
                                          style: GoogleFonts.firaCode(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        )
                                      : MarkdownBody(
                                          data:
                                              messages[index].parts.first.text,
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
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      if (chatBloc.generatingResponse)
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Lottie.asset('assets/loading/loading1.json'),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 16),
                        // color: Colors.white,
                        // height: 120,
                        child: Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
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
                                    hintText: "Ask Gemini anything...",
                                    hintStyle: GoogleFonts.firaCode(
                                      fontSize: 16,
                                      color: Colors.grey[400],
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          const BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  minLines: 1,
                                  maxLines: 5,
                                ),
                              ),
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
                                color: Colors.blue),
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
