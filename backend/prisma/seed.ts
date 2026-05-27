import * as bcrypt from 'bcrypt';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const passwordHash = await bcrypt.hash('Password123!', 10);

  const demoUser = await prisma.user.upsert({
    where: { email: 'demo@familyrecipe.app' },
    update: {
      name: 'Anita Sharma',
      passwordHash,
    },
    create: {
      email: 'demo@familyrecipe.app',
      name: 'Anita Sharma',
      passwordHash,
    },
  });

  await prisma.recipe.deleteMany({
    where: { userId: demoUser.id },
  });

  await prisma.recipe.createMany({
    data: [
      {
        userId: demoUser.id,
        title: 'Aloo Paratha',
        description:
          'Soft, comforting stuffed parathas that always showed up on slow Sunday mornings.',
        ingredients:
          '2 cups whole wheat flour\n3 medium potatoes, boiled and mashed\n1 green chili, finely chopped\n1 tsp cumin seeds\n1 tsp red chili powder\n2 tbsp chopped coriander\nSalt to taste\nGhee for roasting',
        instructions:
          'Knead the flour with water and a pinch of salt into a soft dough.\nMix potatoes with chili, cumin, chili powder, coriander, and salt.\nDivide the dough and stuffing into equal portions.\nStuff each dough ball, roll gently, and cook on a hot tawa.\nApply ghee on both sides until golden brown.\nServe hot with curd or pickle.',
        prepTime: 20,
        cookTime: 18,
        servings: 4,
        difficulty: 'Easy',
        cuisine: 'North Indian',
        imageUrl: null,
      },
      {
        userId: demoUser.id,
        title: 'Tomato Rasam',
        description:
          'A light, peppery rasam recipe passed down for rainy evenings and upset stomach days.',
        ingredients:
          '3 ripe tomatoes, chopped\n2 cups water\n2 garlic cloves, crushed\n1 tsp black pepper\n1 tsp cumin\n1 tbsp tamarind pulp\nA pinch of turmeric\nSalt to taste\n1 tsp mustard seeds\n8 curry leaves\n1 tsp ghee',
        instructions:
          'Crush pepper and cumin coarsely.\nBoil tomatoes with water, garlic, turmeric, salt, and tamarind pulp.\nMash lightly once the tomatoes soften.\nAdd the crushed pepper-cumin mix and simmer briefly.\nTemper mustard seeds and curry leaves in ghee.\nPour the tempering over the rasam and serve warm.',
        prepTime: 10,
        cookTime: 15,
        servings: 3,
        difficulty: 'Easy',
        cuisine: 'South Indian',
        imageUrl: null,
      },
      {
        userId: demoUser.id,
        title: 'Mango Pickle',
        description:
          'Bold, tangy mango achar made the way it was stored in ceramic jars every summer.',
        ingredients:
          '4 raw mangoes, chopped\n3 tbsp red chili powder\n2 tbsp mustard powder\n1 tbsp turmeric powder\n2 tbsp salt\n1 cup sesame oil\n1 tsp fenugreek seeds',
        instructions:
          'Wash and dry the mango pieces fully before mixing.\nCombine mangoes with chili powder, mustard powder, turmeric, and salt.\nHeat the oil lightly and let it cool.\nStir the oil into the mango mixture until coated.\nAdd roasted fenugreek seeds.\nStore in a clean jar and rest for 2 to 3 days before serving.',
        prepTime: 25,
        cookTime: 10,
        servings: 12,
        difficulty: 'Medium',
        cuisine: 'Indian',
        imageUrl: null,
      },
    ],
  });

  console.log('Seeded Family Recipe App demo data.');
  console.log('Email: demo@familyrecipe.app');
  console.log('Password: Password123!');
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
