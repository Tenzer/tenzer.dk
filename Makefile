.PHONY: serve dist sass clean build optimize
serve:
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
		/site/unoptimized/index.html \
		--root /site/unoptimized \
		--outroot /site/optimized
	@echo '==> AssetGraph build done'
