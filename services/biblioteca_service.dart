import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/libro.dart';

class BibliotecaService {
final String baseUrl = "http://localhost/api_biblioteca/api_biblioteca.php";

  // 📘 Listar libros
  Future<List<Libro>> listarLibros() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Libro.fromJson(json)).toList();
    } else {
      throw Exception('Error al listar libros');
    }
  }

  // ➕ Agregar libro
  Future<void> agregarLibro(String titulo, String autor, String isbn, String categoria, String anio) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'accion': 'insertar',
        'titulo': titulo,
        'autor': autor,
        'isbn': isbn,
        'categoria': categoria,
        'anio_publicacion': anio,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Error al agregar libro');
    }
  }

  // ✏️ Editar libro
  Future<void> editarLibro(int id, String titulo, String autor, String isbn, String categoria, String anio) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'accion': 'actualizar',
        'id': id.toString(),
        'titulo': titulo,
        'autor': autor,
        'isbn': isbn,
        'categoria': categoria,
        'anio_publicacion': anio,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Error al editar libro');
    }
  }

  // 🗑️ Eliminar libro
  Future<void> eliminarLibro(int id) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {'accion': 'eliminar', 'id': id.toString()},
    );
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar libro');
    }
  }
}
