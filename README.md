# tm

Practical Time Machine version control utilities for an impractical time where pretty much no one still uses Time Machine for version control, and Time Machine won't backup iCloud.

On the other hand, I hope it's a pretty decent example of how to use subcommands in the Swift Argument Parser.


```
OVERVIEW: Time Machine helper

USAGE: tm <subcommand>

OPTIONS:
  --version               Show the version.
  -h, --help              Show help information.

SUBCOMMANDS:
  info                    Time machine info
  list                    List backup dates
  ls                      Perform a time machine ls
  diff                    Perform a time machine diff
  cp                      Perform a time machine cp

  See 'tm help <subcommand>' for detailed help.
```

This utility supercedes [`tmcp`](https://github.com/erica/tmcp), [`tmls`](https://github.com/erica/tmls), and [`tmdiff`](https://github.com/erica/tmdiff), which broke with Catalina.