import 'package:noteapp/model/note_model.dart';

// Abstract class NoteEvent berfungsi sebagai parent class untuk semua event terkait catatan.
// Setiap event akan diwarisi dari NoteEvent dan mewakili tindakan yang dapat dilakukan dalam aplikasi.
abstract class NoteEvent {}

// Event untuk memuat semua catatan dari database.
class LoadNotes extends NoteEvent {}

// Event untuk menambahkan catatan baru.
// Memiliki properti 'note' yang merupakan objek Note yang ingin ditambahkan.
class AddNote extends NoteEvent {
  final Note note;
  // Konstruktor menerima objek Note yang akan ditambahkan.
  AddNote(this.note);
}

// Event untuk memperbarui catatan yang sudah ada.
// Memiliki properti 'note' yang merupakan objek Note yang berisi data terbaru.
class UpdateNote extends NoteEvent {
  final Note note;
  // Konstruktor menerima objek Note yang akan diperbarui.
  UpdateNote(this.note);
}

// Event untuk menghapus catatan.
// Memiliki properti 'note' yang merupakan objek Note yang akan dihapus berdasarkan ID-nya.
class DeleteNote extends NoteEvent {
  final Note note;
  // Konstruktor menerima objek Note yang akan dihapus.
  DeleteNote(this.note);
}
