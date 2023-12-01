import 'package:desafioescribo2/tabs/favarite_tab.dart';
import 'package:desafioescribo2/tabs/home_tab.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Estante de Livros"),
        ),
        body: Column(children: [
          TabBar(tabs: [
            Tab(
              icon: Icon(
                Icons.book,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
            Tab(
              icon: Icon(Icons.bookmark, color: Color.fromRGBO(0, 0, 0, 1)),
            )
          ]),
          Expanded(
            child: TabBarView(children: [
              HomeTab(context),
              FavoriteTab(context)
            ]),
          )
        ]),
      ),
    );
  }
}
