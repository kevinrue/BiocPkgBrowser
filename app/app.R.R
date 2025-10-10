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
  rv <- reactiveValues(
    selected_pkg_names = character(0)
  )
  
  observeEvent(input$query_biocviews, {
    query_terms <- input$query_biocviews
    if (is.null(query_terms)) {
      return(pkg_list[numeric(0), 1:2])
    }
    keep_rows <- which_multiple_terms(query_terms, pkg_list, biocViewsVocab)
    selected_pkg_names <- pkg_list[keep_rows, "Package", drop = TRUE]
    print(selected_pkg_names)
    rv$selected_pkg_names <- selected_pkg_names
  })
  
  output$filtered_pkg_summary <- renderText({
    sprintf("%s packages selected", format(length(rv$selected_pkg_names), big.mark = ","))
  })
  
  output$filtered_pkg_list <- renderTable({
    keep_rows <- which(pkg_list$Package %in% rv$selected_pkg_names)
    # NOTE: columns that contain lists break the tableOutput
    return(pkg_list[keep_rows, 1:2, drop = FALSE])
  })
}

shinyApp(ui, server)
