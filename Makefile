.PHONY: help serve dist sass clean build optimize

help:  ## Show help output
	# Tip from https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

serve: sass  ## Serve the site directly on http://localhost:1313/
	@hugo server

dist: sass clean build optimize  ## Build the final, optimized site

sass:  ## Convert SASS style sheet to CSS
	@sassc --style compact static/css/style.scss static/css/style.css
	@echo '==> SASS build done'

clean:  ## Clean output folder
	@rm -rf out/
	@echo '==> Output folder removed'

build:  ## Generate the site
	@hugo
	@echo '==> Hugo build done'

optimize:  ## Optimize site with AssetGraph
	@docker run \
		--interactive \
		--tty \
		--rm \
		--volume="$(shell pwd)"/out:/site \
		assetgraph/assetgraph-builder \
		--root /site/unoptimized \
		--outroot /site/optimized \
		--stoponwarning \
		--subresourceintegrity \
		--optimizeimages \
		--inlinehtmlstyle false \
		/site/unoptimized/images/logo.png \
		/site/unoptimized/index.html \
		/site/unoptimized/index.xml \
		/site/unoptimized/404.html \
		/site/unoptimized/keybase.txt \
		/site/unoptimized/robots.txt \
		/site/unoptimized/sitemap.xml
	@echo '==> AssetGraph build done'

deploy:  ## Deploy the site to Google Cloud Storage
	@gsutil -m rsync -rJ out/optimized/ gs://tenzer.dk/
