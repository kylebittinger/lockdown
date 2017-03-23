# lockdown

Lockdown is an R package to check on files or variables that shouldn't change.

# Motivation

Let's say I'm carrying out some data analysis and making a report.  I generate
a plot in the file `myplot.pdf`.  I want to make sure that the plot doesn't
change as I go through the report and touch up other areas.  If I add

```r
lockdown_file("myplot.pdf")
```

to my report, the lockdown package will generate a hash from the plot file and
save it until I call `lockdown_file("myplot.pdf")` again.  When I call this
function the next time, the current hash is checked against the hash from the
previous call.  If the contents are identical, nothing happens (we invisibly
return `TRUE`).  If the contents have changed, a huge ugly error message is
printed.

Now let's say I have a data frame, `my_observations`, that forms the backbone
of my analysis.  I touch up the data frame near the beginning of my report, and
want to make sure that it retians the same value each time I run the report.
If I add

```r
lockdown_variable(my_observations)
```

to my report, the function will cache the value of this variable and check it
each time I run the code.

The package also includes a couple of functions to remove files and variables
from the cache: `lockdown_remove_file()` and `lockdown_remove_variable()`.

