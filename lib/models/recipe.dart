class Recipe {
    final String id;
    String title;
    String description;
    int minutes;
    int servings;
    List<String> ingredients;
    List<String> steps;
    DateTime createdAt;
    DateTime updatedAt;

    Recipe({
        required this.id,
        required this.title,
        required this.description,
        required this.minutes,
        required this.servings,
        required this.ingredients,
        required this.steps,
        required this.createdAt,
        required this.updatedAt,
    });

    Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'minutes': minutes,
        'servings': servings,
        'ingredients': ingredients,
        'steps': steps,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
    };

    static Recipe fromJson(Map data) => Recipe(
        id: data['id'] as String,
        title: (data['title'] ?? '') as String,
        description: (data['description'] ?? '') as String,
        minutes: (data['minutes'] ?? 0) as int,
        servings: (data['servings'] ?? 0) as int,
        ingredients: List<String>.from(data['ingredients'] ?? const []),
        steps: List<String>.from(data['steps'] ?? const []),
        createdAt: DateTime.parse(data['createdAt'] as String),
        updatedAt: DateTime.parse(data['updatedAt'] as String),
    );
}