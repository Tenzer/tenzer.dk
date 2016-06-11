.PHONY: serve dist sass clean build optimize

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
	@hugo --disable404
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
