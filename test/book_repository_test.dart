import 'package:desafioescribo2/entity/book.dart';
import 'package:desafioescribo2/repository/book_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookRepository Tests', () {
    late BookRepository bookRepository;

    setUp(() async {
      bookRepository = BookRepository();
      await bookRepository.initDatabase(); // Certifique-se de inicializar o banco de dados antes de cada teste
    });

    test('Insert and Get All Books', () async {
      final book = Book(
        id: 1,
        title: 'Test Book',
        author: 'Test Author',
        coverUrl: 'https://example.com/cover.jpg',
        downloadUrl: 'https://example.com/book.epub',
        isFavorite: false,
        path: '',
      );

      await bookRepository.insertBook(book);

      final books = await bookRepository.getAllBooks();
      expect(books, isNotEmpty);
      expect(books.first.title, equals('Test Book'));
    });

    test('Get One Book', () async {
      final book = Book(
        id: 2,
        title: 'Another Test Book',
        author: 'Another Test Author',
        coverUrl: 'https://example.com/another_cover.jpg',
        downloadUrl: 'https://example.com/another_book.epub',
        isFavorite: true,
        path: '',
      );

      await bookRepository.insertBook(book);

      final retrievedBook = await bookRepository.getOneBook(2);
      expect(retrievedBook, isNotNull);
      expect(retrievedBook!.title, equals('Another Test Book'));
    });

    // Adicione mais testes conforme necessário para outros métodos do BookRepository
  });
}
