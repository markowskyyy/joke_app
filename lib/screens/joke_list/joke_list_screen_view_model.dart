import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joke_app/core/entities/joke.dart';
import 'package:joke_app/data/services/joke_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JokeListViewModel extends ChangeNotifier {
  final JokeService jokeService;

  JokeListViewModel({required this.jokeService}) {
    _loadFavouritesAndChageFields();
  }

  bool _isLoadnig = false;
  bool get isLoadnig => _isLoadnig;

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

  // подгрузка шуток / категорий

  Future<void> fetchCategories() async {
    try {
      _categories = await jokeService.fetchJokeTypes();
      // Добавляем "any" - для всех категорий
      _categories.add('any');
      _categories.add('favourites');
      notifyListeners();
    } catch (e) {
      print('Failed to load categories: $e');
    }
  }

  Future<void> fetchJokes({int numberOfJokes = 10}) async {
    _isLoadnig = true;
    notifyListeners();

    if (_filter == 'any') {
      _jokes = await jokeService.fetchRandomJokes(numberOfJokes: numberOfJokes);
    } else if (_filter == 'favourites') {
      _jokes = await fetchFavouriteJokes();
    } else {
      _jokes = await jokeService.fetchJokesByType(_filter);
    }

    _jokeVisibility = {for (var i = 0; i < _jokes.length; i++) i: false};
    _jokesCopy = jokes;

    _isLoadnig = false;
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
    _jokes[index].isVisible = !_jokes[index].isVisible;
    notifyListeners();
  }

  // добавление / подгрузка Joke в избранные

  Future<List<Joke>> fetchFavouriteJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds = prefs.getStringList('favorite_jokes');

    if (favoriteIds != null && favoriteIds.isNotEmpty) {
      List<Joke> jokes = [];

      for (String id in favoriteIds) {
        Joke joke = await jokeService.fetchJokeById(int.parse(id));
        joke.isFavorite = true;
        jokes.add(joke);
      }
      return jokes;
    }

    return [];
  }


  Future<void> _loadFavouritesAndChageFields() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds = prefs.getStringList('favorite_jokes');

    if (favoriteIds != null) {
      for (var joke in _jokes) {
        joke.isFavorite = favoriteIds.contains(joke.id.toString());
      }
    }
  }

  Future<void> toggleFavourite({required Joke joke}) async {
    joke.isFavorite = !joke.isFavorite;

    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList('favorite_jokes') ?? [];

    if (favoriteIds.contains(joke.id.toString())) {
      favoriteIds.remove(joke.id.toString());
      if (filter == 'favourites') _jokes.removeWhere((item) => item.id == joke.id);
    } else {
      favoriteIds.add(joke.id.toString());
    }
    notifyListeners();
    await prefs.setStringList('favorite_jokes', favoriteIds);
  }


  // копирование в буфер

  Future<void> copyJokesToClipboard({required context}) async {
    // Фильтрация шуток по текущим активным фильтрам и поисковым запросам
    List<Joke> filteredJokes = _jokes;

    // Формируем строку для копирования
    String jokesText = filteredJokes.map((joke) {
      return '[${joke.category}] ${joke.setup} → ${joke.punchline}';
    }).join('\n');

    // Копируем текст в буфер обмена
    await Clipboard.setData(ClipboardData(text: jokesText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Jokes copied ')),
    );
    notifyListeners();
  }

}
