import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'detalle_pelicula_screen.dart';

class LocalScreen extends StatelessWidget {
  const LocalScreen({super.key});

    Future<List<dynamic>> cargarPeliculas() async {
    final String response =
        await rootBundle.loadString('assets/data/peliculas2.json');
    final data = json.decode(response);
    return data['peliculas'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: cargarPeliculas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar datos'));
        }

        final peliculas = snapshot.data ?? [];

        return ListView.builder(
          itemCount: peliculas.length,
          itemBuilder: (context, index) {
            final peli = peliculas[index];
            final String imagen = peli['enlaces']?['image'] ?? '';
            final String titulo = peli['titulo'] ?? 'Sin título';
            final String descripcion = peli['descripcion'] ?? 'Sin descripción';

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetallePeliculaScreen(pelicula: peli),
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
