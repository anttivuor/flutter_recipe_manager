import 'package:get/get.dart';
import '../infrastructure/recipe_service.dart';
import '../models/recipe.dart';

class RecipeController extends GetxController {
    final RecipeService service = Get.find<RecipeService>();

    final recipes = <Recipe>[].obs;
    final searchQuery = ''.obs;

    @override
    void onInit() {
        super.onInit();
        loadRecipes();
    }

    void loadRecipes() {
        recipes.assignAll(service.getAll());
    }

    void setSearchQuery(String value) {
        searchQuery.value = value;
    }

    List<Recipe> get filteredRecipes {
        final q = searchQuery.value.trim().toLowerCase();
        if (q.isEmpty) return recipes;

        bool matches(Recipe r) {
            final title = r.title.toLowerCase();
            final desc = r.description.toLowerCase();
            return title.contains(q) || desc.contains(q);
        }

        return recipes.where(matches).toList();
    }

    Future<void> addRecipe(Recipe recipe) async {
        await service.upsert(recipe);
        recipes.insert(0, recipe);
    }

    Future<void> updateRecipe(Recipe recipe) async {
        recipe.updatedAt = DateTime.now();
        await service.upsert(recipe);

        final idx = recipes.indexWhere((r) => r.id == recipe.id);
        if (idx != -1) {
            recipes[idx] = recipe;
            recipes.refresh();
        } else {
            // if it wasn't loaded for some reason
            loadRecipes();
        }
    }

    Future<void> deleteRecipe(String id) async {
        await service.delete(id);
        recipes.removeWhere((r) => r.id == id);
    }

    Recipe? findLocalById(String id) {
        final idx = recipes.indexWhere((r) => r.id == id);
        return idx == -1 ? null : recipes[idx];
    }
}