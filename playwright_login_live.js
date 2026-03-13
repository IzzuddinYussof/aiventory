const { firefox } = require('playwright');

(async () => {
  const baseUrl = process.env.AI_BASE_URL || 'http://127.0.0.1:8722';
  const keepOpen = (process.env.KEEP_OPEN ?? '1') === '1';

  const browser = await firefox.launch({ headless: false, slowMo: 120 });
  const context = await browser.newContext();
  const page = await context.newPage();
  page.setDefaultTimeout(20000);

  function locatorFromSelector(root, sel) {
    if (!sel || !sel.engine || !root) return null;
    switch (sel.engine) {
      case 'css': return root.locator(sel.value);
      case 'xpath': return root.locator(`xpath=${sel.value}`);
      case 'role':
        return sel.name
          ? root.getByRole(sel.role, { name: sel.name, exact: sel.exact ?? true })
          : root.getByRole(sel.role);
      default: return null;
    }
  }

  async function resolveLocator(selectors, timeoutMs = 30000) {
    const started = Date.now();
    while (Date.now() - started <= timeoutMs) {
      const roots = [page, ...page.frames()];
      for (const root of roots) {
        for (const selector of selectors) {
          const locator = locatorFromSelector(root, selector);
          if (!locator) continue;
          try {
            if (await locator.count()) return locator.first();
          } catch {}
        }
      }
      await page.waitForTimeout(250);
    }
    throw new Error(`Unable to resolve selectors: ${JSON.stringify(selectors)}`);
  }

  async function fillRobust(selectors, value) {
    const target = await resolveLocator(selectors);
    await target.scrollIntoViewIfNeeded().catch(() => {});
    await target.click({ force: true }).catch(() => {});
    await target.fill(value).catch(async () => {
      await target.click({ force: true }).catch(() => {});
      await target.press('Control+A').catch(() => {});
      await target.type(value, { delay: 20 }).catch(() => {});
    });
  }

  const loginUrl = `${baseUrl}/#/login`;
  console.log('Opening:', loginUrl);
  await page.goto(loginUrl, { waitUntil: 'domcontentloaded' });
  await page.waitForTimeout(2500);

  await page.screenshot({ path: 'C:/Users/User/.openclaw/media/screenshot/login-step-1-open.png', fullPage: true });

  // Flutter web sometimes gates semantics behind this button
  const enableA11y = page.getByRole('button', { name: /enable accessibility/i });
  if (await enableA11y.count()) {
    await enableA11y.first().click({ force: true }).catch(() => {});
    await page.waitForTimeout(1200);
  }

  await fillRobust([
    { engine: 'css', value: '#email' },
    { engine: 'css', value: 'input[name="email"]' },
    { engine: 'css', value: 'input[type="text"]' },
    { engine: 'role', role: 'textbox' },
    { engine: 'xpath', value: '/html/body/flutter-view/flt-text-editing-host/form[1]/input[1]' }
  ], 'izzuddinyussof@gmail.com');

  await fillRobust([
    { engine: 'css', value: '#current-password' },
    { engine: 'css', value: 'input[name="current-password"]' },
    { engine: 'css', value: 'input[type="password"]' },
    { engine: 'xpath', value: '/html/body/flutter-view/flt-text-editing-host/form[2]/input[1]' }
  ], 'odinsa');

  await page.screenshot({ path: 'C:/Users/User/.openclaw/media/screenshot/login-step-2-filled.png', fullPage: true });

  const submit = await resolveLocator([
    { engine: 'css', value: 'button[type="submit"]' },
    { engine: 'css', value: 'input[type="submit"]' },
    { engine: 'xpath', value: '/html/body/flutter-view/flt-text-editing-host/form[2]/input[2]' }
  ], 10000);

  await submit.click({ force: true }).catch(async () => {
    await page.keyboard.press('Enter').catch(() => {});
  });

  await page.waitForTimeout(5000);
  console.log('After submit URL:', page.url());
  await page.screenshot({ path: 'C:/Users/User/.openclaw/media/screenshot/login-step-3-after-submit.png', fullPage: true });

  if (keepOpen) {
    console.log('Keeping browser open for live session. Press Ctrl+C to stop script.');
    await new Promise(() => {});
  } else {
    await browser.close();
  }
})();