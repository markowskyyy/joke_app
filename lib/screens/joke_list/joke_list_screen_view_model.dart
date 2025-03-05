import 'package:flutter/material.dart';
import 'package:joke_app/core/entities/joke.dart';
import 'package:joke_app/data/services/joke_service.dart';

class JokeViewModel extends ChangeNotifier {
  final JokeService jokeService;

  JokeViewModel({required this.jokeService});

  List<Joke> _jokes = [];
  List<Joke> get jokes => _jokes;

  List<String> _categories = [];
  List<String> get categories => _categories;

  String _filter = 'any';
  String get filter => _filter;

  // Переменна показывающая видно ли punchline
  Map<int, bool> _jokeVisibility = {};

  // Функция для изменения фильтра категории
  void setFilter(String filter) {
    _filter = filter;
    fetchJokes();
    notifyListeners();
  }

  // Функция для получения типов шуток
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

  // Функция для получения шуток из API
  Future<void> fetchJokes({int numberOfJokes = 10}) async {
    try {

      if (_filter == 'any') {
        _jokes = await jokeService.fetchRandomJokes(numberOfJokes: numberOfJokes);
      } else {
        _jokes = await jokeService.fetchJokesByType(_filter, numberOfJokes: numberOfJokes);
      }

      // Небольшой цикл делающий все punchline скрытыми по умолчанию
      _jokeVisibility = {for (var i = 0; i < _jokes.length; i++) i: false};
      notifyListeners();
    } catch (e) {
      print('Failed to load jokes: $e');
    }
  }

  // Функция для поиска по шуткам
  void searchJokes(String query) {
    // Поиск по seput и punchline шуток
    _jokes = _jokes
        .where((joke) => joke.setup.toLowerCase().contains(query.toLowerCase()) ||
        joke.punchline.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  // Функция для переключения видимости punchline
  void togglePunchline(int index) {
    _jokeVisibility[index] = !_jokeVisibility[index]!;
    notifyListeners();
  }

  bool isPunchlineVisible(int index) {
    return _jokeVisibility[index] ?? false;
  }

  // Функция для добавления шутки в избранное
  void toggleFavorite(Joke joke) {
    // Логика добавления в избранное, можно хранить в локальном хранилище или в памяти
  }
}
