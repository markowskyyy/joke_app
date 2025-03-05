import 'package:flutter/material.dart';
import 'package:joke_app/core/entities/joke.dart';
import 'package:joke_app/data/services/joke_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JokeListViewModel extends ChangeNotifier {
  final JokeService jokeService;

  JokeListViewModel({required this.jokeService}) {
    _loadFavorites();
  }

  List<Joke> _jokes = [];
  List<Joke> get jokes => _jokes;

  // лист joke для поиска
  List<Joke> _jokesCopy = [];

  List<String> _categories = [];
  List<String> get categories => _categories;

  String _filter = 'any';
  String get filter => _filter;

  Map<int, bool> _jokeVisibility = {};

  // фильтры

  void setFilter(String filter) {
    _filter = filter;
    fetchJokes();
    notifyListeners();
  }

  // подгрузка шутко / категорий

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

  // поиск

  void searchJokes(String query) {

    _jokes = List.from(_jokesCopy.map((joke) => Joke.copy(joke)));
    _jokes = _jokes
        .where((joke) => joke.setup.toLowerCase().contains(query.toLowerCase()) ||
        joke.punchline.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  // отображение puhcline

  void togglePunchline({required int index}) {
    _jokeVisibility[index] = !_jokeVisibility[index]!;
    notifyListeners();
  }

  bool isPunchlineVisible({required int index}) {
    return _jokeVisibility[index] ?? false;
  }

  // добавление / подгрузка Joke в избранные

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds = prefs.getStringList('favorite_jokes');

    if (favoriteIds != null) {
      for (var joke in _jokes) {
        joke.isFavorite = favoriteIds.contains(joke.id.toString());
      }
    }
  }
  void toggleFavorite({required Joke joke}) async {
    joke.isFavorite = !joke.isFavorite;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = _jokes.where((joke) => joke.isFavorite).map((joke) => joke.id.toString()).toList();
    await prefs.setStringList('favorite_jokes', favoriteIds);

    notifyListeners();
  }
}
