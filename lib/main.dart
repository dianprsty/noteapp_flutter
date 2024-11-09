import 'package:flutter/material.dart';
import 'locator.dart'; // Import konfigurasi GetIt untuk dependency injection
import 'go_router.dart'; // Import pengaturan router menggunakan GoRouter
import 'package:provider/provider.dart'; // Import Provider untuk state management
import 'bloc/note_bloc.dart'; // Import NoteBloc
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import untuk FFI SQLite

void main() {
  // Menginisialisasi SQLite FFI (Foreign Function Interface) untuk akses database pada platform non-native seperti desktop
  sqfliteFfiInit();
  // Menentukan databaseFactory untuk digunakan oleh sqflite dengan FFI
  databaseFactory = databaseFactoryFfi;

  // Menyiapkan dependency injection menggunakan GetIt
  setupLocator();

  // Menjalankan aplikasi
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider untuk mengelola beberapa provider sekaligus
    return MultiProvider(
      providers: [
        // Menyediakan instance NoteBloc menggunakan locator (GetIt) dan menutupnya saat widget dihancurkan
        Provider<NoteBloc>(
          create: (_) => locator<NoteBloc>(), // Mengambil instance NoteBloc dari locator
          dispose: (_, bloc) => bloc.close, // Menutup NoteBloc saat tidak lagi digunakan
        ),
      ],
      // Menggunakan MaterialApp.router untuk mengonfigurasi router berdasarkan AppRouter
      child: MaterialApp.router(
        routerConfig: AppRouter().router, // Menyusun router dengan AppRouter
      ),
    );
  }
}
