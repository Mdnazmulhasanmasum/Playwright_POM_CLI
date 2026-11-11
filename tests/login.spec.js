import { test, expect } from '@playwright/test';
import { LoginPage } from '../pages/LoginPage';
import { InventoryPage } from '../pages/InventoryPage';
import users from '../data/users.json';

for (const { username, password, expected } of users) {
  test(`login ${username} / ${password} -> ${expected}`, async ({ page }) => {
    const loginPage = new LoginPage(page);
    const inventoryPage = new InventoryPage(page);

    await loginPage.goto();
    await loginPage.login(username, password);

    if (expected === 'success') {
      expect(await inventoryPage.isLoaded()).toBe(true);
      await expect(page).toHaveURL(/inventory\.html/);
    } else {
      const error = await loginPage.getErrorMessage();
      console.log(`  [${username}] error shown: "${error}"`);
      expect(error).not.toBe('');
      expect(await inventoryPage.isLoaded()).toBe(false);
    }
  });
}
