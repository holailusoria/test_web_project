import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Flutter Demo', home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  String? imageUrl;
  OverlayEntry? overlayEntry;

  void toggleFullscreen() {
    final doc = web.document;
    if (doc.fullscreenElement == null) {
      doc.documentElement?.requestFullscreen();
    } else {
      doc.exitFullscreen();
    }
  }

  void showContextMenu(BuildContext context) {
    overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: removeContextMenu,
                  child: Container(color: Colors.black54),
                ),
              ),
              Positioned(
                bottom: 80,
                right: 20,
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          toggleFullscreen();
                          removeContextMenu();
                        },
                        label: const Text("Enter fullscreen"),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.extended(
                        onPressed: () {
                          web.document.exitFullscreen();
                          removeContextMenu();
                        },
                        label: const Text("Exit fullscreen"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
    Overlay.of(context).insert(overlayEntry!);
  }

  void removeContextMenu() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: GestureDetector(
                  onDoubleTap: toggleFullscreen,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        imageUrl != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                imageUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                            : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(hintText: 'Image URL'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      imageUrl = _urlController.text;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: Icon(Icons.arrow_forward),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showContextMenu(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
