# Experiment

A Swift script to generate a SPM package using templates.

## Setup



Add the following to `~/.bash_profile`:

```
export EXPERIMENTS_PATH={PATH TO WHERE YOU WANT EXPERIMENTS GENERATED}

function exp {
    name=`swift run --package-path {PATH TO THIS SCRIPT} Experiment $1`;
    if [ ! -z "$name" ];
    then
        cd $EXPERIMENTS_PATH/$name;
        open Package.swift;
    fi
}

export -f exp
```

This allows you to just type `exp` and it will do the following:

 * Pick a random word from the dictionary
 * Generate a SPM package with that name
 * Change directory to the generated project
 * Open Xcode
