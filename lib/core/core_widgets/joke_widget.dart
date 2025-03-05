import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joke_app/core/entities/joke.dart';
import 'package:joke_app/design.dart';

class JokeWidget extends StatelessWidget {
  final Joke joke;
  final bool isVisible;
  final bool isFavorite;
  final addFavoriteFunc;
  final togglePunchlineFunc;
  const JokeWidget({
    Key? key,
    required this.joke,
    required this.isVisible,
    required this.isFavorite,
    required this.addFavoriteFunc,
    required this.togglePunchlineFunc,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: togglePunchlineFunc,
      child: Card(
        margin: EdgeInsets.all(8),
        child: ListTile(
          title: Text(joke.setup),
          subtitle: isVisible ? Text(joke.punchline) : null,
          trailing: IconButton(
            icon: Icon(
              isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
              color: isFavorite ? colorFavoriteIcon : colorNotAFavoriteIcon,
            ),
            onPressed: addFavoriteFunc
          ),
        ),
      ),
    );
  }
}
