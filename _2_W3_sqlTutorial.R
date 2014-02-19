##############################################
# This script introduces the major SQL commands
# that can be found on W3
# demonstrating SQLite implementation in R
##############################################

library(RSQLite) # will load DBI as well
## open a connection to a MySQL database
con <- dbConnect(dbDriver("SQLite"), dbname = "testDB-Rdatasets.db")

# -----------------------------------
## explore database structure

dbListTables(con)
dbListFields(con,"mtcars")

# -----------------------------------
# SELECT
dbGetQuery(con,"select * from mtcars")

# ALTER TABLE, ADD COLUMN
dbGetQuery(con,"ALTER TABLE mtcars ADD COLUMN brand")

# SELECT DISTINCT, ORDER BY
dbGetQuery(con, "SELECT distinct cyl, gear FROM mtcars ORDER BY cyl, gear")

### WHERE
dbGetQuery(con, "SELECT * FROM mtcars WHERE cyl = 8")
# LIMIT
dbGetQuery(con, "SELECT * FROM mtcars WHERE cyl = 8 LIMIT 5")
# LIKE with different wildcard characters [more elaborate wildcards]
dbGetQuery(con, "SELECT * FROM mtcars WHERE cyl = 8 and row_names LIKE 'C%'") # % several characters after capital C
dbGetQuery(con, "SELECT * FROM mtcars WHERE cyl = 8 and row_names LIKE '%Z__'") # _ just one character
dbGetQuery(con, "SELECT * FROM mtcars WHERE cyl = 8 and (row_names LIKE 'A%' or row_names LIKE 'C%')") # Starting either with a 'A' or 'C'
# BETWEEN
dbGetQuery(con, "SELECT * FROM mtcars WHERE cyl = 8 and mpg BETWEEN 15 and 16")
# IN
dbGetQuery(con, "SELECT * FROM mtcars WHERE cyl = 8 and mpg IN (15, 15.2, 15.8)")


# INSERT INTO (WITH COL. NAMES) VALUES
dbSendQuery(con, "INSERT INTO mtcars (mpg,row_names,cyl,gear) VALUES (36, 'Subaru Impreza', 4, 5)")

# INSERT INTO (WITHOUT COL. NAMES) VALUES
dbSendQuery(con, "INSERT INTO mtcars VALUES ('Subaru Impreza Premium', 36, 4, 300,160,3.21,2.500,15.2,0,0,5,1)")
# create duplicate
dbSendQuery(con, "INSERT INTO mtcars VALUES ('Subaru Impreza Premium', 36, 4, 300,160,3.21,2.500,15.2,0,0,5,1)")
# deal with duplicates
dbWriteTable(con, "mtcars", dbGetQuery(con, "SELECT * FROM mtcars GROUP BY row_names"), overwrite = T, row.names = F)

# UPDATE ... SET
dbSendQuery(con, "UPDATE mtcars SET row_names = 'Subaru Impreza', mpg = 34, hp = 170 WHERE row_names = 'Subaru Impreza' ")
dbSendQuery(con, "UPDATE mtcars SET brand = 'Mercedes' WHERE row_names LIKE '%Merc%'")
dbSendQuery(con, "UPDATE mtcars SET brand = 'Toyota' WHERE row_names LIKE '%Toyota%'")
dbSendQuery(con, "UPDATE mtcars SET brand = 'Volvo' WHERE row_names LIKE '%Volvo%'")
dbSendQuery(con, "UPDATE mtcars SET brand = 'Hornet' WHERE row_names LIKE '%Hornet%'")
dbSendQuery(con, "UPDATE mtcars SET brand = 'Fiat' WHERE row_names LIKE '%Fiat%'")
dbSendQuery(con, "UPDATE mtcars SET brand = 'Subaru' WHERE row_names LIKE '%Subaru%'")
dbGetQuery(con,"select * from mtcars")

# DELETE FROM
dbSendQuery(con, "DELETE FROM mtcars WHERE row_names = 'Subaru Impreza'")

# CREATE TABLE
dbSendQuery(con, "CREATE TABLE test")

# aggregate, functions
dbWriteTable(con, "aggMtcars", dbGetQuery(con, "SELECT brand, avg(cyl) as averageCyl, count(*) as Ncars FROM mtcars GROUP BY brand HAVING brand IS NOT NULL "), overwrite=T, row.names = F)
dbGetQuery(con,"select * from aggMtcars")

## JOINS

# INNER JOIN
dbGetQuery(con, "SELECT m.brand, row_names, cyl, averageCyl, Ncars FROM mtcars AS m INNER JOIN aggMtcars AS a ON m.brand = a.brand")
# LEFT JOIN
dbGetQuery(con, "SELECT m.brand, row_names, cyl, averageCyl, Ncars FROM mtcars AS m LEFT JOIN aggMtcars AS a ON m.brand = a.brand")
# FULL OUTER JOIN and RIGHT JOINS are currently not supported
#dbGetQuery(con, "SELECT m.brand, row_names, cyl, averageCyl, Ncars FROM mtcars AS m FULL OUTER JOIN aggMtcars AS a ON m.brand = a.brand")
# CARTESIAN JOIN
dbGetQuery(con, "SELECT m.brand, row_names, cyl, averageCyl, Ncars FROM mtcars AS m JOIN aggMtcars")


# ------------------------------------
# close database

dbDisconnect(con)




