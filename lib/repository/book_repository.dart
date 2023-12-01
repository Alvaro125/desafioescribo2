import 'dart:async';
import 'package:desafioescribo2/entity/book.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BookRepository {
  late Database _database;

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'books_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE books(id INTEGER PRIMARY KEY, title TEXT, author TEXT, coverUrl TEXT, downloadUrl TEXT, isFavorite INTEGER, path TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertBook(Book book) async {
    await _database.insert(
      'books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Book>> getAllBooks() async {
    final List<Map<String, dynamic>> maps = await _database.query('books');

    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }
  Future<Book?> getOneBook(int id) async {
  try {
    List<Map<String, dynamic>> maps = await _database.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Book.fromMap(maps.first);
    } else {
      return null;
    }
  } catch (e) {
    print('Error while getting one book: $e');
    return null;
  }
}


  Future<void> updateBookFavoriteStatus(int id, bool isFavorite) async {
    await _database.update(
      'books',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateBookPath(int id, String pathBook) async {
    await _database.update(
      'books',
      {'path': pathBook.isNotEmpty ? pathBook : ""},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Book>> getFavoriteBooks() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('books', where: 'isFavorite = 1');

    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }
}
