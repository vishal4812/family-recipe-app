import { Transform, Type } from 'class-transformer';
import {
  IsInt,
  IsOptional,
  IsString,
  MaxLength,
  Min,
  MinLength,
} from 'class-validator';

function normalizeOptionalString(value: unknown): string | undefined {
  if (value === null || value === undefined) {
    return undefined;
  }

  const normalized = String(value).trim();
  return normalized.length > 0 ? normalized : undefined;
}

function normalizeRequiredString(value: unknown): string | undefined {
  if (value === null || value === undefined) {
    return undefined;
  }

  return String(value).trim();
}

function normalizeOptionalNumber(value: unknown): number | undefined {
  if (value === null || value === undefined || value === '') {
    return undefined;
  }

  return Number(value);
}

export class CreateRecipeDto {
  @Transform(({ value }) => normalizeRequiredString(value))
  @IsString()
  @MinLength(1)
  @MaxLength(160)
  title!: string;

  @Transform(({ value }) => normalizeOptionalString(value))
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  description?: string;

  @Transform(({ value }) => normalizeRequiredString(value))
  @IsString()
  @MinLength(1)
  ingredients!: string;

  @Transform(({ value }) => normalizeRequiredString(value))
  @IsString()
  @MinLength(1)
  instructions!: string;

  @Transform(({ value }) => normalizeOptionalNumber(value))
  @Type(() => Number)
  @IsOptional()
  @IsInt()
  @Min(1)
  prepTime?: number;

  @Transform(({ value }) => normalizeOptionalNumber(value))
  @Type(() => Number)
  @IsOptional()
  @IsInt()
  @Min(1)
  cookTime?: number;

  @Transform(({ value }) => normalizeOptionalNumber(value))
  @Type(() => Number)
  @IsOptional()
  @IsInt()
  @Min(1)
  servings?: number;

  @Transform(({ value }) => normalizeOptionalString(value))
  @IsOptional()
  @IsString()
  @MaxLength(60)
  difficulty?: string;

  @Transform(({ value }) => normalizeOptionalString(value))
  @IsOptional()
  @IsString()
  @MaxLength(80)
  cuisine?: string;

  @Transform(({ value }) => normalizeOptionalString(value))
  @IsOptional()
  @IsString()
  @MaxLength(500)
  imageUrl?: string;
}
