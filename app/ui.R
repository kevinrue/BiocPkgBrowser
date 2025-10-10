## ui.R ##
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody(
    selectizeInput(inputId = "query_biocviews", label = "Query", choices = sort(biocViewsVocab@nodes), selected = NULL, multiple = TRUE),
    tableOutput(outputId = "filtered_pkg_list")
  )
)
