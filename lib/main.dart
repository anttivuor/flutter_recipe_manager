import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import './application/recipe_controller.dart';
import './infrastructure/recipe_service.dart';
import './infrastructure/mock_recipes.dart';

import './view/screens/recipe_list_screen.dart';
import './view/screens/favorites_list_screen.dart';
import './view/screens/stats_screen.dart';
import './view/screens/add_recipe_screen.dart';

Future<void> main() async {
    await Hive.initFlutter();
    await Hive.openBox('recipes');

    await addMockRecipesIfEmpty();

    Get.lazyPut<RecipeController>(() => RecipeController(), fenix: true);
    Get.lazyPut<RecipeService>(() => RecipeService(), fenix: true);

    runApp(
        GetMaterialApp(
            initialRoute: "/",
            getPages: [
                GetPage(
                    name: "/",
                    page: () => RecipeListScreen(),
                    transition: Transition.noTransition,
                ),
                GetPage(
                    name: "/favorites",
                    page: () => FavoritesListScreen(),
                    transition: Transition.noTransition,
                ),
                GetPage(
                    name: "/recipes/new",
                    page: () => AddRecipeScreen(),
                ),
                GetPage(
                    name: "/recipes/:id",
                    page: () => AddRecipeScreen(),
                ),
                GetPage(
                    name: "/recipes/:id/edit",
                    page: () => RecipeListScreen(),
                ),
                GetPage(
                    name: "/stats",
                    page: () => StatsScreen(),
                    transition: Transition.noTransition,
                ),
            ],
        ),
    );
}