# tidyinegi

`tidyinegi` is a set of helper functions that clean data in
[`tidyenigh`](https://github.com/estebandegetau/tidyenigh) and future
friends. `tidyinegi` allows users to access analysis-ready data of
[ENIGH](https://www.inegi.org.mx/programas/enigh/nc/2022/).

Why tidy? While other packages such as
[`importINEGI`](https://github.com/crenteriam/importinegi) and
[`inegiR`](https://github.com/Eflores89/inegiR) provide similar
functionality, `tidyinegi` is built on top of the `tidyverse` and
`tidyselect` packages, which allows for a more consistent and intuitive
user experience.

Why analysis-ready? Frequent users of INEGI data sets ought to know how
painful it is to get raw data from INEGI into a working state, with
variable and value labels. This package aims to bridge that gap,
providing users with a consistent and intuitive way to load INEGI data
sets into R.

## Installation

Install through
[`tidyenigh`](https://github.com/estebandegetau/tidyenigh).
