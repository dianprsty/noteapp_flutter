import 'package:go_router/go_router.dart';
import 'screen/note_list_screen.dart';
import 'screen/note_detail_screen.dart';

// Kelas ini bertanggung jawab untuk mengatur rute aplikasi
class AppRouter {
  final GoRouter router = GoRouter(
    routes: [
      // Rute utama (beranda) yang mengarah ke halaman daftar catatan
      GoRoute(
        path: '/',
        builder: (context, state) => const NoteListScreen(),
      ),
      // Rute untuk halaman detail catatan, menggunakan parameter ID
      GoRoute(
        path: '/note/:id',
        builder: (context, state) {
          // Mengambil ID dari parameter URL dan mengonversinya ke tipe int
          final id = int.tryParse(state.params['id']!) ?? 0;
          return NoteDetailPage(id: id);
        },
      ),
    ],
  );
}
