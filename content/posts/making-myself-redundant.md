+++
date = '2026-09-30T14:00:00+02:00'
draft = false
title = 'Making myself redundant?'
+++

So. When I did infrastructure engineering, I had a mantra: make yourself redundant. Whatever you're doing, automate it so it can run over and over. That freed me up for the important stuff, like coffee. Or YouTube (which hadn't really been invented yet).

Come to think of it, when I made the roadmap for my first PO gig (an operations team), there was a dot on it where it made sense for me to exit and a new skill set to take over.

These days I also work on a platform that does TV stuff. I'm what you could call an infrastructure architect: private cloud, network, load balancing, firewalls, recovery plans. I own the architecture and the infrastructure code. The software running on top belongs to someone else.

Except I haven't written any of that code since January. I made myself redundant from the code and gave myself a new challenge instead. When an agent can produce a change in minutes, how do I make good calls on "should this go live?" and "what happens if it doesn't hold?"

## The herding cats phase

It would be lovely to say it just worked. It didn't. In January there was a fair bit of "stop imagining things that won't work" and "where did that come from? I just asked you something else". Three things stood out.

**The shiny new stack.** Out of nowhere, an agent would suggest running a whole new stack of software alongside one we already had. The existing one was established and did the job. The new one would have been more to run, more to patch and more to break, for no gain whatsoever.

**Running fast in the wrong direction.** Agents are eager. Very eager. They'd lock onto their own reading of the goal before they'd understood mine, and then sprint. The classic: a test fails, so the agent edits the test until it goes green. Technically the task is solved. Practically, you've just taught your safety net to lie to you.

**Run it twice.** Infrastructure code has to be idempotent. Run it once, run it twice, run it on a Tuesday, and nothing should break. Getting agents to write IaC that respects that took a fair bit of work. The first versions were perfectly happy to tear something down and rebuild it just because they could.

Nowadays it's smoother. Not because the agents got magically wiser, but because the guardrails around them grew up.

## Guardrails move

Guardrails aren't a thing you set up once. They've changed a lot, and they're still changing.

Before January, the guardrail was basically me. I'd stitch together code snippets myself to make sure everything was done properly. Safe, but slow, and not exactly making myself redundant.

Then we moved to heavy manual code review, with me running all the tests myself to check it all held together.

Now the first line is other agents. An automated review agent catches concrete code errors, but more importantly it predicts regressions. It'll come back with something like "you've technically solved the task, but X, Y and Z can break in A, B and C ways", and send the task straight back to the coding agent. They sort it out between them before it ever reaches me.

So my part has shifted. It's less "is this line of code correct?" and more of a sanity check: did the agent actually go in the direction I had in mind when we started? That's the question the other agents can't answer for me.

## Teaching the future (carefully)

After each change, an agent goes through the commits and proposes lessons for our shared knowledge base. With approval, because a bad lesson doesn't just affect today. It gets carried into every future session.

The lessons I've turned down have mostly been misunderstandings caused by too little context. And early on, because the agents were so keen to complete the task, I'd get proposed lessons that weren't really relevant, or were already described somewhere else.

What gets through now is the soft stuff around a task. If I've given a slightly cryptic brief and we've circled our way to a good solution, parts of that conversation get saved, so the next session doesn't have to go through it all again. Or a regression that wasn't obvious gets written down, so the next agent knows to look out for it.

## Where I draw the line

Right now, the line is simple. Agents can't merge code, and they don't have write access to production.

They do get read-only access to things like observability. That one might sound odd, but "human in the loop" doesn't get better if the human's job is to be the agent's eyes. Copying log lines back and forth isn't oversight. It's just being a slow API.

The line will probably move. But it'll move because the guardrails earned it, not because it was convenient.

## If you're getting started

A few things I'd tell myself back in January:

- **Say what the goal is, not just the task.** Most of the wrong-direction sprints came from the agent understanding the task but not what I was actually trying to achieve.
- **Let agents review agents, but keep the direction check for yourself.** Machines are getting good at "is this correct?". "Is this what we wanted?" is still your job.
- **Be picky about what gets remembered.** A shared knowledge base is only as good as what you let into it.
- **Give eyes, not hands.** Read access makes the agent useful. Write access to prod makes you nervous. Keep it that way until you have a good reason not to.

## It's still you

The funny thing is how concrete accountability becomes. You can't hide behind "the team decided" when the team is a handful of agents and you. It's you. Every time it goes on air.

Turns out you can make yourself redundant from the work. Just not from the responsibility.
