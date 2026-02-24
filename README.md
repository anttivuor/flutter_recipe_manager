# Flutter Recipe Manager

## Application Idea and Purpose

This app is a responsive web application for managing personal recipes.
It allows users to:
-   Add new recipes
-   Edit and delete existing recipes
-   Mark recipes as favorites
-   Search recipes
-   View recipes
-   View statistics based on stored recipes

The application demonstrates form handling, state management, persistent storage, responsive layouts, and navigation using path variables.

The application is built with **Flutter (Web)** and uses
-   GetX for state management
-   Flutter Form Builder for form handling
-   Hive for persistent local storage
----------
## Deployed Application

The application is deployed on GitHub Pages and can be accessed here:
**[https://anttivuor.github.io/flutter_recipe_manager/](https://anttivuor.github.io/flutter_recipe_manager/)**

The application has four recipes, but more can be added manually.

The application runs directly in a modern web browser.

----------

## How to Use the Application

### 1. Viewing Recipes
-   The main screen shows a list of recipes.
-   You can search recipes using the search field.
-   Click on a recipe to view detailed information.

### 2. Adding a Recipe
-   Click the "Add Recipe" button.
-   Fill in the recipe details (title, description, time, servings, etc.)
-   Save the recipe.
-   The recipe will persist between browser sessions.

### 3. Editing or Deleting a Recipe
- Recipes can be edited from the list view (pen icon) or from single recipe screen.
- Recipes can be deleted from the list view (trash icon) or from single recipe screen.

### 4. Favorites
-   Recipes can be marked as favorites from list view or single recipe screen.
-   The Favorites screen displays all favorited recipes.

### 5. Statistics

The Statistics screen shows:
-   Total number of recipes
-   Number of favorite recipes
-   Most viewed recipes
-   View counts per recipe

Statistics update automatically based on user interaction.

----------

## Responsiveness

The application is responsive and adapts to different screen sizes:

-   **Mobile layout** (<= 480px):
	- Bottom navigation bar
	- More compact list view for recipes
- **Tablet layout** (> 480 px and <= 768 px) :
	- Small navigation rail
-   **Desktop layout** (> 768 px):
	- Expanded navigation rail
-   Maximum content width is constrained for better usability on large screens

