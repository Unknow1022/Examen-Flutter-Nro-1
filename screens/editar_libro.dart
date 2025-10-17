// ignore_for_file: use_build_context_synchronously, use_super_parameters

import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../services/biblioteca_service.dart';

class EditarLibroPage extends StatefulWidget {
  final Libro libro;
  const EditarLibroPage({Key? key, required this.libro}) : super(key: key);

  @override
  State<EditarLibroPage> createState() => _EditarLibroPageState();
}

class _EditarLibroPageState extends State<EditarLibroPage> {
  late TextEditingController _tituloController;
  late TextEditingController _autorController;
  late TextEditingController _isbnController;
  late TextEditingController _categoriaController;
  late TextEditingController _anioController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.libro.titulo);
    _autorController = TextEditingController(text: widget.libro.autor);
    _isbnController = TextEditingController(text: widget.libro.isbn);
    _categoriaController = TextEditingController(text: widget.libro.categoria);
    _anioController = TextEditingController(text: widget.libro.anioPublicacion.toString());
  }

  Future<void> _guardarCambios() async {
    await BibliotecaService().editarLibro(
      widget.libro.id,
      _tituloController.text,
      _autorController.text,
      _isbnController.text,
      _categoriaController.text,
      _anioController.text,
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Libro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _tituloController, decoration: const InputDecoration(labelText: 'Título')),
            TextField(controller: _autorController, decoration: const InputDecoration(labelText: 'Autor')),
            TextField(controller: _isbnController, decoration: const InputDecoration(labelText: 'ISBN')),
            TextField(controller: _categoriaController, decoration: const InputDecoration(labelText: 'Categoría')),
            TextField(controller: _anioController, decoration: const InputDecoration(labelText: 'anio de publicación')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarCambios,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
