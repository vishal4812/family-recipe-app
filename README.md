# Family Recipe App

Flutter MVP app for storing and preserving family recipes, plus a NestJS backend for the production-minded MVP API. The repository now includes the mobile UI, secure JWT-backed API integration, multipart recipe image upload, and a PostgreSQL-ready backend under `backend/`.

## Product Vision

Family Recipe App is a private family cookbook for preserving recipes, memories, and the people behind the food.

The long-term goal is to go beyond a basic recipe manager. Instead of only storing titles, ingredients, and instructions, the app should help families keep the story of a recipe alive: who made it, when it was cooked, why it matters, and how each generation adapted it.

Example:

> This was Grandma's Sunday curry, originally written in her notebook, later updated by Mom, with tips from everyone who cooked it for family gatherings.

## Product Direction

- Private family cookbook spaces where invited members can save and browse shared recipes.
- Recipe stories and memories, so each dish can include the person, occasion, and meaning behind it.
- Original recipe photos for handwritten cards, notebooks, old clippings, or family recipe pages.
- Contributor and origin details such as "Added by Rahul", "Originally by Grandma", or "Mom's version".
- Occasion tags for family events, holidays, birthdays, comfort food, Sunday lunch, festivals, and celebrations.
- Family comments and cooking notes so relatives can share substitutions, serving tips, and small improvements.
- Recipe variations and version history for preserving different family versions of the same dish.
- Printable or exportable family cookbook support for turning saved recipes into a keepsake.

## Scope

- UI complete for MVP flows
- Flutter app connected to the NestJS MVP backend
- Mock-backed repositories kept for tests and isolated UI development
- No dark mode
- No advanced features beyond the MVP design spec

## Current MVP

The current implementation focuses on the foundation needed for the larger family cookbook idea:

- Account signup, login, and saved session restore
- Private recipe list for the signed-in user
- Add, view, edit, delete, and search recipes
- Recipe image upload
- Backend API with JWT authentication
- PostgreSQL-ready data model using Prisma

## Implemented Screens

- Splash / auth check
- Login / signup
- Home / recipe list
- Search state on home
- Empty, loading, and error states
- Add recipe
- Recipe detail
- Edit recipe
- Profile / settings placeholder

## Tech Notes

- Flutter `3.35.6`
- Material 3
- `flutter_secure_storage` for JWT persistence
- `google_fonts` for `Nunito Sans`
- `image_picker` for local device image selection
- `http` for NestJS API access and multipart upload
- App state using `ChangeNotifier` with dependency injection via inherited scopes

## Run The Backend

```bash
cd backend
cp .env.example .env
npm install
npm run db:generate
npm run db:migrate:deploy
npm run db:seed
npm run start:dev
```

Backend docs: [backend/README.md](/home/addweb/Learning/Pro/family-recipe-app/backend/README.md)

## Run Flutter Against The Backend

Install Flutter dependencies:

```bash
flutter pub get
```

The app now defaults to the real API path, but you should always pass `API_BASE_URL` explicitly for beta and release validation.

HTTPS staging or production backend:

```bash
flutter run --dart-define API_BASE_URL=https://api.familyrecipe.example
```

Android emulator local backend, debug-only:

```bash
flutter run --dart-define API_BASE_URL=http://10.0.2.2:3000
```

iOS simulator or desktop local backend, debug-only:

```bash
flutter run --dart-define API_BASE_URL=http://localhost:3000
```

Physical device on the same network, debug-only:

```bash
flutter run --dart-define API_BASE_URL=http://YOUR_LAN_IP:3000
```

Optional development-only sample photo shortcuts:

```bash
flutter run \
  --dart-define API_BASE_URL=https://api.familyrecipe.example \
  --dart-define ENABLE_SAMPLE_PHOTOS=true
```

If you are doing local-only debugging instead of beta validation, use desktop/web or a temporary HTTPS tunnel for the backend. Mobile release configuration is now aligned to HTTPS-only deployment assumptions.

### Environment notes

- Beta and release builds should always provide `API_BASE_URL` with `--dart-define`.
- Release builds now require `API_BASE_URL` and require it to use `https://`.
- Recipe images are rendered from backend-provided `imageUrl` values, so backend `APP_URL` must also be HTTPS and device-reachable.
- The earlier mobile cleartext HTTP allowances have been removed from production app config.
- Local `http://` URLs are acceptable only for debug-only development runs.

### Exact config items still needed from you

- Android release keystore file path.
- Android keystore passwords and key alias.
- Apple Developer Team ID and provisioning setup.
- Public HTTPS backend URL for `API_BASE_URL`.
- Public HTTPS backend `APP_URL` used for uploaded recipe images.
- At least one physical Android device and one physical iPhone or TestFlight target for final smoke testing.

## Verify

```bash
flutter analyze
flutter test
```

## Project Structure

```text
lib/
  main.dart
  src/
    app.dart
    core/
      di/
      network/
      navigation/
      state/
      theme/
    shared/
      widgets/
        branding/
        buttons/
        inputs/
        layout/
        sheets/
        state/
    features/
      auth/
        data/
        domain/
        presentation/
      recipes/
        data/
        domain/
        presentation/
      profile/
        domain/
        presentation/
```

## UI Notes

- Recipe creation and editing use multiline fields for ingredients and instructions.
- Recipe image upload sends the selected local file to `POST /uploads/image` before recipe save.
- Home uses a single-stack navigation flow with an extended `Add Recipe` FAB.
- Delete actions use a confirmation bottom sheet.

## Backend Integration Status

The Flutter app is now wired to the implemented NestJS backend without changing the current UI flow.

- `FamilyRecipeApp` now defaults to `AppDependencies.api()`.
- `AppDependencies` still supports mock repositories for tests and isolated UI runs.
- `AuthRepository` and `RecipeRepository` define the interfaces the UI depends on.
- `AuthService` and `RecipeService` sit between state and repositories so async behavior can evolve without rewriting screens.
- `MockAuthRepository` and `MockRecipeRepository` remain available for tests.
- `ApiAuthRepository` and `ApiRecipeRepository` are aligned to the implemented backend contract.
- `NestApiClient` injects the bearer token automatically and maps common backend errors to cleaner messages.
- `SecureAuthTokenStore` persists the JWT between launches.
- `AppUserDto`, `RecipeDto`, and `RecipeUpsertDto` handle mapping between domain models and transport payloads.
- `RecipeDraft` is still the submission model used by add/edit flows.
- `RecipeImagePickerService` abstracts local image picking so the UI does not depend directly on plugin code.
- `ApiRecipeImageUploadService` uploads selected local images before recipe create and update calls.

### Implemented backend contract

- Auth routes:
  - `POST /auth/signup`
  - `POST /auth/login`
  - `GET /users/me`
- Recipe routes:
  - `GET /recipes`
  - `GET /recipes/:id`
  - `POST /recipes`
  - `PATCH /recipes/:id`
  - `DELETE /recipes/:id`
- Upload route:
  - `POST /uploads/image`

## Auth And Session Behavior

- On login and signup, the app stores `accessToken` securely and keeps the current screen flow unchanged.
- On app launch, the splash/auth gate restores the token and calls `GET /users/me`.
- If the token is valid, the app restores the session and loads recipes.
- If the token is invalid or expired, the app clears the stored token and routes back to auth.
- If the server is unreachable during session restore, the app routes to auth and shows a user-facing connectivity message.
- Logout is client-side for MVP and clears the stored JWT.

## Upload Flow

- The user picks a local image through `image_picker`.
- The app uploads that file with multipart form-data to `POST /uploads/image`.
- The returned `imageUrl` is attached to the recipe payload.
- Existing remote image URLs remain supported in detail cards and hero images.
- Sample photo shortcuts are disabled by default and can be re-enabled with `ENABLE_SAMPLE_PHOTOS=true`.

## Hardening Notes

- API requests now time out after a short network window instead of hanging indefinitely.
- Unreachable server failures are mapped to user-friendly messages.
- Auth, add recipe, edit recipe, and logout flows guard against duplicate taps.
- Save and delete error handling now preserves backend messages where useful and falls back to clear generic copy otherwise.
- Invalid session tokens are cleared automatically on bootstrap.

## Known MVP Limitations

- The app is online-first. There is no offline sync.
- Ingredients and instructions are stored as newline-separated text in the backend for MVP simplicity.
- Logout is local token removal only. There is no server-side token revocation endpoint.
- Recipe detail is primarily driven from the loaded recipe list, with targeted fetch support when a recipe is missing from local state.
- Family sharing, meal planning, grocery lists, OCR, AI parsing, subscriptions, and other non-MVP features are still out of scope.

## Release Prep

Before shipping a public build:

1. Use an HTTPS backend and HTTPS image URLs.
2. Build with `--dart-define API_BASE_URL=https://...`.
3. Verify secure token persistence and logout behavior on Android and iOS release builds.
4. Test image upload and remote image rendering against the deployed backend.
5. Confirm backend `APP_URL`, storage paths, and CORS settings match the deployed environment.
6. Run the smoke checklist below on at least one Android device and one iPhone or simulator.
7. Complete the dedicated release checklist in [docs/release-readiness-checklist.md](/home/addweb/Learning/Pro/family-recipe-app/docs/release-readiness-checklist.md).

### Android release commands

Create `android/key.properties` from [android/key.properties.example](/home/addweb/Learning/Pro/family-recipe-app/android/key.properties.example) or provide equivalent environment variables:

- `ANDROID_KEYSTORE_PATH`
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

Configured Android app ID:

- `com.addweb.familyrecipeapp`

Then build:

```bash
flutter build appbundle \
  --release \
  --dart-define API_BASE_URL=https://api.familyrecipe.example
```

Optional APK build for direct device install:

```bash
flutter build apk \
  --release \
  --dart-define API_BASE_URL=https://api.familyrecipe.example
```

### iOS / TestFlight commands

Before building:

- select the correct Apple Developer team in Xcode
- confirm provisioning profiles or automatic signing are valid

Configured iOS bundle IDs:

- Runner: `com.addweb.familyrecipeapp`
- RunnerTests: `com.addweb.familyrecipeapp.RunnerTests`

Then build:

```bash
flutter build ipa \
  --release \
  --dart-define API_BASE_URL=https://api.familyrecipe.example
```

## Manual QA Checklist

Auth and bootstrap:

- Launch the app with no stored token and confirm it opens the auth screen.
- Log in with the seeded backend user and confirm navigation goes to the recipe list.
- Kill and relaunch the app and confirm the session restores automatically.
- Force an invalid token, relaunch, and confirm the app clears the session and returns to auth.
- Stop the backend, relaunch, and confirm a clear connectivity message is shown on auth.

Recipes:

- Load the home screen and confirm seeded recipes appear in descending updated order.
- Search by a partial title and confirm the results update correctly.
- Search for a non-existent title and confirm the empty search state appears.
- Open a recipe detail screen and confirm hero image, metadata, ingredients, and instructions render correctly.
- Add a recipe without a photo and confirm it appears in the list immediately after save.
- Edit a recipe and confirm updated text persists after returning to the list and reopening detail.
- Delete a recipe from detail or edit flow and confirm it disappears from the list.

Uploads and images:

- Add a recipe with a device photo and confirm the upload succeeds.
- Reopen that recipe and confirm the remote image loads from the backend URL.
- Test with the backend unreachable and confirm photo upload failure shows a clear message.
- Test with an oversized image and confirm the user sees an upload-size failure message.

Device and network:

- Test Android emulator with `10.0.2.2`.
- Test iOS simulator or desktop with `localhost`.
- Test at least one physical device on LAN using the machine IP.
- Confirm the backend `APP_URL` image links load from the same device that created the recipe.

## Physical Device Smoke Test

1. Sign up with a fresh account.
2. Log in and reach the recipe list.
3. Fully close the app, relaunch it, and confirm the session restores.
4. Create a recipe without an image.
5. Create another recipe with an uploaded image.
6. Edit that recipe and confirm the changes persist.
7. Search by a partial title and confirm the expected result appears.
8. Delete the test recipe and confirm it is removed.
9. Log out.
10. Log back in and confirm the remaining recipes load correctly.

## Remaining Launch Blockers

- Production HTTPS backend and HTTPS-served image URLs must be confirmed in the deployed environment.
- A final real-device smoke pass against the deployed backend is still needed.
- Android release signing values still need to be supplied.
- Apple signing, team, and provisioning still need to be supplied in Xcode.
- App store metadata, icons, and final backend deployment configuration are not covered in this repo yet.

## Closed Beta Recommendation

Not ready for closed beta yet.

The app flow itself is in solid MVP shape, but the remaining blockers are release-configuration blockers rather than product-flow blockers:

- add real Android release signing
- deploy and verify the HTTPS backend and image URLs
- complete a real-device smoke pass against the deployed environment

Once those are done, the app is a reasonable candidate for a small closed beta.

## Source Specs

- `docs/mvp-mobile-design-spec.md`
- `docs/flutter-ui-implementation-spec.md`
