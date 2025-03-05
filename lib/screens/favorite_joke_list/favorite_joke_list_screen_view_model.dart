import 'package:flutter/cupertino.dart';
import 'package:joke_app/core/entities/joke.dart';
import 'package:joke_app/data/services/joke_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteJokeListViewModel extends ChangeNotifier {
  final JokeService jokeService;

  FavoriteJokeListViewModel({required this.jokeService});

  List<Joke> _favoriteJokes = [];
  List<Joke> get favoriteJokes => _favoriteJokes;

  Future<void> loadFavoriteJokes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoriteIds = prefs.getStringList('favoriteJokesIds');

    if (favoriteIds != null) {
      List<Joke> jokes = [];
      for (String id in favoriteIds) {
        Joke joke = await jokeService.fetchJokeById(int.parse(id));
        jokes.add(joke);
      }
      _favoriteJokes = jokes;
      notifyListeners();
    }
  }

  Future<void> removeFavoriteJoke(int jokeId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds = prefs.getStringList('favoriteJokesIds') ?? [];

    favoriteIds.removeWhere((id) => id == jokeId.toString());
    await prefs.setStringList('favoriteJokesIds', favoriteIds);
    _favoriteJokes = _favoriteJokes.where((joke) => joke.id != jokeId).toList();

    notifyListeners();
  }



}
