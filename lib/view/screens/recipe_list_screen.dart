import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../layout/responsive_scaffold_with_menu.dart';
import '../widgets/recipe_card.dart';
import '../../application/recipe_controller.dart';
import '../layout/breakpoints.dart';

class RecipeListScreen extends StatelessWidget {
    final controller = Get.find<RecipeController>();

    @override
    Widget build(BuildContext context) {
        final isMobile = AppBreakpoints.isMobile(context);
        final isTablet = AppBreakpoints.isTablet(context);

        return ResponsiveScaffoldWithMenu(
            title: 'Recipes',
            actions: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: FilledButton.icon(
                        onPressed: () {
                            Get.toNamed('/recipes/new');
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(isMobile ? "New" : isTablet ? "New recipe" :  "Add new recipe"),
                    ),
                ),
            ],
            child: Obx(() {
                if (controller.recipes.isEmpty) {
                    return Text('No recipes yet');
                }
                return ListView.separated(
                    itemCount: controller.recipes.length,
                    padding: EdgeInsets.only(right: 10, left: 10),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                        final recipe = controller.recipes[index];

                        return RecipeCard(
                            recipe: recipe,
                            onTap: () {
                                Get.toNamed('/recipes/${recipe.id}');
                            },
                            onDelete: () {
                                controller.deleteRecipe(recipe.id);
                            },
                        );
                    },
                );
            }),
        );
    }
}