import { Recipe } from '@prisma/client';

export class RecipeResponseDto {
  constructor(recipe: Recipe) {
    this.id = recipe.id;
    this.userId = recipe.userId;
    this.title = recipe.title;
    this.description = recipe.description;
    this.ingredients = recipe.ingredients;
    this.instructions = recipe.instructions;
    this.prepTime = recipe.prepTime;
    this.cookTime = recipe.cookTime;
    this.servings = recipe.servings;
    this.difficulty = recipe.difficulty;
    this.cuisine = recipe.cuisine;
    this.imageUrl = recipe.imageUrl;
    this.createdAt = recipe.createdAt;
    this.updatedAt = recipe.updatedAt;
  }

  id: string;
  userId: string;
  title: string;
  description: string | null;
  ingredients: string;
  instructions: string;
  prepTime: number | null;
  cookTime: number | null;
  servings: number | null;
  difficulty: string | null;
  cuisine: string | null;
  imageUrl: string | null;
  createdAt: Date;
  updatedAt: Date;
}
