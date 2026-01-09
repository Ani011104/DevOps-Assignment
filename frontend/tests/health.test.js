import { test, expect } from '@playwright/test';

test('backend health status is shown in UI', async ({ page }) => {
    await page.goto('/');

    const statusText = page.getByText('Backend is connected!');
    await expect(statusText).toBeVisible();
});
