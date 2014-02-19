##############################################
# This script introduces some basic concepts 
# it also shows that basically the same code 
# can be used for RSQLite and MySQL databases
# it first walks through an example with 
# RSQlite and then replicates a MySQL example
##############################################


library(RSQLite) # will load DBI as well
## open a connection to a MySQL database
con <- dbConnect(dbDriver("SQLite"), dbname = "testDB-Rdatasets.db")

################################
# save internal R datasets in database

dbWriteTable(con, "iris", iris,overwrite = T)
dbWriteTable(con, "USArrests", USArrests, overwrite = T)
dbWriteTable(con, "mtcars", mtcars  ,overwrite = T)
dbWriteTable(con, "iris2", iris,overwrite = T)

################################
## explore database structure

dbListTables(con)
dbListFields(con,"iris")
dbListFields(con,"USArrests")





################################
## run queries (get and send queries)

# get query [submits a query and returns the results]
query <- "select * from iris"
dbGetQuery(con, query)
dbGetQuery(con, "select count(*) as Nrecord from iris")

# send query [just execute statement without returning anything]
query <- (
    "DELETE FROM iris
     WHERE Species = 'setosa'"
    )
dbSendQuery(con, query)




################################
## run queries (get and send queries)

dbRemoveTable(con, "iris2")
dbDisconnect(con)


#############################################################
#############################################################
# MySQL #

library(RMySQL) # will load DBI as well
## open a connection to a MySQL database (database has to exist!!)
con <- dbConnect(dbDriver("MySQL"), dbname = "testDB_Rdatasets_mysql", user="micha", password="pw")

# save internal R datasets in database
dbWriteTable(con, "iris", iris, overwrite = T)
dbWriteTable(con, "USArrests", USArrests, overwrite = T)
dbWriteTable(con, "mtcars", mtcars  ,overwrite = T)
dbWriteTable(con, "iris2", iris, overwrite = T)

################################
## explore database structure

dbListTables(con)
dbListFields(con,"iris")


################################
## run queries (get and send queries)

# get query [submits a query and returns the results]
query <- "select * from iris"
dbGetQuery(con, query)
dbGetQuery(con, "select count(*) as Nrecord from iris")

# send query [just execute statement without returning anything]
query <- (
    "DELETE FROM iris
     WHERE Species = 'setosa'"
    )
dbSendQuery(con, query)




################################
## run queries (get and send queries)

dbRemoveTable(con, "iris2")
dbDisconnect(con)
