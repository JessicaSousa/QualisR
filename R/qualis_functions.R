#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL


#' get_sucupira_page
#'
#' Realiza GET na página  do \href{https://sucupira.capes.gov.br/sucupira/public/consultas/coleta/veiculoPublicacaoQualis/listaConsultaGeralPeriodicos.jsf}{Sucupira}
#'
#' @importFrom  httr GET
#' @return Retorna a operação obtida pelo GET do rvest no site do sucupira.
#' @export
#' @examples
#' \dontrun{
#' sucupira_get <- get_sucupira_page()
#' print(sucupira_get$headers)
#' }
get_sucupira_page <- function(){
  url <- paste("https://sucupira.capes.gov.br/",
               "sucupira/public/consultas/coleta/",
               "veiculoPublicacaoQualis/",
               "listaConsultaGeralPeriodicos.jsf",
               sep = "")
  request <- httr::GET(url)
  return(request)
}

#' get_options
#'
#' Obtém a lista de opções de cada menu do formulário do site
#' do Sucupira
#'
#' @importFrom  xml2 read_html
#' @importFrom  rvest html_nodes
#' @importFrom  glue glue
#' @importFrom  rvest html_attr
#' @importFrom  rvest html_text
#' @return Retorna um dataframe contendo o valor dos campos de opções do menu informado.
#' @param request refere-se o objeto gerado pela função \code{get_sucupira_page}
#' @param form refere-se ao nome do formulário do menu presente no HTML do sucupira,
#' algumas opções são: evento, area e estrato
#' @export
#' @examples
#' \dontrun{
#' sucupira_pg <- get_sucupira_page()
#' evento_op <- get_options(request = sucupira_pg, form = 'evento')
#' print(evento_op)
#' area_op <- get_options(request = sucupira_pg, form = 'area')
#' print(head(area_op))
#' }
get_options <- function(request, form = "evento"){
  options <- request %>% xml2::read_html()  %>%
    rvest::html_nodes(xpath = glue::glue("//*[@id=\"form:{form}\"]/option"))
  data.frame(value = options %>% rvest::html_attr("value"),
             name = options %>% rvest::html_text(),
             stringsAsFactors = FALSE)[-1, ]
}
