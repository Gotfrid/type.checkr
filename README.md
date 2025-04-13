# type.checkr

Type definitions in R for static code analysis.

## Goal

As a developer, I want to be able to add type definitions,
or type hints, to my code without any runtime overhead,
and perform static code analysis to identify any potential
function misuse.

## Approach

I will develop a Proof of Concept solution incrementally
increasing the compexity and robustness of the solution.

Ever since the discussion on Appsilon Retreat 2024 I've
had an idea to be able to use roxygen tags to create type
hints in the R code.

Indeed, roxygen2 allows developers to extend its roclets
with custom tags ([docs](https://roxygen2.r-lib.org/articles/extending.html)). I guess that the current PoC is going to
revolve aroung this idea.
