import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/screen/note_detail_screen.dart';
import '../bloc/note_bloc.dart';
import '../bloc/note_event.dart';
import '../bloc/note_state.dart';
import 'package:go_router/go_router.dart';

// Kelas ini menampilkan daftar catatan yang ada
class NoteListScreen extends StatelessWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Memastikan bahwa event LoadNotes hanya dipanggil sekali ketika widget pertama kali dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteBloc>().add(LoadNotes());
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan'), // Judul aplikasi di AppBar
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const NoteDetailPage(),
          ));
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          // Menampilkan indikator loading saat catatan sedang dimuat
          if (state is NotesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // Menampilkan daftar catatan jika data berhasil dimuat
          else if (state is NotesLoaded) {
            final notes = state.notes;
            return notes.isEmpty
                ? const Center(child: Text('We got the data but it\'s empty'))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      itemCount: notes.length, // Total jumlah catatan
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return ListTile(
                          dense: true,
                          leading: Text(note.id.toString()),
                          title: Text(note.title), // Menampilkan judul catatan
                          onTap: () {
                            // Navigasi ke halaman detail catatan dengan ID catatan
                            context.push('/note/${note.id}',
                                extra: (note.title, note.content));
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Mengirim event untuk menghapus catatan
                              context.read<NoteBloc>().add(DeleteNote(note));
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    ),
                  );
          }
          // Menampilkan pesan error jika terjadi kesalahan saat memuat catatan
          else if (state is NotesError) {
            debugPrint('Error: ${state.error}'); // Debug log untuk error
            return Center(child: Text('Error: ${state.error}'));
          }

          // Menampilkan pesan jika tidak ada catatan yang tersedia
          return const Center(child: Text('Tidak ada catatan.'));
        },
      ),
    );
  }
}
