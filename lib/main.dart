import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

void main() {
  // Run the Flutter application
  runApp(const MyApp());
}

/// The main application widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a MaterialApp with the home page
    return const MaterialApp(title: 'Flutter Demo', home: HomePage());
  }
}

/// The home page of the app, where image management and fullscreen mode take place.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controller for the TextField to enter the image URL
  final TextEditingController _urlController = TextEditingController();

  // Variable to store the image URL
  String? imageUrl;

  // OverlayEntry object for displaying the context menu
  OverlayEntry? overlayEntry;

  /// Toggle fullscreen mode.
  void toggleFullscreen() {
    final doc = web.document;
    // Request to enter fullscreen mode
    if (doc.fullscreenElement == null) {
      doc.documentElement?.requestFullscreen();
    } else {
      // Exit fullscreen mode
      doc.exitFullscreen();
    }
  }

  /// Show the context menu on the screen.
  void showContextMenu(BuildContext context) {
    overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              // Background overlay to dim the screen when the context menu is visible
              Positioned.fill(
                child: GestureDetector(
                  onTap:
                      removeContextMenu, // Close context menu on background tap
                  child: Container(color: Colors.black54),
                ),
              ),
              // Position the buttons for the context menu
              Positioned(
                bottom: 80,
                right: 20,
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Button to enter fullscreen mode
                      FloatingActionButton.extended(
                        onPressed: () {
                          toggleFullscreen();
                          removeContextMenu();
                        },
                        label: const Text("Enter fullscreen"),
                      ),
                      const SizedBox(height: 8),
                      // Button to exit fullscreen mode
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
    // Insert the OverlayEntry into the widget tree
    Overlay.of(context).insert(overlayEntry!);
  }

  /// Remove the context menu from the screen.
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
                aspectRatio: 1, // Maintain aspect ratio for the container
                child: GestureDetector(
                  onDoubleTap:
                      toggleFullscreen, // Enter fullscreen mode on double tap
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        imageUrl != null
                            // If the image URL is provided, display the image
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
                      // Set the image URL
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
        onPressed:
            () => showContextMenu(context), // Show context menu on button press
        child: const Icon(Icons.add),
      ),
    );
  }
}
