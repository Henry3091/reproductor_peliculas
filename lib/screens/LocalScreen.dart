import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'detalle_pelicula_screen.dart';

class LocalScreen extends StatefulWidget {
  final Function(String)? onSeleccionarVideo;

  const LocalScreen({super.key, this.onSeleccionarVideo});

  @override
  State<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  late Future<List<Map<String, dynamic>>> peliculasFuture;

  @override
  void initState() {
    super.initState();
    peliculasFuture = cargarPeliculas();
  }

  // 🔥 CARGA PELÍCULAS DESDE REALTIME DATABASE
  Future<List<Map<String, dynamic>>> cargarPeliculas() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    final ref = FirebaseDatabase.instance.ref('peliculas');
    final snapshot = await ref.get();

    if (!snapshot.exists) return [];

    // 👇 TU JSON ES UNA LISTA
    final List<dynamic> data = snapshot.value as List<dynamic>;

    return data
        .where((e) => e != null)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: peliculasFuture,
      builder: (context, snapshot) {
        // 🔐 Usuario no autenticado
        if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/');
          });
          return const SizedBox();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final peliculas = snapshot.data ?? [];

        if (peliculas.isEmpty) {
          return const Center(child: Text('No hay películas disponibles'));
        }

        return ListView.builder(
          itemCount: peliculas.length,
          itemBuilder: (context, index) {
            final peli = peliculas[index];

            final String titulo = peli['titulo'] ?? 'Sin título';
            final String descripcion = peli['descripcion'] ?? '';
            final String imagen = peli['enlaces']?['image'] ?? '';
            final String trailer = peli['enlaces']?['trailer'] ?? '';

            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: imagen.isNotEmpty
                    ? Image.network(
                        imagen,
                        width: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.movie),
                title: Text(titulo),
                subtitle: Text(
                  descripcion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (trailer.isNotEmpty &&
                      widget.onSeleccionarVideo != null) {
                    widget.onSeleccionarVideo!(trailer);
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DetallePeliculaScreen(pelicula: peli),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
