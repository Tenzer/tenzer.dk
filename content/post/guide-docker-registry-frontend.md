+++
date = "2015-01-17"
title = "Guide: Docker Registry Frontend"
+++

If you have your own [private Docker registry]({{< relref "post/guide-private-docker-registry.md" >}}) you might be wanting some kind of frontend for it, as `docker search [...]` can only get you so far in regards to getting an overview of what the registry contains. Fortunately all the information you might want about the registry contents can be aquired through the [REST API](https://docs.docker.com/reference/api/registry_api/), making it possible to present the data neatly on a website.

Konrad Kleine has made the [docker-registry-frontend](https://github.com/kwk/docker-registry-frontend) project to do just that. It's a client-only AngularJS based web app which calls the Docker registry API directly and serves it up in a neat web interface ([screenshots here](https://github.com/kwk/docker-registry-frontend/wiki/Features)).

While he does provide a [Dockerfile](https://github.com/kwk/docker-registry-frontend/blob/master/Dockerfile) which builds and run the interface, I would rather just serve the files via the Nginx server which already run in front of the registry.

I am going to presume you have set up a private registry like described in [my guide]({{< relref "post/guide-private-docker-registry.md" >}}). First you have to install the dependencies we need; Git for getting the code and Node.js + NPM for building it. We also make a symlink to the Node.js executable so it can be called with just `node` as some NPM packages' install scripts rely on that:

{{< highlight shell >}}
sudo apt-get install git nodejs npm
sudo ln -s /usr/bin/nodejs /usr/local/bin/node
{{< /highlight >}}

Then switch to the Docker user and clone the Git repository into a folder called `frontend`:

{{< highlight shell >}}
sudo su - docker
git clone https://github.com/kwk/docker-registry-frontend.git frontend
{{< /highlight >}}

Then enter the folder, install the Node.js and Bower packages and then build the site with Grunt:

{{< highlight shell >}}
cd frontend/
npm install
node_modules/.bin/bower install
node_modules/.bin/grunt build
{{< /highlight >}}

The build files are then available inside the `/home/docker/frontend/dist/` folder. Before the site can be served we have to copy and adjust two JSON files containing some metadata the frontend need. The first one, `app-version.json`, can be generated like this:

{{< highlight shell >}}
echo '{
    "git": {
        "sha1": "'$(git log --pretty=format:%h -n 1)'",
        "ref": "'$(git branch | cut -c 3-)'"
    }
}' > dist/app-version.json
{{< /highlight >}}

The second file, `registry-host.json`, contain the hostname and port number of where the registry is located at, and is used to create copy/pastable `docker pull` commands in the web interface. Create a file at `dist/registry-host.json` and fill it out like this (adjust the hostname and port number as needed):

{{< highlight json >}}
{
    "host": "docker.domain.com",
    "port": 443
}
{{< /highlight >}}

The last thing to do is to change our Nginx configuration to serve this interface. You can use this Nginx configuration and modify to suit you:

{{< highlight nginx >}}
upstream docker { server 127.0.0.1:5000; }

server {
    listen 80;
    listen 443 ssl;

    ssl_certificate cert.pem;
    ssl_certificate_key cert.key;

    client_max_body_size 500M;
    proxy_set_header Host $host;

    auth_basic "Docker Registry";
    auth_basic_user_file /home/docker/auth;

    location / { root /home/docker/frontend/dist; }

    location /v1 { proxy_pass http://docker; }

    # Endpoints which are not requested with authentication
    location /v1/_ping { proxy_pass http://docker; auth_basic off; }
    location /v1/search { proxy_pass http://docker; auth_basic off; }
}
{{< /highlight >}}

Then just reload the Nginx configuration with `sudo service nginx reload`, open the Docker registry website in a browser, input your credentials and there you have it.
