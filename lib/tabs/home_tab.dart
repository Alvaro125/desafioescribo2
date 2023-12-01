import 'dart:convert';

import 'package:desafioescribo2/entity/book.dart';
import 'package:desafioescribo2/repository/book_repository.dart';
import 'package:desafioescribo2/service/book_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeTab extends StatefulWidget {
  BuildContext ctx;
  HomeTab(this.ctx, {super.key});
  @override
  _HomeTabState createState() => _HomeTabState(ctx);
}

class _HomeTabState extends State<HomeTab> {
  final BookRepository _bookRepository = BookRepository();
  late BookService _bookService;
  List<Book> books = [];
  
  BuildContext ctx;

  _HomeTabState(this.ctx) {
    _bookService = BookService(ctx);
  }

  void initState() {
    super.initState();
    initDatabaseAndLoadBooks();
  }

  Future<void> initDatabaseAndLoadBooks() async {
    await _bookRepository.initDatabase(); // Inicializa o banco de dados
    loadBooks(); // Carrega os livros após a inicialização do banco de dados
  }

  Future<void> loadBooks() async {
    try {
      List<Book> fetchedBooks = await _bookService.getBooksApi();
      setState(() {
        books = fetchedBooks;
      });
    } catch (e) {
      print('Failed to load books: $e');
    }
  }

  void toggleFavorite(Book book) {
    setState(() {
      book.isFavorite = !book.isFavorite;
      _bookService.favoriteBook(book);
    });
    // Adicione lógica adicional para persistir o status de favorito no banco de dados, se necessário.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: .35
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            return Card(
              child: Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                        onTap: () {
                          _bookService.OpenBook(books[index]);
                        },
                        child: Image.network(books[index].coverUrl)),
                    Text(
                      books[index].title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    Text(
                      books[index].author,
                    ),
                  ],
                ),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: IconButton(
                    icon: Icon(
                      books[index].isFavorite
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: books[index].isFavorite
                          ? Color.fromRGBO(214, 21, 21, 1)
                          : null,
                    ),
                    onPressed: () {
                      toggleFavorite(books[index]);
                    },
                  ),
                ),
              ]),
            );
          },
        )
    );
  }
}
