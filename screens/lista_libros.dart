import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../services/biblioteca_service.dart';
import 'agregar_libro.dart';
import 'editar_libro.dart';
import 'detalle_libro.dart';

class ListaLibrosPage extends StatefulWidget {
  const ListaLibrosPage({Key? key}) : super(key: key);

  @override
  State<ListaLibrosPage> createState() => _ListaLibrosPageState();
}

class _ListaLibrosPageState extends State<ListaLibrosPage> {
  late Future<List<Libro>> _listaLibros;

  @override
  void initState() {
    super.initState();
    _refreshLibros();
  }

  void _refreshLibros() {
    setState(() {
      _listaLibros = BibliotecaService().listarLibros();
    });
  }

  Future<void> _eliminarLibro(int id) async {
    await BibliotecaService().eliminarLibro(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Libro eliminado correctamente')),
    );
    _refreshLibros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Biblioteca Digital'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Listar libros',
            onPressed: _refreshLibros,
          ),
        ],
      ),
      body: FutureBuilder<List<Libro>>(
        future: _listaLibros,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay libros registrados.'),
            );
          } else {
            final libros = snapshot.data!;
            return ListView.builder(
              itemCount: libros.length,
              itemBuilder: (context, index) {
                final libro = libros[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.book, color: Colors.blueAccent),
                    title: Text(libro.titulo),
                    subtitle: Text(libro.autor),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'editar') {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarLibroPage(libro: libro),
                            ),
                          );
                          _refreshLibros();
                        } else if (value == 'eliminar') {
                          _eliminarLibro(libro.id);
                        } else if (value == 'detalle') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleLibroPage(libro: libro),
                            ),
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'detalle',
                          child: Text('Ver Detalle'),
                        ),
                        const PopupMenuItem(
                          value: 'editar',
                          child: Text('Actualizar'),
                        ),
                        const PopupMenuItem(
                          value: 'eliminar',
                          child: Text('Eliminar'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'btnAgregar',
            icon: const Icon(Icons.add),
            label: const Text('Añadir'),
            backgroundColor: Colors.green,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AgregarLibroPage()),
              );
              _refreshLibros();
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'btnListar',
            icon: const Icon(Icons.list),
            label: const Text('Listar'),
            backgroundColor: Colors.blue,
            onPressed: _refreshLibros,
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'btnActualizar',
            icon: const Icon(Icons.edit),
            label: const Text('Actualizar'),
            backgroundColor: Colors.orange,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Selecciona un libro para editar.')),
              );
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'btnEliminar',
            icon: const Icon(Icons.delete),
            label: const Text('Eliminar'),
            backgroundColor: Colors.red,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Usa el menú del libro para eliminar.')),
              );
            },
          ),
        ],
      ),
    );
  }
}