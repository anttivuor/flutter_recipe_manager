import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../layout/responsive_scaffold_with_menu.dart';
import '../widgets/recipe_card.dart';
import '../../application/recipe_controller.dart';
import '../layout/breakpoints.dart';
import '../../models/recipe.dart';

class FavoritesListScreen extends StatefulWidget {
    const FavoritesListScreen({super.key});

    @override
    State<FavoritesListScreen> createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {
    final controller = Get.find<RecipeController>();
    final searchController = TextEditingController();

    @override
    void dispose() {
        searchController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final isMobile = AppBreakpoints.isMobile(context);
        final isTablet = AppBreakpoints.isTablet(context);

        return ResponsiveScaffoldWithMenu(
            title: 'Favorites',
            actions: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: FilledButton.icon(
                        onPressed: () => Get.toNamed('/recipes/new'),
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(isMobile ? "New" : isTablet ? "New recipe" : "Add new recipe"),
                    ),
                ),
            ],
            child: Column(
                children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                        child: TextField(
                            controller: searchController,
                            onChanged: controller.setSearchQuery,
                            decoration: InputDecoration(
                                hintText: 'Search favorites...',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: Obx(() {
                                    if (controller.searchQuery.value.isEmpty) return const SizedBox.shrink();
                                    return IconButton(
                                        tooltip: 'Clear',
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                            searchController.clear();
                                            controller.setSearchQuery('');
                                        },
                                    );
                                }),
                                border: const OutlineInputBorder(),
                            ),
                        ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                        child: Obx(() {
                            final shown = controller.filteredFavorites;

                            if (controller.recipes.isEmpty) {
                                return const Center(child: Text('No recipes yet'));
                            }

                            if (shown.isEmpty) {
                                return const Center(child: Text('No favorites found'));
                            }

                            return ListView.separated(
                                itemCount: shown.length,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                    final recipe = shown[index];

                                    return RecipeCard(
                                        recipe: recipe,
                                        onTap: () => Get.toNamed('/recipes/${recipe.id}'),
                                        onDelete: () => controller.deleteRecipe(recipe.id),
                                        onUpdate: controller.updateRecipe,
                                    );
                                },
                            );
                        }),
                    ),
                ],
            ),
        );
    }
}