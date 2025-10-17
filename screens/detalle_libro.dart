import 'package:flutter/material.dart';
import '../models/libro.dart';

class DetalleLibroPage extends StatelessWidget {
  final Libro libro;
  const DetalleLibroPage({Key? key, required this.libro}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(libro.titulo)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Autor: ${libro.autor}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('ISBN: ${libro.isbn}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Categoría: ${libro.categoria}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Año de publicación: ${libro.anioPublicacion}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Disponible: ${libro.disponible ? "Sí" : "No"}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
