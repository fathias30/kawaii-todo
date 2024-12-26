import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListViewPage extends StatefulWidget {
  final String name;

  const ListViewPage({Key? key, required this.name}) : super(key: key);

  @override
  _ListViewState createState() => _ListViewState();
}

class _ListViewState extends State<ListViewPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _tasks = [];
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksData = prefs.getString('tasks');
    bool? darkMode = prefs.getBool('darkMode');

    if (tasksData != null) {
      setState(() {
        _tasks.addAll(List<Map<String, dynamic>>.from(jsonDecode(tasksData)));
        _isDarkMode = darkMode ?? false;
      });
    }
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedTasks = jsonEncode(_tasks);
    await prefs.setString('tasks', encodedTasks);
    await prefs.setBool('darkMode', _isDarkMode);
  }

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _tasks.add({
          'text': _controller.text,
          'isChecked': false,
          'isFavorite': false,
          'originalIndex': _tasks.length,
        });
        _controller.clear();
        _saveTasks();
      });
    }
  }

  void _toggleCheckbox(int index) {
    setState(() {
      var task = _tasks[index];
      task['isChecked'] = !task['isChecked'];

      if (task['isChecked']) {
        _tasks.removeAt(index);
        _tasks.add(task);
      } else {
        _tasks.removeAt(index);

        int insertIndex = _tasks.indexWhere((t) => t['isChecked'] == true);
        if (insertIndex == -1) {
          _tasks.add(task);
        } else {
          _tasks.insert(insertIndex, task);
        }
      }
      _saveTasks();
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      _saveTasks();
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      var task = _tasks[index];

      if (task['isFavorite']) {
        task['isFavorite'] = false;
        _tasks.removeAt(index);
        _tasks.insert(task['originalIndex'], task);
      } else {
        task['isFavorite'] = true;
        _tasks.removeAt(index);

        int insertIndex = _tasks.indexWhere((t) => !t['isFavorite']);
        if (insertIndex == -1) {
          _tasks.add(task);
        } else {
          _tasks.insert(insertIndex, task);
        }
      }

      for (int i = 0; i < _tasks.length; i++) {
        if (!_tasks[i]['isFavorite']) {
          _tasks[i]['originalIndex'] = i;
        }
      }
      _saveTasks();
    });
  }

  void _toggleDarkMode(bool? value) {
    setState(() {
      _isDarkMode = value ?? false;
      _saveTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: _isDarkMode
            ? const Color.fromARGB(255, 30, 30, 30)
            : const Color.fromARGB(255, 199, 219, 230),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 226, 150, 169),
        ),
      ),
      body: Container(
        color: _isDarkMode
            ? const Color.fromARGB(255, 30, 30, 30)
            : const Color.fromARGB(255, 199, 219, 230),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      style: GoogleFonts.montserrat(
                        color: _isDarkMode
                            ? Colors.white
                            : const Color.fromARGB(255, 81, 48, 55),
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                      "${widget.name}'s Task ${_isDarkMode ? '🌙' : '☀'}",
                    ),
                  ),
                  Switch(
                    value: _isDarkMode,
                    onChanged: _toggleDarkMode,
                    activeColor: const Color.fromARGB(255, 226, 150, 169),
                    inactiveThumbColor:
                        const Color.fromARGB(255, 226, 150, 169),
                    inactiveTrackColor: Colors.white,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 8.0),
                    child: Slidable(
                      key: ValueKey(_tasks[index]),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) => _deleteTask(index),
                            borderRadius: BorderRadius.circular(8),
                            backgroundColor: _isDarkMode
                                ? const Color.fromARGB(255, 70, 70, 70)
                                : Colors.white,
                            foregroundColor: Colors.red,
                            icon: Icons.delete,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                        ],
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: _isDarkMode
                              ? const Color(0xFF424242)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 172, 173, 172),
                              offset: Offset(4.0, 4.0),
                              spreadRadius: 1.0,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(
                              top: 2, bottom: 8, left: 16, right: 6),
                          title: Text(
                            _tasks[index]['text'],
                            style: GoogleFonts.montserrat(
                              fontSize: 14.0,
                              color: _isDarkMode
                                  ? Colors.white
                                  : const Color.fromARGB(255, 81, 48, 55),
                              decoration: _tasks[index]['isChecked']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationColor: _isDarkMode
                                  ? Colors.white
                                  : const Color.fromARGB(255, 81, 48, 55),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () => _toggleCheckbox(index),
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                    color: _tasks[index]['isChecked']
                                        ? const Color.fromARGB(
                                            255, 226, 150, 169)
                                        : Colors.transparent,
                                  ),
                                  child: _tasks[index]['isChecked']
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  (_tasks[index]['isFavorite'] ?? false)
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: (_tasks[index]['isFavorite'] ?? false)
                                      ? const Color.fromARGB(255, 255, 215, 0)
                                      : Colors.grey,
                                ),
                                onPressed: () => _toggleFavorite(index),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: GoogleFonts.montserrat(
                        color: _isDarkMode
                            ? Colors.white
                            : const Color.fromARGB(255, 81, 48, 55),
                        fontSize: 14,
                      ),
                      cursorColor: _isDarkMode
                          ? const Color.fromARGB(255, 226, 150, 169)
                          : const Color.fromARGB(150, 81, 48, 55),
                      controller: _controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: _isDarkMode
                            ? const Color(0xFF424242)
                            : Colors.white,
                        hintText: "Ada lagi?",
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: _isDarkMode
                              ? Colors.white60
                              : const Color.fromARGB(150, 81, 48, 55),
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: _isDarkMode
                                ? const Color.fromARGB(255, 226, 150, 169)
                                : const Color.fromARGB(150, 81, 48, 55),
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: _isDarkMode
                                ? const Color.fromARGB(255, 226, 150, 169)
                                : const Color.fromARGB(150, 81, 48, 55),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 226, 150, 169),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(16),
                    ),
                    label: Text(
                      'Tambah',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
