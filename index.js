// const puppeteer = require("puppeteer-extra");
// const RecaptchaPlugin = require("puppeteer-extra-plugin-recaptcha");
// puppeteer.use(
//   RecaptchaPlugin({
//     provider: {
//       id: "2captcha",
//       token: "xxx",
//     },
//     visualFeedback: true,
//   })
// );
// const StealthPlugin = require("puppeteer-extra-plugin-stealth");
// puppeteer.use(StealthPlugin());
// const run_script = (positionOffset) => {
//   return {
//     next: document.querySelector("#pnnext")?.getAttribute("href"),
//     serp_url: document.location.href,
//     search_results: [
//       ...document.querySelectorAll("#search > div > div > div"),
//     ].map((article, index) => ({
//       site_name:
//         article
//           .querySelector(
//             "div > div > div > div > div > div > div > div > div > div > div > div > div > div > div > div > div > div > div"
//           )
//           ?.textContent?.trim() || "N/A",
//       url:
//         article
//           .querySelector(
//             "div > div > div > div > div > div > div > div > div > div > div > div > div > div > span > a"
//           )
//           ?.getAttribute("href") || "N/A",
//       title:
//         article
//           .querySelector(
//             "div > div > div > div > div > div > div > div > div > div > div > div > div > div > span > a > h3"
//           )
//           ?.textContent?.trim() || "N/A",
//       description:
//         article
//           .querySelectorAll(
//             "div > div > div > div > div > div > div > div > div > div > div"
//           )
//           [
//             article.querySelectorAll(
//               "div > div > div > div > div > div > div > div > div > div > div"
//             ).length - 1
//           ]?.textContent?.trim() || "N/A",
//       position: positionOffset + index + 1,
//     })),
//   };
// };
// (async () => {
//   const browser = await puppeteer.launch({
//     headless: false,
//     slowMo: 50,
//   });
//   const page = await browser.newPage();
//   await page.goto("https://www.google.com/");
//   await page.click("#L2AGLb");
//   await page.type("textarea", "arioz");
//   await page.keyboard.press("Enter");
//   await page.waitForSelector("iframe");
//   const { captchas, filtered, solutions, solved, error } =
//     await page.solveRecaptchas();
//   await page.waitForNavigation();
//   const results = [];
//   let positionOffset = 0;
//   while (true) {
//     const data = await page.evaluate(run_script, positionOffset);
//     results.push(data);
//     positionOffset += data.search_results.length;
//     if (!data.next || positionOffset / 10 >= 3) {
//       break;
//     }
//     await page.goto("https://www.google.com" + data.next);
//   }
//   console.log(JSON.stringify(results));
//   await browser.close();
// })();

// const { chromium } = require("playwright-extra");
// const stealth = require("puppeteer-extra-plugin-stealth")();
// chromium.use(stealth);
// const run_script = (positionOffset) => {
//   try {
//     return {
//       next: document.querySelector("a.next")?.getAttribute("href"),
//       serp_url: document.location.href,
//       search_results: [...document.querySelectorAll("div > ol > li")]
//         .slice(3)
//         .map((article, index) => ({
//           site_name:
//             article.querySelector("div > div > span")?.textContent?.trim() ||
//             "N/A",
//           url:
//             article.querySelector("div > div > h3 > a")?.getAttribute("href") ||
//             "N/A",
//           title:
//             article.querySelector("div > div > h3 > a")?.textContent?.trim() ||
//             "N/A",
//           description:
//             article.querySelector("div > div > p")?.textContent?.trim() ||
//             "N/A",
//           position: positionOffset + index + 1,
//         })),
//     };
//   } catch (error) {
//     console.log(error);
//   }
// };
// (async () => {
//   const browser = await chromium.launch({ headless: false });
//   const page = await browser.newPage();
//   await page.goto("https://search.yahoo.com/search?p=arioz");
//   await page.click(".accept-all");
//   await page.waitForSelector("div > ol > li", { timeout: 5000 });
//   const results = [];
//   let positionOffset = 0;
//   try {
//     do {
//       const data = await page.evaluate(run_script, positionOffset);
//       results.push(data);
//       positionOffset += data.search_results.length;
//       if (!data.next || positionOffset / 10 >= 6) {
//         break;
//       }
//       await page.goto(data.next);
//       await page.waitForSelector("div > ol > li", { timeout: 5000 });
//     } while (true);
//   } catch (e) {
//     console.log(e);
//   }
//   console.log(JSON.stringify(results));
//   await browser.close();
// })();

const { chromium } = require("playwright-extra");
const stealth = require("puppeteer-extra-plugin-stealth")();
chromium.use(stealth);
(async () => {
  const browser = await chromium.launch({ headless: false });
  const page = await browser.newPage();
  await page.goto("https://twitter.com/i/flow/login");
  await page.fill("input[name='text']", "");
  await page.keyboard.press("Enter");
  await page.waitForSelector("input[name='password']");
  await page.fill("input[name='password']", "");
  await page.keyboard.press("Enter");
  await page.waitForSelector('[role="combobox"]');
  await page.fill('[role="combobox"]', "ruby");
  await page.keyboard.press("Enter");
  await page.waitForTimeout(2000);
  let i = 0;
  do {
    await page.mouse.wheel(0, 1000);
    await page.waitForTimeout(250);
    i += 1;
  } while (i < 5);
  const links = await page.evaluate(() => {
    return [
      ...new Set(
        Array.from(
          document.querySelectorAll('article a[href*="/status/"]')
        ).map(
          (a) =>
            "https://twitter.com" +
            a.getAttribute("href").split("/status/")[0] +
            "/status/" +
            a.getAttribute("href").split("/status/")[1].split("/")[0]
        )
      ),
    ];
  });
  for (const link of links) {
    try {
      await page.goto(link);
      const textArea = await page.waitForSelector('[data-contents="true"]');
      await textArea.click();
      await textArea.fill("try fetchserp.com with 2500 free credits");
      const tweetButton = await page.waitForSelector(
        '[data-testid="tweetButtonInline"]'
      );
      await tweetButton.click();
    } catch (error) {
      console.log(error);
    }
  }
  console.log(links);
  await browser.close();
})();
