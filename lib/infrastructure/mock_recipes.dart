import 'package:hive_ce_flutter/hive_flutter.dart';

Future<void> addMockRecipesIfEmpty() async {
    final box = Hive.box('recipes');

    if (box.isNotEmpty) return;

    final now = DateTime.now();

    final mockRecipes = <Map<String, dynamic>>[
        {
            'id': 'r1',
            'title': 'Creamy Garlic Pasta',
            'description': 'Quick weekday pasta with garlic, cream, and parmesan.',
            'minutes': 20,
            'servings': 2,
            'tags': ['quick', 'pasta', 'vegetarian'],
            'ingredients': [
                '200g pasta',
                '2 cloves garlic',
                '150ml cream',
                '30g parmesan',
                'Salt & pepper',
            ],
            'steps': [
                'Boil pasta in salted water.',
                'Sauté garlic briefly (do not burn).',
                'Add cream and simmer 2–3 minutes.',
                'Toss pasta in sauce, add parmesan.',
                'Season and serve.',
            ],
            'createdAt': now.subtract(const Duration(days: 5)).toIso8601String(),
            'updatedAt': now.subtract(const Duration(days: 5)).toIso8601String(),
        },
        {
            'id': 'r2',
            'title': 'Overnight Oats',
            'description': 'Breakfast you prep in 5 minutes. Great with berries.',
            'minutes': 5,
            'servings': 1,
            'tags': ['breakfast', 'healthy', 'no-cook'],
            'ingredients': [
                '1/2 cup oats',
                '1/2 cup milk (or plant milk)',
                '1 tbsp chia seeds',
                '1 tsp honey',
                'Handful of berries',
            ],
            'steps': [
                'Mix oats, milk, chia, honey in a jar.',
                'Refrigerate overnight.',
                'Top with berries before eating.',
            ],
            'createdAt': now.subtract(const Duration(days: 3)).toIso8601String(),
            'updatedAt': now.subtract(const Duration(days: 3)).toIso8601String(),
        },
        {
            'id': 'r3',
            'title': 'Chicken Rice Bowl',
            'description': 'Simple bowl with chicken, rice, and crunchy veggies.',
            'minutes': 30,
            'servings': 2,
            'tags': ['dinner', 'protein', 'meal-prep'],
            'ingredients': [
                '250g chicken breast',
                '1 cup cooked rice',
                '1 carrot (shredded)',
                '1 cucumber (sliced)',
                'Soy sauce',
                'Sesame seeds',
            ],
            'steps': [
                'Cook rice.',
                'Pan-fry chicken until cooked through.',
                'Slice chicken and assemble bowls.',
                'Add veggies, drizzle soy sauce, top with sesame.',
            ],
            'createdAt': now.subtract(const Duration(days: 2)).toIso8601String(),
            'updatedAt': now.subtract(const Duration(days: 2)).toIso8601String(),
        },
        {
            'id': 'r4',
            'title': 'Tomato Lentil Soup',
            'description': 'Hearty soup with lentils, tomatoes, and spices.',
            'minutes': 40,
            'servings': 4,
            'tags': ['soup', 'vegan', 'budget'],
            'ingredients': [
                '1 onion',
                '2 cloves garlic',
                '1 cup red lentils',
                '400g canned tomatoes',
                '750ml vegetable stock',
                'Cumin + paprika',
            ],
            'steps': [
                'Sauté onion and garlic.',
                'Add spices, lentils, tomatoes, stock.',
                'Simmer 25–30 minutes.',
                'Blend partially if desired and serve.',
            ],
            'createdAt': now.subtract(const Duration(days: 1)).toIso8601String(),
            'updatedAt': now.subtract(const Duration(days: 1)).toIso8601String(),
        },
    ];

    for (final r in mockRecipes) {
        await box.put(r['id'], r);
    }
}