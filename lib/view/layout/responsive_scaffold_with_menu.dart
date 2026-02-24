import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './breakpoints.dart';
import '../widgets/add_recipe_button.dart';

class ResponsiveScaffoldWithMenu extends StatelessWidget {
    final Widget child;
    final String title;
    final List<Widget>? actions;

    const ResponsiveScaffoldWithMenu({
        super.key,
        required this.child,
        required this.title,
        this.actions,
    });

    int _selectedIndexFromRoute(String route) {
        if (route.startsWith('/stats')) return 2;
        if (route.startsWith('/favorites')) return 1;
        return 0;
    }

    void _navigateForIndex(int index) {
        switch (index) {
        case 0:
            Get.offNamed('/');
            break;
        case 1:
            Get.offNamed('/favorites');
            break;
        case 2:
            Get.offNamed('/stats');
            break;
        }
    }

    @override
    Widget build(BuildContext context) {
        final route = Get.currentRoute;
        final selectedIndex = _selectedIndexFromRoute(route);

        final isMobile = AppBreakpoints.isMobile(context);
        final isDesktop = AppBreakpoints.isDesktop(context);

        return LayoutBuilder(
            builder: (context, c) {
                const maxWidth = 1000.0;

                Widget content = Center(
                    child: Column(
                        children: [
                            AppBar(title: Text(title), actions: actions),
                            Expanded(child: child),
                        ],
                    ),
                );

                if (!isMobile) {
                    content = Center(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: maxWidth,
                                minWidth: c.maxWidth < maxWidth ? c.maxWidth : maxWidth,
                            ),
                            child: Row(
                                children: [
                                    NavigationRail(
                                        selectedIndex: selectedIndex,
                                        onDestinationSelected: _navigateForIndex,
                                        labelType: isDesktop
                                            ? NavigationRailLabelType.none
                                            : NavigationRailLabelType.all,
                                        extended: isDesktop,
                                        leading: isDesktop ? Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                                "Menu",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                ),
                                            ),
                                        ) : null,
                                        destinations: const [
                                            NavigationRailDestination(
                                                icon: Icon(Icons.fastfood),
                                                label: Text('Recipes'),
                                            ),
                                            NavigationRailDestination(
                                                icon: Icon(Icons.favorite),
                                                label: Text('Favorites'),
                                            ),
                                            NavigationRailDestination(
                                                icon: Icon(Icons.query_stats),
                                                label: Text('Statistics'),
                                            ),
                                        ],
                                    ),
                                    const VerticalDivider(width: 1),
                                    Expanded(child: content),
                                ],
                            ),
                        ),
                    );
                }

                return Scaffold(
                    floatingActionButton: AddRecipeButton(),
                    body: content,
                    bottomNavigationBar: isMobile ? NavigationBar(
                        selectedIndex: selectedIndex,
                        onDestinationSelected: _navigateForIndex,
                        destinations: const <Widget>[
                            NavigationDestination(icon: Icon(Icons.fastfood), label: 'Recipes'),
                            NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
                            NavigationDestination(icon: Icon(Icons.query_stats), label: 'Statistics'),
                        ],
                    ) : null,
                );
            },
        );
    }
}