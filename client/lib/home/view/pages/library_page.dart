import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
class LibraryPage extends ConsumerStatefulWidget {
  /// Creates a [LibraryPage] widget.
  const LibraryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LibraryState();
}

class _LibraryState extends ConsumerState<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('LibraryPage'));
  }
}
