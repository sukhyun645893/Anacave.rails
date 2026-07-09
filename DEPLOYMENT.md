# Deployment Notes

## Recommended First Deployment: Render

For the first real launch, the easiest path is:

1. Push this `community` Rails app to GitHub.
2. Create a PostgreSQL database on Render.
3. Create a Render Web Service from the GitHub repository.
4. Set the web service root directory to `community` if your GitHub repository contains the parent `new-chat` folder.
5. Use these commands on Render:

```bash
Build Command: bash bin/render-build.sh
Start Command: bin/rails server
```

6. Add these environment variables to the Render Web Service:

```bash
RAILS_ENV=production
RAILS_MASTER_KEY=<config/master.key value>
DATABASE_URL=<Render Postgres internal database URL>
APP_HOST=<your-render-name>.onrender.com
WEB_CONCURRENCY=2
```

7. For HTTPS/custom domain later:

```bash
APP_HOST=your-domain.com
RAILS_ASSUME_SSL=true
RAILS_FORCE_SSL=true
```

8. For uploaded images and anacons, use object storage before opening the service publicly:

```bash
ACTIVE_STORAGE_SERVICE=cloudflare_r2
R2_ACCESS_KEY_ID=...
R2_SECRET_ACCESS_KEY=...
R2_BUCKET=...
R2_ENDPOINT=https://ACCOUNT_ID.r2.cloudflarestorage.com
```

If you skip external storage, uploaded images may depend on the server filesystem and can be lost or become hard to move when the app is redeployed or scaled.

## Deployment Checklist

- [ ] Commit the latest code.
- [ ] Push to GitHub.
- [ ] Create a production PostgreSQL database.
- [ ] Set `DATABASE_URL`.
- [ ] Set `RAILS_MASTER_KEY`.
- [ ] Set `APP_HOST`.
- [ ] Configure external image storage such as Cloudflare R2 or AWS S3.
- [ ] Deploy.
- [ ] Open `/up` to confirm the app is healthy.
- [ ] Create the first admin account or promote your account to admin from Rails console.
- [ ] Test signup, login, post writing, comments, image upload, anacon upload, and admin approval.
- [ ] Connect a domain and turn on HTTPS settings.

## Admin Account After Deploy

After creating your own account on the deployed site, open the Rails console on the server and run:

```ruby
User.find_by!(username: "your_username").update!(admin: true)
```

Do not expose the Rails console or database admin screen to the public internet.

This app is configured for production-style deployment with:

- Rails 8
- PostgreSQL through `DATABASE_URL`
- Active Storage on local disk, AWS S3, or Cloudflare R2
- Docker/Kamal-ready production image

## 1. PostgreSQL

Create a PostgreSQL database from a provider such as Render, Railway, Supabase, Neon, Fly Postgres, or a VPS.

Set:

```bash
DATABASE_URL=postgres://USER:PASSWORD@HOST:5432/community_production
```

For local development, install PostgreSQL and create:

```bash
createdb community_development
createdb community_test
```

Then run:

```bash
bin/rails db:prepare
bin/rails test
```

If Docker is available locally, you can start PostgreSQL with:

```bash
docker compose up -d postgres
```

Then set:

```bash
POSTGRES_HOST=localhost
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=community_development
POSTGRES_TEST_DB=community_test
POSTGRES_PORT=55432
```

## 2. Upload Storage

For production uploads, use object storage.

Cloudflare R2:

```bash
ACTIVE_STORAGE_SERVICE=cloudflare_r2
R2_ACCESS_KEY_ID=...
R2_SECRET_ACCESS_KEY=...
R2_BUCKET=...
R2_ENDPOINT=https://ACCOUNT_ID.r2.cloudflarestorage.com
```

AWS S3:

```bash
ACTIVE_STORAGE_SERVICE=amazon
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=ap-northeast-2
AWS_BUCKET=...
```

## 3. Docker

Build:

```bash
docker build -t community .
```

Run:

```bash
docker run -p 80:80 \
  -e RAILS_MASTER_KEY=... \
  -e DATABASE_URL=... \
  -e APP_HOST=example.com \
  community
```

## 4. Kamal

Edit `config/deploy.yml`:

- `image`
- `servers.web`
- `registry.server`
- `registry.username`
- `APP_HOST`
- `ACTIVE_STORAGE_SERVICE`

Export secrets locally before deployment:

```bash
set DATABASE_URL=postgres://USER:PASSWORD@HOST:5432/community_production
set RAILS_MASTER_KEY=<config/master.key value>
set R2_ACCESS_KEY_ID=...
set R2_SECRET_ACCESS_KEY=...
```

Deploy:

```bash
bin/kamal setup
bin/kamal deploy
```

## 5. Domain and HTTPS

Point your domain DNS to the server/load balancer, then set:

```bash
APP_HOST=your-domain.com
RAILS_ASSUME_SSL=true
RAILS_FORCE_SSL=true
```

If using Kamal proxy SSL, enable `proxy.ssl` and set `proxy.host` in `config/deploy.yml`.
