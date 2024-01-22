
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyinegi

<!-- badges: start -->

[![R-CMD-check](https://github.com/estebandegetau/tidyinegi/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/estebandegetau/tidyinegi/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`tidyinegi` is a set of helper functions that clean data in
[`tidyenigh`](https://github.com/estebandegetau/tidyenigh) and future
friends. `tidyenigh` is a data package that ships analysis-ready data
from the [Encuesta Nacional de Ingresos y Gastos de los Hogares (ENIGH).
Nueva serie](https://www.inegi.org.mx/programas/enigh/nc/2022/).

Why analysis-ready? Frequent users of INEGI data sets ought to know how
painful it is to get its raw data into a useful and tidy state, ready to
draw analyses. This family of packages aims to bridge that gap,
providing users with a consistent and intuitive way to load INEGI data
sets into R.

Since the functions shipped in these packages are only used internally
in `tidyenigh`, its installation is for advanced users who seek to test
its cleaning process.
