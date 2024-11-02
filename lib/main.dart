import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

void main() {
  runApp(const MyApp());
}

/// The main application widget.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: buildIcon,
          ),
        ),
      ),
    );
  }

  /// Builds an icon widget with specific styling.
  ///
  /// The [iconData] parameter is the icon to display within the container.
  Widget buildIcon(IconData iconData) {
    return Container(
      constraints: const BoxConstraints(minWidth: 48),
      height: 48,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.primaries[iconData.hashCode % Colors.primaries.length],
      ),
      child: Center(child: Icon(iconData, color: Colors.white)),
    );
  }
}

/// A widget that displays a list of items in a reorderable row.
///
/// The [Dock] widget is generic and can take any type of item. Each item is
/// displayed using the [builder] function provided.
class Dock<T> extends StatefulWidget {
  /// Creates a [Dock] widget.
  ///
  /// The [items] list defines the items to be displayed, and [builder] is
  /// a function that creates a widget for each item.
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// The list of items to display.
  final List<T> items;

  /// A function that builds a widget for each item in [items].
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

class _DockState<T> extends State<Dock<T>> {
  /// A copy of the items list that can be reordered within this widget.
  late final List<T> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black12.withOpacity(0.1),
          ),
          padding: const EdgeInsets.all(4),
          child: ReorderableRow(
            needsLongPressDraggable: false,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _items.map((item) {
              final index = _items.indexOf(item);
              return KeyedSubtree(
                key: ValueKey(index),
                child: widget.builder(item),
              );
            }).toList(),
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex--;
                }
                final item = _items.removeAt(oldIndex);
                _items.insert(newIndex, item);
              });
            },
          ),
        ),
      ),
    );
  }
}
