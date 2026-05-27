import {
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Prisma, Recipe } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { CreateRecipeDto } from './dto/create-recipe.dto';
import { QueryRecipesDto } from './dto/query-recipes.dto';
import { UpdateRecipeDto } from './dto/update-recipe.dto';

@Injectable()
export class RecipesService {
  constructor(private readonly prisma: PrismaService) {}

  create(userId: string, dto: CreateRecipeDto): Promise<Recipe> {
    return this.prisma.recipe.create({
      data: {
        userId,
        title: dto.title,
        description: dto.description ?? null,
        ingredients: dto.ingredients,
        instructions: dto.instructions,
        prepTime: dto.prepTime ?? null,
        cookTime: dto.cookTime ?? null,
        servings: dto.servings ?? null,
        difficulty: dto.difficulty ?? null,
        cuisine: dto.cuisine ?? null,
        imageUrl: dto.imageUrl ?? null,
      },
    });
  }

  findAll(userId: string, query: QueryRecipesDto): Promise<Recipe[]> {
    const where: Prisma.RecipeWhereInput = {
      userId,
      ...(query.search?.trim()
        ? {
            title: {
              contains: query.search.trim(),
              mode: 'insensitive',
            },
          }
        : {}),
    };

    return this.prisma.recipe.findMany({
      where,
      orderBy: {
        updatedAt: 'desc',
      },
    });
  }

  async findOne(userId: string, recipeId: string): Promise<Recipe> {
    const recipe = await this.prisma.recipe.findUnique({
      where: { id: recipeId },
    });

    if (!recipe) {
      throw new NotFoundException('Recipe not found.');
    }

    this.ensureOwnership(userId, recipe.userId);
    return recipe;
  }

  async update(
    userId: string,
    recipeId: string,
    dto: UpdateRecipeDto,
  ): Promise<Recipe> {
    await this.findOne(userId, recipeId);

    return this.prisma.recipe.update({
      where: { id: recipeId },
      data: {
        ...(dto.title !== undefined ? { title: dto.title } : {}),
        ...(dto.description !== undefined
          ? { description: dto.description ?? null }
          : {}),
        ...(dto.ingredients !== undefined
          ? { ingredients: dto.ingredients }
          : {}),
        ...(dto.instructions !== undefined
          ? { instructions: dto.instructions }
          : {}),
        ...(dto.prepTime !== undefined
          ? { prepTime: dto.prepTime ?? null }
          : {}),
        ...(dto.cookTime !== undefined
          ? { cookTime: dto.cookTime ?? null }
          : {}),
        ...(dto.servings !== undefined
          ? { servings: dto.servings ?? null }
          : {}),
        ...(dto.difficulty !== undefined
          ? { difficulty: dto.difficulty ?? null }
          : {}),
        ...(dto.cuisine !== undefined ? { cuisine: dto.cuisine ?? null } : {}),
        ...(dto.imageUrl !== undefined
          ? { imageUrl: dto.imageUrl ?? null }
          : {}),
      },
    });
  }

  async remove(userId: string, recipeId: string): Promise<void> {
    await this.findOne(userId, recipeId);
    await this.prisma.recipe.delete({
      where: { id: recipeId },
    });
  }

  private ensureOwnership(userId: string, ownerId: string): void {
    if (userId !== ownerId) {
      throw new ForbiddenException('You do not have access to this recipe.');
    }
  }
}
