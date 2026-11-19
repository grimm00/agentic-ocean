# Worked example: making a nightly upgrade unit non-interactive

Adapted from the review this skill came from, with names and fleet figures generalised. A teammate's
PR made `apt-full-upgrade.service`, a nightly `apt full-upgrade` unit, non-interactive after a
vendor package's repository prompt hung it. An automated reviewer ran several rounds and found three
problems, all inside the diff. Everything below came from outside it.

## The six questions

| # | What the PR said or assumed | Receipt | Weight |
|---|---|---|---|
| 1 | "A one-hour timeout allows slower upgrades to complete" assumes a shorter limit existed | `systemctl show apt-full-upgrade.service -p TimeoutStartUSec` → `infinity`; `systemctl cat` shows `Type=oneshot`, no `TimeoutStartSec`; `systemctl show -p DefaultTimeoutStartUSec` → `1min 30s`; the unit on the default branch has no timeout | Question |
| 2 | Deployed through the upgrades role to every workstation | The role's first task installs a package with `apt`, so a host holding the dpkg lock may not apply it (inferred) | Question |
| 3 | The package preseed is described as "approving" the prompt | The preseed value is `false`, which declines the vendor repository, so "approve" is the wrong word. It is also not decisive: the team's repackaged `postinst` removes the vendor `.list` and `.sources` files, so no vendor source survives an install (confirmed absent on a host). The environment lines stop the hang; the preseed only skips a write-then-delete | Suggestion |
| 4 | The original hang was silent | A waiting run neither fails nor finishes, so failure queries miss it; the only trace was the prompt text | Suggestion |
| 5 | "No live upgrade was run" | Two cheap receipts: `systemctl show ... -p Environment` after deploy, and the log-search count of the prompt going to zero | Suggestion |
| 6 | README: other prompts "are not auto-approved"; PR body: they "fail safely" | The noninteractive frontend takes the default for any question that has one, which is auto-approval | Suggestion |

## Sizing the timeout with fleet data

A finding about a new limit depends on how often it would trip, so measure it first. In the log
search's query language, pairing the unit's start and finish messages per host:

```
index=<fleet-index> "<unit description>" ("Starting" OR "Finished")
| transaction host startswith="Starting" endswith="Finished" maxspan=24h keepevicted=false
| where duration>0
| stats count as runs p50(duration) as p50_s perc90(duration) as p90_s perc99(duration) as p99_s
        max(duration) as max_s count(eval(duration>1800)) as over_30min
        count(eval(duration>3600)) as over_1h dc(host) as hosts
```

Over 30 days the median run took under a minute, p99 about five minutes, and exactly one run went
past an hour. That moved the timeout from "candidate to block" to "question". It is a lower bound:
runs that never reached `Finished` are not counted.

The hang's footprint, separately: searching for the prompt text found it on dozens of hosts in 30
days, where the team had escalated two.

## A draft comment in the expected shape

> Question on `TimeoutStartSec=1h`. The PR body says this lets slower upgrades complete, which reads
> like a shorter limit already existed. As far as I can tell none did: `Type=oneshot` units don't get
> systemd's 90s default, and the unit on the default branch has no `TimeoutStartSec`.
>
> - `systemctl show apt-full-upgrade.service -p TimeoutStartUSec` → `infinity`
> - `systemctl show -p DefaultTimeoutStartUSec` → `1min 30s`
> - Log search, 30 days: no `Failed with result 'timeout'` for this unit; one completed run over an
>   hour (longest about 110 minutes)
>
> If that holds, this adds a kill point where there wasn't one, on the lane that upgrades the kernel
> and GPU driver. Was the intent to bound hangs like the eleven-day one on that laptop? If so, what
> happens to dpkg when it is killed at 1h on a slow machine, and is the recovery block the plan for
> that? I checked the current unit, not the change itself.
