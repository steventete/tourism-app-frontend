import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key, required this.title});
  final String title;

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _messages = [];
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  bool _showLoader = false;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _micAnimationController;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage("es-ES");
    _flutterTts.setPitch(1.0);
    _flutterTts.setSpeechRate(0.9);

    _micAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _micAnimationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == "done") {
            setState(() {
              _isListening = false;
              _showLoader = true;
            });
            _speech.stop();
            _processQuestion(_controller.text);
          }
        },
        onError: (val) => debugPrint('onError: $val'),
      );

      if (available) {
        setState(() {
          _isListening = true;
          _showLoader = false;
          _controller.clear();
        });

        _speech.listen(
          localeId: "es_CO",
          onResult: (val) {
            setState(() {
              _controller.text = val.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _processQuestion(String question) async {
    if (question.trim().isEmpty) return;

    setState(() {
      _messages.add({"text": question, "isUser": true});
      _controller.clear();
      _showLoader = true;
    });

    _scrollToBottom();

    await Future.delayed(const Duration(seconds: 2));

    String response;
    if (question.toLowerCase().contains("cartagena")) {
      response = "Cartagena es una ciudad hermosa llena de historia y playas increíbles.";
    } else if (question.toLowerCase().contains("hola")) {
      response = "¡Hola! ¿Cómo estás? Estoy aquí para ayudarte con tus destinos turísticos.";
    } else {
      response = "No estoy seguro, pero puedo ayudarte a buscar información sobre eso.";
    }

    setState(() {
      _messages.add({"text": response, "isUser": false});
      _showLoader = false;
    });

    _scrollToBottom();

    await _flutterTts.speak(response);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF0ba6da) : const Color(0xFFE8F7FB),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(1, 1),
              blurRadius: 3,
            )
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTap: _listen,
      child: AnimatedBuilder(
        animation: _micAnimationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _isListening ? 1 + (_micAnimationController.value * 0.2) : 1,
            child: CircleAvatar(
              radius: 26,
              backgroundColor:
                  _isListening ? const Color(0xFF0ba6da) : Colors.grey.shade300,
              child: Icon(
                _isListening ? CupertinoIcons.mic_fill : CupertinoIcons.mic,
                color: _isListening ? Colors.white : Colors.black87,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0ba6da);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: _messages.length + (_showLoader ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_showLoader && index == _messages.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(primaryColor),
                        ),
                      ),
                    );
                  }
                  final msg = _messages[index];
                  return _buildMessageBubble(msg["text"], msg["isUser"]);
                },
              ),
            ),
            Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _processQuestion,
                      decoration: InputDecoration(
                        hintText: "Habla o escribe tu mensaje...",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _buildMicButton(),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: primaryColor,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () => _processQuestion(_controller.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
