import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joke_app/core/core_widgets/joke_widget.dart';
import 'package:joke_app/screens/favorite_joke_list/favorite_joke_list_screen_view_model.dart';
import 'package:provider/provider.dart';


class FavoriteJokeListScreen extends StatelessWidget {
  const FavoriteJokeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранные шутки'),
      ),
      body: Consumer<FavoriteJokeListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.favoriteJokes.isEmpty) {
            // Показываем индикатор загрузки, если нет избранных шуток
            return Center(child: CupertinoActivityIndicator());
          }

          return ListView.builder(
            itemCount: viewModel.favoriteJokes.length,
            itemBuilder: (context, index) {
              final joke = viewModel.favoriteJokes[index];

              return JokeWidget(
                joke: joke,
                isVisible: true,
                isFavorite: joke.isFavorite,
                addFavoriteFunc: () {
                  // Можно сделать функционал для удаления из избранных
                  viewModel.removeFavoriteJoke(joke.id);
                },
                togglePunchlineFunc: () {
                  // Для избранных шуток можно оставить видимость punchline всегда
                },
              );
            },
          );
        },
      ),
    );
  }
}
