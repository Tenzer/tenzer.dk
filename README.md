# Tenzer.dk

This is the source code for my personal website and blog.

In order to make a production build of the site you need to have
[Hugo](https://gohugo.io/) and [SassC](https://github.com/sass/sassc) installed
and on your path. Then you can run `make dist` which takes care of converting
SCSS to CSS, building the static sites and optimize it all with
[AssetGraph](http://assetgraph.org/) through [Docker](https://www.docker.com/).

If you want to work on testing out changes before building the site, a local
webserver with live reload can be started by running `make serve`. If changes
are made to the SCSS file you can either re-run the `make serve` command or run
`make sass` to only run that specific step.

`make` and `make help` can be used to list all available make commands.
