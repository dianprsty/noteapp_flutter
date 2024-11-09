import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Kelas DatabaseHelper untuk mengelola operasi CRUD pada tabel 'notes'.
class DatabaseHelper {
  // Singleton instance untuk memastikan hanya ada satu instance DatabaseHelper.
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Konstruktor private untuk menginisialisasi DatabaseHelper.
  DatabaseHelper._init();

  // Getter untuk mengakses database, akan menginisialisasi database jika belum ada.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db'); // Membuat atau membuka database dengan nama 'notes.db'.
    return _database!;
  }

  // Fungsi untuk inisialisasi database.
  Future<Database> _initDB(String filePath) async {
    // Mendapatkan path direktori database.
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath); // Menyusun path lengkap database.
    // Membuka atau membuat database dan menentukan skema tabel.
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Fungsi untuk membuat tabel 'notes' di database.
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT, // Kolom ID sebagai primary key yang auto increment.
        title TEXT NOT NULL,                  // Kolom title untuk judul catatan.
        content TEXT NOT NULL                 // Kolom content untuk isi catatan.
      )
    ''');
  }

  // Fungsi untuk menambahkan catatan baru ke database.
  Future<int> create(Map<String, dynamic> note) async {
    final db = await instance.database; // Memastikan database sudah terinisialisasi.
    // Menyisipkan data catatan ke dalam tabel 'notes'.
    return await db.insert('notes', note);
  }

  // Fungsi untuk membaca semua catatan dari tabel 'notes'.
  Future<List<Map<String, dynamic>>> readAllNotes() async {
    final db = await instance.database;
    // Melakukan query untuk mengambil semua data catatan.
    final result = await db.query('notes');
    debugPrint('Database result: $result'); // Log untuk mengecek hasil query.
    return result; // Mengembalikan hasil query sebagai list map.
  }

  // Fungsi untuk memperbarui catatan yang sudah ada di database.
  Future<int> update(Map<String, dynamic> note) async {
    final db = await instance.database;
    final id = note['id']; // Mengambil ID catatan dari map untuk kondisi where.
    // Mengupdate data catatan berdasarkan ID.
    return await db.update('notes', note, where: 'id = ?', whereArgs: [id]);
  }

  // Fungsi untuk menghapus catatan dari database berdasarkan ID.
  Future<int> delete(int id) async {
    final db = await instance.database;
    // Menghapus data catatan dengan ID yang sesuai.
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
