# Agent guide: tommyeriksen

Hugo site for tommyeriksen.dk: personal blog plus About and CV pages, in English, theme Stack.

## How work is coordinated

Work on this repo is tracked in itsaplan project `WEBS` (MCP: https://itsaplan-api.tommyeriksen.dk/mcp), shared by Claude (label `claude`) and Cursor (label `cursor`). At the start of a session, read the WEBS doc **"Agent coordination rules"** and follow it; it wins if it differs from this file.

- Knowledge lives only in this repo (code-level docs: this file, plus a `docs/` folder if one is added) or in itsaplan (tasks, plans, decisions, notes). Never only in an agent's local memory, scratch files or chat.
- All work has a WEBS issue. Create one first if none exists.
- Only take `unstarted` issues carrying your own label. Claim by re-reading the issue and moving it to `started`. An issue in `started` is owned; leave it alone.
- When blocked on anything (Tommy, a review, another issue, CI), add the label `waiting` and comment "Waiting on: who/what, and what exactly is needed". Remove it when unblocked.
- Notes, findings and questions go as comments on the issue.
- One issue gives one branch and one PR. Branch names, PR titles and commits start with `WEBS-N`.
- Done → `completed`, abandoned → `canceled`. Never leave an issue `started` after stopping.

## The site

- Hugo extended, version pinned only in `.github/workflows/ci.yml` (`hugo-version`, bumped by Renovate). The theme is a git submodule under `themes/`; clone with `--recurse-submodules`.
- Hosting: Cloudflare Workers static assets (`wrangler.jsonc`). CI builds Hugo into `public/` and deploys it with wrangler; `worker/index.js` runs in front of every request (`run_worker_first`) and does what nginx used to: Markdown negotiation (`Accept: text/markdown` gets the page's `index.md`), `text/markdown; charset=utf-8`, `Vary: Accept`, `Cache-Control: private, no-cache` on pages, HSTS and CSP on every response, and www → apex (the zone's redirect rule normally answers www first). Missing pages get Hugo's `404.html`. Hostnames are Workers routes managed by `scripts/cloudflare-cutover.sh` (status, route, dns, rollback), not by wrangler, so the CI token only needs Workers Scripts edit rights.
- Content: posts in `content/posts/`, page bundles for posts with images (`content/posts/<slug>/index.md` + images). TOML front matter (`+++`) with date, title, draft.
- Tags: every post gets exactly one series tag in `tags`: `ai-agents`, `careers`, `security`, `platform` or `motorcycles`. Optional topic tags on top, only where they clearly fit: `leadership`, `lessons-learned`, `ai-in-practice`. Example: `tags = ['security', 'lessons-learned']`. The scheme can be extended; a new tag gets a `content/tags/<tag>/_index.md` with its display title (otherwise Hugo shows the slug title-cased, e.g. "Ai-Agents"). The tag scheme is also documented in itsaplan (context doc 8).
- Front matter: every non-draft post needs `description` (max 155 chars), exactly one series tag and a valid `date`. `scripts/lint-front-matter.py` checks it in CI; the series list is `data/tags.toml`. Rules are in `README.md`.
- Images: `layouts/_default/_markup/render-image.html` serves page-bundle images resized (WebP, `srcset`, lazy) and links them to a full-size copy capped at 3000px (EXIF dropped); remote images, SVG and GIF render as a plain img. Posts have `build.publishResources = false` (cascade in `hugo.toml`), so raw bundle files are only published when a template uses them. `layouts/partials/_funcs/get-page-images.html` overrides Hugo's embedded partial so every page gets `og:image`/`twitter:image`: front matter `images` first (wider than 1200px becomes a 1200px JPEG), else a 1200x630 crop of the first bundle image in the body (anchor from front matter `ogAnchor`, default Smart), else `params.images` in `hugo.toml`. `layouts/_partials/head/custom.html` adds `og:image:width`/`height` and staging noindex metadata.
- Search and sharing metadata: `layouts/_partials/data/title.html` puts the author's name in every `<title>`/og:title (home uses `params.seo.homeTitle`); `layouts/_partials/data/description.html` picks the meta description (front matter `description`, generated text for tag pages, post summary, else `params.description`). `layouts/_partials/head/opengraph/provider/{base,twitter}.html` are copies of Stack's that take og:image/twitter:image from `get-page-images` (Stack's own only reads `.Params.image`) and pick `summary_large_image` only for wide images. `layouts/_partials/head/custom.html` emits schema.org JSON-LD: Person (from `params.seo` and `menu.social` as sameAs) on home, About and CV, BlogPosting on posts. Only the `tags` taxonomy is enabled.
- Date-based publishing: `buildFuture = false`, `timeZone = 'Europe/Copenhagen'`. A future-dated post merged to `main` goes live with the scheduled morning build on its date (06:00 UTC: 08:00 Copenhagen in summer, 07:00 in winter).
- The footer shows the build commit.

## Build and deploy

- `hugo --minify` must succeed before pushing. CI also smoke-tests every build through the Worker with `wrangler dev` (`scripts/smoke-test.sh production|staging`).
- The commit SHA is passed to Hugo as `HUGO_PARAMS_commit`.
- CI runs on a self-hosted runner. A push to `main`, the morning schedule (cron 06:00 UTC) and a manual run on `main` deploy production (Worker `tommyeriksen`) and a staging build of `main` with future-dated posts (Worker `tommyeriksen-staging`). **Merging to `main` deploys tommyeriksen.dk.** A manual run on another branch deploys that branch to staging. PRs only build and smoke-test, since agents open PRs as the repo owner (HOME-33).
- Staging builds (PRs, manual runs on other branches, and a second build of every `main` run) use baseURL `https://staging.tommyeriksen.dk/`, `--buildFuture`, and `params.staging` (noindex meta, `Disallow: /` in robots.txt).
- The Cloudflare token (`CLOUDFLARE_API_TOKEN`) lives in two GitHub environments and is only used by the `deploy` job: `cloudflare` (main only) and `cloudflare-staging` (any branch, requires Tommy's approval). The build job uploads the tested `out/production` and `out/staging`; the deploy job deploys exactly those.
- Never push to `main` directly; work via PR.
- Renovate auto-merges Hugo, wrangler (`WRANGLER_VERSION` in `ci.yml`), Actions and submodule bumps.
