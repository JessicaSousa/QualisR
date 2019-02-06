## ------------------------------------------------------------------------
#Realiza Get na página do Sucupira
sucupira_get <- QualisR::get_sucupira_page()
print(sucupira_get$status_code)

#Obter a tabela de periódicos de computação no triênio 2010-2012
tabela_computacao <- QualisR::get_qualis_table(sucupira_get, area = 'computação', event = 'triênio 2010-2012')

head(tabela_computacao[order(tabela_computacao$Estrato), ])

## ------------------------------------------------------------------------
library(magrittr)

url <- paste("https://sucupira.capes.gov.br/",
               "sucupira/public/consultas/coleta/",
               "veiculoPublicacaoQualis/",
               "listaConsultaGeralPeriodicos.jsf",
               sep = "")
sucupira_session <- rvest::html_session(url)
#Obter a região do html correspondente ao formulário de busca
formulario <- sucupira_session %>% xml2::read_html() %>% rvest::html_nodes('.form-group')

campo <- formulario %>% rvest::html_nodes('label') %>% rvest::html_text()
nomes <- formulario %>%  rvest::html_nodes('.form-control') %>% rvest::html_attr('name')



## ---- echo=FALSE, results='asis'-----------------------------------------
labels <- gsub("[\r\n]", "", campo)
campos <- data.frame(campo = labels, nomes = nomes)

knitr::kable(campos, caption = 'Nomes dos nós do formulário')

## ------------------------------------------------------------------------
#ATENÇÃO, é para colocar o nome de acordo com o nome do nó (após o form:)
options <- QualisR::get_options(request = sucupira_get, form = 'estrato')

## ---- echo=FALSE, results='asis'-----------------------------------------
knitr::kable(options, caption = 'Lista de Estratos', row.names = FALSE)

## ------------------------------------------------------------------------

evento.op <- QualisR::get_options(request = sucupira_get, form = 'evento')

#Valor do campo do envento que corresponde ao quadriênio
evento.valor <- evento.op$value[1]

#Obter ViewState da Página do Sucupira
  viewstate <- sucupira_get %>% xml2::read_html() %>%
    rvest::html_node(xpath = "//*[@id=\"javax.faces.ViewState\"]") %>%
    rvest::html_attr("value")

parametros <- list(
  'form' = 'form',
  'form:evento'= evento.valor,
  'form:area' = '',
  'form:issn:issn' ='', 
  'form:checkTitulo' = TRUE,
  'form:j_idt52' = 'Journal of Statistical Software',
  'form:estrato' = '',
  'form:consultar' = 'Consultar',
  'javax.faces.ViewState' = viewstate
)

resultado <- httr::POST(url, body = parametros)
pagina <- resultado %>% httr::content('text') %>% xml2::read_html() 
tabela <- pagina %>% rvest::html_table() %>% .[[1]]

## ---- echo=FALSE, results='asis'-----------------------------------------
knitr::kable(tabela, caption = 'Resultado da busca do periódico', row.names = FALSE)

