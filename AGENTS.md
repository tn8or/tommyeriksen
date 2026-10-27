# Agent guide: tommyeriksen

Hugo site for tommyeriksen.dk: personal blog plus About and CV pages, in English, theme m10c.

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

- Hugo 0.167.0 extended. The theme is a git submodule under `themes/`; clone with `--recurse-submodules`.
- Multi-stage `Dockerfile`: Hugo builds the site, nginx serves it (config in `nginx/`).
- Content: posts in `content/posts/`, page bundles for posts with images (`content/posts/<slug>/index.md` + images). TOML front matter (`+++`) with date, title, draft.
- Tags: every post gets exactly one series tag in `tags`: `ai-agents`, `careers`, `security`, `platform` or `motorcycles`. Optional topic tags on top, only where they clearly fit: `leadership`, `lessons-learned`, `ai-in-practice`. Example: `tags = ['security', 'lessons-learned']`. The scheme can be extended; a new tag gets a `content/tags/<tag>/_index.md` with its display title (otherwise Hugo shows the slug title-cased, e.g. "Ai-Agents"). The tag scheme is also documented in itsaplan (context doc 8).
- Front matter: every non-draft post needs `description` (max 155 chars), exactly one series tag and a valid `date`. `scripts/lint-front-matter.py` checks it in CI; the series list is `data/tags.toml`. Rules are in `README.md`.
- Images: `layouts/_default/_markup/render-image.html` serves page-bundle images resized (WebP, `srcset`, lazy) and links them to a full-size copy capped at 3000px (EXIF dropped); remote images, SVG and GIF render as a plain img. Posts have `build.publishResources = false` (cascade in `hugo.toml`), so raw bundle files are only published when a template uses them. `layouts/partials/_funcs/get-page-images.html` overrides Hugo's embedded partial so every page gets `og:image`/`twitter:image`: front matter `images` first (wider than 1200px becomes a 1200px JPEG), else a 1200x630 crop of the first bundle image in the body (anchor from front matter `ogAnchor`, default Smart), else `params.images` in `hugo.toml`. `baseof.html` adds `og:image:width`/`height`.
- Date-based publishing: `buildFuture = false`, `timeZone = 'Europe/Copenhagen'`. A future-dated post merged to `main` goes live with the scheduled morning build on its date (06:00 UTC: 08:00 Copenhagen in summer, 07:00 in winter).
- The footer shows the build commit.

## Build and deploy

- `hugo --minify` must succeed before pushing. CI also builds the container and smoke-tests it.
- The commit SHA is passed to Hugo as `HUGO_PARAMS_commit`.
- CI runs on a self-hosted runner. A push to `main`, the morning schedule (cron 06:00 UTC) and a manual run push `:latest`, which is what goes live. **Merging to `main` deploys tommyeriksen.dk.**
- PR builds pass `STAGING_URL` to the `Dockerfile`: baseURL `https://staging.tommyeriksen.dk/`, `--buildFuture`, and `params.staging` (noindex meta, `Disallow: /` in robots.txt). Only PRs from this repo with the `staging` label push `:staging`.
- Never push to `main` directly; work via PR.
- Renovate auto-merges Hugo, Docker image, Actions and submodule bumps. Keep the Hugo version in `Dockerfile` and `.github/workflows/ci.yml` in sync.
