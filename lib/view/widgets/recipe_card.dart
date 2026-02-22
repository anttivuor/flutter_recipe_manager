import 'package:flutter/material.dart';

import '../../models/recipe.dart';
import '../layout/breakpoints.dart';

class RecipeCard extends StatelessWidget {
    final Recipe recipe;
    final VoidCallback? onTap;
    final VoidCallback? onDelete;

    const RecipeCard({
        super.key,
        required this.recipe,
        this.onTap,
        this.onDelete,
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
                                _InfoChip(icon: Icons.schedule, label: '${recipe.minutes} min'),
                                _InfoChip(icon: Icons.people, label: '${recipe.servings} servings'),
                            ],
                        ),
                        if (isMobile)
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                    IconButton(
                                        tooltip: 'Edit',
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => {

                                        },
                                    ),
                                    IconButton(
                                        tooltip: 'Remove',
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: onDelete,
                                    ),
                                ],
                            ),
                    ]
                ),
                trailing: !isMobile ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        IconButton(
                            tooltip: 'Edit',
                            icon: const Icon(Icons.edit),
                            onPressed: () => {

                            },
                        ),
                        IconButton(
                            tooltip: 'Remove',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: onDelete,
                        ),
                    ],
                ) : null,
            ),
        );
    }
}

class _InfoChip extends StatelessWidget {
    final IconData icon;
    final String label;

    const _InfoChip({
        required this.icon,
        required this.label,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Icon(icon, size: 16),
                    const SizedBox(width: 4),
                    Text(label),
                ],
            ),
        );
    }
}