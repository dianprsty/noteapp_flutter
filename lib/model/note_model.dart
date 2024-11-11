// Kelas Note merepresentasikan model data untuk catatan dalam aplikasi.
// Terdiri dari tiga properti: id, title, dan content.
class Note {
  final int? id; // ID unik untuk setiap catatan.
  final String title; // Judul catatan.
  final String content; // Isi catatan.

  // Konstruktor untuk menginisialisasi objek Note dengan nilai-nilai yang diberikan.
  Note({
    this.id,
    required this.title,
    required this.content,
  });

  // Factory method untuk membuat objek Note dari Map (biasanya dari database).
  // Berguna untuk mengonversi data dari database ke dalam objek Note.
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
    );
  }

  // Method untuk mengonversi objek Note menjadi Map.
  // Berguna untuk menyimpan objek Note ke dalam database sebagai data map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }

  // Method copyWith untuk membuat salinan dari objek Note dengan nilai baru.
  // Dapat digunakan untuk memperbarui properti tertentu tanpa mengubah objek asli.
  Note copyWith({
    int? id,
    String? title,
    String? content,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
