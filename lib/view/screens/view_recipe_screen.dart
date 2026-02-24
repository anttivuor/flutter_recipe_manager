import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../layout/responsive_scaffold_with_menu.dart';
import '../layout/breakpoints.dart';
import '../../application/recipe_controller.dart';
import '../../models/recipe.dart';
import '../widgets/info_chip.dart';

class ViewRecipeScreen extends StatefulWidget {
    const ViewRecipeScreen({super.key});

    @override
    State<ViewRecipeScreen> createState() => _ViewRecipeScreenState();
}

class _ViewRecipeScreenState extends State<ViewRecipeScreen> {
    final controller = Get.find<RecipeController>();
    late final String id = Get.parameters['id']!;

    @override
    void initState() {
        super.initState();
        // run after first frame so it doesn't run during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.incrementViews(id);
        });
    }

    @override
    Widget build(BuildContext context) {
        final id = Get.parameters['id'];
        if (id == null) {
            return const ResponsiveScaffoldWithMenu(title: 'Not found', child: Center(child: Text('Recipe not found')));
        }

        final isMobile = AppBreakpoints.isMobile(context);

        return Obx(() {
            final recipe = controller.findLocalById(id);

            if (recipe == null) {
                return const ResponsiveScaffoldWithMenu(title: 'Not found', child: Center(child: Text('Recipe not found')));
            }

            return ResponsiveScaffoldWithMenu(
                title: recipe.title,
                child: Padding(
                    padding: EdgeInsets.only(left: 12, right: 12),
                    child: ListView(
                        children: [
                            const SizedBox(height: 12),
                            // Header actions
                            Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                    InfoChip(icon: Icons.schedule, label: '${recipe.minutes} min'),
                                    InfoChip(icon: Icons.people, label: '${recipe.servings} servings'),
                                    recipe.favorite
                                        ? FilledButton.icon(
                                            onPressed: () {
                                                controller.updateRecipe(
                                                    recipe.copyWith(favorite: false),
                                                );
                                            },
                                            icon: Icon(Icons.favorite),
                                            label: Text('Favorited'),
                                        ) : OutlinedButton.icon(
                                            onPressed: () {
                                                controller.updateRecipe(
                                                    recipe.copyWith(favorite: true),
                                                );
                                            },
                                            icon: Icon(Icons.favorite_border),
                                            label: Text('Favorite'),
                                        ),
                                    OutlinedButton.icon(
                                        onPressed: () => Get.toNamed('/recipes/${recipe.id}/edit'),
                                        icon: const Icon(Icons.edit),
                                        label: const Text('Edit'),
                                    ),
                                    OutlinedButton.icon(
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
                                                await controller.deleteRecipe(recipe.id);
                                                if (Get.key.currentState?.canPop() ?? false) {
                                                    Get.back();
                                                } else {
                                                    Get.offAllNamed('/');
                                                }
                                            }
                                        },
                                        icon: const Icon(Icons.delete_outline),
                                        label: const Text('Delete'),
                                    ),
                                ],
                            ),

                            const SizedBox(height: 16),

                            if (recipe.description.trim().isNotEmpty) ...[
                                Text('Description', style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 6),
                                Text(recipe.description),
                                const SizedBox(height: 16),
                            ],

                            Text('Ingredients', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            ...recipe.ingredients.map((i) => _BulletLine(text: i)),

                            const SizedBox(height: 16),

                            Text('Steps', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            ...recipe.steps.asMap().entries.map((e) {
                                final idx = e.key + 1;
                                final step = e.value;
                                return _StepCard(index: idx, text: step, compact: isMobile);
                            }),

                            const SizedBox(height: 12),
                        ],
                    ),
                ),
            );
        });
    }
}

class _BulletLine extends StatelessWidget {
    final String text;
    const _BulletLine({required this.text});

    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    const Text('•  '),
                    Expanded(child: Text(text)),
                ],
            ),
        );
    }
}

class _StepCard extends StatelessWidget {
    final int index;
    final String text;
    final bool compact;

    const _StepCard({
        required this.index,
        required this.text,
        required this.compact,
    });

    @override
    Widget build(BuildContext context) {
        return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
                leading: CircleAvatar(
                    radius: compact ? 14 : 16,
                    child: Text('$index'),
                ),
                title: Text(text),
            ),
        );
    }
}