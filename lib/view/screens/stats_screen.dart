import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../layout/responsive_scaffold_with_menu.dart';
import '../../application/recipe_controller.dart';

class StatsScreen extends StatelessWidget {
    StatsScreen({super.key});

    final controller = Get.find<RecipeController>();

    @override
    Widget build(BuildContext context) {
        return ResponsiveScaffoldWithMenu(
            title: 'Statistics',
            child: Obx(() {
                final recipes = controller.recipes.toList();
                final total = recipes.length;
                final favorites = recipes.where((r) => r.favorite).length;

                final mostViewed = [...recipes]
                    ..sort((a, b) => b.views.compareTo(a.views));

                final top = mostViewed.take(10).toList();

                return Padding(
                    padding: EdgeInsets.only(left: 12, right: 12),
                    child: ListView(
                        children: [
                            const SizedBox(height: 12),
                            _StatCard(label: 'Total recipes', value: '$total'),
                            _StatCard(label: 'Favorited recipes', value: '$favorites'),
                            const SizedBox(height: 24),

                            Text('Most viewed', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),

                            if (top.isEmpty)
                                const Text('No recipes yet')
                            else
                                ...top.map((r) => Card(
                                    elevation: 1,
                                    child: ListTile(
                                    title: Text(r.title),
                                    subtitle: Text(r.favorite ? 'Favorited' : 'Not favorited'),
                                    trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                            const Icon(Icons.visibility, size: 18),
                                            const SizedBox(width: 6),
                                            Text('${r.views}', style: Theme.of(context).textTheme.titleMedium),
                                        ],
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                    ),
                                    onTap: () => Get.toNamed('/recipes/${r.id}'),
                                ),
                            )),

                            const SizedBox(height: 12),

                            Text('All view counts', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),

                            ...recipes.map((r) => ListTile(
                                dense: true,
                                title: Text(r.title),
                                trailing: Text('${r.views}', style: Theme.of(context).textTheme.titleMedium),
                            )),
                            const SizedBox(height: 12),
                        ],
                    ),
                );
            }),
        );
    }
}

class _StatCard extends StatelessWidget {
    final String label;
    final String value;

    const _StatCard({required this.label, required this.value});

    @override
    Widget build(BuildContext context) {
        return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: ListTile(
                title: Text(label),
                trailing: Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge,
                ),
            ),
        );
    }
}