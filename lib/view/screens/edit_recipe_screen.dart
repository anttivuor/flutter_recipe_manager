import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../layout/responsive_scaffold.dart';
import '../widgets/chip_input.dart';
import '../../models/recipe.dart';
import '../../application/recipe_form_controller.dart';
import '../../application/recipe_controller.dart';

class EditRecipeScreen extends StatefulWidget {
    const EditRecipeScreen({super.key});

    @override
    State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
    late final String id = Get.parameters['id']!;
    final recipeController = Get.find<RecipeController>();
    late final RecipeFormController formController;

    @override
    void initState() {
        super.initState();
        final recipe = recipeController.findLocalById(id);
        if (recipe == null) return;

        formController = Get.put(
            RecipeFormController(initialRecipe: recipe),
            tag: id,
        );
    }

    @override
    void dispose() {
        Get.delete<RecipeFormController>(tag: id, force: true);
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final recipe = recipeController.findLocalById(id);
        if (recipe == null) {
            return const Scaffold(body: Center(child: Text('Recipe not found')));
        }

        return ResponsiveScaffold(
            title: 'Edit recipe',
            child: FormBuilder(
                key: formController.formKey,
                initialValue: formController.initialFormValue,
                child: ListView(
                    children: [
                        const SizedBox(height: 12),
                        FormBuilderTextField(
                            name: 'title',
                            decoration: const InputDecoration(
                                labelText: 'Title *',
                                border: OutlineInputBorder(),

                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(2),
                                FormBuilderValidators.maxLength(80),
                            ]),
                        ),

                        const SizedBox(height: 12),

                        FormBuilderTextField(
                            name: 'description',
                            decoration: const InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            minLines: 2,
                            maxLines: 5,
                            textInputAction: TextInputAction.next,
                            validator: FormBuilderValidators.compose([
                                FormBuilderValidators.maxLength(500),
                            ]),
                        ),

                        const SizedBox(height: 12),

                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Expanded(
                                    child: FormBuilderTextField(
                                        name: 'minutes',
                                        decoration: const InputDecoration(
                                            labelText: 'Minutes *',
                                            border: OutlineInputBorder(),
                                        ),
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        keyboardType: TextInputType.number,
                                        valueTransformer: (v) => int.tryParse((v ?? '').toString()),
                                        validator: FormBuilderValidators.compose([
                                            FormBuilderValidators.required(),
                                            FormBuilderValidators.integer(),
                                            FormBuilderValidators.min(1),
                                            FormBuilderValidators.max(24 * 60),
                                        ]),
                                    ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: FormBuilderTextField(
                                        name: 'servings',
                                        decoration: const InputDecoration(
                                            labelText: 'Servings *',
                                            border: OutlineInputBorder(),
                                        ),
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        keyboardType: TextInputType.number,
                                        valueTransformer: (v) => int.tryParse((v ?? '').toString()),
                                        validator: FormBuilderValidators.compose([
                                            FormBuilderValidators.required(),
                                            FormBuilderValidators.integer(),
                                            FormBuilderValidators.min(1),
                                            FormBuilderValidators.max(200),
                                        ]),
                                    ),
                                ),
                            ],
                        ),

                        const SizedBox(height: 12),

                        Obx(() => ChipInput(
                            title: 'Ingredients *',
                            type: 'ingredients',
                            hintText: 'e.g. 2 eggs, 200g flour',
                            controller: formController.ingredientCtrl,
                            chips: formController.ingredients.toList(),
                            onAdd: formController.addIngredient,
                            onRemove: formController.removeIngredient,
                            onReorder: formController.reorderIngredients,
                            errorText: formController.ingredientsError.value,
                        )),

                        const SizedBox(height: 12),

                        Obx(() => ChipInput(
                            title: 'Steps *',
                            type: 'steps',
                            hintText: 'e.g. Mix ingredients',
                            controller: formController.stepCtrl,
                            chips: formController.steps.toList(),
                            onAdd: formController.addStep,
                            onRemove: formController.removeStep,
                            onReorder: formController.reorderSteps,
                            errorText: formController.stepsError.value,
                        )),

                        const SizedBox(height: 24),

                        Obx(() => OutlinedButton.icon(
                            onPressed: formController.isSaving.value ? null : formController.submit,
                            icon: const Icon(Icons.save),
                            label: Text(formController.isSaving.value ? 'Saving…' : 'Save changes'),
                        )),

                        const SizedBox(height: 12),
                    ],
                ),
            ),
        );
    }
}