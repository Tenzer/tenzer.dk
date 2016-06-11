+++
date = "2009-10-04"
title = "Updating an OpenSolaris zone"
+++

This is just a quick guide for people who need to update an OpenSolaris zone. First off, you need to shutdown the zone. This can either by done by using `init 5` or `shutdown` inside the zone, or by running any of the two commands with `zlogin` from the global zone. A final not recommended possibility is to run `zoneadm -z <zonename> halt` from the global zone.

After the zone is stopped, you will have to set the zone state to "ready", in order for the file systems to be mounted:

{{< highlight shell >}}
zoneadm -z <zonename> ready
{{< /highlight >}}

Then you can start the update procedure:

{{< highlight shell >}}
pkg -R <path to zone>/root image-update
{{< /highlight >}}

And lastly, when the zone is upgraded you can boot up the zone again:

{{< highlight shell >}}
zoneadm -z <zonename> boot
{{< /highlight >}}
