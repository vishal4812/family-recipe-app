# Family Cookbook Design Plan

## Product direction

This is not a generic food-discovery app. It is a private, warm digital cookbook for preserving and sharing family recipes, the people behind them, and the memories attached to them.

The product should feel like opening a loved family recipe book: personal, trusted, useful in the kitchen, and worth keeping for years.

## Primary visual reference

Use [Cook It, Eat It UI Kit](https://www.figma.com/design/VOnmtkekAX6Pq3Q08ctKkm/Recipe-App--Cook-it-Eat-it--UI-Kit--Community-?node-id=4-2) as the main structural reference.

Use its strengths:

- clear mobile recipe browsing;
- strong recipe photography and card hierarchy;
- category chips and bottom navigation;
- recipe-detail layout; and
- profile-led content presentation.

Do not copy its branding, assets, copy, or exact screens. It is inspiration only.

## Family cookbook adaptation

| Cook It, Eat It pattern | Family Recipe App version |
| --- | --- |
| Trending today | Family favourites / Made this week |
| Categories | Family collections: Grandma's recipes, Sunday lunch, festivals, childhood favourites |
| Verified chefs | Family cooks: Mom, Dad, Grandma, Aunt, and friends |
| Generic profile | Family cookbook profile and contributor history |
| Food discovery | Recipe preservation, stories, and practical cooking |
| Bright social-app look | Warm, calm, keepsake cookbook feel |

## Visual language

- **Palette:** cream or warm paper background, deep cocoa text, muted terracotta/coral as the action color, and sage/olive supporting tones.
- **Typography:** clear modern sans-serif for reading and controls; use one restrained handwritten accent only for recipe titles, signatures, or memory notes.
- **Photography:** large, inviting food photos; use soft corners and a subtle paper or scrapbook-card treatment.
- **Spacing:** generous and calm. The screen must remain fast to scan while cooking.
- **Icons:** simple outlined icons; avoid overly playful or cluttered decoration.

## Core content model

Every recipe should be able to carry more than ingredients and steps:

- recipe title and photo;
- family collection;
- contributor, for example “From Grandma Meera”;
- occasion, for example “Diwali” or “Sunday lunch”;
- a short memory or family note;
- ingredients and cooking method; and
- optional photo scan of the original handwritten recipe.

## Design order

1. **Home / cookbook shelf**
   - Personal greeting and a family-cookbook message.
   - Featured family recipe.
   - Collection chips and a “From our family” section.
   - Clear search and add-recipe entry points.

2. **Recipe cards and collection browsing**
   - Large image, recipe title, collection, and contributor.
   - Make the collection feel like a cookbook chapter, not a generic filter.

3. **Recipe detail**
   - Hero photo, contributor, memory note, ingredients, and method.
   - Make the recipe easy to use one-handed while cooking.

4. **Add / edit recipe**
   - Keep the existing reliable form flow.
   - Add supportive family fields gradually: contributor, occasion, and memory.

5. **Recipe Photo Scanner**
   - Clearly present this as “Save an old family recipe.”
   - Scan image → editable draft → preserve the original photo alongside it.

6. **Profile and family contributors**
   - Replace generic account emphasis with cookbook ownership, contributors, and recipe history.

## Implementation rules

- Preserve the existing tested navigation, validations, and Android safe-area behavior.
- Improve the visual layer screen by screen; do not replace working flows in one large rewrite.
- Use original app copy, images, icons, and colors. Do not ship reference-kit assets.
- Check accessibility: readable contrast, large touch targets, and text that remains legible with larger phone font settings.

## First design milestone

The first milestone is complete when Home, recipe cards, and recipe details share the new family-cookbook visual language while all existing recipe creation, editing, search, collections, and settings flows still work.
