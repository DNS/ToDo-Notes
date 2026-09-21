import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo Notes',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Model for the Todo Item
class TodoItem {
  String id;
  String title;
  String content;
  Color color;

  TodoItem({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
  });
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // Supported Colors Map
  final Map<Color, Color> colorPalette = {
    Colors.yellow: Colors.yellow[100]!,
    Colors.red: Colors.red[100]!,
    Colors.green: Colors.green[100]!,
    Colors.blue: Colors.blue[100]!,
    Colors.purple: Colors.purple[100]!,
    Colors.grey: Colors.grey[300]!,
  };

  // Sample Data
  List<TodoItem> todoList = [
    TodoItem(id: '1', title: 'List 1', content: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.', color: Colors.yellow),
    TodoItem(id: '2', title: 'List 2', content: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.', color: Colors.red),
    TodoItem(id: '3', title: 'List 3', content: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.', color: Colors.green),
  ];

  bool isSelectionMode = false;
  Set<int> selectedIndices = {};

  // Navigate to Add/Edit Page
  Future<void> navigateToEditPage(TodoItem? item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoEditPage(
          item: item,
          supportedColors: colorPalette.keys.toList(),
        ),
      ),
    );

    if (result != null) {
      if (result is TodoItem) {
        setState(() {
          if (item == null) {
            todoList.add(result);
          } else {
            int index = todoList.indexWhere((element) => element.id == item.id);
            todoList[index] = result;
          }
        });
      } else if (result == 'DELETE') {
        setState(() {
          if (item != null) {
            todoList.removeWhere((element) => element.id == item.id);
          }
        });
      }
    }
  }

  void toggleSelection(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
      if (selectedIndices.isEmpty) {
        isSelectionMode = false;
      }
    });
  }

  void deleteSelected() {
    setState(() {
      // Sort indices in descending order to avoid index shifting during removal
      List<int> sortedIndices = selectedIndices.toList()..sort((a, b) => b.compareTo(a));
      for (var index in sortedIndices) {
        todoList.removeAt(index);
      }
      isSelectionMode = false;
      selectedIndices.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo Notes'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'About') {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: const Text('Created by Daniel Sirait'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Settings', child: Text('Settings')),
              const PopupMenuItem(value: 'About', child: Text('About')),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              final item = todoList[index];
              final bgColor = colorPalette[item.color] ?? Colors.white;
              final isSelected = selectedIndices.contains(index);

              return GestureDetector(
                onLongPress: () {
                  setState(() {
                    isSelectionMode = true;
                    selectedIndices.add(index);
                  });
                },
                onTap: () {
                  if (isSelectionMode) {
                    toggleSelection(index);
                  } else {
                    navigateToEditPage(item);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
                  ),
                  child: Row(
                    children: [
                      if (isSelectionMode)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: Colors.black54,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (isSelectionMode)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                      onPressed: deleteSelected,
                      child: const Text('Delete'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          isSelectionMode = false;
                          selectedIndices.clear();
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: isSelectionMode
          ? null
          : FloatingActionButton(
              onPressed: () => navigateToEditPage(null),
              child: const Icon(Icons.add),
            ),
    );
  }
}

class TodoEditPage extends StatefulWidget {
  final TodoItem? item;
  final List<Color> supportedColors;

  const TodoEditPage({super.key, this.item, required this.supportedColors});

  @override
  State<TodoEditPage> createState() => _TodoEditPageState();
}

class _TodoEditPageState extends State<TodoEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _contentController = TextEditingController(text: widget.item?.content ?? '');
    _selectedColor = widget.item?.color ?? widget.supportedColors[0];
  }

  void _saveAndPop() {
    final item = TodoItem(
      id: widget.item?.id ?? DateTime.now().toString(),
      title: _titleController.text,
      content: _contentController.text,
      color: _selectedColor,
    );
    Navigator.pop(context, item);
  }

  void _deleteAndPop() {
    // Return a special string to signal deletion
    Navigator.pop(context, 'DELETE');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _saveAndPop,
        ),
        title: Text(widget.item == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Select Color:"),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: widget.supportedColors.map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor == color ? Colors.black : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                onPressed: _saveAndPop,
                child: const Text('Save'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: _deleteAndPop,
                child: const Text('Delete'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
