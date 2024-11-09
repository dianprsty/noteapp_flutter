import 'package:noteapp/model/note_model.dart';

// Abstract class NoteState berfungsi sebagai parent class untuk semua state terkait catatan.
// Setiap state akan diwarisi dari NoteState dan mewakili kondisi data catatan di aplikasi.
abstract class NoteState {}

// State untuk menunjukkan bahwa proses pemuatan catatan sedang berlangsung.
class NotesLoading extends NoteState {}

// State yang menunjukkan bahwa semua catatan berhasil dimuat.
// Memiliki properti 'notes' yang merupakan daftar objek Note yang telah dimuat.
class NotesLoaded extends NoteState {
  final List<Note> notes;
  // Konstruktor menerima daftar catatan yang dimuat dari database.
  NotesLoaded(this.notes);
}

// State untuk menunjukkan bahwa terjadi error selama proses pengambilan atau manipulasi catatan.
// Memiliki properti 'error' yang merupakan pesan error.
class NotesError extends NoteState {
  final String error;
  // Konstruktor menerima pesan error yang akan ditampilkan atau dicatat.
  NotesError(this.error);
}
