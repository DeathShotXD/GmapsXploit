# Contributing

Thanks for wanting to help. A few ground rules keep the project clean.

## Commits

- one change per commit, present tense: "add ...", "fix ...", "docs ..."
- keep the subject under 72 characters, no trailing period
- do not mix a refactor with a behaviour change

## Checks

```
bash -n GmapsXploit.sh
bash tests/smoke.sh
```

## Style

- Bash 4.0 or later, no dependency beyond curl and awk
- plain ASCII in code, comments, and documents
- do not run the simulation against endpoints you are not authorized to test
- never write a real key into a report that leaves the machine
