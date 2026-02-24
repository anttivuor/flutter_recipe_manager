import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../application/recipe_controller.dart';
import '../models/recipe.dart';

class RecipeFormController extends GetxController {
    RecipeFormController({this.initialRecipe});

    final Recipe? initialRecipe;

    final RecipeController recipeController = Get.find<RecipeController>();
    final formKey = GlobalKey<FormBuilderState>();

    final ingredients = <String>[].obs;
    final steps = <String>[].obs;

    final ingredientCtrl = TextEditingController();
    final stepCtrl = TextEditingController();

    final ingredientsError = RxnString();
    final stepsError = RxnString();

    final isSaving = false.obs;

    bool get isEditMode => initialRecipe != null;

    /// Use this in FormBuilder(initialValue: controller.initialFormValue)
    Map<String, dynamic> get initialFormValue {
        final r = initialRecipe;
        if (r == null) return {};
        return {
            'title': r.title,
            'description': r.description,
            'minutes': r.minutes.toString(),
            'servings': r.servings.toString(),
        };
    }

    @override
    void onInit() {
        super.onInit();

        // Prefill lists for edit mode
        final r = initialRecipe;
        if (r != null) {
            ingredients.assignAll(r.ingredients);
            steps.assignAll(r.steps);
        }
    }

    @override
    void onClose() {
        ingredientCtrl.dispose();
        stepCtrl.dispose();
        super.onClose();
    }

    bool validateLists() {
        ingredientsError.value = ingredients.isEmpty ? 'Add at least one ingredient' : null;
        stepsError.value = steps.isEmpty ? 'Add at least one step' : null;

        return ingredients.isNotEmpty && steps.isNotEmpty;
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

    void removeIngredient(String v) => _removeChip(ingredients, v);
    void removeStep(String v) => _removeChip(steps, v);

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
        _syncListsIntoForm();
    }

    void reorderIngredients(int oldIndex, int newIndex) {
        if (newIndex > oldIndex) newIndex -= 1;
        final item = ingredients.removeAt(oldIndex);
        ingredients.insert(newIndex, item);
        _syncListsIntoForm();
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

            final Recipe recipeToSave;

            if (isEditMode) {
                final old = initialRecipe!;
                recipeToSave = old.copyWith(
                    title: (values['title'] as String).trim(),
                    description: ((values['description'] as String?) ?? '').trim(),
                    minutes: values['minutes'] as int,
                    servings: values['servings'] as int,
                    ingredients: List<String>.from(ingredients),
                    steps: List<String>.from(steps),
                    updatedAt: now,
                );

                await recipeController.updateRecipe(recipeToSave);

                if (Get.key.currentState?.canPop() ?? false) {
                    Get.back();
                } else {
                    Get.offAllNamed('/');
                }

                Get.snackbar(
                    'Saved',
                    'Recipe updated',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(10),
                    animationDuration: const Duration(milliseconds: 300),
                );
            } else {
                recipeToSave = Recipe(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    title: (values['title'] as String).trim(),
                    description: ((values['description'] as String?) ?? '').trim(),
                    minutes: values['minutes'] as int,
                    servings: values['servings'] as int,
                    ingredients: List<String>.from(ingredients),
                    steps: List<String>.from(steps),
                    favorite: false,
                    createdAt: now,
                    updatedAt: now,
                );

                await recipeController.addRecipe(recipeToSave);

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
                    margin: const EdgeInsets.all(10),
                    animationDuration: const Duration(milliseconds: 300),
                );
            }
        } catch (_) {
            Get.snackbar(
                'Something went wrong',
                'Try again later',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(10),
                animationDuration: const Duration(milliseconds: 300),
            );
        } finally {
            isSaving.value = false;
        }
    }
}