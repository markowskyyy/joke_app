import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joke_app/core/entities/joke.dart';
import 'package:joke_app/design.dart';

class JokeWidget extends StatelessWidget {
  final Joke joke;
  final addFavoriteFunc;
  final togglePunchlineFunc;
  const JokeWidget({
    Key? key,
    required this.joke,
    required this.addFavoriteFunc,
    required this.togglePunchlineFunc,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: togglePunchlineFunc,
      child: Card(
        margin: EdgeInsets.all(8),
        color: jokeCategoriesColors[joke.category],
        child: ListTile(
          title: Text(joke.setup),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (joke.isVisible) Text(joke.punchline),
              SizedBox(height: 8),
              Text('${joke.totalCharacters}'),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              joke.isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
              color: joke.isFavorite ? colorFavoriteIcon : colorNotAFavoriteIcon,
            ),
            onPressed: addFavoriteFunc
          ),
        ),
      ),
    );
  }
}
