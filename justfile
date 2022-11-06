_default:
    @just --list

# Serve the site directly on http://localhost:1313/
serve:
    @hugo server

# Generate the site
build:
    @hugo \
        --cleanDestinationDir \
        --gc \
        --minify

# Deploy the site to Cloudflare
deploy:
    @wrangler publish
