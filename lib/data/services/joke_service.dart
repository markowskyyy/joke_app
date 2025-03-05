import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:joke_app/core/entities/joke.dart';

class JokeService {

  static const String baseUrl = 'https://official-joke-api.appspot.com';

  // Метод для получения одной случайной шутки
  Future<Joke> fetchRandomJoke() async {
    final response = await http.get(Uri.parse('$baseUrl/random_joke'));

    if (response.statusCode == 200) {
      // Преобразуем JSON в объект Joke
      var jsonResponse = json.decode(response.body);
      return Joke.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load a random joke');
    }
  }

  // Метод для получения случайных шуток
  Future<List<Joke>> fetchRandomJokes({int numberOfJokes = 10}) async {
    final response = await http.get(Uri.parse('$baseUrl/jokes/random/$numberOfJokes'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => Joke.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load jokes');
    }
  }

  // Метод для получения шуток по типу
  Future<List<Joke>> fetchJokesByType(String type, {int numberOfJokes = 10}) async {
    final response = await http.get(Uri.parse('$baseUrl/jokes/$type/random/$numberOfJokes'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => Joke.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load jokes by type');
    }
  }

  // Метод для получения типов шуток
  Future<List<String>> fetchJokeTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/types'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return List<String>.from(jsonResponse);
    } else {
      throw Exception('Failed to load joke types');
    }
  }
}
