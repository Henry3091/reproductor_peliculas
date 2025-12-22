import 'package:flutter/material.dart';
import 'localscreen.dart';
import 'reproductor_screen.dart';

class HomeTabs extends StatelessWidget {
  const HomeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pantalla Principal - Catálogo de Películas'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Catálogo', icon: Icon(Icons.movie)),
              Tab(text: 'Reproductor', icon: Icon(Icons.play_circle_fill)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LocalScreen(),
            ReproductorScreen(
              urlVideo: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
            ),
          ],
        ),
      ),
    );
  }
}
