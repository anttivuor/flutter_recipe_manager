import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../layout/responsive_scaffold.dart';
import '../widgets/chip_input.dart';
import '../../application/recipe_form_controller.dart';

class AddRecipeScreen extends StatefulWidget {
    const AddRecipeScreen({super.key});

    @override
    State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
    late final RecipeFormController controller;

    @override
    void initState() {
        super.initState();
        controller = Get.put(RecipeFormController());
    }

    @override
    void dispose() {
        Get.delete<RecipeFormController>(force: true);
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return ResponsiveScaffold(
            title: 'Add new recipe',
            child: FormBuilder(
                key: controller.formKey,
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
                                labelText: 'Description *',
                                border: OutlineInputBorder(),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            minLines: 2,
                            maxLines: 5,
                            textInputAction: TextInputAction.next,
                            validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(2),
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

                        // Ingredients
                        Obx(() => ChipInput(
                            title: 'Ingredients *',
                            type: 'ingredients',
                            hintText: 'e.g. 2 eggs, 200g flour',
                            controller: controller.ingredientCtrl,
                            chips: controller.ingredients.toList(),
                            onAdd: controller.addIngredient,
                            onRemove: controller.removeIngredient,
                            onReorder: controller.reorderIngredients,
                            errorText: controller.ingredientsError.value,
                        )),

                        const SizedBox(height: 12),

                        // Steps
                        Obx(() => ChipInput(
                            title: 'Steps *',
                            type: 'steps',
                            hintText: 'e.g. Mix ingredients',
                            controller: controller.stepCtrl,
                            chips: controller.steps.toList(),
                            onAdd: controller.addStep,
                            onRemove: controller.removeStep,
                            onReorder: controller.reorderSteps,
                            errorText: controller.stepsError.value,
                        )),

                        const SizedBox(height: 24),

                        Obx(() => OutlinedButton.icon(
                            onPressed: controller.isSaving.value ? null : controller.submit,
                            icon: const Icon(Icons.save),
                            label: Text(controller.isSaving.value ? 'Saving…' : 'Save recipe'),
                        )),

                        const SizedBox(height: 12),
                    ],
                ),
            ),
        );
    }
}