## ------------------------------------------------------------------------
conferencias <- QualisR::GetTable(id_table = 'tb-conferencias')
#head(conferencias, 5)

## ---- echo=FALSE, results='asis'-----------------------------------------
knitr::kable(head(conferencias, 5))

## ----fig.width=7, fig.height=3-------------------------------------------
library(ggplot2)
ggplot(conferencias, aes(`Extrato CAPES`, fill = `Extrato CAPES` ) ) +
  geom_bar()

## ------------------------------------------------------------------------

areas <- 'machine learning|data mining'
conferencias <- QualisR::GetTable(id_table = 'tb-conferencias')
periodicos <- QualisR::GetTable(id_table = 'tb-periodicos')

confs <- dplyr::filter(conferencias, grepl(areas, Conferência, ignore.case = TRUE))[,2:3]
peris <- dplyr::filter(periodicos, grepl(areas, Periódico, ignore.case = TRUE))[,2:3]


## ---- echo=FALSE, results='asis'-----------------------------------------

knitr::kable(list(head(confs, 7), head(peris, 7)))

