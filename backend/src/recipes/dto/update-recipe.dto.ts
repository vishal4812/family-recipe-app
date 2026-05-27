import { Transform, Type } from 'class-transformer';
import {
  IsInt,
  IsOptional,
  IsString,
  MaxLength,
  Min,
  MinLength,
} from 'class-validator';

function normalizeOptionalNonEmptyString(value: unknown): string | undefined {
  if (value === null || value === undefined) {
    return undefined;
  }

  return String(value).trim();
}

function normalizeNullableString(value: unknown): string | null | undefined {
  if (value === undefined) {
    return undefined;
  }

  if (value === null) {
    return null;
  }

  const normalized = String(value).trim();
  return normalized.length > 0 ? normalized : null;
}

function normalizeNullableNumber(value: unknown): number | null | undefined {
  if (value === undefined) {
    return undefined;
  }

  if (value === null || value === '') {
    return null;
  }

  return Number(value);
}

export class UpdateRecipeDto {
  @Transform(({ value }) => normalizeOptionalNonEmptyString(value))
  @IsOptional()
  @IsString()
  @MinLength(1)
  @MaxLength(160)
  title?: string;

  @Transform(({ value }) => normalizeNullableString(value))
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  description?: string | null;

  @Transform(({ value }) => normalizeOptionalNonEmptyString(value))
  @IsOptional()
  @IsString()
  @MinLength(1)
  ingredients?: string;

  @Transform(({ value }) => normalizeOptionalNonEmptyString(value))
  @IsOptional()
  @IsString()
  @MinLength(1)
  instructions?: string;

  @Transform(({ value }) => normalizeNullableNumber(value))
  @Type(() => Number)
  @IsOptional()
  @IsInt()
  @Min(1)
  prepTime?: number | null;

  @Transform(({ value }) => normalizeNullableNumber(value))
  @Type(() => Number)
  @IsOptional()
  @IsInt()
  @Min(1)
  cookTime?: number | null;

  @Transform(({ value }) => normalizeNullableNumber(value))
  @Type(() => Number)
  @IsOptional()
  @IsInt()
  @Min(1)
  servings?: number | null;

  @Transform(({ value }) => normalizeNullableString(value))
  @IsOptional()
  @IsString()
  @MaxLength(60)
  difficulty?: string | null;

  @Transform(({ value }) => normalizeNullableString(value))
  @IsOptional()
  @IsString()
  @MaxLength(80)
  cuisine?: string | null;

  @Transform(({ value }) => normalizeNullableString(value))
  @IsOptional()
  @IsString()
  @MaxLength(500)
  imageUrl?: string | null;
}
