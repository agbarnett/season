# season 0.3.16.9000

* Added a `NEWS.md` file to track changes to the package.

## New Features

* New vignette, "Modelling monthly data", which demonstrates how to use `createAdj()` with the `{nimble}` R package.

## Breaking change

* `monthmean()` argument, `adjmonth` must be one of "none" (default), "thirty", or "average", rather than: FALSE, "thirty", or "average".
* `createAdj()` argument, `filepath` has been removed, as it is no longer required.