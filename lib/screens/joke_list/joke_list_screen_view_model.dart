import 'package:flutter/material.dart';
import 'package:joke_app/core/entities/joke.dart';
import 'package:joke_app/data/services/joke_service.dart';

class JokeViewModel extends ChangeNotifier {
  final JokeService jokeService;

  JokeViewModel({required this.jokeService});

  List<Joke> _jokes = [];
  List<Joke> get jokes => _jokes;

  // лист шуток для поиска
  List<Joke> _jokesCopy = [];

  List<String> _categories = [];
  List<String> get categories => _categories;

  String _filter = 'any';
  String get filter => _filter;

  Map<int, bool> _jokeVisibility = {};

  void setFilter(String filter) {
    _filter = filter;
    fetchJokes();
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    try {
      _categories = await jokeService.fetchJokeTypes();
      // Добавляем "any" - для всех категорий
      _categories.add('any');
      notifyListeners();
    } catch (e) {
      print('Failed to load categories: $e');
    }
  }

  Future<void> fetchJokes({int numberOfJokes = 10}) async {

    if (_filter == 'any') {
      _jokes = await jokeService.fetchRandomJokes(numberOfJokes: numberOfJokes);
    } else {
      _jokes = await jokeService.fetchJokesByType(_filter);
    }

    _jokeVisibility = {for (var i = 0; i < _jokes.length; i++) i: false};
    _jokesCopy = jokes;
    notifyListeners();

  }

  void searchJokes(String query) {

    _jokes = List.from(_jokesCopy.map((joke) => Joke.copy(joke)));
    _jokes = _jokes
        .where((joke) => joke.setup.toLowerCase().contains(query.toLowerCase()) ||
        joke.punchline.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void togglePunchline({required int index}) {
    _jokeVisibility[index] = !_jokeVisibility[index]!;
    notifyListeners();
  }

  bool isPunchlineVisible({required int index}) {
    return _jokeVisibility[index] ?? false;
  }

  void toggleFavorite({required Joke joke}) {
    // Логика добавления в избранное, можно хранить в локальном хранилище или в памяти
  }
}
