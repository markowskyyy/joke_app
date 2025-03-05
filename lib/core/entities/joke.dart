class Joke {
  final String setup;
  final String punchline;
  final String category;
  final int id;
  bool isFavorite;
  bool isVisible;

  Joke({
    required this.setup,
    required this.punchline,
    required this.category,
    required this.id,
    this.isFavorite = false,
    this.isVisible = false,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      setup: json['setup'],
      punchline: json['punchline'],
      category: json['type'],
      id: json['id'],
      isFavorite: false,
      isVisible: false,
    );
  }

  int get totalCharacters {
    return setup.length + punchline.length;
  }

  Joke.copy(Joke other)
      : setup = other.setup,
        punchline = other.punchline,
        category = other.category,
        id = other.id,
        isFavorite = other.isFavorite,
        isVisible = other.isVisible;
}
