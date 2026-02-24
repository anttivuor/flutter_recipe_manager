import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/recipe.dart';
import '../layout/breakpoints.dart';
import '../widgets/info_chip.dart';

class RecipeCard extends StatelessWidget {
    final Recipe recipe;
    final VoidCallback onTap;
    final VoidCallback onDelete;
    final void Function(Recipe) onUpdate;

    const RecipeCard({
        super.key,
        required this.recipe,
        required this.onTap,
        required this.onDelete,
        required this.onUpdate,
    });

    @override
    Widget build(BuildContext context) {
        final isMobile = AppBreakpoints.isMobile(context);

        return Card(
            elevation: 1,
            child: ListTile(
                onTap: onTap,
                title: Text(recipe.title),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(recipe.description),
                        const SizedBox(height: 4),
                        Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                                InfoChip(icon: Icons.schedule, label: '${recipe.minutes} min'),
                                InfoChip(icon: Icons.people, label: '${recipe.servings} servings'),
                            ],
                        ),
                        if (isMobile)
                            _ActionButtons(recipe: recipe, onDelete: onDelete, onUpdate: onUpdate)
                    ]
                ),
                trailing: !isMobile ? _ActionButtons(recipe: recipe, onDelete: onDelete, onUpdate: onUpdate) : null,
            ),
        );
    }
}

class _ActionButtons extends StatelessWidget {
    final Recipe recipe;
    final VoidCallback onDelete;
    final void Function(Recipe) onUpdate;

    const _ActionButtons({
        required this.recipe,
        required this.onDelete,
        required this.onUpdate,
    });

    @override
    Widget build(BuildContext context) {
        return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
                IconButton(
                    tooltip: recipe.favorite ? 'Remove from favorites' : 'Add to favorites',
                    icon: recipe.favorite ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
                    onPressed: () {
                        onUpdate(recipe.copyWith(favorite: !recipe.favorite));
                    },
                ),
                IconButton(
                    tooltip: 'Edit',
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                        Get.toNamed('/recipes/${recipe.id}/edit');
                    },
                ),
                IconButton(
                    tooltip: 'Remove',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                        final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                                title: const Text('Delete recipe?'),
                                content: const Text('This cannot be undone.'),
                                actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text('Delete'),
                                    ),
                                ],
                            ),
                        );

                        if (ok == true) {
                            onDelete();
                        }
                    },
                ),
            ]
        );
    }
}