import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../application/recipe_controller.dart';
import '../models/recipe.dart';

class AddRecipeFormController extends GetxController {
    final RecipeController recipeController = Get.find<RecipeController>();

    final formKey = GlobalKey<FormBuilderState>();

    final ingredients = <String>[].obs;
    final steps = <String>[].obs;

    final ingredientCtrl = TextEditingController();
    final stepCtrl = TextEditingController();

    final ingredientsError = RxnString();
    final stepsError = RxnString();

    final isSaving = false.obs;

    @override
    void onClose() {
        ingredientCtrl.dispose();
        stepCtrl.dispose();
        super.onClose();
    }

    bool validateLists() {
        ingredientsError.value = ingredients.isEmpty ? 'Add at least one ingredient' : null;
        stepsError.value = steps.isEmpty ? 'Add at least one step' : null;

        return !steps.isEmpty && !ingredients.isEmpty;
    }

    void _syncListsIntoForm() {
        final state = formKey.currentState;
        if (state == null) return;

        state.fields['ingredients']?.didChange(ingredients.toList());
        state.fields['steps']?.didChange(steps.toList());
    }

    void addIngredient() {
        _addChip(ingredientCtrl, ingredients);
        ingredientsError.value = null;
    }

    void addStep() {
        _addChip(stepCtrl, steps);
        stepsError.value = null;
    }

    void removeIngredient(String v) {
        _removeChip(ingredients, v);
    }

    void removeStep(String v) {
        _removeChip(steps, v);
    }

    void _addChip(TextEditingController input, RxList<String> list) {
        final v = input.text.trim();
        if (v.isEmpty) return;

        if (!list.contains(v)) {
            list.add(v);
        }
        input.clear();

        _syncListsIntoForm();
    }

    void _removeChip(RxList<String> list, String value) {
        list.remove(value);
        _syncListsIntoForm();
    }

    void reorderSteps(int oldIndex, int newIndex) {
        if (newIndex > oldIndex) newIndex -= 1;
        final item = steps.removeAt(oldIndex);
        steps.insert(newIndex, item);
        validateLists(); // keep your list validation synced
    }

    void reorderIngredients(int oldIndex, int newIndex) {
        if (newIndex > oldIndex) newIndex -= 1;
        final item = ingredients.removeAt(oldIndex);
        ingredients.insert(newIndex, item);
        validateLists();
    }

    Future<void> submit() async {
        if (isSaving.value) return;

        final state = formKey.currentState;
        if (state == null) return;

        _syncListsIntoForm();

        final listsValid = validateLists();
        final isValid = state.saveAndValidate();
        if (!isValid || !listsValid) return;

        isSaving.value = true;

        try {
            final values = state.value;

            final now = DateTime.now();
            final recipe = Recipe(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                title: (values['title'] as String).trim(),
                description: ((values['description'] as String?) ?? '').trim(),
                minutes: values['minutes'] as int,
                servings: values['servings'] as int,
                ingredients: List<String>.from(ingredients),
                steps: List<String>.from(steps),
                createdAt: now,
                updatedAt: now,
            );

            recipeController.addRecipe(recipe);

            if (Get.key.currentState?.canPop() ?? false) {
                Get.back();
            } else {
                Get.offAllNamed('/');
            }
            Get.snackbar(
                'Saved',
                'Recipe added',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.all(10),
                animationDuration: Duration(milliseconds: 300),
            );
        } catch (error) {
            Get.snackbar(
                'Something went wrong',
                'Try again later',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.all(10),
                animationDuration: Duration(milliseconds: 300),
            );
        } finally {
            isSaving.value = false;
        }
    }
}