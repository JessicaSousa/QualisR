#' get_qualis_table
#'
#' Obtém a tabela com o nome dos periódicos de acordo com a classificação do
#' evento e a área desejada
#'
#' @importFrom  xml2 read_html
#' @importFrom  rvest html_nodes
#' @importFrom  glue glue
#' @importFrom  rvest html_attr
#' @importFrom  rvest html_text
#' @importFrom  utils read.table
#' @importFrom  dplyr filter
#' @importFrom  readr read_file
#' @return Retorna um dataframe contendo o valor dos campos de opções do menu informado.
#' @param sucupira_get refere-se o objeto gerado pela função \code{get_sucupira_page}
#' @param area refere-se a área que se deseja obter a tabela dos periódicos
#' @param event refere-se ao evento de classificação dos periódiocos se é do triênio
#' ou quadriênio
#' @export
#' @examples
#'
#' sucupira_pg <- get_sucupira_page()
#' #todos_cursos_tb <- get_qualis_table(sucupira_pg)
#' #print(head(todos_cursos_tb))
#' estatistica_tb <- get_qualis_table(sucupira_get = sucupira_pg, area = 'estatística')
#' print(head(estatistica_tb))
#'
#'
get_qualis_table <- function(sucupira_get, area = "", event = "2013-2016"){

  select_option <- function(options, key)
    as.integer(dplyr::filter(options,
                             grepl(key, options$name, ignore.case = TRUE))[1, 1])

  #Obter opções de evento e área para construir  a busca
  cod_event <- select_option(get_options(sucupira_get,
                                         form = "evento"), key = event)
  #Obtém viewstate da página
  viewstate <- sucupira_get %>%
    xml2::read_html() %>%
    rvest::html_node(xpath = "//*[@id=\"javax.faces.ViewState\"]") %>%
    rvest::html_attr("value")

  # Preencher formulário para busca
  params <- list(
    'form' = 'form',
    'form:evento'= cod_event,
    'form:estrato' = 0,
    'form:consultar' = 'Consultar',
    'javax.faces.ViewState' = viewstate
  )


  if(area != ""){
    cod_area <- select_option(get_options(sucupira_get,
                                          form = "area"),
                              key = area)
    if(is.na(cod_area))
      stop('The area does not exist in the table!')
    params$`form:checkArea` <- "on"
    params$`form:area` <- cod_area
  }

  #Faz consulta no site do sucupira
  response <- httr::POST(sucupira_get$url, body = params)

  params$`form:consultar` <- NULL

  if(area != ''){
    params$`form:j_idt560` =	'form:j_idt560'
  }
  else{
    params$`form:j_idt568` <- "form:j_idt568"
  }

  response <- httr::POST(response$url, body = params)

  xls_file <- response %>%
    httr::content('text', encoding = "latin1") %>%
    readr::read_file()
  read.table(text = xls_file, header = TRUE, sep = "\t")

}



#' #' get_all_tables
#' #'
#' #' Obtém as tabelas de qualis dos cursos
#' #'
#' #' @importFrom  purrr set_names
#' #' @importFrom  purrr map
#' #' @param sucupira_get refere-se o objeto gerado pela função \code{get_sucupira_page}
#' #' @param num_tables refere-se a quantidade das n primeiras tabelas
#' #' @param event refere-se ao evento de classificação dos periódiocos se é do triênio
#' #' ou quadriênio
#' #' @return Retorna uma lista atualizada de N tabelas do site do Sucupira
#' #' @export
#' #' @examples
#' #' \dontrun{
#' #' sucupira_pg <- get_sucupira_page()
#' #' qualis.tab <- get_all_tables(sucupira_pg)
#' #' print(head(qualis.tab$ARTES))
#' #' }
#' get_all_tables <- function(sucupira_get, num_tables = 5,  event = '2013-2016'){
#'   areas_options <- get_options(sucupira_get, form = 'area')
#'   areas <- areas_options$name
#'   if(num_tables <= length(areas)) areas <- areas[1:num_tables]
#'   qualis <- purrr::map(areas, function(tb) get_qualis_table(sucupira_get,tb, event))%>%
#'             purrr::set_names(areas)
#'   return(qualis)
#' }
