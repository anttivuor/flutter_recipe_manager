import 'package:hive_ce_flutter/hive_flutter.dart';
import '../models/recipe.dart';

class RecipeService {
    final Box box = Hive.box('recipes');

    List<Recipe> getAll() {
        return box.values
            .whereType<Map>()
            .map((m) => Recipe.fromJson(m))
            .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    Recipe? getById(String id) {
        final data = box.get(id);
        if (data is Map) return Recipe.fromJson(data);
        return null;
    }

    Future<void> upsert(Recipe recipe) async {
        await box.put(recipe.id, recipe.toJson());
    }

    Future<void> delete(String id) async {
        await box.delete(id);
    }
}