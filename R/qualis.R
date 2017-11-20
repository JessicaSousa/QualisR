#' Qualis das conferências e revistas.
#'
#' Contém o conjunto de informações sobre qualis de períodicos e conferências da área da computação
#'
#' @format Uma lista contendo três data frames
#' \describe{
#'   \item{conferencias}{Qualis das conferências}
#'   \item{periodicos}{Qualis dos periódicos}
#'   \item{outros}{Correlação com outras áreas}
#' }
#' @source \url{ http://qualis.ic.ufmt.br/}
"qualis"

#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

#' GetColNames
#'
#' Obtém o nome das colunas presentes na tabela
#'
#' @importFrom  xml2 read_html
#' @importFrom  rvest html_node
#' @importFrom  rvest html_table
#' @param url refere-se a url da página do qualis http://qualis.ic.ufmt.br/
#' @param xpath se refere a xpath da tabela desejada
#' @return Retorna um vetor contendo os nomes dos campos da tabela
#' @keywords internal
#' @examples
#' conferencia.cols <- QualisR:::GetColNames(xpath = '//*[@id="tb-conferencias"]')
#' periodicos.cols <- QualisR:::GetColNames(xpath = '//*[@id="tb-periodicos"]')
#' print(conferencia.cols)
#' print(periodicos.cols)
GetColNames <- function(url = 'http://qualis.ic.ufmt.br/', xpath = '//*[@id="tb-conferencias"]'){
  names<- url %>%
    xml2::read_html() %>%
    rvest::html_node(xpath=xpath) %>% rvest::html_table() %>% colnames()
  return(names)
}


#' GetJsonPath
#'
#' Obtém o caminho do json utilizado para preencher a tabela dos qualis
#'
#' @importFrom  xml2 read_html
#' @importFrom  rvest html_nodes
#' @importFrom  rvest html_text
#' @importFrom  stringi stri_split_lines
#' @importFrom  stringi stri_detect_fixed
#' @importFrom  stringr str_match
#' @importFrom  stringr str_c
#' @param url refere-se a url da página do qualis http://qualis.ic.ufmt.br/
#' @param tab refere-se ao nome da tabela no "View Source" da página que se deseja recuperar
#' @return Retorna o caminho do arquivo json que contém as informações da tabela
#' @keywords internal
#' @examples
#' tab.conf <- "#tb-conferencias"
#' tab.per <- "#tb-periodicos"
#' print(QualisR:::GetJsonPath(tab = tab.conf))
#' print(QualisR:::GetJsonPath(tab = tab.per))
GetJsonPath <- function(url = 'http://qualis.ic.ufmt.br/', tab = '#tb-conferencias'){
  page <- xml2::read_html(url)
  js_lines <- rvest::html_nodes(page, xpath=".//script[contains(., '#tabs-qualis')]") %>%
    rvest::html_text() %>% stringi::stri_split_lines()
  js_lines <- js_lines[[1]]
  idx <- which(stringi::stri_detect_fixed(js_lines, tab))
  current_line <- js_lines[idx]
  json_file <- stringr::str_match(current_line, "([a-zA_Z0-9\ ]+)\\.json")[1]
  return(stringr::str_c(url,json_file))
}


#' GetTable
#'
#' Obtém a tabela do qualis em forma de data.frame
#'
#' @importFrom  xml2 read_html
#' @importFrom  rvest html_nodes
#' @importFrom  rvest html_text
#' @importFrom  stringi stri_split_lines
#' @importFrom  rjson fromJSON
#' @importFrom  purrr reduce
#' @param url refere-se a url da página do qualis http://qualis.ic.ufmt.br/
#' @param id_table refere-se ao id tabela no "View Source" da página que se deseja recuperar
#' @return Retorna um data.frame contendo as informações referente a tabela buscada
#' @export
#' @examples
#' tab.conf <- GetTable(id_table = "tb-conferencias")
#' tab.per <-  GetTable(id_table = "tb-periodicos")
#' print(head(tab.conf))
#' print(head(tab.per))
GetTable <- function(url = 'http://qualis.ic.ufmt.br/', id_table = 'tb-conferencias'){
  xpath <- stringr::str_c('//*[@id="',id_table,'"]')
  table.names <- GetColNames(xpath = xpath)
  json.path <- GetJsonPath(url = url, tab = stringr::str_c('#',id_table))
  table <- rjson::fromJSON(file=json.path)[[1]] %>%
    purrr::reduce(rbind) %>% unname
  colnames(table) <-table.names
  return(as.data.frame(table))
}

#' GetQualisList
#'
#' Atualiza os dados com as informações dos qualis na área de computação de acordo com
#' as informações contidas em http://qualis.ic.ufmt.br/
#'
#' @importFrom  purrr set_names
#' @importFrom  purrr map
#' @return Retorna uma lista atualizada de data frames obtidos a partir do site dos
#' qualis da UFMT
#' @export
#' @examples
#' qualis.tabs <- GetQualisList()
#' print(head(qualis.tabs$conferencias))
GetQualisList <- function(){
  tables <- c('conferencias','periodicos','todos')
  qualis <- purrr::map(tables, function(tb) GetTable(id_table = stringr::str_c('tb-',tb)))%>%
    purrr::set_names(tables)
  return(qualis)
}

