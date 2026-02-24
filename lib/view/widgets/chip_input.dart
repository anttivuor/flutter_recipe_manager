import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChipInput extends StatelessWidget {
    final String title;
    final String type;
    final String hintText;
    final TextEditingController controller;
    final List<String> chips;
    final VoidCallback onAdd;
    final ValueChanged<String> onRemove;
    final void Function(int oldIndex, int newIndex) onReorder;
    final String? errorText;

    const ChipInput({
        required this.title,
        required this.type,
        required this.hintText,
        required this.controller,
        required this.chips,
        required this.onAdd,
        required this.onRemove,
        required this.onReorder,
        this.errorText,
    });

    @override
    Widget build(BuildContext context) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: hintText,
                        border: const OutlineInputBorder(),
                        errorText: errorText,
                        suffix: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: FilledButton.icon(
                                onPressed: onAdd,
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text("Add"),
                                style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    minimumSize: const Size(0, 36), // compact height
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                            ),
                        ),
                    ),
                    onSubmitted: (_) => onAdd(),
                ),
                const SizedBox(height: 8),
                if (!chips.isEmpty)
                    ReorderableCards(
                        items: chips,
                        showIndex: type == 'steps',
                        onRemove: onRemove,
                        onReorder: onReorder,
                    ),
            ],
        );
    }
}

class ReorderableCards extends StatelessWidget {
    final List<String> items;
    final void Function(int oldIndex, int newIndex) onReorder;
    final void Function(String value) onRemove;

    final bool showIndex;

    const ReorderableCards({
        super.key,
        required this.items,
        required this.onReorder,
        required this.onRemove,
        this.showIndex = false,
    });

    @override
    Widget build(BuildContext context) {
        return ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: onReorder,
            itemCount: items.length,
            buildDefaultDragHandles: false,
            proxyDecorator: (child, index, animation) {
                return Material(
                    elevation: 0,
                    child: child,
                );
            },
            itemBuilder: (context, index) {
                final value = items[index];

                return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 8),
                    key: ValueKey(value),
                    child: ListTile(
                        leading: showIndex
                            ? CircleAvatar(radius: 14, child: Text('${index + 1}'))
                            : null,
                        title: Text(value),
                        trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                IconButton(
                                    tooltip: 'Remove',
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => onRemove(value),
                                ),
                                ReorderableDragStartListener(
                                    index: index,
                                    child: const Icon(Icons.drag_handle),
                                ),
                            ],
                        ),
                    ),
                );
            },
        );
    }
}