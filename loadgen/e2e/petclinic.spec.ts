import { test, expect } from '@playwright/test';
import { LoremIpsum } from 'lorem-ipsum'; // Import LoremIpsum class

function generateRandomDate(): string {
  // Generate a random year between 2000 and 2025 (inclusive)
  const year = Math.floor(Math.random() * (2025 - 2000 + 1)) + 2000;

  // Generate a random month between 0 (January) and 11 (December)
  const month = Math.floor(Math.random() * 12);

  // Get the number of days in the generated month and year
  // Date(year, month + 1, 0) gives the last day of the month
  const date = new Date(year, month + 1, 0);
  const maxDay = date.getDate();

  // Generate a random day between 1 and maxDay
  const day = Math.floor(Math.random() * maxDay) + 1;

  // Format month and day to have leading zeros if necessary
  const formattedMonth = (month + 1).toString().padStart(2, '0');
  const formattedDay = day.toString().padStart(2, '0');

  return `${year}-${formattedMonth}-${formattedDay}`;
}

test('Petclinic LoadGen', async ({ page }) => {

  const lorem = new LoremIpsum({
    sentencesPerParagraph: {
      max: 8,
      min: 4
    },
    wordsPerSentence: {
      max: 16,
      min: 4
    }
  });
  const lorem_ipsum_text = lorem.generateWords(15);
  const MY_IP = process.env.MY_IP || 'localhost'
  // Get the base URL from an environment variable, default to a safe fallback
  const BASE_URL = 'http://' + MY_IP+':8080';
  console.log(`Navigating to: ${BASE_URL}`);
  await page.goto(BASE_URL);
  await page.getByRole('link').filter({ hasText: /^$/ }).click();
  await page.getByRole('link', { name: ' Home' }).click();
  await page.getByRole('link', { name: ' Find Owners' }).click();
  await page.getByRole('button', { name: 'Find Owner' }).click();
  await page.getByTitle('Next').click();
  await page.getByTitle('Last').click();
  await page.getByTitle('First').click();
  await page.getByRole('link', { name: ' Find Owners' }).click();
  await page.locator('#lastName').click();
  await page.locator('#lastName').fill('Franklin');
  await page.getByRole('button', { name: 'Find Owner' }).click();
  await page.getByRole('link', { name: 'Add Visit' }).click();
  await expect(page.getByRole('textbox', { name: 'Description' })).toBeVisible();
  let mydate = generateRandomDate();
  console.log(mydate);
  await page.getByRole('textbox', { name: 'Date' }).fill(mydate);
  await page.getByRole('textbox', { name: 'Date' }).press('Enter');
  await page.getByRole('textbox', { name: 'Description' }).click();
  await page.getByRole('textbox', { name: 'Description' }).fill(lorem_ipsum_text);
  console.log(lorem_ipsum_text);
  await page.getByRole('button', { name: 'Add Visit' }).click();
  await page.getByRole('link', { name: 'Add Visit' }).click();
  await page.getByRole('link', { name: ' Veterinarians' }).click();
  await page.getByRole('link', { name: '2' }).click();
  await page.getByRole('link', { name: '1' }).click();
});
 