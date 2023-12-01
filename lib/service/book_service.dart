import 'package:desafioescribo2/entity/book.dart';
import 'package:desafioescribo2/repository/book_repository.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class BookService {
  BuildContext context;
  final BookRepository _bookRepository = BookRepository();

  BookService(this.context) {
    _bookRepository.initDatabase();
  }

  Future<List<Book>> getBooksApi() async {
    try {
      // Obter a lista de livros favoritos do banco de dados local
      List<Book> favoriteBooks = await _bookRepository.getFavoriteBooks();

      // Obter a lista de livros da API
      final response =
          await http.get(Uri.parse('https://escribo.com/books.json'));

      if (response.statusCode == 200) {
        List<dynamic> apiBooks = json.decode(response.body);

        // Marcar os livros favoritos obtidos da API
        List<Book> mergedBooks = apiBooks.map((item) {
          Book book = Book.fromJson(item);
          book.isFavorite =
              favoriteBooks.any((favorite) => favorite.id == book.id);
          return book;
        }).toList();

        return mergedBooks;
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      print('Failed to load books: $e');
      // Caso ocorra algum erro ao carregar os livros, você pode lidar com isso aqui.
      return [];
    }
  }

  Future<void> favoriteBook(Book book) async {
    await _bookRepository.insertBook(book);
    await _bookRepository.updateBookFavoriteStatus(
        book.id as int, book.isFavorite);
  }

  Future<void> OpenBook(Book book) async {
    String path = "";
    Book? getBook = await _bookRepository.getOneBook(book.id as int);
    if (getBook != null) {
      if (getBook.path.isNotEmpty) {
        path = getBook.path;
      } else {
        path = await downloadBook(getBook);
        await _bookRepository.updateBookPath(getBook.id as int, path);
      }
    } else {
      path = await downloadBook(book);
    }

    VocsyEpub.setConfig(
      themeColor: Theme.of(context).primaryColor,
      identifier: "iosBook",
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: true,
      enableTts: true,
      nightMode: true,
    );
    VocsyEpub.locatorStream.listen((locator) {
      print('LOCATOR: $locator');
    });
    VocsyEpub.open(
      path,
      lastLocation: EpubLocator.fromJson({
        "bookId": "${book.id}",
        "href": "/OEBPS/ch06.xhtml",
        "created": DateTime.now().millisecond,
        "locations": {"cfi": "${path}"}
      }),
    );
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await path.getApplicationDocumentsDirectory();
      } else {
        directory = await path.getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  Future<String> downloadBook(Book book) async {
    try {
      final response = await http.get(Uri.parse(book.downloadUrl));
      if (response.statusCode == 200) {
        return await saveBookToDevice(book, response.bodyBytes);
      } else {
        print('Falha no download do livro: ${book.title}');
        return "";
      }
    } catch (e) {
      print(e);
      print('Erro durante o download do livro: ${book.title}');
      return "";
    }
  }

  Future<String> saveBookToDevice(Book book, List<int> bytes) async {
    final String? documentsDirectory = await getDownloadPath();
    final String filePath = '$documentsDirectory/${book.title}-${book.id}.epub';
    File file = File(filePath);
    await file.writeAsBytes(bytes);
    book.path = filePath;
    await _bookRepository.insertBook(book);
    return filePath;
  }

  Future<List<Book>> getFavoriteBooks() async {
    return await _bookRepository.getFavoriteBooks();
  }
}
