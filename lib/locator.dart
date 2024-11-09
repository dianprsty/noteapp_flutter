import 'package:get_it/get_it.dart';
import 'model/database_helper.dart';
import 'bloc/note_bloc.dart';

// Inisialisasi instance GetIt sebagai 'locator' untuk mengatur dependency injection
final locator = GetIt.instance;

// Fungsi setupLocator digunakan untuk mendaftarkan dan mengatur dependency yang akan diinject
void setupLocator() {
  // Mendaftarkan DatabaseHelper sebagai singleton yang akan diinisialisasi hanya sekali
  locator.registerLazySingleton(() => DatabaseHelper.instance);

  // Mendaftarkan NoteBloc sebagai factory, menghasilkan instance baru setiap kali dibutuhkan
  locator.registerFactory(() => NoteBloc(locator<DatabaseHelper>()));
}
