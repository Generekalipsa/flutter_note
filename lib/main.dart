import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'settings.dart';


void main() {
  runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Note',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: MyHomePage(title: 'Flutter Note'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, String>> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList('notes');
    if (notesJson != null) {
      setState(() {
        _notes = notesJson.map((note) => Map<String, String>.from(jsonDecode(note))).toList();
      });
    }
  }

  void _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = _notes.map((note) => jsonEncode(note)).toList();
    prefs.setStringList('notes', notesJson);
  }

  void _addNoteOrEditNote({Map<String, String>? noteToEdit}) {
    TextEditingController titleController = TextEditingController(text: noteToEdit?['title'] ?? '');
    TextEditingController noteController = TextEditingController(text: noteToEdit?['note'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(noteToEdit == null ? 'Add Note' : 'Edit Note'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Enter note title'),
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: 200.0,
                ),
                child: TextField(
                  controller: noteController,
                  expands: true,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(labelText: 'Enter your note'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (noteToEdit == null) {
                    _notes.add({
                      'title': titleController.text,
                      'note': noteController.text,
                    });
                  } else {
                    final index = _notes.indexOf(noteToEdit);
                    if (index != -1) {
                      _notes[index]['title'] = titleController.text;
                      _notes[index]['note'] = noteController.text;
                    }
                  }
                });
                _saveNotes();
                Navigator.pop(context);
              },
              child: Text(noteToEdit == null ? 'Save' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  void _removeNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            tooltip: "settings",
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: _notes.asMap().entries.map(
                      (entry) {
                    final index = entry.key;
                    final note = entry.value;

                    return GestureDetector(
                      onLongPress: () {
                        _addNoteOrEditNote(noteToEdit: note);
                      },
                      child: Builder(
                        builder: (context) {
                          try {
                            return Dismissible(
                              key: Key(index.toString()),
                              onDismissed: (direction) {
                                _removeNote(index);
                              },
                              background: Container(
                                color: Colors.red,
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.all(8),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note['title'] ?? 'No title',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      note['note'] ?? '',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } catch (e) {
                            print('Error: $e');
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNoteOrEditNote();
        },
        tooltip: 'Add',
        child: const Icon(Icons.note_add),
      ),
    );
  }
}