import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_event.dart';
import 'note_state.dart';
import '../model/database_helper.dart';
import '../model/note_model.dart';

// Bloc yang bertanggung jawab untuk mengelola semua alur data untuk Notes, mulai dari load, add, update, dan delete.
class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final DatabaseHelper _databaseHelper;

  // Konstruktor yang menerima instance DatabaseHelper untuk mengelola operasi basis data.
  NoteBloc(this._databaseHelper) : super(NotesLoading()) {
    on<LoadNotes>(
      (event, emit) async {
        try {
          log('its running');
          // Mengambil semua data catatan dari database.
          final List<Map<String, dynamic>> data =
              await _databaseHelper.readAllNotes();
          // Mengonversi data yang diambil menjadi objek Note.
          final notes = data.map((note) => Note.fromMap(note)).toList();
          debugPrint(
              'Loaded notes: $notes'); // Untuk debugging, menampilkan catatan yang telah dimuat.
          emit(NotesLoaded(
              notes)); // Menghasilkan state NotesLoaded yang berisi list notes.
        } catch (e) {
          emit(NotesError(
              "Failed to load notes: $e")); // Jika terjadi error, menghasilkan state NotesError.
        }
      },
    );

    on<AddNote>((event, emit) async {
      try {
        // Menambahkan catatan ke database dan mendapatkan ID catatan baru.
        final id = await _databaseHelper.create(event.note.toMap());
        debugPrint(
            'Added note with ID: $id'); // Untuk debugging, menampilkan ID catatan baru.

        // Mengambil semua data catatan dari database.
        final List<Map<String, dynamic>> data =
            await _databaseHelper.readAllNotes();
        // Mengonversi data yang diambil menjadi objek Note.
        final notes = data.map((note) => Note.fromMap(note)).toList();
        emit(NotesLoaded(
            notes)); // Menghasilkan state NotesLoaded dengan catatan baru.
      } catch (e) {
        emit(NotesError(
            "Failed to add note: $e")); // Jika terjadi error, menghasilkan state NotesError.
      }
    });

    on<UpdateNote>((event, emit) async {
      try {
        // Memperbarui catatan di database.
        await _databaseHelper.update(event.note.toMap());
        debugPrint(
            'Updated note with ID: ${event.note.id}'); // Untuk debugging, menampilkan ID catatan yang telah diperbarui.

        // Mengambil semua data catatan dari database.
        final List<Map<String, dynamic>> data =
            await _databaseHelper.readAllNotes();
        // Mengonversi data yang diambil menjadi objek Note.
        final notes = data.map((note) => Note.fromMap(note)).toList();
        emit(NotesLoaded(
            notes)); // Menghasilkan state NotesLoaded dengan catatan yang telah diperbarui.
      } catch (e) {
        emit(NotesError(
            "Failed to update note: $e")); // Jika terjadi error, menghasilkan state NotesError.
      }
    });

    on<DeleteNote>((event, emit) async {
      try {
        // Menghapus catatan dari database berdasarkan ID.
        await _databaseHelper.delete(event.note.id ?? 0);
        debugPrint(
            'Deleted note with ID: ${event.note.id}'); // Untuk debugging, menampilkan ID catatan yang telah dihapus.

        // Mengambil semua data catatan dari database.
        final List<Map<String, dynamic>> data =
            await _databaseHelper.readAllNotes();
        // Mengonversi data yang diambil menjadi objek Note.
        final notes = data.map((note) => Note.fromMap(note)).toList();
        emit(NotesLoaded(
            notes)); // Menghasilkan state NotesLoaded dengan catatan yang telah dihapus.
      } catch (e) {
        emit(NotesError(
            "Failed to delete note: $e")); // Jika terjadi error, menghasilkan state NotesError.
      }
    });
  }

  /// mapEventToState sudah deprecated pada verso 7.2.0 dan di remove pada 8.0.0
  ///
  // // Override mapEventToState untuk memetakan event NoteEvent menjadi state NoteState.
  // @override
  // Stream<NoteState> mapEventToState(NoteEvent event) async* {
  //   // Jika event adalah LoadNotes, kita akan membaca semua catatan dari database.
  //   if (event is LoadNotes) {
  //     try {
  //       // Mengambil semua data catatan dari database.
  //       final List<Map<String, dynamic>> data =
  //           await _databaseHelper.readAllNotes();
  //       // Mengonversi data yang diambil menjadi objek Note.
  //       final notes = data.map((note) => Note.fromMap(note)).toList();
  //       debugPrint(
  //           'Loaded notes: $notes'); // Untuk debugging, menampilkan catatan yang telah dimuat.
  //       yield NotesLoaded(
  //           notes); // Menghasilkan state NotesLoaded yang berisi list notes.
  //     } catch (e) {
  //       yield NotesError(
  //           "Failed to load notes: $e"); // Jika terjadi error, menghasilkan state NotesError.
  //     }
  //   }
  //   // Jika event adalah AddNote, kita akan menambahkan catatan baru ke database.
  //   else if (event is AddNote) {
  //     try {
  //       // Menambahkan catatan ke database dan mendapatkan ID catatan baru.
  //       final id = await _databaseHelper.create(event.note.toMap());
  //       // Membuat objek Note baru dengan ID yang baru saja dibuat.
  //       final newNote = event.note.copyWith(id: id);

  //       // Jika state saat ini adalah NotesLoaded, kita akan memperbarui daftar catatan.
  //       if (state is NotesLoaded) {
  //         final updatedNotes = List<Note>.from((state as NotesLoaded).notes)
  //           ..add(newNote); // Menambahkan catatan baru ke daftar.
  //         yield NotesLoaded(
  //             updatedNotes); // Menghasilkan state NotesLoaded yang diperbarui.
  //       }
  //     } catch (e) {
  //       yield NotesError(
  //           "Failed to add note: $e"); // Jika terjadi error, menghasilkan state NotesError.
  //     }
  //   }
  //   // Jika event adalah UpdateNote, kita akan memperbarui catatan di database.
  //   else if (event is UpdateNote) {
  //     try {
  //       // Mengupdate data catatan di database.
  //       await _databaseHelper.update(event.note.toMap());

  //       // Jika state saat ini adalah NotesLoaded, kita akan memperbarui daftar catatan.
  //       if (state is NotesLoaded) {
  //         final updatedNotes = (state as NotesLoaded).notes.map((note) {
  //           // Jika ID catatan sesuai, kita update dengan data baru, jika tidak tetap gunakan yang lama.
  //           return note.id == event.note.id ? event.note : note;
  //         }).toList();
  //         yield NotesLoaded(
  //             updatedNotes); // Menghasilkan state NotesLoaded yang diperbarui.
  //       }
  //     } catch (e) {
  //       yield NotesError(
  //           "Failed to update note: $e"); // Jika terjadi error, menghasilkan state NotesError.
  //     }
  //   }
  //   // Jika event adalah DeleteNote, kita akan menghapus catatan dari database.
  //   else if (event is DeleteNote) {
  //     try {
  //       // Menghapus catatan dari database berdasarkan ID.
  //       await _databaseHelper.delete(event.note.id!);

  //       // Jika state saat ini adalah NotesLoaded, kita akan memperbarui daftar catatan.
  //       if (state is NotesLoaded) {
  //         // Membuat daftar catatan baru tanpa catatan yang dihapus.
  //         final updatedNotes = (state as NotesLoaded)
  //             .notes
  //             .where((note) => note.id != event.note.id)
  //             .toList();
  //         yield NotesLoaded(
  //             updatedNotes); // Menghasilkan state NotesLoaded yang diperbarui.
  //       }
  //     } catch (e) {
  //       yield NotesError(
  //           "Failed to delete note: $e"); // Jika terjadi error, menghasilkan state NotesError.
  //     }
  //   }
  // }
}
