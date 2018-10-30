+++
date = "2016-11-20"
title = "Making a server - The plan"
aliases = ["/making-a-server---the-plan/"]
+++

I currently have a virtual server running at [Hetzner](https://www.hetzner.de/gb/), it's used for hosting this website plus a few other projects of mine. I've been contemplating rebuilding it from scratch, and think it could be good to blog about and to give you some tips in case you feel inspired to do the same.

The current server has been ad-hoc configured over the years, I instead plan to make the new server a lot more structured and instead make use of configuration management for setting it up, a continuous integration server for checking and executing the configuration, "ChatOps" for day-to-day system administration and tools, metrics for the system and services, etc.


The plan
--------

My current plan looks like this, although it may change over time:

### Operating system
The current server runs [Arch Linux](https://www.archlinux.org/) and I want to continue using it for the new server. I like having the system constantly up to date while still having a stable system. I haven't had any stability problems with running Arch on my server over the last 4 years I've been using it, and I quite like the light weight approach of the system as you only install the software you need on it. The current server is for instance an old VPS model with only 512 MB of RAM of which only ~115 MB is used for normal operations (26 MB are inside a Redis database).

Arch Linux also has the benefit of the [Arch User Repository](https://aur.archlinux.org/) which makes it easy to package and install software which aren't available in the official repositories. It may be necessary for me to make a package or two in order to get the stuff installed that I would like, so having an easy, reproducible way to do that would be convenient.

### Configuration management
I plan to use [Ansible](https://www.ansible.com/) for the configuration management tool. In my experience it makes it rather easy to write readable recipes for how the system should be configured (it's all YAML files), and since it's an open-source project written in Python I can easily look into the source code in order to see if any potential unexpected behaviour or missing features are easy to fix. I've already made a few pull requests to the project and wouldn't be afraid to contribute more in case I bump into some edge cases or optimisations that would be made along the way.

Ansible playbooks can be as simple or advanced as you'd like, making them usable for multiple different purposes. As well as configuring the system and installing packages, I also plan to use it for deploying changes to software by using separate playbooks.

Ansible also has the concept of [Ansible Vault](http://docs.ansible.com/ansible/playbooks_vault.html) which would allow me to have a public repository on GitHub with my Ansible configuration that I can refer to, while keeping any passwords or private information encrypted with AES. I think this would be helpful as a learning tool to the reader of the blog post, and would allow me to refer to it from the future blog posts.

### Virtualisation
[Docker](https://www.docker.com/) can have its place on a server, although I currently mostly use it for build tools with lots of dependencies at the moment - like [AssetGraph](https://github.com/assetgraph/assetgraph) which I use to optimise the generated HTML files for [my website](https://github.com/Tenzer/tenzer.dk/blob/master/Makefile#L21).

At the moment I don't use Docker for any long running processes but I may start using it more for specific applications, in order to keep them more contained in case they have dependencies that I don't feel like installing system-wide. That could for instance be [Tweet Nest](http://pongsocket.com/tweetnest/) which is a PHP application - the only PHP application I run on the current server. It's also a project which is rarely updated any more, making it an even better candidate for a bit of isolation. It's used for archiving all my tweets as I write them and can be seen at [tweets.tenzer.dk](https://tweets.tenzer.dk/).

### ChatOps
I like the idea of setting up a system like [Mattermost](https://www.mattermost.org/) on my server, coding some bots for it and using that for automating the slightly more tedious tasks or just as an alternative way of writing scripts for looking up information or doing routine things. I can also have different services on the server publish information to the chat system in case something happens that I would like to be notified about (like recently when [Taphouse Watcher](https://twitter.com/TaphouseWatcher) couldn't get beer ratings), or just for scraping information from interesting websites and posting updates into the chat system instead of putting it into my RSS reader.

### Continuous Integration
Instead of running scripts and Ansible playbooks ad-hoc on the server in order to make changes over time, I like the concept of executing everything in a controlled way - with proper logging and configuration that can be tweaked over time as needed. A CI server will help me achieve that and is able to be triggered from various places, whether it's a command on a chat server or a commit being pushed to a Git repository.

A CI server can also be used for doing syntax checking and linting on both program code and Ansible playbooks, helping me save time by checking the work I'm doing before I try to execute it on the server. Feedback on how the checks and other deploy jobs are going can easily be pushed to either the chat system or as feedback on GitHub pull requests.

So far [Concourse](https://concourse.ci/) looks like the most interesting option for me, but I'll see how it fares when I get around to set it up.

### Metrics
I don't currently have any metrics for the server, neither a graph of the load on the machine, memory usage, number of website hits, disk space remaining or similar. It's mostly a matter of not having had a need for that so far. It's however something I would like to change as I see a weird satisfaction in looking at graphs, even if just to get assured everything is fine, or correlating graphs to figure out exactly what went wrong in case something does go wrong.

I haven't quite decided on what I'll use for collecting and storing the metrics yet, but I do have a preference and experience with using [StatsD style metrics](https://github.com/etsy/statsd/blob/master/docs/metric_types.md) sent to [CollectD](http://collectd.org/), but I have yet to decide if I'll store it in [Graphite](https://graphiteapp.org/) or if I'll try to use the new kid on the block: [Prometheus](https://prometheus.io/). [InfluxDB](https://www.influxdata.com/time-series-platform/influxdb/) is a bit of a dark horse, I've previously tried it out with limited success due to performance issues with a ton of metrics, and the recent change to make it more commercial doesn't attract me too much, but it may be outweighed by number of features and ease of deployment. I do however know that I want to use [Grafana](http://grafana.org/) as my metrics front-end since I know and love it from past experience.


Closing remarks
---------------

That was a bit about my plans. I hope it's something you'd like to follow, and I'll make sure to post updates on [Twitter](https://twitter.com/Tenzer) whenever new blog posts are up. Do also feel free to reach out to me in case you have any questions, suggestions or comments for this series along the way!
