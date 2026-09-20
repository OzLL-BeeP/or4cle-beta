// Scrape Roblox profile page
export async function scrapeProfile(browser, username) {
  const page = await browser.newPage();
  try {
    await page.goto(`https://www.roblox.com/users/profile?username=${username}`, {
      waitUntil: 'domcontentloaded',
      timeout: 30000
    });
    await page.waitForTimeout(3000);

    const data = await page.evaluate(() => {
      const getText = (sel) => document.querySelector(sel)?.textContent?.trim() || null;
      const getAttr = (sel, attr) => document.querySelector(sel)?.getAttribute(attr) || null;

      return {
        title: document.title,
        url: window.location.href,
        displayName: getText('.profile-name, .display-name'),
        description: getText('.profile-about-content, .profile-about'),
        joinDate: getText('.profile-join-date, .join-date'),
        friendCount: getText('.friends-count, .friend-count'),
        followerCount: getText('.followers-count'),
        followingCount: getText('.following-count'),
        avatarUrl: getAttr('.avatar-card-image img, .thumbnail-2d img', 'src'),
      };
    });

    return data;
  } finally {
    await page.close();
  }
}
