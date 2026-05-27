# Family Recipe App Backend

NestJS + Prisma + PostgreSQL backend for the Family Recipe App MVP.

## Stack

- NestJS
- Prisma ORM
- PostgreSQL
- JWT auth
- class-validator
- Local file storage with an S3-ready abstraction

## MVP Modules

- `auth`
- `users`
- `recipes`
- `uploads`

## Setup

1. Install dependencies:

```bash
npm install
```

2. Copy the environment template:

```bash
cp .env.example .env
```

3. Update `DATABASE_URL` and `JWT_SECRET` in `.env`.

4. Generate Prisma client:

```bash
npm run db:generate
```

5. Run migrations:

```bash
npm run db:migrate:deploy
```

6. Seed demo data:

```bash
npm run db:seed
```

7. Start the API:

```bash
npm run start:dev
```

The default API base URL is `http://localhost:3000`.

## Environment

`.env.example`

```env
PORT=3000
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/family_recipe_app?schema=public"
JWT_SECRET="change-this-in-production"
JWT_EXPIRES_IN="7d"
APP_URL="http://localhost:3000"
STORAGE_DRIVER="local"
STORAGE_ROOT="storage"
```

## Database

Prisma schema: [prisma/schema.prisma](/home/addweb/Learning/Pro/family-recipe-app/backend/prisma/schema.prisma)

Models:

- `User`
- `Recipe`

Included migration:

- [prisma/migrations/20260407195000_init/migration.sql](/home/addweb/Learning/Pro/family-recipe-app/backend/prisma/migrations/20260407195000_init/migration.sql)

## Scripts

- `npm run start:dev`
- `npm run build`
- `npm run test`
- `npm run db:generate`
- `npm run db:migrate`
- `npm run db:migrate:deploy`
- `npm run db:seed`
- `npm run db:studio`

## API Route Summary

### Auth

- `POST /auth/signup`
- `POST /auth/login`

### Users

- `GET /users/me`

### Recipes

- `POST /recipes`
- `GET /recipes`
- `GET /recipes/:id`
- `PATCH /recipes/:id`
- `DELETE /recipes/:id`

### Uploads

- `POST /uploads/image`

## Auth Notes

- JWT bearer auth is required for all routes except `POST /auth/signup` and `POST /auth/login`.
- Pass the token as `Authorization: Bearer <token>`.
- `GET /users/me` is the current-user endpoint for session restore.

## Recipe Fields

Recipe payloads use these fields:

- `id`
- `userId`
- `title`
- `description`
- `ingredients`
- `instructions`
- `prepTime`
- `cookTime`
- `servings`
- `difficulty`
- `cuisine`
- `imageUrl`
- `createdAt`
- `updatedAt`

`ingredients` and `instructions` are stored as newline-separated text for the MVP.

## Upload Notes

- Upload endpoint accepts multipart form-data with field name `file`.
- Only image uploads are accepted.
- Max file size is `5 MB`.
- Files are stored locally under `storage/uploads/images`.
- The storage interface is abstracted behind `FileStorageService` so S3 can replace local storage later.

## Error Response Shape

All handled errors return the same JSON shape:

```json
{
  "statusCode": 400,
  "error": "Bad Request",
  "message": "Validation failed",
  "timestamp": "2026-04-07T12:00:00.000Z",
  "path": "/recipes"
}
```

## Seed Data

Seed script: [prisma/seed.ts](/home/addweb/Learning/Pro/family-recipe-app/backend/prisma/seed.ts)

Demo account:

- Email: `demo@familyrecipe.app`
- Password: `Password123!`

Sample recipes:

- `Aloo Paratha`
- `Tomato Rasam`
- `Mango Pickle`

## Tests

Unit tests cover:

- environment validation
- auth service flow
- local file storage writes

Run:

```bash
npm test
```

`test:e2e` is intentionally empty for now. A database-backed e2e harness can be added later once the MVP API contract settles.

## Flutter Integration Notes

The existing Flutter app can integrate with this backend without redesigning UI, but the API adapter layer needs a small contract update.

- Auth signup route is `POST /auth/signup`, not `/auth/register`.
- Session restore should call `GET /users/me`, not `/auth/session`.
- Sign-out is currently client-side token disposal. There is no `POST /auth/logout` route in the MVP backend.
- Recipe search uses `GET /recipes?search=<title>`.
- Recipe create and update expect `ingredients` and `instructions` as text, so the Flutter layer should join list values with newline characters before submission.
- Recipe responses return `prepTime` and `cookTime`, not `prepTimeMinutes` and `cookTimeMinutes`.
- Recipe responses return raw JSON objects and arrays, not `{ "data": ... }` wrappers.
- Image upload should call `POST /uploads/image` as multipart form-data, then store the returned `url` in `imageUrl` when creating or updating a recipe.

## Short Flutter Integration Checklist

1. Point the Flutter API base URL to this Nest backend.
2. Store `accessToken` from `POST /auth/signup` and `POST /auth/login`.
3. Send `Authorization: Bearer <token>` on protected requests.
4. Change session restore to `GET /users/me`.
5. Update auth signup mapping from `/auth/register` to `/auth/signup`.
6. Remove logout API calls and clear the token locally for MVP sign-out.
7. Convert recipe ingredient and instruction lists to newline-separated strings before `POST /recipes` and `PATCH /recipes/:id`.
8. Parse `ingredients` and `instructions` text back into UI lists after reads.
9. Rename recipe time mappings from `prepTimeMinutes` and `cookTimeMinutes` to `prepTime` and `cookTime`.
10. Update the Flutter API client to read raw JSON responses instead of expecting a `data` wrapper.
