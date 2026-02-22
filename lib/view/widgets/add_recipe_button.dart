import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddRecipeButton extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return FloatingActionButton(
            onPressed: () => Get.toNamed('/recipes/new'),
            child: const Icon(Icons.add),
            tooltip: 'Add new recipe',
        );
    }
}