# Family Recipe App MVP Flutter UI Implementation Spec

This document converts the existing MVP design spec into Flutter-ready UI definitions. It stays within MVP scope and is intended to drive direct implementation.

## 1. Assumptions

- Flutter uses Material 3.
- Dark mode is disabled for MVP.
- Navigation uses a simple stack.
- State management can stay lightweight for MVP.
- Forms use `Form`, `GlobalKey<FormState>`, and `TextEditingController`.
- Search only filters by recipe title.
- Ingredients and instructions are entered as multiline text and split by newline on save.

## 2. Final Design Tokens as Dart Constants

### 2.1 `lib/src/core/theme/app_colors.dart`

```dart
import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFFF07A4A);
  static const Color primaryDark = Color(0xFFD8612F);
  static const Color background = Color(0xFFFFF8F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFFFF3EC);
  static const Color accentSoft = Color(0xFFFBE7DD);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color border = Color(0xFFEADFD8);

  static const Color success = Color(0xFF467A57);
  static const Color error = Color(0xFFC65A46);

  static const Color disabled = Color(0xFFF1E5DE);
  static const Color disabledText = Color(0xFFA69084);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color skeleton = Color(0xFFF2E8E1);
  static const Color skeletonDark = Color(0xFFE7D9CF);
}
```

### 2.2 `lib/src/core/theme/app_spacing.dart`

```dart
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;

  static const double screenHorizontal = 20;
  static const double screenTop = 16;
  static const double sectionGap = 24;
  static const double fieldGap = 16;
  static const double cardGap = 12;
  static const double bottomSafe = 20;
}
```

### 2.3 `lib/src/core/theme/app_radii.dart`

```dart
import 'package:flutter/widgets.dart';

abstract final class AppRadii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 14;
  static const double xl = 16;
  static const double xxl = 20;
  static const double pill = 28;

  static const BorderRadius radius8 = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radius12 = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radius14 = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radius16 = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radius20 = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius radius28 = BorderRadius.all(Radius.circular(pill));
}
```

### 2.4 `lib/src/core/theme/app_shadows.dart`

```dart
import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const List<BoxShadow> low = <BoxShadow>[
    BoxShadow(
      color: Color(0x0F1A1A1A),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> medium = <BoxShadow>[
    BoxShadow(
      color: Color(0x141A1A1A),
      blurRadius: 18,
      offset: Offset(0, 6),
    ),
  ];
}
```

### 2.5 `lib/src/core/theme/app_dimensions.dart`

```dart
abstract final class AppDimensions {
  static const double maxContentWidth = 600;

  static const double buttonHeight = 52;
  static const double textButtonHeight = 40;
  static const double searchFieldHeight = 52;
  static const double inputMinHeight = 52;
  static const double multilineMinHeight = 120;

  static const double recipeCardMinHeight = 112;
  static const double recipeCardImageSize = 88;
  static const double metadataChipHeight = 32;
  static const double iconButtonSize = 40;
  static const double minTouchTarget = 44;

  static const double fabHeight = 56;
  static const double fabIconSize = 22;

  static const double uploadBoxHeight = 180;
  static const double heroAspectRatio = 16 / 9;
  static const double heroPlaceholderIconSize = 36;

  static const double authLogoBox = 72;
  static const double splashLogoBox = 88;
  static const double emptyGraphicSize = 120;
  static const double avatarSize = 56;

  static const double stickyActionBarMinHeight = 88;
  static const double dividerThickness = 1;
}
```

### 2.6 `lib/src/core/theme/app_typography.dart`

```dart
import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const String fontFamily = 'NunitoSans';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w700,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w700,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w700,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w400,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6B6B6B),
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6B6B6B),
  );

  static const TextStyle buttonLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 18 / 14,
    fontWeight: FontWeight.w700,
  );
}
```

### 2.7 `lib/src/core/theme/app_theme.dart`

```dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accentSoft,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.onPrimary,
        onSurface: AppColors.textPrimary,
      ),
      fontFamily: AppTypography.fontFamily,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      dividerColor: AppColors.border,
      splashFactory: InkRipple.splashFactory,
    );
  }
}
```

## 3. Suggested Icon Set Usage

Use Flutter Material icons only for MVP. Prefer rounded variants where available to match the soft visual language and avoid adding a custom icon dependency.

| Usage | Icon |
| --- | --- |
| Brand placeholder | `Icons.menu_book_rounded` |
| Splash loading area | `Icons.menu_book_rounded` |
| Search | `Icons.search_rounded` |
| Clear search | `Icons.close_rounded` |
| Add recipe | `Icons.add_rounded` |
| Edit recipe | `Icons.edit_rounded` |
| Delete recipe | `Icons.delete_outline_rounded` |
| Overflow menu | `Icons.more_vert_rounded` |
| Back | `Icons.arrow_back_rounded` |
| Profile | `Icons.account_circle_rounded` |
| Logout | `Icons.logout_rounded` |
| Image upload | `Icons.add_a_photo_outlined` |
| Missing image | `Icons.image_outlined` |
| Prep or cook time | `Icons.schedule_rounded` |
| Servings | `Icons.people_alt_outlined` |
| Empty recipes | `Icons.restaurant_menu_rounded` |
| Error state | `Icons.error_outline_rounded` |
| Retry | `Icons.refresh_rounded` |

## 4. Flutter Widget and Component List

### 4.1 App-level widgets

| Widget | Purpose | File |
| --- | --- | --- |
| `FamilyRecipeApp` | Root `MaterialApp` | `lib/src/app.dart` |
| `AppRouter` | Route generation | `lib/src/core/navigation/app_router.dart` |
| `AuthGate` | Redirect splash to auth or home | `lib/src/features/auth/presentation/auth_gate.dart` |

### 4.2 Reusable UI widgets

| Widget | Purpose | File |
| --- | --- | --- |
| `AppPrimaryButton` | Main CTA button | `lib/src/shared/widgets/buttons/app_primary_button.dart` |
| `AppSecondaryButton` | Secondary action button | `lib/src/shared/widgets/buttons/app_secondary_button.dart` |
| `AppTextButton` | Low-emphasis text action | `lib/src/shared/widgets/buttons/app_text_button.dart` |
| `AppTextField` | Single-line field with label/helper/error | `lib/src/shared/widgets/inputs/app_text_field.dart` |
| `AppMultilineField` | Long-form text field | `lib/src/shared/widgets/inputs/app_multiline_field.dart` |
| `RecipeSearchField` | Search field with clear action | `lib/src/shared/widgets/inputs/recipe_search_field.dart` |
| `AppIconButton` | Rounded icon button | `lib/src/shared/widgets/buttons/app_icon_button.dart` |
| `SectionHeader` | Section title block | `lib/src/shared/widgets/layout/section_header.dart` |
| `StickyActionBar` | Bottom CTA container | `lib/src/shared/widgets/layout/sticky_action_bar.dart` |
| `StatusView` | Shared empty/error state block | `lib/src/shared/widgets/state/status_view.dart` |
| `SkeletonBlock` | Base skeleton shape | `lib/src/shared/widgets/state/skeleton_block.dart` |
| `ConfirmActionSheet` | Delete confirmation bottom sheet | `lib/src/shared/widgets/sheets/confirm_action_sheet.dart` |
| `BrandMark` | Simple logo mark | `lib/src/shared/widgets/branding/brand_mark.dart` |

### 4.3 Auth-specific widgets

| Widget | Purpose | File |
| --- | --- | --- |
| `AuthModeToggle` | Login or signup mode switch | `lib/src/features/auth/presentation/widgets/auth_mode_toggle.dart` |
| `FormSurfaceCard` | White bordered container for auth form fields | `lib/src/features/auth/presentation/widgets/form_surface_card.dart` |

### 4.4 Recipe-specific widgets

| Widget | Purpose | File |
| --- | --- | --- |
| `HomeHeaderBlock` | Home title and subtitle | `lib/src/features/recipes/presentation/widgets/home_header_block.dart` |
| `RecipeCard` | Recipe list item | `lib/src/features/recipes/presentation/widgets/recipe_card.dart` |
| `MetadataChip` | Prep time, cook time, servings chip | `lib/src/features/recipes/presentation/widgets/metadata_chip.dart` |
| `AddRecipeFab` | Extended home FAB | `lib/src/features/recipes/presentation/widgets/add_recipe_fab.dart` |
| `ImageUploadBox` | Recipe photo upload and preview | `lib/src/features/recipes/presentation/widgets/image_upload_box.dart` |
| `RecipeHeroImage` | Detail hero image or placeholder | `lib/src/features/recipes/presentation/widgets/recipe_hero_image.dart` |
| `IngredientsCard` | Ingredients list card | `lib/src/features/recipes/presentation/widgets/ingredients_card.dart` |
| `InstructionStepList` | Numbered instruction steps | `lib/src/features/recipes/presentation/widgets/instruction_step_list.dart` |
| `RecipeEmptyState` | Home empty-state content widget | `lib/src/features/recipes/presentation/widgets/recipe_empty_state.dart` |
| `RecipeLoadingState` | Home loading-state content widget | `lib/src/features/recipes/presentation/widgets/recipe_loading_state.dart` |
| `RecipeErrorState` | Home or detail error-state content widget | `lib/src/features/recipes/presentation/widgets/recipe_error_state.dart` |
| `ProfileSummaryCard` | User name and email card | `lib/src/features/profile/presentation/widgets/profile_summary_card.dart` |
| `StatTile` | Recipe count tile | `lib/src/features/profile/presentation/widgets/stat_tile.dart` |
| `SettingsPlaceholderCard` | Future settings placeholder | `lib/src/features/profile/presentation/widgets/settings_placeholder_card.dart` |
| `SkeletonRecipeCard` | List loading placeholder | `lib/src/features/recipes/presentation/widgets/skeleton_recipe_card.dart` |
| `SkeletonChipRow` | Metadata loading placeholder | `lib/src/features/recipes/presentation/widgets/skeleton_chip_row.dart` |

## 5. Reusable Component Definitions

### `AuthModeToggle`

- Purpose: switch between login and signup modes.
- Props:
  - `bool isSignup`
  - `ValueChanged<bool> onChanged`
- Variants/states:
  - login selected
  - signup selected
- Used in:
  - auth

### `FormSurfaceCard`

- Purpose: simple white form container with border and internal padding.
- Props:
  - `Widget child`
- Variants/states:
  - default
- Used in:
  - auth

## 5.1 `AppPrimaryButton`

- Purpose: primary action button for submit, save, retry.
- Props:
  - `String label`
  - `VoidCallback? onPressed`
  - `bool isLoading = false`
  - `Widget? leading`
  - `double? width`
- Variants/states:
  - default
  - pressed
  - disabled
  - loading
- Used in:
  - auth
  - add recipe
  - edit recipe
  - empty state
  - error state
  - confirm delete sheet

## 5.2 `AppSecondaryButton`

- Purpose: secondary action with soft surface styling.
- Props:
  - `String label`
  - `VoidCallback? onPressed`
  - `Widget? leading`
- Variants/states:
  - default
  - disabled
- Used in:
  - profile logout if using non-destructive secondary style
  - cancel actions in sheets

## 5.3 `AppTextButton`

- Purpose: low-emphasis text action.
- Props:
  - `String label`
  - `VoidCallback? onPressed`
  - `Color? foregroundColor`
- Variants/states:
  - default
  - destructive text
- Used in:
  - auth mode switch
  - clear search
  - delete button on edit
  - go back from error state

## 5.4 `AppTextField`

- Purpose: labeled single-line text input.
- Props:
  - `String label`
  - `String? hintText`
  - `TextEditingController controller`
  - `TextInputType keyboardType`
  - `TextInputAction? textInputAction`
  - `String? Function(String?)? validator`
  - `String? helperText`
  - `Widget? prefixIcon`
  - `Widget? suffixIcon`
  - `bool obscureText = false`
- Variants/states:
  - idle
  - focused
  - filled
  - error
  - disabled
- Used in:
  - auth
  - add recipe
  - edit recipe

## 5.5 `AppMultilineField`

- Purpose: multiline recipe entry for description, ingredients, instructions.
- Props:
  - same base props as `AppTextField`
  - `int minLines = 5`
  - `int maxLines = 8`
- Variants/states:
  - idle
  - focused
  - filled
  - error
- Used in:
  - add recipe
  - edit recipe

## 5.6 `RecipeSearchField`

- Purpose: title search input with active clear state.
- Props:
  - `TextEditingController controller`
  - `ValueChanged<String>? onChanged`
  - `VoidCallback? onClear`
  - `FocusNode? focusNode`
  - `String hintText = 'Search recipes by title'`
- Variants/states:
  - idle
  - focused
  - typing
  - hasText
- Used in:
  - home
  - search state

## 5.7 `RecipeCard`

- Purpose: scrollable recipe list item.
- Props:
  - `String title`
  - `String? subtitle`
  - `String? imageUrl`
  - `String? imagePath`
  - `int? prepMinutes`
  - `int? cookMinutes`
  - `int? servings`
  - `VoidCallback onTap`
- Variants/states:
  - default
  - pressed
  - imageMissing
- Used in:
  - home list
  - search results

## 5.8 `MetadataChip`

- Purpose: compact recipe metadata display.
- Props:
  - `IconData? icon`
  - `String label`
  - `Color? backgroundColor`
- Variants/states:
  - default
  - soft-highlight
- Used in:
  - recipe card
  - recipe detail summary

## 5.9 `ImageUploadBox`

- Purpose: select and preview recipe photo.
- Props:
  - `String? imagePath`
  - `String? imageUrl`
  - `VoidCallback onTap`
  - `VoidCallback? onRemove`
- Variants/states:
  - empty
  - selected
  - error
- Used in:
  - add recipe
  - edit recipe

## 5.10 `StatusView`

- Purpose: reusable empty or error view.
- Props:
  - `Widget? illustration`
  - `IconData? icon`
  - `String title`
  - `String message`
  - `Widget? primaryAction`
  - `Widget? secondaryAction`
- Variants/states:
  - empty
  - error
- Used in:
  - home empty
  - search no results
  - home error
  - detail error

## 5.11 `StickyActionBar`

- Purpose: keep form CTA fixed above safe area.
- Props:
  - `Widget child`
  - `bool showTopBorder = true`
- Variants/states:
  - default
- Used in:
  - add recipe
  - edit recipe

## 5.12 `ConfirmActionSheet`

- Purpose: consistent delete confirmation.
- Props:
  - `String title`
  - `String message`
  - `String confirmLabel = 'Delete'`
  - `String cancelLabel = 'Cancel'`
  - `VoidCallback onConfirm`
- Variants/states:
  - default
  - destructive
- Used in:
  - recipe detail delete
  - edit recipe delete

## 6. Example Placeholder and Sample Content

Use this content during UI build to keep layout realistic.

### 6.1 User sample

```dart
const sampleUserName = 'Priya Sharma';
const sampleUserEmail = 'priya@example.com';
const sampleRecipeCount = 12;
```

### 6.2 Recipe list samples

```dart
final sampleRecipes = <Map<String, Object?>>[
  {
    'title': 'Aloo Paratha',
    'subtitle': 'Soft, buttery parathas with spiced potato filling.',
    'prepMinutes': 20,
    'cookMinutes': 15,
    'servings': 4,
  },
  {
    'title': 'Dal Tadka',
    'subtitle': 'Comforting yellow dal finished with garlic tempering.',
    'prepMinutes': 10,
    'cookMinutes': 25,
    'servings': 3,
  },
  {
    'title': 'Coconut Fish Curry',
    'subtitle': 'A family-style curry with coconut, chili, and tamarind.',
    'prepMinutes': 15,
    'cookMinutes': 30,
    'servings': 5,
  },
];
```

### 6.3 Add/edit form sample

```dart
const sampleDescription =
    'A Sunday breakfast favorite from home. Crisp outside and soft inside.';

const sampleIngredients =
    '2 cups whole wheat flour\n'
    '3 boiled potatoes\n'
    '1 green chili, chopped\n'
    '1 tsp cumin seeds\n'
    'Salt to taste\n'
    'Ghee for cooking';

const sampleInstructions =
    'Mix flour with water and rest the dough for 20 minutes.\n'
    'Mash potatoes with chili, cumin, and salt.\n'
    'Stuff dough balls with the potato mixture.\n'
    'Roll gently and cook on a hot tawa.\n'
    'Brush with ghee and serve hot.';
```

## 7. Screen-by-Screen Flutter UI Specification

## 7.1 `SplashAuthCheckScreen`

- Purpose: startup check while auth state resolves.
- Scaffold/app bar behavior:
  - `Scaffold`
  - no app bar
  - background `AppColors.background`
- Body sections in order:
  - centered brand block
  - loading indicator
- Widget tree:

```dart
Scaffold(
  backgroundColor: AppColors.background,
  body: SafeArea(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandMark(size: AppDimensions.splashLogoBox),
            const SizedBox(height: AppSpacing.xl),
            Text('Family Recipe', style: AppTypography.displayLarge),
            const SizedBox(height: AppSpacing.md),
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            ),
          ],
        ),
      ),
    ),
  ),
)
```

- Exact layout measurements:
  - horizontal padding `20`
  - logo size `88`
  - logo to title `24`
  - title to loader `16`
  - loader size `20`
- Reusable widgets used:
  - `BrandMark`
- CTA placement:
  - none
- Edge cases:
  - if auth check exceeds 2 seconds, keep the same UI
  - no retry button here
- Keyboard handling:
  - none
- Sample content:
  - title `Family Recipe`

## 7.2 `AuthScreen`

- Purpose: login or signup with minimal friction.
- Scaffold/app bar behavior:
  - `Scaffold`
  - no app bar
  - `resizeToAvoidBottomInset: true`
- Body sections in order:
  - top spacing
  - brand and headline
  - mode toggle or inline switch
  - form card
  - primary CTA
  - mode switch text action
- Widget tree:

```dart
Scaffold(
  backgroundColor: AppColors.background,
  resizeToAvoidBottomInset: true,
  body: SafeArea(
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandMark(size: AppDimensions.authLogoBox),
                const SizedBox(height: 24),
                Text(
                  'Keep your family recipes close',
                  style: AppTypography.displayLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Save the dishes you grew up with, one recipe at a time.',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 32),
                AuthModeToggle(
                  isSignup: isSignup,
                  onChanged: onModeChanged,
                ),
                const SizedBox(height: 16),
                FormSurfaceCard(
                  child: Column(
                    children: [
                      if (isSignup) ...[
                        AppTextField(
                          label: 'Full name',
                          controller: nameController,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                      ],
                      AppTextField(
                        label: 'Email',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Password',
                        controller: passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AppPrimaryButton(
                  label: 'Continue',
                  isLoading: isSubmitting,
                  onPressed: onSubmit,
                ),
                const SizedBox(height: 12),
                Center(
                  child: AppTextButton(
                    label: isSignup
                        ? 'Already have an account? Log in'
                        : 'New here? Create an account',
                    onPressed: onToggleMode,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ),
)
```

- Exact layout measurements:
  - outer padding top `40`
  - outer horizontal padding `20`
  - logo size `72`
  - headline to subtitle `8`
  - intro to toggle `32`
  - toggle to form `16`
  - field gap `16`
  - form to CTA `20`
  - CTA to footer action `12`
- Reusable widgets used:
  - `BrandMark`
  - `AuthModeToggle`
  - `AppTextField`
  - `AppPrimaryButton`
  - `AppTextButton`
- CTA placement:
  - full-width button below the form
- Edge cases:
  - email/password validation errors
  - auth failure message above CTA or as inline banner above form
  - signup mode can hide full name if backend is not ready
- Keyboard handling:
  - `SingleChildScrollView`
  - bottom padding should remain at least `24`
  - set `textInputAction` to move focus forward
- Sample content:
  - login mode default
  - headline `Keep your family recipes close`
  - helper `Save the dishes you grew up with, one recipe at a time.`

## 7.3 `HomeRecipeListScreen`

- Purpose: browse saved recipes and start recipe creation.
- Scaffold/app bar behavior:
  - `Scaffold`
  - quiet `AppBar`
  - right action profile icon
  - extended FAB
- Body sections in order:
  - header block
  - search field
  - optional results count or recipe count
  - recipe list or empty state
- Widget tree:

```dart
Scaffold(
  appBar: AppBar(
    toolbarHeight: 56,
    titleSpacing: 20,
    title: const SizedBox.shrink(),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: AppIconButton(
          icon: Icons.account_circle_rounded,
          onPressed: onProfileTap,
        ),
      ),
    ],
  ),
  floatingActionButton: AddRecipeFab(onPressed: onAddRecipeTap),
  body: SafeArea(
    top: false,
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimensions.maxContentWidth),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 88),
          children: [
            const HomeHeaderBlock(
              eyebrow: 'Your kitchen notebook',
              title: 'Saved recipes',
              subtitle: 'Keep family favorites in one place',
            ),
            const SizedBox(height: 16),
            RecipeSearchField(
              controller: searchController,
              onChanged: onSearchChanged,
              onClear: onSearchClear,
            ),
            const SizedBox(height: 12),
            Text('${recipes.length} recipes', style: AppTypography.caption),
            const SizedBox(height: 20),
            ...recipes.map(
              (recipe) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RecipeCard(
                  title: recipe.title,
                  subtitle: recipe.description,
                  prepMinutes: recipe.prepMinutes,
                  cookMinutes: recipe.cookMinutes,
                  servings: recipe.servings,
                  imageUrl: recipe.imageUrl,
                  onTap: () => onRecipeTap(recipe),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
)
```

- Exact layout measurements:
  - app bar height `56`
  - profile icon button size `40`
  - list padding `20,16,20,88`
  - header to search `16`
  - search height `52`
  - count text to list `20`
  - card gap `12`
  - FAB height `56`
- Reusable widgets used:
  - `AppIconButton`
  - `HomeHeaderBlock`
  - `RecipeSearchField`
  - `RecipeCard`
  - `AddRecipeFab`
- CTA placement:
  - extended FAB bottom-right
- Edge cases:
  - no recipes should render `RecipeEmptyState` in place of list
  - search text with zero results should render `HomeSearchNoResults`
  - long recipe titles clamp to 2 lines
- Keyboard handling:
  - search stays visible when keyboard opens
  - do not resize FAB on keyboard unless needed
- Sample content:
  - header subtitle `Keep family favorites in one place`
  - cards from `sampleRecipes`

## 7.4 `HomeSearchState`

- Purpose: filtered home state while searching.
- Scaffold/app bar behavior:
  - same scaffold as home
  - remains within home screen widget tree
- Body sections in order:
  - header block
  - active search field
  - results summary
  - filtered list or no-results block
- Widget tree:

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const HomeHeaderBlock(
      eyebrow: 'Your kitchen notebook',
      title: 'Saved recipes',
      subtitle: 'Keep family favorites in one place',
    ),
    const SizedBox(height: 16),
    RecipeSearchField(
      controller: searchController,
      onChanged: onSearchChanged,
      onClear: onSearchClear,
    ),
    const SizedBox(height: 12),
    Text('3 results for "dal"', style: AppTypography.caption),
    const SizedBox(height: 12),
    if (filteredRecipes.isEmpty)
      StatusView(
        icon: Icons.restaurant_menu_rounded,
        title: 'No recipes found',
        message: 'Try a different title or add this recipe as a new one.',
        primaryAction: AppPrimaryButton(
          label: 'Add Recipe',
          onPressed: onAddRecipeTap,
        ),
        secondaryAction: AppTextButton(
          label: 'Clear Search',
          onPressed: onSearchClear,
        ),
      )
    else
      ...filteredRecipes.map((recipe) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RecipeCard(...),
          )),
  ],
)
```

- Exact layout measurements:
  - search to summary `12`
  - summary to content `12`
  - no-results block top padding `32`
- Reusable widgets used:
  - `RecipeSearchField`
  - `RecipeCard`
  - `StatusView`
  - `AppPrimaryButton`
  - `AppTextButton`
- CTA placement:
  - inline primary button inside no-results view
- Edge cases:
  - clear icon hidden when query empty
  - do not show results summary if query empty
- Keyboard handling:
  - keep screen scrollable
  - on submit, close keyboard but keep filtered results visible
- Sample content:
  - query `dal`
  - result `Dal Tadka`

## 7.5 `AddRecipeScreen`

- Purpose: create a recipe manually.
- Scaffold/app bar behavior:
  - `Scaffold`
  - app bar title `Add Recipe`
  - `resizeToAvoidBottomInset: true`
- Body sections in order:
  - image upload
  - title field
  - description field
  - ingredients field
  - instructions field
  - metadata fields
  - sticky save bar
- Widget tree:

```dart
Scaffold(
  appBar: AppBar(title: const Text('Add Recipe')),
  resizeToAvoidBottomInset: true,
  body: SafeArea(
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimensions.maxContentWidth),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageUploadBox(
                        imagePath: selectedImagePath,
                        onTap: onSelectImage,
                      ),
                      const SizedBox(height: 24),
                      AppTextField(
                        label: 'Recipe title',
                        hintText: 'Eg. Aloo Paratha',
                        controller: titleController,
                        validator: validateRequired,
                      ),
                      const SizedBox(height: 16),
                      AppMultilineField(
                        label: 'Description',
                        hintText: 'Optional family note or short description',
                        controller: descriptionController,
                        minLines: 3,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 24),
                      AppMultilineField(
                        label: 'Ingredients',
                        hintText: 'Add one ingredient per line',
                        helperText: 'Add one ingredient per line',
                        controller: ingredientsController,
                        validator: validateRequired,
                      ),
                      const SizedBox(height: 24),
                      AppMultilineField(
                        label: 'Instructions',
                        hintText: 'Write one step per line',
                        helperText: 'Write one step per line',
                        controller: instructionsController,
                        validator: validateRequired,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Prep time',
                              hintText: '20 min',
                              controller: prepController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextField(
                              label: 'Cook time',
                              hintText: '15 min',
                              controller: cookController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Servings',
                        hintText: '4',
                        controller: servingsController,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            StickyActionBar(
              child: AppPrimaryButton(
                label: 'Save Recipe',
                isLoading: isSaving,
                onPressed: onSave,
              ),
            ),
          ],
        ),
      ),
    ),
  ),
)
```

- Exact layout measurements:
  - form padding `20,16,20,24`
  - upload box height `180`
  - section gap `24`
  - field gap `16`
  - sticky action bar min height `88`
  - save button height `52`
- Reusable widgets used:
  - `ImageUploadBox`
  - `AppTextField`
  - `AppMultilineField`
  - `StickyActionBar`
  - `AppPrimaryButton`
- CTA placement:
  - fixed bottom via sticky action bar
- Edge cases:
  - empty title
  - empty ingredients
  - empty instructions
  - no image selected is valid
  - long multiline content should scroll smoothly
- Keyboard handling:
  - `SingleChildScrollView` plus sticky bottom CTA
  - use `scrollPadding: EdgeInsets.only(bottom: 120)` on fields if needed
  - focus order: title -> description -> ingredients -> instructions -> prep -> cook -> servings
- Sample content:
  - title `Aloo Paratha`
  - description from `sampleDescription`
  - ingredients and instructions from sample text

## 7.6 `RecipeDetailScreen`

- Purpose: readable recipe view.
- Scaffold/app bar behavior:
  - `Scaffold`
  - app bar with back, edit, overflow delete
- Body sections in order:
  - hero image
  - summary block
  - ingredients section
  - instructions section
- Widget tree:

```dart
Scaffold(
  appBar: AppBar(
    title: const SizedBox.shrink(),
    actions: [
      AppIconButton(
        icon: Icons.edit_rounded,
        onPressed: onEditTap,
      ),
      PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert_rounded),
        onSelected: onMenuSelected,
        itemBuilder: (context) => const [
          PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete recipe'),
          ),
        ],
      ),
    ],
  ),
  body: SafeArea(
    top: false,
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimensions.maxContentWidth),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RecipeHeroImage(
                imageUrl: recipe.imageUrl,
                imagePath: recipe.imagePath,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(recipe.title, style: AppTypography.titleLarge),
                    if (recipe.description?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 8),
                      Text(recipe.description!, style: AppTypography.bodySmall),
                    ],
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (recipe.prepMinutes != null)
                          MetadataChip(
                            icon: Icons.schedule_rounded,
                            label: '${recipe.prepMinutes} min prep',
                          ),
                        if (recipe.cookMinutes != null)
                          MetadataChip(
                            icon: Icons.schedule_rounded,
                            label: '${recipe.cookMinutes} min cook',
                          ),
                        if (recipe.servings != null)
                          MetadataChip(
                            icon: Icons.people_alt_outlined,
                            label: 'Serves ${recipe.servings}',
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const SectionHeader(title: 'Ingredients'),
                    const SizedBox(height: 12),
                    IngredientsCard(items: recipe.ingredients),
                    const SizedBox(height: 24),
                    const SectionHeader(title: 'Instructions'),
                    const SizedBox(height: 12),
                    InstructionStepList(steps: recipe.instructions),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
)
```

- Exact layout measurements:
  - hero image aspect ratio `16 / 9`
  - hero to content `20`
  - title to description `8`
  - description to metadata `16`
  - metadata wrap spacing `8`
  - section gap `24`
  - section header to card `12`
  - content padding `20,20,20,24`
- Reusable widgets used:
  - `AppIconButton`
  - `RecipeHeroImage`
  - `MetadataChip`
  - `SectionHeader`
  - `IngredientsCard`
  - `InstructionStepList`
  - `ConfirmActionSheet`
- CTA placement:
  - edit in app bar
  - delete inside overflow menu
- Edge cases:
  - no image should show placeholder
  - empty description should hide the block
  - if metadata missing, hide unused chips
  - if ingredient or instruction lines are malformed, trim blank lines before render
- Keyboard handling:
  - none
- Sample content:
  - title `Aloo Paratha`
  - description and metadata from sample content

## 7.7 `EditRecipeScreen`

- Purpose: update an existing recipe.
- Scaffold/app bar behavior:
  - same as add screen
  - title `Edit Recipe`
- Body sections in order:
  - same form order as add screen
  - delete text action near form bottom
  - sticky save bar
- Widget tree:

```dart
Scaffold(
  appBar: AppBar(title: const Text('Edit Recipe')),
  resizeToAvoidBottomInset: true,
  body: SafeArea(
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimensions.maxContentWidth),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageUploadBox(...),
                      const SizedBox(height: 24),
                      AppTextField(...),
                      const SizedBox(height: 16),
                      AppMultilineField(...),
                      const SizedBox(height: 24),
                      AppMultilineField(...),
                      const SizedBox(height: 24),
                      AppMultilineField(...),
                      const SizedBox(height: 24),
                      Row(...),
                      const SizedBox(height: 16),
                      AppTextField(...),
                      const SizedBox(height: 24),
                      AppTextButton(
                        label: 'Delete Recipe',
                        foregroundColor: AppColors.error,
                        onPressed: onDeleteTap,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            StickyActionBar(
              child: AppPrimaryButton(
                label: 'Save Changes',
                isLoading: isSaving,
                onPressed: onSaveChanges,
              ),
            ),
          ],
        ),
      ),
    ),
  ),
)
```

- Exact layout measurements:
  - identical to add screen
  - delete action top gap `24`
- Reusable widgets used:
  - same as add screen
  - `AppTextButton`
  - `ConfirmActionSheet`
- CTA placement:
  - save changes fixed at bottom
  - delete as low-emphasis destructive text inside form content
- Edge cases:
  - unsaved changes on back navigation
  - delete confirmation required
- Keyboard handling:
  - same as add screen
- Sample content:
  - use same values as `sampleDescription`, `sampleIngredients`, `sampleInstructions`

## 7.8 `ProfilePlaceholderScreen`

- Purpose: simple account page for MVP.
- Scaffold/app bar behavior:
  - `Scaffold`
  - app bar title `Profile`
- Body sections in order:
  - profile summary card
  - stats card
  - settings placeholder card
  - logout button
- Widget tree:

```dart
Scaffold(
  appBar: AppBar(title: const Text('Profile')),
  body: SafeArea(
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimensions.maxContentWidth),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            ProfileSummaryCard(
              name: sampleUserName,
              email: sampleUserEmail,
            ),
            const SizedBox(height: 16),
            const StatTile(
              label: 'Recipes saved',
              value: '12',
            ),
            const SizedBox(height: 16),
            const SettingsPlaceholderCard(
              items: [
                'Account settings',
                'More family features coming soon',
              ],
            ),
            const SizedBox(height: 24),
            AppSecondaryButton(
              label: 'Log Out',
              leading: const Icon(Icons.logout_rounded),
              onPressed: onLogoutTap,
            ),
          ],
        ),
      ),
    ),
  ),
)
```

- Exact layout measurements:
  - list padding `20,16,20,24`
  - card gap `16`
  - logout top gap `24`
  - avatar size `56`
- Reusable widgets used:
  - `ProfileSummaryCard`
  - `StatTile`
  - `SettingsPlaceholderCard`
  - `AppSecondaryButton`
- CTA placement:
  - logout button at bottom of visible content
- Edge cases:
  - missing name should show email prefix or `Family Cook`
  - recipe count can be zero
- Keyboard handling:
  - none
- Sample content:
  - `Priya Sharma`
  - `priya@example.com`
  - `12`

## 7.9 `RecipeEmptyState`

- Purpose: first-time state when there are no recipes.
- Scaffold/app bar behavior:
  - not a separate route
  - rendered inside home content area
- Body sections in order:
  - home header
  - search field
  - centered empty block
- Widget tree:

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const HomeHeaderBlock(...),
    const SizedBox(height: 16),
    RecipeSearchField(...),
    const SizedBox(height: 32),
    StatusView(
      icon: Icons.restaurant_menu_rounded,
      title: 'No recipes saved yet',
      message: 'Start with the dishes your family makes most often.',
      primaryAction: AppPrimaryButton(
        label: 'Add Your First Recipe',
        onPressed: onAddRecipeTap,
      ),
    ),
  ],
)
```

- Exact layout measurements:
  - search to empty block `32`
  - illustration/icon area `120`
  - title to body `8`
  - body to CTA `20`
- Reusable widgets used:
  - `HomeHeaderBlock`
  - `RecipeSearchField`
  - `StatusView`
  - `AppPrimaryButton`
- CTA placement:
  - inside status block
- Edge cases:
  - if user types in search on empty data, keep the same empty state wording simple
- Keyboard handling:
  - search remains interactive
- Sample content:
  - title `No recipes saved yet`

## 7.10 `LoadingState`

- Purpose: loading placeholders for home and detail.
- Scaffold/app bar behavior:
  - follows parent screen scaffold
- Body sections in order:
  - home loading: header skeleton, search skeleton, 4 card skeletons
  - detail loading: hero skeleton, title skeleton, chip row skeleton, content skeletons
- Widget tree for home:

```dart
ListView(
  padding: const EdgeInsets.fromLTRB(20, 16, 20, 88),
  children: const [
    SkeletonBlock(height: 18, width: 140),
    SizedBox(height: 8),
    SkeletonBlock(height: 28, width: 180),
    SizedBox(height: 8),
    SkeletonBlock(height: 20, width: 220),
    SizedBox(height: 16),
    SkeletonBlock(height: 52),
    SizedBox(height: 20),
    SkeletonRecipeCard(),
    SizedBox(height: 12),
    SkeletonRecipeCard(),
    SizedBox(height: 12),
    SkeletonRecipeCard(),
    SizedBox(height: 12),
    SkeletonRecipeCard(),
  ],
)
```

- Widget tree for detail:

```dart
SingleChildScrollView(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      AspectRatio(
        aspectRatio: AppDimensions.heroAspectRatio,
        child: SkeletonBlock(),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBlock(height: 28, width: 220),
            SizedBox(height: 8),
            SkeletonBlock(height: 18, width: 280),
            SizedBox(height: 16),
            SkeletonChipRow(),
            SizedBox(height: 24),
            SkeletonBlock(height: 24, width: 120),
            SizedBox(height: 12),
            SkeletonBlock(height: 120),
            SizedBox(height: 24),
            SkeletonBlock(height: 24, width: 120),
            SizedBox(height: 12),
            SkeletonBlock(height: 180),
          ],
        ),
      ),
    ],
  ),
)
```

- Exact layout measurements:
  - match loaded layouts exactly
  - skeleton recipe card height `112`
  - detail content padding `20,20,20,24`
- Reusable widgets used:
  - `SkeletonBlock`
  - `SkeletonRecipeCard`
  - `SkeletonChipRow`
- CTA placement:
  - none
- Edge cases:
  - avoid flashy shimmer
  - use pulse only if already implemented globally
- Keyboard handling:
  - none

## 7.11 `ErrorState`

- Purpose: graceful recovery when load fails.
- Scaffold/app bar behavior:
  - can be full-screen within home or detail scaffold
- Body sections in order:
  - icon
  - title
  - message
  - retry button
  - optional back text action
- Widget tree:

```dart
Center(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: StatusView(
        icon: Icons.error_outline_rounded,
        title: 'Something went wrong',
        message: 'We couldn\\'t load your recipes right now. Please try again.',
        primaryAction: AppPrimaryButton(
          label: 'Try Again',
          onPressed: onRetry,
        ),
        secondaryAction: canGoBack
            ? AppTextButton(
                label: 'Go Back',
                onPressed: onGoBack,
              )
            : null,
      ),
    ),
  ),
)
```

- Exact layout measurements:
  - max content width `320`
  - horizontal padding `20`
  - icon area `120`
  - message to primary action `20`
  - primary to secondary action `12`
- Reusable widgets used:
  - `StatusView`
  - `AppPrimaryButton`
  - `AppTextButton`
- CTA placement:
  - centered within state block
- Edge cases:
  - for save action failure, use inline snackbar instead of full-page error
  - for initial list/detail load, use full-page error
- Keyboard handling:
  - none

## 8. Exact Layout Measurements Summary

### 8.1 Global

| Item | Measurement |
| --- | --- |
| Screen horizontal padding | `20` |
| Top content padding below app bar | `16` |
| Major section gap | `24` |
| Standard field gap | `16` |
| Small gap | `8` |
| Recipe card gap | `12` |
| Bottom content padding under FAB | `88` |
| Max centered content width | `600` |

### 8.2 Inputs and buttons

| Item | Measurement |
| --- | --- |
| Primary and secondary button height | `52` |
| Text button height | `40` |
| Search field height | `52` |
| Input min height | `52` |
| Multiline min height | `120` |
| Metadata chip height | `32` |
| Icon button size | `40` |
| Minimum touch target | `44` |

### 8.3 Content elements

| Item | Measurement |
| --- | --- |
| Recipe card image | `88 x 88` |
| Recipe card min height | `112` |
| Upload box height | `180` |
| Hero image ratio | `16 / 9` |
| Empty state graphic | `120 x 120` |
| Profile avatar | `56` |
| FAB height | `56` |
| Sticky action bar min height | `88` |

## 9. Recommended Flutter UI Folder Structure

```text
lib/
  main.dart
  src/
    app.dart
    core/
      navigation/
        app_router.dart
        route_names.dart
      theme/
        app_colors.dart
        app_dimensions.dart
        app_radii.dart
        app_shadows.dart
        app_spacing.dart
        app_theme.dart
        app_typography.dart
    shared/
      widgets/
        branding/
          brand_mark.dart
        buttons/
          app_icon_button.dart
          app_primary_button.dart
          app_secondary_button.dart
          app_text_button.dart
        inputs/
          app_multiline_field.dart
          app_text_field.dart
          recipe_search_field.dart
        layout/
          section_header.dart
          sticky_action_bar.dart
        sheets/
          confirm_action_sheet.dart
        state/
          skeleton_block.dart
          status_view.dart
    features/
      auth/
        presentation/
          auth_gate.dart
          screens/
            splash_auth_check_screen.dart
            auth_screen.dart
          widgets/
            auth_mode_toggle.dart
            form_surface_card.dart
      recipes/
        presentation/
          screens/
            home_recipe_list_screen.dart
            add_recipe_screen.dart
            recipe_detail_screen.dart
            edit_recipe_screen.dart
          widgets/
            add_recipe_fab.dart
            home_header_block.dart
            image_upload_box.dart
            ingredients_card.dart
            instruction_step_list.dart
            metadata_chip.dart
            recipe_card.dart
            recipe_hero_image.dart
            skeleton_chip_row.dart
            skeleton_recipe_card.dart
            recipe_empty_state.dart
            recipe_error_state.dart
            recipe_loading_state.dart
      profile/
        presentation/
          screens/
            profile_placeholder_screen.dart
          widgets/
            profile_summary_card.dart
            settings_placeholder_card.dart
            stat_tile.dart
```

## 10. State Handling Notes

### 10.1 Lightweight MVP recommendation

- Use feature-local `ChangeNotifier`, `ValueNotifier`, or equivalent.
- Do not introduce complex global state until API and flows stabilize.
- Keep screen state separate from reusable widgets.

### 10.2 Loading states

- Home:
  - show `RecipeLoadingState` before initial list load completes
- Detail:
  - show detail loading variant before recipe data resolves
- Auth submit:
  - disable CTA and show inline spinner in `AppPrimaryButton`
- Form save:
  - disable CTA and show button loading state

### 10.3 Empty states

- Home:
  - empty list uses `RecipeEmptyState`
- Search:
  - no results uses `StatusView` inline
- Profile:
  - recipe count can be zero but page still loads normally

### 10.4 Error states

- Initial load failure:
  - render full-page `StatusView`
- Search failure:
  - unlikely for in-memory filtering, so avoid separate error UI
- Save/update/delete failure:
  - use `SnackBar` or top inline banner
- Image picker failure:
  - use small snackbar message, do not block form

### 10.5 Form validation

- Required:
  - title
  - ingredients
  - instructions
- Optional:
  - image
  - description
  - prep time
  - cook time
  - servings
- Validation messages:
  - `Please enter a recipe title`
  - `Please add at least one ingredient`
  - `Please add at least one instruction step`
  - `Enter numbers only` for numeric fields
- Before submit:
  - trim whitespace
  - collapse blank lines in multiline fields
- After submit:
  - split `ingredients` and `instructions` by newline
  - remove empty lines

## 11. Recommended Reusable Widgets and Where to Use Them

| Widget | Where to use |
| --- | --- |
| `BrandMark` | splash, auth |
| `AuthModeToggle` | auth |
| `FormSurfaceCard` | auth |
| `AppPrimaryButton` | auth, add, edit, empty, error, confirm sheet |
| `AppSecondaryButton` | profile logout, cancel sheet if needed |
| `AppTextButton` | auth switch, edit delete, search clear, error back |
| `AppTextField` | auth, add, edit |
| `AppMultilineField` | add, edit |
| `RecipeSearchField` | home |
| `AppIconButton` | home app bar, detail app bar |
| `SectionHeader` | detail ingredients and instructions |
| `StickyActionBar` | add, edit |
| `StatusView` | empty, error, no results |
| `ConfirmActionSheet` | detail delete, edit delete |
| `RecipeCard` | home list, search results |
| `MetadataChip` | recipe card, detail summary |
| `ImageUploadBox` | add, edit |
| `RecipeHeroImage` | detail |
| `IngredientsCard` | detail |
| `InstructionStepList` | detail |
| `ProfileSummaryCard` | profile |
| `StatTile` | profile |
| `SettingsPlaceholderCard` | profile |
| `SkeletonBlock` | loading states |
| `SkeletonRecipeCard` | home loading |
| `SkeletonChipRow` | detail loading |

## 12. Build Priority Order for UI Implementation

1. Theme tokens and `AppTheme`
2. Shared buttons
3. Shared inputs
4. `BrandMark`, `StatusView`, `StickyActionBar`, `ConfirmActionSheet`
5. Recipe-specific shared widgets:
   - `MetadataChip`
   - `RecipeCard`
   - `ImageUploadBox`
   - `RecipeHeroImage`
   - `IngredientsCard`
   - `InstructionStepList`
6. `SplashAuthCheckScreen`
7. `AuthScreen`
8. `HomeRecipeListScreen`
9. `RecipeEmptyState`
10. `HomeSearchState`
11. `AddRecipeScreen`
12. `RecipeDetailScreen`
13. `EditRecipeScreen`
14. `ProfilePlaceholderScreen`
15. Home and detail loading states
16. Shared error states

## 13. UX Adjustments Needed Before Coding

- Lock auth scope to email and password for the first pass. Do not build social auth UI yet.
- Keep full name optional in signup until backend requirements are fixed.
- Treat ingredients and instructions as line-based input only for MVP.
- Keep delete in one place per screen. Use overflow on detail and text action on edit.
- Do not add filters beyond search by title.
- Keep the profile page clearly labeled as a placeholder to avoid false expectations.
- Keep FAB label as `Add Recipe` on all devices. Do not collapse to icon-only unless space is severely constrained.

## 14. Final Coding Guidance

- Build the shared widget layer first and keep the screens thin.
- Keep the layout consistent by using token values only.
- Avoid hard-coded colors, font sizes, and paddings inside screen files.
- Keep list screens and form screens centered with a `maxWidth` of `600`.
- Prefer `ListView` and `SingleChildScrollView` over premature sliver complexity for MVP.
