import 'package:flutter/material.dart';
import 'package:joke_app/screens/joke_list/joke_list_screen_view.dart';
import 'package:joke_app/screens/joke_list/joke_list_screen_view_model.dart';
import 'package:provider/provider.dart';

import 'data/services/joke_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // services
        Provider<JokeService>(create: (_) => JokeService()),

        // view models
        ChangeNotifierProvider<JokeListViewModel>(
          create: (context) => JokeListViewModel(jokeService: Provider.of<JokeService>(context, listen: false)),
        ),
      ],
      child: MaterialApp(
        home: const JokeListScreen(),
      ),
    );
  }
}

