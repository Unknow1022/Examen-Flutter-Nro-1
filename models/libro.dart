class Libro {
  final int id;
  final String titulo;
  final String autor;
  final String isbn;
  final String categoria;
  final int anioPublicacion;
  final bool disponible;

  Libro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.isbn,
    required this.categoria,
    required this.anioPublicacion,
    required this.disponible,
  });

  factory Libro.fromJson(Map<String, dynamic> json) {
    return Libro(
      id: int.parse(json['id'].toString()),
      titulo: json['titulo'],
      autor: json['autor'],
      isbn: json['isbn'],
      categoria: json['categoria'],
      anioPublicacion: int.parse(json['año_publicacion'].toString()),
      disponible: json['disponible'].toString() == '1',
    );
  }
}
