[![Travis-CI Build Status](https://travis-ci.org/JessicaSousa/QualisR.svg?branch=master)](https://travis-ci.org/JessicaSousa/QualisR)

QualisR: Acesso as tabelas dos qualis do Sucupira via R
========================================

O presente pacote permite que você acesse as tabelas dos qualis do site [Sucupira](https://sucupira.capes.gov.br/sucupira/public/consultas/coleta/veiculoPublicacaoQualis/listaConsultaGeralPeriodicos.jsf), via R. Você pode pode selecionar se deseja obter todas as tabelas do site ou apenas algumas, relacioná-las e fazer as operações que desejar.

O pacote `QualisR` é desenvolvido utilizando o controle de versão do Github. Então você pode fazer download dele utilizando o pacote `QualisR`:

``` r
# install.packages("devtools")
devtools::install_github("JessicaSousa/QualisR")
```

### Exemplo

A função `QualisR::get_qualis_table` permite que você obtenha a tabela do site do Sucupira com o qualis de todos os cursos, caso não passe o argumento área

```{r}
#Realiza Get na página do Sucupira
sucupira_get <- QualisR::get_sucupira_page()
print(sucupira_get$status_code)

#Obtém a tabela de periódicos do curso de estatística no triênio 2010-2012
tabela <- QualisR::get_qualis_table(sucupira_get,area = "estatística", event = '2010-2012')

head(tabela)
```

#### Outros exemplos
Veja mais coisas que você pode fazer no [Tutorial](https://jessicasousa.github.io/QualisR/inst/doc/README.html)
