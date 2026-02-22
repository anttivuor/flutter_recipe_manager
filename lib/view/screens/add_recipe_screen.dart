import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../layout/responsive_scaffold.dart';
import '../../application/add_recipe_controller.dart';

class AddRecipeScreen extends StatelessWidget {
    final AddRecipeFormController controller = Get.put(AddRecipeFormController());

    @override
    Widget build(BuildContext context) {
        return ResponsiveScaffold(
            title: 'Add new recipe',
            child: FormBuilder(
                key: controller.formKey,
                child: ListView(
                    children: [
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

                        // Ingredients
                        Obx(() => _ChipInputSection(
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
                        Obx(() => _ChipInputSection(
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
                    ],
                ),
            ),
        );
    }
}

class _ChipInputSection extends StatelessWidget {
    final String title;
    final String type;
    final String hintText;
    final TextEditingController controller;
    final List<String> chips;
    final VoidCallback onAdd;
    final ValueChanged<String> onRemove;
    final void Function(int oldIndex, int newIndex) onReorder;
    final String? errorText;

    const _ChipInputSection({
        required this.title,
        required this.type,
        required this.hintText,
        required this.controller,
        required this.chips,
        required this.onAdd,
        required this.onRemove,
        required this.onReorder,
        this.errorText,
    });

    @override
    Widget build(BuildContext context) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: hintText,
                        border: const OutlineInputBorder(),
                        errorText: errorText,
                        suffix: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: FilledButton.icon(
                                onPressed: onAdd,
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text("Add"),
                                style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    minimumSize: const Size(0, 36), // compact height
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                            ),
                        ),
                    ),
                    onSubmitted: (_) => onAdd(),
                ),
                const SizedBox(height: 8),
                if (!chips.isEmpty)
                    ReorderableCards(
                        items: chips,
                        showIndex: type == 'steps',
                        onRemove: onRemove,
                        onReorder: onReorder,
                    ),
            ],
        );
    }
}

class ReorderableCards extends StatelessWidget {
    final List<String> items;
    final void Function(int oldIndex, int newIndex) onReorder;
    final void Function(String value) onRemove;

    final bool showIndex;

    const ReorderableCards({
        super.key,
        required this.items,
        required this.onReorder,
        required this.onRemove,
        this.showIndex = false,
    });

    @override
    Widget build(BuildContext context) {
        return ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: onReorder,
            itemCount: items.length,
            buildDefaultDragHandles: false,
            proxyDecorator: (child, index, animation) {
                return Material(
                    elevation: 0,
                    child: child,
                );
            },
            itemBuilder: (context, index) {
                final value = items[index];

                return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 8),
                    key: ValueKey(value),
                    child: ListTile(
                        leading: showIndex
                            ? CircleAvatar(radius: 14, child: Text('${index + 1}'))
                            : null,
                        title: Text(value),
                        trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                IconButton(
                                    tooltip: 'Remove',
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => onRemove(value),
                                ),
                                ReorderableDragStartListener(
                                    index: index,
                                    child: const Icon(Icons.drag_handle),
                                ),
                            ],
                        ),
                    ),
                );
            },
        );
    }
}