import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './breakpoints.dart';

class ResponsiveScaffold extends StatelessWidget {
    final Widget child;
    final String title;

    const ResponsiveScaffold({
        super.key,
        required this.child,
        required this.title,
    });

    @override
    Widget build(BuildContext context) {
        return LayoutBuilder(
            builder: (context, c) {
                const maxWidth = 800.0;

                return Scaffold(
                    appBar: AppBar(
                    title: Text(title),
                        leading: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                                if (Get.key.currentState?.canPop() ?? false) {
                                    Get.back();
                                } else {
                                    Get.offAllNamed('/');
                                }
                            },
                        ),
                    ),
                    body: Center(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: maxWidth,
                                minWidth: c.maxWidth < maxWidth ? c.maxWidth : maxWidth,
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: child,
                            ),
                        ),
                    ),
                );
            },
        );
    }
}