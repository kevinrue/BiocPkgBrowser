## app.R ##
library(shiny)
library(shinydashboard)
library(BiocPkgTools)
library(biocViews)

data(biocViewsVocab)

pkg_list <- BiocPkgTools::biocPkgList()

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody(
    selectizeInput(inputId = "query_biocviews", label = "Query", choices = sort(biocViewsVocab@nodes), selected = NULL, multiple = TRUE),
    tableOutput(outputId = "filtered_pkg_list")
  )
)

which_single_term <- function(query_term) {
  query_terms <- biocViews::getSubTerms(dag = biocViewsVocab, term = query_term)
  which_pkgs <- vapply(
    X = pkg_list$biocViews,
    FUN = function(pkg_terms, query_terms) {
      any(pkg_terms %in% query_terms)
    },
    FUN.VALUE = logical(1),
    query_terms = query_terms
  )
}

which_multiple_terms <- function(query_terms) {
  which_pkgs_list <- lapply(
    X = query_terms,
    FUN = which_single_term
  )
  which(Reduce(f = `&`, x = which_pkgs_list))
}

server <- function(input, output) {
  output$filtered_pkg_list <- renderTable({
    query_terms <- input$query_biocviews
    print(query_terms)
    if (is.null(query_terms)) {
      return(pkg_list[numeric(0),])
    }
    keep_rows <- which_multiple_terms(query_terms)
    # NOTE: columns that contain lists break the tableOutput
    return(pkg_list[which_multiple_terms(query_terms), 1:2])
  })
}

shinyApp(ui, server)
