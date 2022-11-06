# Tenzer.dk

This is the source code for my personal website and blog.

In order to make a production build of the site you need to have [Hugo](https://gohugo.io/) and [SassC](https://github.com/sass/sassc) installed and on your path.
Then you can run `just build` which takes care building the static site and optimize it.

If you want to work on testing out changes before building the site,
a local webserver with live reload can be started by running `just serve`.

`just` and `just --list` can be used to list all available just commands.
