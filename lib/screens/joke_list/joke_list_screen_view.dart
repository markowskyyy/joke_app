import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joke_app/core/core_widgets/joke_widget.dart';
import 'package:provider/provider.dart';
import 'package:joke_app/screens/joke_list/joke_list_screen_view_model.dart';

class JokeListScreen extends StatelessWidget {
  const JokeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jokes App'),
      ),
      body: Consumer<JokeListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.categories.isEmpty) {
            viewModel.fetchCategories();
            viewModel.fetchJokes();
            return Center(child: CupertinoActivityIndicator());
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoTextField(
                  onChanged: (query) => viewModel.searchJokes(query),
                  placeholder: 'Search jokes',
                ),
              ),
              DropdownButton<String>(
                value: viewModel.filter,
                items: viewModel.categories.map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                )).toList(),
                onChanged: (value) {
                  if (value != null) {
                    viewModel.setFilter(value);
                  }
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.jokes.length,
                  itemBuilder: (context, index) {
                    final joke = viewModel.jokes[index];
                    final isVisible = viewModel.isPunchlineVisible(index: index);

                    return JokeWidget(
                      joke: joke,
                      isVisible: isVisible,
                      isFavorite: joke.isFavorite,
                      addFavoriteFunc: () {
                        viewModel.toggleFavorite(joke: joke);
                      },
                      togglePunchlineFunc: () {
                        viewModel.togglePunchline(index: index);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

