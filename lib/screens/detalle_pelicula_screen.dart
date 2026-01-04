import 'package:flutter/material.dart';
import 'reproductor_screen.dart';

class DetallePeliculaScreen extends StatelessWidget {
  final Map<String, dynamic> pelicula;
  const DetallePeliculaScreen({super.key, required this.pelicula});

  @override
  Widget build(BuildContext context) {
    final String titulo = pelicula['titulo'] ?? 'Sin título';
    final String descripcion = pelicula['descripcion'] ?? 'Sin descripción';
    final String imagen = pelicula['enlaces']?['image'] ?? '';
    final String videoUrl = pelicula['enlaces']?['trailer'] ?? ''; // ✅ CORREGIDO

    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (imagen.isNotEmpty)
              Image.network(
                imagen,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 100),
              ),
            const SizedBox(height: 10),
            Text(
              descripcion,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text("Ver Trailer"),
              onPressed: videoUrl.isNotEmpty
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ReproductorScreen(urlVideo: videoUrl),
                        ),
                      );
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
