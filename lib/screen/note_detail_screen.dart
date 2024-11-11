import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter untuk navigasi
import '../bloc/note_bloc.dart';
import '../bloc/note_event.dart';
import '../model/note_model.dart';

// Halaman detail untuk menambahkan atau mengedit catatan
class NoteDetailPage extends StatefulWidget {
  final int? id; // ID dari catatan yang akan diedit (0 jika catatan baru)
  final String?
      title; // Judul catatan yang akan diedit (null jika catatan baru)
  final String?
      content; // Isi catatan yang akan diedit (null jika catatan baru)

  // Konstruktor menerima ID untuk menentukan apakah catatan baru atau edit
  const NoteDetailPage({super.key, this.id, this.title, this.content});

  @override
  NoteDetailPageState createState() => NoteDetailPageState();
}

class NoteDetailPageState extends State<NoteDetailPage> {
  late Note _note; // Objek catatan yang akan disimpan atau diperbarui
  late TextEditingController _titleController; // Kontrol judul catatan
  late TextEditingController _contentController; // Kontrol isi catatan

  @override
  void initState() {
    super.initState();

    // Inisialisasi objek Note dan controller teks berdasarkan ID catatan
    _note = Note(
        id: widget.id,
        title: widget.title ?? '',
        content: widget.content ?? '');
    _titleController = TextEditingController(text: _note.title);
    _contentController = TextEditingController(text: _note.content);
  }

  // dispose controller to prevent memory leaks
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Jika ID = 0, tampilkan 'Add Note' sebagai judul, jika tidak, 'Edit Note'
        title: Text(_note.id == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('ID: ${_note.id}'),
            // Input field untuk judul catatan
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            // Input field untuk konten catatan
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
            const SizedBox(height: 20),
            // Tombol untuk menyimpan catatan (tambah atau perbarui)
            ElevatedButton(
              onPressed: _saveNote,
              child: Text(_note.id == null ? 'Add Note' : 'Update Note'),
            ),
          ],
        ),
      ),
    );
  }

  // Method untuk menyimpan atau memperbarui catatan
  void _saveNote() {
    // Membuat objek Note baru atau memperbarui data berdasarkan input pengguna
    final updatedNote = _note.copyWith(
      title: _titleController.text,
      content: _contentController.text,
    );

    // Jika ID = 0, tambahkan catatan baru, jika tidak, perbarui catatan yang ada
    if (updatedNote.id == null) {
      BlocProvider.of<NoteBloc>(context)
          .add(AddNote(updatedNote.copyWith(id: null)));
    } else {
      BlocProvider.of<NoteBloc>(context).add(UpdateNote(updatedNote));
    }

    context.pop(context); // Navigasi kembali setelah menyimpan catatan
  }
}
