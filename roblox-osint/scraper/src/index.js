#!/usr/bin/env node
// ROBLOX-OSINT Scraper — CLI entry
import { chromium, firefox } from 'playwright';
import { Command } from 'commander';
import { scrapeProfile } from './profile.js';
import os from 'os';

const CHROMIUM_PATHS = [
  process.env.CHROMIUM_PATH,
  '/data/data/com.termux/files/usr/bin/chromium-browser',
  '/usr/bin/chromium',
  '/usr/bin/chromium-browser',
  '/usr/bin/google-chrome',
].filter(Boolean);

const program = new Command();
program
  .name('scraper')
  .argument('<username>', 'Roblox username')
  .option('-b, --browser <type>', 'chromium or firefox', 'chromium')
  .option('-h, --headless', 'headless mode', true)
  .option('--timeout <ms>', 'timeout in ms', '30000')
  .parse();

const opts = program.opts();
const username = program.args[0];

async function findExecutable() {
  const fs = await import('fs');
  for (const p of CHROMIUM_PATHS) {
    if (fs.existsSync(p)) return p;
  }
  return null;
}

async function main() {
  const browserType = opts.browser === 'firefox' ? firefox : chromium;
  const launchOpts = {
    headless: opts.headless,
    args: [
      '--no-sandbox',
      '--disable-gpu',
      '--disable-dev-shm-usage',
      '--single-process',
    ],
  };

  if (opts.browser === 'chromium') {
    const exe = await findExecutable();
    if (exe) launchOpts.executablePath = exe;
  }

  const browser = await browserType.launch(launchOpts);

  try {
    const data = await scrapeProfile(browser, username);
    console.log(JSON.stringify({ ok: true, data }, null, 2));
  } catch (err) {
    console.log(JSON.stringify({ ok: false, error: err.message }));
    process.exit(1);
  } finally {
    await browser.close();
  }
}

main();
