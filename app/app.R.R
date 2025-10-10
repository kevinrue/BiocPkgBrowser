## app.R ##
library(shiny)
library(shinydashboard)
library(BiocPkgTools)
library(biocViews)

source("functions.R")
source("data.R")
source("ui.R")

pkg_list <- BiocPkgTools::biocPkgList()

server <- function(input, output) {
  output$filtered_pkg_list <- renderTable({
    query_terms <- input$query_biocviews
    print(query_terms)
    if (is.null(query_terms)) {
      return(pkg_list[numeric(0), 1:2])
    }
    keep_rows <- which_multiple_terms(query_terms, pkg_list, biocViewsVocab)
    # NOTE: columns that contain lists break the tableOutput
    return(pkg_list[keep_rows, 1:2, drop = FALSE])
  })
}

shinyApp(ui, server)
