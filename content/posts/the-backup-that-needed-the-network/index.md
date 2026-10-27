+++
date = '2026-12-03'
draft = false
title = "The backup that needed the network"
description = "My network config backups ran as planned and monitoring was green. At 3am I found they lived on a server that needed the network they could restore."
tags = ['platform', 'lessons-learned']
images = ['the-backup-that-needed-the-network_wide.png']
+++

![Illustration: a dark datacenter at night with a wall clock showing 3 o'clock. A monitoring screen on a cart glows green with a checkmark, while three icons, a server holding the backups, a storage array and a network switch, are joined by arrows in a closed loop, each depending on the next.](the-backup-that-needed-the-network_wide.png)

Why should your disaster recovery plan have different scenarios? And why should you test all of them regularly?

Pull up a chair, I'll tell you a story.

Back in the day, we did hosting. It was rather fun, actually. All the tech, all the responsibilities, all the creative ways to make the environment more redundant, resilient and performant.

I'm into automation, that's no secret :-)

So in addition to all the regular backups of servers and so on, I'd set up something that would pull the configuration files from all our network gear and store them on a management server, which again was part of the backup cycle. They were even stored in different versions, so you could backtrack changes. It was pretty quick to set up, and very useful over time, I found.

I even had a use for it a couple of times. A switch in a rack would go dark, and I could pretty easily replace it with an identical cousin and load its config, and voila. Everything was back up and running. Felt pretty good, to be fair.

Monitoring of the backup jobs and the config dumps was of course in place, so I could trust that the process worked.

Months went by with things running smoothly.

This was also the point in time where virtualization was the new big thing, so we were constantly remodelling our infrastructure. What used to be physical servers were consolidated into virtualization hosts. My management server was one of those servers. Standalone virtualization hosts were consolidated into clusters, to allow fancy things like failover and load sharing. And we invested in a storage system that used iSCSI, so we could leverage our existing network infrastructure.

Then came a weekday night at 3am. There was a lights-out service window of some kind; I no longer remember exactly what it was for. I powered down a bunch of virtual servers so the service window could proceed, and somewhere in that process I found I needed to restore my switch configurations from the backups on the management server.

Except the management server was now virtualized. And the virtualization needed the shared storage system. And the shared storage system needed the network.

So there I was, standing in the datacenter at 3am, realizing that all the monitoring was still green and all the backups had run exactly as planned. They were just stored somewhere I couldn't reliably get to without the information in those same backups.

Yeah. I made a quick and dirty workaround, got enough stuff back up to restore the actual configs, and in the end this particular incident added maybe 10 to 15 minutes to the actual runtime. But it did teach me a lesson about the need to test continuously, because even if your specific prerequisite hasn't changed, others might have.

## If you want something to take away

- **Map what the recovery depends on, not just what it restores.** Where does the backup live, what does that server need to start, and what does that need again? Follow the chain until you hit something that works on its own.
- **Have a scenario where the infrastructure itself is down.** Restoring one server while everything else is happy is the easy test.
- **Keep a copy somewhere that doesn't depend on the thing you're restoring.**
- **Retest when anything around it changes, not only when the backup changes.** My backup job never changed. Everything underneath it did.
