# Playwright_POM_CLI

Playwright + JavaScript Page Object Model framework testing the login on https://www.saucedemo.com.

## Structure
- `pages/` – page objects (`LoginPage.js`, `InventoryPage.js`)
- `tests/` – `login.spec.js` (data-driven login test)
- `data/` – `users.json` (test data: 1 success case, 2 error cases)

## Run
```
npm install
npx playwright install chromium
npm run test:login
```
Expected result: 3 passed (1 successful login, 2 login errors).
