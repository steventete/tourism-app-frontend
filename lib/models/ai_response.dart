class AiResponse {
  final String question;
  final String answer;
  final List<dynamic> contextUsed;

  AiResponse({
    required this.question,
    required this.answer,
    required this.contextUsed,
  });

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      contextUsed: json['contextUsed'] ?? [],
    );
  }
}
