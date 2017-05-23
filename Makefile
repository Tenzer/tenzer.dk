.PHONY: serve dist sass clean build optimize

PYGMENTS := $(shell command -v pygmentize 2> /dev/null)

serve: sass
	@hugo server

.PHONY: dist
dist: sass clean build optimize

sass:
	@sassc --style compact static/css/style.scss static/css/style.css
	@echo '==> SASS build done'

clean:
	@rm -rf out/
	@echo '==> Output folder removed'

build:
ifndef PYGMENTS
	$(error "Pygments was not found, please make it available in $$PATH")
endif
	@hugo
	@echo '==> Hugo build done'

optimize:
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
