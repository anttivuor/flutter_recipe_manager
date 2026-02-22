import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../layout/responsive_scaffold_with_menu.dart';
import '../../application/recipe_controller.dart';

class FavoritesListScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {

        return ResponsiveScaffoldWithMenu(
            title: 'Favorites',
            actions: [
                IconButton(
                    tooltip: 'Stats',
                    onPressed: () => Get.toNamed('/stats'),
                    icon: const Icon(Icons.bar_chart),
                ),
            ],
            child: Center(
                child: Obx(() => OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text("Favorites"),
                )),
            ),
        );
    }
}