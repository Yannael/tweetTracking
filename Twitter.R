#!/usr/bin/Rscript

require(RSQLite)
require(twitteR)
require(plyr)

#Connect using preregistered credentials
load('credentials.Rdata')
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

createTable <- function(str,table) {
  
  tweets <- searchTwitter(str, n=100)
  tweetsDF <- ldply(tweets, as.data.frame)
  
  con <- dbConnect(RSQLite::SQLite(), "twitter.db")
  dbWriteTable(con,table,tweetsDF,overwrite=T)
  dbDisconnect(con)
  
}

updateTable <- function(str,table) {
	
  lastID <- as.numeric(dbGetQuery(con, statement = paste("SELECT max(id) from ",table)))
	
  tweets <- searchTwitter(str, n=1000,sinceID=lastID)
  tweetsDF <- ldply(tweets, as.data.frame)
	
  if (nrow(tweetsDF)>0) {
    con <- dbConnect(RSQLite::SQLite(), "twitter.db")
    dbWriteTable(con, table, tweetsDF, append = T)
    dbDisconnect(con)
  }
	
}

#createTable()
updateTable("keyword","tablename")

