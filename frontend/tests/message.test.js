import { test, expect } from '@playwright/test';

test('backend message is rendered in frontend', async ({ page }) => {
    await page.goto('/');

    const messageText = page.getByText(
        "You've successfully integrated the backend!"
    );
    await expect(messageText).toBeVisible();
});
