import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LocalScreen.dart';
import 'reproductor_screen.dart';

class HomeTabs extends StatefulWidget {
  const HomeTabs({super.key});

  @override
  State<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  String? videoSeleccionadoUrl;

  @override
  void initState() {
    super.initState();

    // Comprobar si hay usuario logueado
    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
    }
  }

  // 🔴 FUNCIÓN PARA CERRAR SESIÓN
  void _logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  // Callback para actualizar el video seleccionado desde LocalScreen
  void seleccionarVideo(String url) {
    setState(() {
      videoSeleccionadoUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pantalla Principal - Catálogo de Películas'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Cerrar sesión',
              onPressed: _logout,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Catálogo', icon: Icon(Icons.movie)),
              Tab(text: 'Reproductor', icon: Icon(Icons.play_circle_fill)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LocalScreen(
              onSeleccionarVideo: seleccionarVideo,
            ),
            ReproductorScreen(
              urlVideo: videoSeleccionadoUrl ??
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
            ),
          ],
        ),
      ),
    );
  }
}
