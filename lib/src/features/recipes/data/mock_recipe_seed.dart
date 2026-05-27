import '../../profile/domain/models/app_user.dart';
import '../domain/models/recipe.dart';

abstract final class MockRecipeSeed {
  static const AppUser sampleUser = AppUser(
    name: 'Priya Sharma',
    email: 'priya@example.com',
  );

  static final List<Recipe> sampleRecipes = <Recipe>[
    Recipe(
      id: 'recipe_1',
      title: 'Aloo Paratha',
      description: 'Soft, buttery parathas with spiced potato filling.',
      imageUrl:
          'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=1200&q=80',
      prepTimeMinutes: 20,
      cookTimeMinutes: 15,
      servings: 4,
      ingredients: const <String>[
        '2 cups whole wheat flour',
        '3 boiled potatoes',
        '1 green chili, chopped',
        '1 tsp cumin seeds',
        'Salt to taste',
        'Ghee for cooking',
      ],
      instructions: const <String>[
        'Mix flour with water and rest the dough for 20 minutes.',
        'Mash potatoes with chili, cumin, and salt.',
        'Stuff dough balls with the potato mixture.',
        'Roll gently and cook on a hot tawa.',
        'Brush with ghee and serve hot.',
      ],
      createdAt: DateTime(2024, 10, 10),
      updatedAt: DateTime(2026, 4, 7, 9, 0),
    ),
    Recipe(
      id: 'recipe_2',
      title: 'Dal Tadka',
      description: 'Comforting yellow dal finished with garlic tempering.',
      imageUrl:
          'https://images.unsplash.com/photo-1547592166-23ac45744acd?auto=format&fit=crop&w=1200&q=80',
      prepTimeMinutes: 10,
      cookTimeMinutes: 25,
      servings: 3,
      ingredients: const <String>[
        '1 cup toor dal',
        '1 tomato, chopped',
        '2 garlic cloves',
        '1 tsp cumin seeds',
        '1 tsp turmeric',
        'Salt to taste',
      ],
      instructions: const <String>[
        'Wash the dal and pressure cook until soft.',
        'Simmer cooked dal with tomato, turmeric, and salt.',
        'Heat ghee in a pan with cumin and garlic.',
        'Pour the tempering over the dal and mix well.',
        'Serve hot with rice or roti.',
      ],
      createdAt: DateTime(2024, 12, 5),
      updatedAt: DateTime(2026, 4, 5, 18, 30),
    ),
    Recipe(
      id: 'recipe_3',
      title: 'Coconut Fish Curry',
      description: 'A family-style curry with coconut, chili, and tamarind.',
      imageUrl:
          'https://images.unsplash.com/photo-1515003197210-e0cd71810b5f?auto=format&fit=crop&w=1200&q=80',
      prepTimeMinutes: 15,
      cookTimeMinutes: 30,
      servings: 5,
      ingredients: const <String>[
        '500 g fish pieces',
        '1 cup coconut milk',
        '1 onion, sliced',
        '2 green chilies',
        '1 tsp turmeric',
        '1 tsp tamarind pulp',
      ],
      instructions: const <String>[
        'Season fish lightly with salt and turmeric.',
        'Saute onion and chilies until softened.',
        'Add turmeric and tamarind, then pour in coconut milk.',
        'Simmer gently and add the fish pieces.',
        'Cook until the fish is tender and serve warm.',
      ],
      createdAt: DateTime(2025, 1, 12),
      updatedAt: DateTime(2026, 4, 2, 12, 15),
    ),
  ];

  static const List<String> mockUploadImageOptions = <String>[
    'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1547592166-23ac45744acd?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1515003197210-e0cd71810b5f?auto=format&fit=crop&w=1200&q=80',
  ];
}
