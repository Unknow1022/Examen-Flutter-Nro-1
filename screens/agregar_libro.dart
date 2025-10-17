import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgregarLibroPage extends StatefulWidget {
  const AgregarLibroPage({Key? key}) : super(key: key);

  @override
  State<AgregarLibroPage> createState() => _AgregarLibroPageState();
}

class _AgregarLibroPageState extends State<AgregarLibroPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();
  final TextEditingController _anioController = TextEditingController();

  bool _enviando = false;

  Future<void> agregarLibro() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enviando = true);

    final url = Uri.parse('http://localhost/api_biblioteca/api_biblioteca.php?action=agregar');
    final response = await http.post(
      url,
      body: {
        'titulo': _tituloController.text,
        'autor': _autorController.text,
        'isbn': _isbnController.text,
        'categoria': _categoriaController.text,
        'anio_publicacion': _anioController.text,
      },
    );

    setState(() => _enviando = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Libro agregado correctamente')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${data['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en la conexión (${response.statusCode})')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Libro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => v!.isEmpty ? 'Ingrese el título' : null,
              ),
              TextFormField(
                controller: _autorController,
                decoration: const InputDecoration(labelText: 'Autor'),
                validator: (v) => v!.isEmpty ? 'Ingrese el autor' : null,
              ),
              TextFormField(
                controller: _isbnController,
                decoration: const InputDecoration(labelText: 'ISBN'),
                validator: (v) => v!.isEmpty ? 'Ingrese el ISBN' : null,
              ),
              TextFormField(
                controller: _categoriaController,
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (v) => v!.isEmpty ? 'Ingrese la categoría' : null,
              ),
              TextFormField(
                controller: _anioController,
                decoration: const InputDecoration(labelText: 'anio de publicación'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese el anio';
                  if (int.tryParse(v) == null) return 'Debe ser un número';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _enviando ? null : agregarLibro,
                child: _enviando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
