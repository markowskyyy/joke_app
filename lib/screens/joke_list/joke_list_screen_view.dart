import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      body: Consumer<JokeViewModel>(
        builder: (context, viewModel, child) {
          // Загружаем категории шуток при запуске
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
                  onChanged: (query) {
                    viewModel.searchJokes(query);
                  },
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
                    final isVisible = viewModel.isPunchlineVisible(index);

                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(joke.setup),
                        subtitle: isVisible ? Text(joke.punchline) : null,
                        trailing: IconButton(
                          icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            viewModel.togglePunchline(index); // Тоглим видимость punchline
                          },
                        ),
                      ),
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

