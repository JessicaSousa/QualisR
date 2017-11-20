---
output:
  pdf_document: default
  html_document: default
---

[![Travis-CI Build Status](https://travis-ci.org/JessicaSousa/QualisR.svg?branch=master)](https://travis-ci.org/JessicaSousa/QualisR)

QualisR: Acesso as tabelas dos qualis de computação via R
========================================

O presente pacote permite que você acesse as tabelas dos qualis na área de computação do site http://qualis.ic.ufmt.br/, via R. Você pode pode selecionar ser deseja obter todas as tabelas do site ou apenas algumas, relacioná-las e fazer as operações que desejar por si mesmo.

O pacote `QualisR` é desenvolvido utilizando o controle de versão do Github. Então você pode fazer download dele utilizando o pacote `devtools`:

``` r
# install.packages("devtools")
devtools::install_github("JessicaSousa/QualisR")
```

------------------------------------------------------------------------
#### Exemplos:

Primeiramente, no site de onde essas informações foram tiradas, as tabelas possuem seus ids `tb-conferencias`, `tb-periodicos`, `tb-todos`, ao acessar uma tabela específica devemos informar um desses três ids.

``` r
conferencias <- QualisR::GetTable(id_table = 'tb-conferencias')
head(conferencias)

```
