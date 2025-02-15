require(RMySQL)

get_tab <- function (uid = input$uid,
                     password = input$password,
                     host,
                     dbname,
                     tabname) {
  samplecon <- dbConnect(
    dbDriver("MySQL"),
    user = uid,
    # "root"
    password = pw,
    host = host,
    dbname = dbname,
    #for real d3:
    # port=8100
    #for local test:
    options = list(local_infile = TRUE)
  )

  output <- dbGetQuery(samplecon, paste("select * from", tabname))
  dbDisconnect(samplecon)
  return(output)
}
