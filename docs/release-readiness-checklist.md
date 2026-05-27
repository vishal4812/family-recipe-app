# Family Recipe App Release Readiness Checklist

Final pre-beta and pre-release checklist for the MVP app. This is intentionally limited to release readiness and validation of the existing scope.

## Recommendation

Not ready for closed beta yet.

The product flow is functionally complete, but release configuration still has blocking setup work outside normal feature code:

- Android release signing credentials still need to be supplied to [android/app/build.gradle.kts](/home/addweb/Learning/Pro/family-recipe-app/android/app/build.gradle.kts).
- iOS Apple signing, team, and provisioning still need to be supplied in [ios/Runner.xcodeproj/project.pbxproj](/home/addweb/Learning/Pro/family-recipe-app/ios/Runner.xcodeproj/project.pbxproj).
- A real HTTPS staging or production backend URL still needs to be supplied at build time.
- A full real-device smoke pass against the deployed HTTPS backend still needs to be completed.

Once those are resolved, the app is a reasonable candidate for a small closed beta.

## Production-Safe Environment Guidance

- Release builds must provide `API_BASE_URL` using `--dart-define`.
- Release builds must use an `https://` API base URL.
- Uploaded image URLs returned by the backend must also be HTTPS and publicly reachable by beta devices.
- Backend `APP_URL` must match the public HTTPS origin used for image serving.
- Do not ship release builds that depend on `localhost`, `10.0.2.2`, or private LAN IPs.

Base URL handling by environment:

- Android emulator, debug only: `http://10.0.2.2:3000`
- iOS simulator or desktop, debug only: `http://localhost:3000`
- Physical device on local LAN, debug only: `http://YOUR_LAN_IP:3000`
- Closed beta and release: `https://api.familyrecipe.example`

Recommended release build examples:

Android:

```bash
flutter build appbundle \
  --release \
  --dart-define API_BASE_URL=https://api.familyrecipe.example
```

iOS:

```bash
flutter build ipa \
  --release \
  --dart-define API_BASE_URL=https://api.familyrecipe.example
```

## Exact Config Items Still Needed From You

- Android release keystore file.
- Android keystore store password.
- Android key alias.
- Android key password.
- Apple Developer Team ID.
- Valid Apple signing and provisioning configuration.
- Final public HTTPS API URL.
- Final public HTTPS `APP_URL` for uploaded images.

Configured app identifiers in this repo:

- Android application ID and namespace: `com.addweb.familyrecipeapp`
- Android Kotlin package: `com.addweb.familyrecipeapp`
- iOS Runner bundle ID: `com.addweb.familyrecipeapp`
- iOS RunnerTests bundle ID: `com.addweb.familyrecipeapp.RunnerTests`

## Backend Deploy Checklist

1. Deploy the NestJS backend to a stable environment with PostgreSQL.
2. Set `DATABASE_URL`, `JWT_SECRET`, `JWT_EXPIRES_IN`, `APP_URL`, `STORAGE_DRIVER`, and `STORAGE_ROOT`.
3. Run Prisma migrations in the deployed environment.
4. Seed only if beta accounts or demo content are required.
5. Confirm CORS allows the mobile app's expected origin patterns or bearer-token mobile usage.
6. Confirm upload storage persists across backend restarts and deploys.
7. Confirm uploaded files are served from the same HTTPS origin as `APP_URL`.

## HTTPS Verification Checklist

1. Verify `API_BASE_URL` is HTTPS.
2. Verify the backend certificate is valid on Android and iOS devices.
3. Verify every `imageUrl` returned from `/uploads/image` is HTTPS.
4. Verify recipe detail images load successfully on real devices over mobile and Wi-Fi networks.
5. Verify there are no mixed-content or transport-security failures in logs.

## Image URL Verification Checklist

1. Upload a new recipe image from a real device.
2. Confirm `/uploads/image` returns an HTTPS URL.
3. Create the recipe and reload the list.
4. Open recipe detail and confirm the image loads.
5. Kill and relaunch the app, then reopen the same recipe and confirm the image still loads.
6. Test one older uploaded image after a backend deploy to confirm storage persistence.

Code-path assumption to verify:

- [api_recipe_image_upload_service.dart](/home/addweb/Learning/Pro/family-recipe-app/lib/src/features/recipes/data/services/api_recipe_image_upload_service.dart) now expects `/uploads/image` to return an absolute `http://` or `https://` URL.
- [app_image.dart](/home/addweb/Learning/Pro/family-recipe-app/lib/src/shared/widgets/media/app_image.dart) renders remote recipe photos directly from `imageUrl`; if the backend returns an invalid, private, or expired URL, the UI will fall back to the image placeholder.

## Android Release Checklist

1. Create `android/key.properties` from [android/key.properties.example](/home/addweb/Learning/Pro/family-recipe-app/android/key.properties.example) or set `ANDROID_KEYSTORE_PATH`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, and `ANDROID_KEY_PASSWORD`.
2. Build a release `.aab` with the production HTTPS `API_BASE_URL`.
3. Install and test the release build on at least one physical Android device.
4. Verify login, session restore, recipe CRUD, search, upload, and logout on the release build.
5. Confirm remote recipe images load on the release build.
6. Confirm there are no transport or cleartext warnings in Android logs.

## iOS / TestFlight Checklist

1. Configure the correct Apple Developer team and signing settings in Xcode.
2. Verify automatic signing or provisioning profiles resolve cleanly for device builds.
3. Build an IPA with the production HTTPS `API_BASE_URL`.
4. Upload the build to TestFlight.
5. Verify login, session restore, recipe CRUD, search, upload, and logout on a physical iPhone or TestFlight install.
6. Confirm remote recipe images load from the deployed backend.
7. Confirm there are no ATS or certificate issues.

## Final Smoke Checklist

1. Sign up with a fresh account.
2. Log in and reach the recipe list.
3. Force-close the app, relaunch it, and confirm the session restores.
4. Create a recipe without an image.
5. Create another recipe with an uploaded image.
6. Edit that recipe and confirm the changes persist.
7. Search by a partial title and confirm the expected result appears.
8. Delete the test recipe and confirm it is removed.
9. Log out.
10. Log back in and confirm the remaining recipes load correctly.

## Remaining Risks

- No server-side logout revocation. This is acceptable for a small MVP beta, but it is still a security and session-management limitation.
- No refresh-token flow. Expired sessions fall back to re-login, which is acceptable for MVP but still a UX constraint.
- Uploads depend on backend-hosted file serving. Storage persistence and CDN/front-door behavior must be validated in the deployed environment.
- Real iOS and Android release builds have not been fully validated from this repo alone because final signing identifiers are still placeholders.
