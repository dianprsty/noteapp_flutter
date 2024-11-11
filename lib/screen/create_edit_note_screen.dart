import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/bloc/note_bloc.dart';
import 'package:noteapp/bloc/note_event.dart';
import 'package:noteapp/bloc/note_state.dart';
import 'package:go_router/go_router.dart';
import 'package:noteapp/model/note_model.dart';

class CreateEditNoteScreen extends StatefulWidget {
  const CreateEditNoteScreen({Key? key}) : super(key: key);

  @override
  _CreateEditNoteScreenState createState() => _CreateEditNoteScreenState();
}

class _CreateEditNoteScreenState extends State<CreateEditNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

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
          title: const Text('Add Note'),
        ),
        body: ListView(children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: 'Content',
            ),
          ),
          BlocBuilder<NoteBloc, NoteState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  final newNote = Note(
                    title: _titleController.text,
                    content: _contentController.text,
                  );

                  context.read<NoteBloc>().add(AddNote(newNote));
                  // Navigasi ke halaman detail catatan dengan ID 0
                  context.pop();
                },
                child: const Text('Save'),
              );
            },
          ),
        ]));
  }
}
