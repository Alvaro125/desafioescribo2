class Book {
  int? id;
  String title;
  String author;
  String coverUrl;
  String downloadUrl;
  String path;
  bool isFavorite;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.downloadUrl,
    this.isFavorite = false,
    this.path = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverUrl': coverUrl,
      'downloadUrl': downloadUrl,
      'isFavorite': isFavorite ? 1 : 0,
      'path': path.isNotEmpty ? path : "",
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      coverUrl: map['coverUrl'],
      downloadUrl: map['downloadUrl'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      coverUrl: json['cover_url'],
      downloadUrl: json['download_url'],
      isFavorite: false,
    );
  }
  @override
  String toString() {
    return 'Book{id: $id, title: $title, author: $author, coverUrl: $coverUrl, downloadUrl: $downloadUrl, isFavorite: $isFavorite, path: $path}';
  }
}
// class Book {
//   final int id;
//   final String title;
//   final String author;
//   final String coverUrl;
//   final String downloadUrl;
  

//   Book({
//     required this.id,
//     required this.title,
//     required this.author,
//     required this.coverUrl,
//     required this.downloadUrl,
//   });

//   factory Book.fromJson(Map<String, dynamic> json) {
//     return Book(
//       id: json['id'],
//       title: json['title'],
//       author: json['author'],
//       coverUrl: json['cover_url'],
//       downloadUrl: json['download_url'],
//     );
//   }
// }