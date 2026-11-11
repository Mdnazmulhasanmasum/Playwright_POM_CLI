export class InventoryPage {
  constructor(page) {
    this.page = page;
    this.title = page.getByTestId('title');
    this.inventoryList = page.getByTestId('inventory-list');
  }

  // True when the Products page with its product list is visible
  async isLoaded() {
    try {
      await this.inventoryList.waitFor({ state: 'visible', timeout: 5000 });
      return (await this.title.innerText()).trim() === 'Products';
    } catch {
      return false;
    }
  }
}
