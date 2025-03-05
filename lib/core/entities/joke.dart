class Joke {
  final String setup;
  final String punchline;
  final String category;

  Joke({
    required this.setup,
    required this.punchline,
    required this.category,
  });

  // создание шутки из JSON
  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      setup: json['setup'],
      punchline: json['punchline'],
      category: json['type'],
    );
  }

  Joke.copy(Joke other) : setup = other.setup, punchline = other.punchline, category = other.category;
}
