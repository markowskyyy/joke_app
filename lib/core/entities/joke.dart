class Joke {
  final String setup;
  final String punchline;
  final String category;
  final int id;
  late final bool isFavorite;

  Joke({
    required this.setup,
    required this.punchline,
    required this.category,
    required this.id,
    this.isFavorite = false,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      setup: json['setup'],
      punchline: json['punchline'],
      category: json['type'],
      id: json['id'],
    );
  }

  Joke.copy(Joke other)
      : setup = other.setup,
        punchline = other.punchline,
        category = other.category,
        id = other.id,
        isFavorite = other.isFavorite;
}
