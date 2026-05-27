# Family Recipe App MVP Mobile Design Spec

## 1. Product Visual Direction Summary

### Product intent
Family Recipe App should feel like a digital family notebook for recipes, not a food marketplace and not a lifestyle luxury product. The experience should feel calm, useful, and emotionally grounded.

### Visual direction
- Warm, soft surfaces with terracotta highlights and clean white cards.
- Emotional through copy, imagery, and spacing rather than decorative graphics.
- Readability-first layouts for long recipe content.
- Rounded corners and gentle borders to keep the app approachable for non-technical users.
- Indian-family-friendly in warmth and tone, but globally usable by avoiding culturally narrow motifs or region-specific visual clichés.

### Core UI principles
- Mobile-first and one-handed where possible.
- One clear primary action per screen.
- Content-heavy screens should rely on spacing and typography, not ornament.
- Use recipe photos as content, not background decoration.
- Keep navigation shallow and predictable.

### Brand tone
- Warm
- Trustworthy
- Simple
- Personal
- Homemade

### Simple logo/icon concept
- A rounded recipe notebook shape with a small spoon and steam line inside.
- Use terracotta on cream.
- Keep it flat, single-weight, and icon-friendly for app splash, auth, and empty states.

## 2. Design System

### 2.1 Color palette

| Token | Hex | Usage |
| --- | --- | --- |
| `colorPrimary` | `#F07A4A` | Primary actions, key accents, focused states |
| `colorPrimaryDark` | `#D8612F` | Pressed primary buttons, strong emphasis |
| `colorBackground` | `#FFF8F3` | App background |
| `colorSurface` | `#FFFFFF` | Cards, sheets, inputs |
| `colorSurfaceSoft` | `#FFF3EC` | Soft highlighted sections, subtle chips |
| `colorAccentSoft` | `#FBE7DD` | Secondary buttons, soft banners, empty states |
| `colorTextPrimary` | `#1A1A1A` | Main text |
| `colorTextSecondary` | `#6B6B6B` | Secondary text, labels, helper text |
| `colorBorder` | `#EADFD8` | Input borders, dividers, card outlines |
| `colorSuccess` | `#467A57` | Save success, positive state |
| `colorError` | `#C65A46` | Error states, destructive actions |
| `colorDisabled` | `#F1E5DE` | Disabled fills |
| `colorDisabledText` | `#A69084` | Disabled text |
| `colorOnPrimary` | `#FFFFFF` | Text/icons on primary surfaces |

### 2.2 Typography

### Font recommendation
- Primary: `Nunito Sans`
- Fallback: `Noto Sans`
- Flutter note: if keeping dependencies minimal, use platform sans fallback with the same sizing scale.

### Type scale

| Style token | Size | Weight | Line height | Usage |
| --- | --- | --- | --- | --- |
| `displayLarge` | 28 | 700 | 34 | Splash title, auth headline |
| `titleLarge` | 22 | 700 | 28 | Screen titles, recipe title |
| `titleMedium` | 18 | 700 | 24 | Section headers |
| `bodyLarge` | 16 | 600 | 24 | Strong body text, card titles |
| `bodyMedium` | 15 | 400 | 22 | Standard body copy |
| `bodySmall` | 14 | 400 | 20 | Supporting copy, helper text |
| `caption` | 13 | 400 | 18 | Metadata, labels, footnotes |
| `buttonLarge` | 16 | 700 | 20 | Primary and secondary buttons |
| `buttonSmall` | 14 | 700 | 18 | Chips, compact actions |

### Typography usage rules
- Prefer left-aligned text across the app.
- Limit recipe titles to 2 lines in lists and 3 lines on detail.
- Use `bodyMedium` for ingredients and instructions for readability while cooking.
- Keep captions and metadata high-contrast enough to remain readable in kitchens and bright light.

### 2.3 Spacing system

Use a 4-point spacing system.

| Token | Value | Usage |
| --- | --- | --- |
| `space4` | 4 | Tight icon-label gaps |
| `space8` | 8 | Small chip spacing |
| `space12` | 12 | Internal card spacing |
| `space16` | 16 | Standard control gap |
| `space20` | 20 | Screen horizontal padding |
| `space24` | 24 | Section spacing |
| `space32` | 32 | Large vertical blocks |
| `space40` | 40 | Top breathing room on empty states and auth |

### Default screen spacing
- Horizontal screen padding: `20`
- Top content padding below app bar: `16`
- Vertical gap between stacked form fields: `16`
- Gap between major sections: `24`
- Bottom safe area padding: `20` plus device safe inset

### 2.4 Border radius system

| Token | Value | Usage |
| --- | --- | --- |
| `radius8` | 8 | Chips, small badges |
| `radius12` | 12 | Compact buttons, image placeholders |
| `radius14` | 14 | Inputs, standard buttons |
| `radius16` | 16 | Cards, upload boxes |
| `radius20` | 20 | Bottom sheets, larger cards |
| `radius28` | 28 | Extended pill shapes, large empty-state surfaces |

### 2.5 Elevation and shadow usage

Keep shadows subtle. Prefer borders over heavy elevation.

| Token | Value | Usage |
| --- | --- | --- |
| `shadowLow` | `0 2 8 rgba(26,26,26,0.06)` | Cards on light background |
| `shadowMedium` | `0 6 18 rgba(26,26,26,0.08)` | FAB, bottom sheet |
| `shadowNone` | none | App bars, section containers |

### Elevation rules
- Cards: border plus optional `shadowLow`
- App bar: no elevation
- FAB: `shadowMedium`
- Inputs: no shadow, border only

### 2.6 Button styles

#### `AppPrimaryButton`
- Height: `52`
- Padding: `16 horizontal`
- Radius: `14`
- Fill: `colorPrimary`
- Text: `buttonLarge`, `colorOnPrimary`
- Pressed: `colorPrimaryDark`
- Disabled: `colorDisabled` with `colorDisabledText`

#### `AppSecondaryButton`
- Height: `52`
- Padding: `16 horizontal`
- Radius: `14`
- Fill: `colorAccentSoft`
- Border: `1px colorBorder`
- Text: `buttonLarge`, `colorPrimaryDark`

#### `AppTextButton`
- Height: `40`
- Text: `buttonSmall`
- Use for auth mode switch, cancel, secondary link actions

#### Destructive action button
- Use secondary surface or text button pattern
- Text: `colorError`
- Never use filled red for the main CTA on MVP screens

### 2.7 Input styles

#### `AppTextField`
- Min height: `52`
- Fill: `colorSurface`
- Border: `1px colorBorder`
- Focus border: `1.5px colorPrimary`
- Radius: `14`
- Label: `bodySmall`
- Input text: `bodyMedium`
- Placeholder: `colorTextSecondary`

#### `AppMultilineField`
- Min height: `120`
- Same visual style as `AppTextField`
- Text aligns top-left
- Helper text sits below field at `space8`

#### Error state
- Border becomes `colorError`
- Helper text becomes `colorError`

### 2.8 Card styles

#### `RecipeCard`
- Surface: `colorSurface`
- Radius: `16`
- Border: `1px colorBorder`
- Optional `shadowLow`
- Internal padding: `12`
- Thumbnail: `88 x 88`, radius `12`
- Layout: image left, text/meta right

#### Content cards on detail
- Ingredients and instructions should sit in separate white cards
- Internal padding: `16`
- Use clear item separation rather than visual complexity

### 2.9 App bar / header style

#### Default app bar
- Height: platform default
- Background: `colorBackground`
- Elevation: `0`
- Title: `titleLarge`
- Actions: icon buttons with 40x40 minimum touch target

#### Home header block
- Use a content header instead of a heavy app bar title
- Greeting label: `bodySmall`
- Main title: `titleLarge`
- Subtitle: `bodySmall`

### 2.10 Floating action button style

#### `AddRecipeFab`
- Type: extended FAB on home
- Height: `56`
- Radius: `18`
- Fill: `colorPrimary`
- Label: `Add Recipe`
- Icon: `plus`
- Shadow: `shadowMedium`

### 2.11 Navigation pattern recommendation

Do not use bottom navigation for MVP.

Recommended pattern:
- Root auth gate decides whether to show auth flow or app flow.
- After login, use a single-stack navigation model.
- Home is the root screen.
- Add, detail, edit, and profile are pushed from home.
- Search stays as an inline home state, not a separate tab.
- Use bottom sheets for image source selection and delete confirmation.

Reason:
- MVP has one core content area.
- Bottom navigation would add complexity without meaningful value.
- A stack model is easiest to build and easiest to understand for non-technical users.

## 3. App Navigation Flow

### Primary flow
1. `SplashAuthCheckScreen`
2. `AuthScreen` if unauthenticated
3. `HomeRecipeListScreen`
4. From home:
   - `AddRecipeScreen`
   - `RecipeDetailScreen`
   - `ProfilePlaceholderScreen`
5. From recipe detail:
   - `EditRecipeScreen`

### Simplified route map
- `/splash`
- `/auth`
- `/home`
- `/recipe/add`
- `/recipe/:id`
- `/recipe/:id/edit`
- `/profile`

### Interaction flow summary
- Login/signup success lands directly on home.
- Search filters content inside home.
- Add recipe returns to home and refreshes list.
- Detail edit returns to detail after update.
- Delete returns to home with confirmation.
- Logout returns to auth.

## 4. Screen-by-Screen Design Spec

## 4.1 `SplashAuthCheckScreen`

### Purpose
Minimal branded loading screen while auth state is checked.

### Layout sections
- Full-screen cream background
- Centered brand mark
- App name below icon
- Small loading indicator below app name

### Layout detail
- Vertical stack centered on screen
- Brand mark inside a soft terracotta-tinted rounded square
- App name: `Family Recipe`
- Optional subtitle omitted to keep this screen minimal

### Reusable widgets needed
- `BrandMark`
- `CenteredLoadingBlock`

### Recommended spacing
- Icon to app name: `24`
- App name to loader: `16`

### Recommended states
- Default checking state only

### Responsive notes
- Keep content width under `240`
- Always vertically center on phones
- Do not add illustration or extra copy

## 4.2 `AuthScreen`

### Purpose
Help users quickly sign in or create an account with minimal friction.

### Layout sections
- Intro block
- Auth mode switch
- Form card
- Primary CTA
- Mode-switch text action

### Layout detail
- Background stays `colorBackground`
- Top section contains:
  - Small brand mark
  - Headline: `Keep your family recipes close`
  - Supporting text: `Save the dishes you grew up with, one recipe at a time.`
- Form card contains:
  - Segmented mode toggle or simple inline text switch between `Log in` and `Sign up`
  - `Email` field
  - `Password` field
  - Optional `Full name` field only in signup mode if needed by the product team later
- Full-width `Continue` primary button
- Secondary text action:
  - Login mode: `New here? Create an account`
  - Signup mode: `Already have an account? Log in`

### Reusable widgets needed
- `BrandMark`
- `AuthModeToggle`
- `AppTextField`
- `AppPrimaryButton`
- `AppTextButton`
- `FormSurfaceCard`

### Recommended spacing
- Screen horizontal padding: `20`
- Intro block to form card: `32`
- Field-to-field gap: `16`
- CTA to mode switch: `12`

### Recommended states
- Login mode
- Signup mode
- Submitting state
- Field validation state
- Auth error banner

### Responsive notes
- Use `SingleChildScrollView`
- Keep form card max width near `420`
- Keep CTA visible above keyboard using bottom padding

## 4.3 `HomeRecipeListScreen`

### Purpose
Main dashboard for browsing saved recipes and starting new ones.

### Layout sections
- Home header
- Search field
- Optional light info row
- Recipe list
- Floating add recipe button

### Layout detail
- App bar stays visually quiet with profile icon on the right
- Content header:
  - Eyebrow: `Your kitchen notebook`
  - Title: `Saved recipes`
  - Subtitle: `Keep family favorites in one place`
- Search field directly below header
- Optional info row can show:
  - `12 recipes`
  - Keep it passive, not interactive
- Main list uses vertical recipe cards
- FAB anchored bottom-right with label `Add Recipe`

### Recipe card content
- Thumbnail image or placeholder tile
- Recipe title
- One-line subtitle from description if available
- Metadata row using chips for any available values:
  - Prep time
  - Cook time
  - Servings

### Reusable widgets needed
- `HomeHeaderBlock`
- `RecipeSearchField`
- `RecipeCard`
- `MetadataChip`
- `AddRecipeFab`

### Recommended spacing
- Header to search: `16`
- Search to list: `20`
- Card-to-card gap: `12`
- Bottom list padding: `88` to clear FAB

### Recommended states
- List with content
- Empty variant
- Loading skeleton
- Full-page error

### Responsive notes
- One-column list only for MVP
- Keep content centered on widths above `600`
- Avoid grids for MVP

## 4.4 `HomeSearchState`

### Purpose
Inline home state while the user searches by recipe title.

### Layout sections
- Focused search field
- Results count or helper text
- Filtered recipe list or no-result block

### Layout detail
- Search field becomes active and shows clear icon
- Optional helper text under search:
  - `3 results`
  - Or `Searching for "dal"...`
- Results reuse the same `RecipeCard`
- No-result state stays compact and appears inside the content area

### No-result copy
- Title: `No recipes found`
- Supporting text: `Try a different title or add this recipe as a new one.`
- Actions:
  - `Clear Search`
  - `Add Recipe`

### Reusable widgets needed
- `RecipeSearchField`
- `RecipeCard`
- `CompactEmptyStateBlock`

### Recommended spacing
- Search to result summary: `12`
- Result summary to list: `12`

### Recommended states
- Active typing
- Filtered results
- No results

### Responsive notes
- Search should stay pinned near the top of the content
- Use inline filtering for MVP if list sizes are small

## 4.5 `AddRecipeScreen`

### Purpose
Allow users to manually create a recipe in a way that feels easy and forgiving.

### Layout sections
- App bar
- Scrollable form
- Sticky bottom save area

### Layout detail
- App bar title: `Add Recipe`
- Scroll content order:
  1. `ImageUploadBox`
  2. `Title` field
  3. `Description` field with optional note copy
  4. `Ingredients` multiline field
  5. `Instructions` multiline field
  6. Short metadata fields for prep time, cook time, servings
- `Ingredients` helper text: `Add one ingredient per line`
- `Instructions` helper text: `Write one step per line`
- Save button sits in a bottom safe-area action bar

### Field structure recommendation
- Use multiline text for ingredients and instructions in MVP
- Parse by line breaks instead of designing complex repeatable item builders
- Use 2-column layout for short metadata fields:
  - Row 1: `Prep time`, `Cook time`
  - Row 2: `Servings`

### Image upload area
- 16:9 box
- White surface with dashed or bordered drop zone look
- Placeholder icon plus short label:
  - `Add recipe photo`
  - `Optional, but helpful`

### Reusable widgets needed
- `ImageUploadBox`
- `AppTextField`
- `AppMultilineField`
- `SectionHeader`
- `StickyActionBar`
- `AppPrimaryButton`

### Recommended spacing
- Section-to-section gap: `24`
- Field gap: `16`
- Helper text gap: `8`

### Recommended states
- Blank form
- Form with image selected
- Validation errors
- Saving
- Save success feedback

### Responsive notes
- Use `SingleChildScrollView` plus safe-area bottom action bar
- Ensure keyboard does not cover save button
- Center content with max width `600` on larger devices

## 4.6 `RecipeDetailScreen`

### Purpose
Provide a calm, readable recipe view that works well during cooking.

### Layout sections
- App bar
- Hero image
- Recipe summary
- Ingredients section
- Instructions section

### Layout detail
- App bar:
  - Back button
  - Edit icon action
  - Overflow menu with delete
- Hero image:
  - Full-width, 16:9
  - Use placeholder if no image
- Summary block:
  - Recipe title
  - Optional description below title
  - Metadata chips row
- Ingredients section:
  - Section header
  - White card with one ingredient per row
- Instructions section:
  - Section header
  - White card with numbered steps
- Destructive action:
  - Delete should sit in overflow or bottom action sheet, not inline next to edit

### Reading comfort rules
- Use generous vertical spacing
- Maintain strong contrast
- Avoid dense dividers between every line unless content is long
- Give instructions enough line height for quick scanning

### Reusable widgets needed
- `RecipeHeroImage`
- `MetadataChip`
- `SectionHeader`
- `IngredientsCard`
- `InstructionStepList`
- `AppIconButton`
- `ConfirmActionSheet`

### Recommended spacing
- Image to summary: `20`
- Summary to ingredients: `24`
- Ingredients to instructions: `24`
- Step-to-step gap: `16`

### Recommended states
- Detail with image
- Detail without image
- Loading skeleton
- Error state
- Delete confirmation

### Responsive notes
- On tablets, cap content width and center it
- Keep text column readable and not overly wide

## 4.7 `EditRecipeScreen`

### Purpose
Same structure as add recipe, but optimized for updating existing recipes.

### Layout sections
- App bar
- Prefilled form
- Sticky bottom save area
- Destructive delete zone

### Layout detail
- App bar title: `Edit Recipe`
- Reuse the add form layout exactly
- All fields are prefilled
- Primary button label: `Save Changes`
- Delete action appears below the form as a separate destructive text button:
  - `Delete Recipe`
- Confirm delete in a bottom sheet before removing

### Reusable widgets needed
- Same widgets as `AddRecipeScreen`
- `ConfirmActionSheet`

### Recommended spacing
- Match add screen for consistency
- Add `24` before destructive section

### Recommended states
- Prefilled default
- Validation errors
- Saving
- Delete confirmation
- Unsaved changes warning on back

### Responsive notes
- Same as add screen
- Keep field order unchanged to reduce user confusion

## 4.8 `ProfilePlaceholderScreen`

### Purpose
Provide a very basic account page for MVP without implying a full settings product.

### Layout sections
- App bar
- User summary card
- Stats card
- Placeholder settings card
- Logout action

### Layout detail
- App bar title: `Profile`
- User summary card contains:
  - Initial/avatar circle
  - Name
  - Email
- Stats card contains:
  - `Recipes saved`
  - Numeric count
- Placeholder settings card contains non-interactive or soft-link rows:
  - `Account settings`
  - `More family features coming soon`
- Logout as a full-width secondary or text-destructive action at the bottom

### Reusable widgets needed
- `ProfileSummaryCard`
- `StatTile`
- `SettingsPlaceholderCard`
- `AppSecondaryButton`

### Recommended spacing
- Card-to-card gap: `16`
- Bottom action spacing: `24`

### Recommended states
- Loaded state
- Logging out

### Responsive notes
- Keep this screen simple
- Do not add tabs or advanced settings for MVP

## 4.9 `RecipeEmptyState`

### Purpose
Encourage first recipe creation when there is no content yet.

### Placement
- Use as the empty variant inside `HomeRecipeListScreen`

### Layout detail
- Keep home header and search field visible
- Replace recipe list with a centered empty state block
- Visual direction:
  - Soft illustration of a recipe card and small bowl/spoon icon
  - Or use a terracotta icon inside a rounded cream circle if illustration is not available
- Copy:
  - Title: `No recipes saved yet`
  - Supporting text: `Start with the dishes your family makes most often.`
- Actions:
  - Primary: `Add Your First Recipe`

### Reusable widgets needed
- `EmptyStateBlock`
- `AppPrimaryButton`

### Recommended spacing
- Empty graphic to title: `20`
- Title to body: `8`
- Body to CTA: `20`

### Recommended states
- First-time user empty only

### Responsive notes
- Keep the CTA above the fold on most devices
- Do not fill the entire page with illustration

## 4.10 `LoadingState`

### Purpose
Provide lightweight, non-distracting loading placeholders.

### Variant A: `HomeLoadingState`
- Header skeleton
- Search bar skeleton
- 4 recipe card skeletons

### Variant B: `RecipeDetailLoadingState`
- Hero image skeleton
- Title bar skeleton
- Metadata chip skeleton row
- Ingredient line skeletons
- Instruction block skeletons

### Style direction
- Use static skeletons or very subtle pulse only
- No shimmer-heavy animation for MVP
- Skeleton blocks should use warm neutral grays that match the palette

### Reusable widgets needed
- `SkeletonBlock`
- `SkeletonRecipeCard`
- `SkeletonChipRow`

### Recommended spacing
- Match the final loaded layout exactly

### Responsive notes
- Preserve overall layout structure to reduce content shift

## 4.11 `ErrorState`

### Purpose
Show friendly, practical recovery when data fails to load or an action fails.

### Layout detail
- Centered icon or simple illustration
- Title
- One short sentence of explanation
- Primary retry button
- Optional secondary action depending on context

### Suggested copy
- Title: `Something went wrong`
- Body: `We couldn't load your recipes right now. Please try again.`
- Primary action: `Try Again`
- Secondary action:
  - `Go Back` on detail
  - Omit on home if retry is enough

### Reusable widgets needed
- `StatusView`
- `AppPrimaryButton`
- `AppTextButton`

### Recommended states
- Full-page load error
- Inline action error banner for save/update failures

### Responsive notes
- Keep content centered and compact
- Avoid large, alarming error visuals

## 5. Component Library

| Component name | Purpose | Key anatomy | Main states |
| --- | --- | --- | --- |
| `AppPrimaryButton` | Main CTA | Label, optional leading icon | Default, pressed, disabled, loading |
| `AppSecondaryButton` | Secondary CTA | Label, optional icon | Default, pressed, disabled |
| `AppTextField` | Single-line input | Label, field, helper/error text | Default, focused, filled, error, disabled |
| `AppMultilineField` | Long-form input | Label, large text area, helper/error text | Default, focused, filled, error |
| `RecipeSearchField` | Search by title | Search icon, input, clear icon | Idle, focused, typing, filled |
| `RecipeCard` | Recipe list item | Thumbnail, title, subtitle, metadata chips | Default, pressed, image-missing |
| `MetadataChip` | Compact recipe metadata | Icon or text prefix, label | Default, soft highlighted |
| `ImageUploadBox` | Add recipe photo | Upload icon, label, optional preview | Empty, hover/tap, image selected, error |
| `EmptyStateBlock` | No content guidance | Graphic/icon, title, body, CTA | Default |
| `SectionHeader` | Content section label | Title, optional trailing action | Default |
| `AppIconButton` | Small utility action | Circular/rounded icon container | Default, pressed, disabled |
| `AddRecipeFab` | Fast add action on home | Plus icon, label | Default, pressed |
| `ConfirmActionSheet` | Safe destructive confirmation | Title, message, primary/secondary actions | Default |
| `StatusView` | Reusable loading/error/empty shell | Icon or illustration, title, body, action | Empty, loading, error |
| `StickyActionBar` | Bottom CTA area on forms | Surface, divider, button row | Default |

### Recommended component naming in Flutter
- `AppPrimaryButton`
- `AppSecondaryButton`
- `AppTextField`
- `AppMultilineField`
- `RecipeSearchField`
- `RecipeCard`
- `MetadataChip`
- `ImageUploadBox`
- `EmptyStateBlock`
- `SectionHeader`
- `AppIconButton`
- `AddRecipeFab`
- `ConfirmActionSheet`
- `StatusView`

## 6. UX Notes and Flutter Implementation Notes

### 6.1 General UX notes
- Keep recipe creation forgiving. Users should not feel forced into perfect structure.
- Searching should be instant and simple. Do not add filters beyond title search in MVP.
- Deleting a recipe should always require confirmation.
- Keep empty states encouraging, not overly cute.
- Use actual recipe images where available, otherwise use clean placeholders.

### 6.2 Flutter architecture notes

#### Design token structure
Create dedicated token files for:
- `app_colors.dart`
- `app_text_styles.dart`
- `app_spacing.dart`
- `app_radii.dart`
- `app_shadows.dart`

#### Shared widget structure
Create a reusable widget layer for:
- buttons
- text fields
- cards
- status views
- sheets

#### Theme recommendation
- Use Material 3 as a base
- Override color scheme with the warm palette above
- Keep surfaces flat and bright
- Disable dark mode for MVP

### 6.3 Navigation recommendation for Flutter
- Simplest MVP approach:
  - Root `AuthGate`
  - `Navigator` or `MaterialPageRoute` stack
- Recommended stack:
  - `SplashAuthCheckScreen`
  - `AuthScreen`
  - `HomeRecipeListScreen`
  - Push detail/add/edit/profile screens as needed

### 6.4 Form implementation notes
- Use `TextEditingController` for all fields
- Ingredients and instructions should be stored as multiline strings in the form layer
- On save, split by line breaks into arrays if the backend model prefers lists
- Validate required fields:
  - Title
  - Ingredients
  - Instructions

### 6.5 Search implementation notes
- Search only by recipe title in MVP
- If data is local or already fetched, filter in memory
- Add a light debounce only if needed
- Keep search UI on the home screen instead of pushing to a separate route

### 6.6 Image upload notes
- Use `image_picker` or equivalent
- Image source selection should open from a bottom sheet
- Keep photo optional in MVP
- Show selected image preview immediately in `ImageUploadBox`

### 6.7 Delete behavior notes
- Use a `ConfirmActionSheet`
- Show recipe title in the confirmation message when possible
- Example:
  - `Delete "Aloo Paratha"? This action can't be undone.`

### 6.8 Loading and error handling notes
- Prefer screen-specific loading placeholders rather than a global spinner for data screens
- Use full-page `StatusView` for load failures
- Use inline error text for form validation
- Use snackbars or banners for short action feedback like save success or delete success

### 6.9 Responsive mobile behavior notes
- Primary target width: `360` to `430`
- Support tablets by centering content with max width `600`
- Keep lists single-column for MVP
- Ensure bottom CTA bars respect safe areas
- All touch targets should be at least `44x44`

### 6.10 Data model implications from design
The design assumes each recipe can support:
- `id`
- `title`
- `description`
- `imageUrl` or local image path
- `ingredients` list
- `instructions` list
- `prepTimeMinutes`
- `cookTimeMinutes`
- `servings`
- `createdAt`
- `updatedAt`

No other fields are required for MVP UI.

## 7. Priority Order for Designing and Building

1. Design tokens and shared components
2. `SplashAuthCheckScreen`
3. `AuthScreen`
4. `HomeRecipeListScreen`
5. `RecipeEmptyState`
6. `HomeSearchState`
7. `AddRecipeScreen`
8. `RecipeDetailScreen`
9. `EditRecipeScreen`
10. `ProfilePlaceholderScreen`
11. `LoadingState`
12. `ErrorState`

## 8. Final MVP Scope Guardrails

### Include
- Login/signup
- Recipe list
- Search by title
- Add recipe manually
- Upload recipe image
- View recipe detail
- Edit recipe
- Delete recipe
- Basic profile placeholder

### Exclude
- Meal planning
- Grocery lists
- Subscriptions
- AI parsing
- WhatsApp integration
- Family sharing
- Admin panel
- Voice mode
- Nutrition
- Social features

### Final design recommendation
If implementation speed is the priority, keep the first Flutter pass intentionally plain:
- warm palette
- strong typography
- clean cards
- multiline recipe form
- single navigation stack

That combination will feel trustworthy and usable without overdesigning the MVP.
