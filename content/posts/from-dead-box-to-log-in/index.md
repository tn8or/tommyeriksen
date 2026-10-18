+++
date = '2026-11-05'
draft = false
title = "From dead box to log in"
tags = ['platform', 'lessons-learned']
+++

![Illustration: a server rack where one blade is lit green and labelled "ready for use", joined by dotted lines to the people it took: the platform architect and a couple of developers on one side, the ITSM owners, the integration engine owners and the external operations partner on the other. Caption: "Not because of the server. Because of everyone it took."](from-dead-box-to-log-in.png)

Building it wasn't the hard part. I'd automated provisioning plenty of times, just never on something you could kick.

Then one day a physical server came up by itself. Someone filled in a form in the ITSM system. Less than an hour later, a transition had happened: from an empty, dead blade to a fully working server. In the CMDB, disks on the SAN, OS installed, registered in all the right systems and ready to log in. Until then, that could take days.

I remember thinking: that's pretty cool. Not because of the server. Because of everyone it took.

I was the platform architect, which mostly meant knowing who to ask. A couple of developers wrote the code. The ITSM system and the integration engine belonged to other teams, and our operations partner built their share of the integration. Quite the crowd, and none of us could have done it alone.

Nobody ever said "agile" out loud. We just did what seemed quickest: close conversations, regular check-ins and goals adjusted every week, because it moved fast and we kept finding things that needed changing.

Technically it was the same old same old: more automation. On a box in a rack, it still felt different.

Automation is satisfying when it saves you typing. It's something else when it takes a rack of people to pull off.
