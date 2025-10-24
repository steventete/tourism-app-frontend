import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:tourism_app/services/api_service.dart';
import 'package:tourism_app/utils/theme_controller.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({
    super.key,
    required this.title,
    required this.themeController,
  });

  final String title;
  final ThemeController themeController;

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _messages = [];
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _showLoader = false;
  bool _showIntro = true;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _micAnimationController;

  final List<String> _suggestedQuestions = [
    "Recomiéndame hoteles baratos",
    "Recomiéndame restaurantes tradicionales",
    "Recomiéndame clubs nocturnos",
    "Qué lugares turísticos puedo visitar cerca",
    "Dónde puedo ver atardeceres en Cartagena",
  ];

  final List<String> _cartagenaGreetings = [
    "¡Ajá! ¿Pa' dónde vamos hoy?",
    "¡Quiubo, llave! ¿Listo pa' turistear?",
    "¡Oye bien! Cartagena te espera",
    "¡Mi hermano! Te tengo los mejores planes.",
    "¡Qué más pues, papá! Vamos a recorrer la Heroica.",
    "¡Ajá, mijo! Le tengo lo mejorcito de la costa.",
    "¡Uff, pelao! Hoy hay buen sol pa’ pasear.",
    "¡Mi llave, no se diga más!",
    "¡Oye! Cartagena está encendida hoy.",
  ];

  late String _randomGreeting;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _randomGreeting =
        _cartagenaGreetings[Random().nextInt(_cartagenaGreetings.length)];

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
      _showIntro = false;
      _messages.add({"text": question, "isUser": true});
      _controller.clear();
      _showLoader = true;
    });

    _scrollToBottom();

    try {
      final aiResponse = await ApiService.askAI(question);
      final String answer = aiResponse.answer;
      final List<dynamic> contextUsed = aiResponse.contextUsed;

      setState(() {
        _messages.add({
          "text": answer,
          "isUser": false,
          "contextUsed": contextUsed,
        });
        _showLoader = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({
          "text": "Ocurrió un error al contactar la IA.",
          "isUser": false,
        });
        _showLoader = false;
      });
    }

    _scrollToBottom();
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
    final isDark = widget.themeController.isDarkMode;
    const primaryColor = Color(0xFF0ba6da);

    if (!isUser) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: const EdgeInsets.all(14),
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE8F7FB),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          child: MarkdownBlock(
            data: text,
            config: isDark
                ? MarkdownConfig.darkConfig.copy(configs: [
                    PConfig(textStyle: const TextStyle(color: Colors.white70)),
                  ])
                : MarkdownConfig.defaultConfig,
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildMicButton() {
    final isDark = widget.themeController.isDarkMode;
    return GestureDetector(
      onTap: _listen,
      child: AnimatedBuilder(
        animation: _micAnimationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _isListening ? 1 + (_micAnimationController.value * 0.2) : 1,
            child: CircleAvatar(
              radius: 26,
              backgroundColor: _isListening
                  ? const Color(0xFF0ba6da)
                  : (isDark ? Colors.grey[800]! : Colors.grey.shade300),
              child: Icon(
                _isListening ? CupertinoIcons.mic_fill : CupertinoIcons.mic,
                color: _isListening
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.black87),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIntroSection() {
    const primaryColor = Color(0xFF0ba6da);
    final isDark = widget.themeController.isDarkMode;

    return AnimatedOpacity(
      opacity: _showIntro ? 1 : 0,
      duration: const Duration(milliseconds: 400),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            _randomGreeting,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _showIntro
                ? _buildSuggestionCards(isDark)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCards(bool isDark) {
    const primaryColor = Color(0xFF0ba6da);
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _suggestedQuestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final question = _suggestedQuestions[index];
          return GestureDetector(
            onTap: () {
              setState(() => _showIntro = false);
              _processQuestion(question);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 220,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                border: Border.all(color: primaryColor.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(1, 2),
                    ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Text(
                  question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0ba6da);
    final isDark = widget.themeController.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
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
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : primaryColor),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildIntroSection(),
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
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColor),
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
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
Expanded(
  child: ConstrainedBox(
    constraints: const BoxConstraints(
      maxHeight: 150, // altura máxima del textfield
    ),
    child: TextField(
      controller: _controller,
      textInputAction: TextInputAction.newline,
      onSubmitted: _processQuestion,
      onTap: () => setState(() => _showIntro = false),
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      minLines: 1,
      maxLines: null, // permite crecer automáticamente
      decoration: InputDecoration(
        hintText: "Habla o escribe tu mensaje...",
        hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
        filled: true,
        fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
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
