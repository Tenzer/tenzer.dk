.PHONY: help serve dist sass clean build optimize

PYGMENTS := $(shell command -v pygmentize 2> /dev/null)

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
ifndef PYGMENTS
	$(error "Pygments was not found, please make it available in $$PATH")
endif
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
		/site/unoptimized/images/logo.png \
		/site/unoptimized/index.html \
		/site/unoptimized/index.xml \
		/site/unoptimized/keybase.txt \
		/site/unoptimized/robots.txt \
		/site/unoptimized/sitemap.xml
	@echo '==> AssetGraph build done'
