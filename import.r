#!/usr/bin/env Rscript

library(GwasDataImport)
library(dplyr)
library(data.table)

thisFile <- function() {
	cmdArgs <- commandArgs(trailingOnly = FALSE)
	needle <- "--file="
	match <- grep(needle, cmdArgs)
	if (length(match) > 0) {
		# Rscript
		return(normalizePath(sub(needle, "", cmdArgs[match])))
	} else {
		# 'source'd via R console
		return(normalizePath(sys.frames()[[1]]$ofile))
	}
}

scriptdir <- function()
{
	thisfile <- thisFile()
	return(dirname(thisfile))
}

update_ignore_list <- function(ignore_list, newid, filename)
{
	n <- tibble(id=newid, date=as.character(Sys.time()))
	ignore_list <- bind_rows(ignore_list, n)
	write.table(ignore_list, file=filename, row=F, col=TRUE, qu=TRUE, sep=",")
	return(ignore_list)
}

wd <- scriptdir()
dir.create(file.path(wd, "processing"))

ignore_file <- file.path(wd, "ignorelist.txt")

# Get list of files
if(file.exists(ignore_file))
{
	message("Loading ignore list")
	ignore_list <- fread(ignore_file)
} else {
	ignore_list <- data.frame(id=NULL, date=NULL)
}
newdats <- determine_new_datasets(blacklist=ignore_list$id)
newdats <- being_processed(newdats) %>% subset(., need)
print(newdats)

for(i in 1:nrow(newdats))
{
	message(newdats$ebi_id[i])
	x <- EbiDataset$new(
		ebi_id = newdats$ebi_id[i], 
		ftp_path = newdats$path[i],
		wd = file.path(wd, "processing", newdats$ebi_id[i])
	)
	o <- x$pipeline()
	if(! "NULL" %in% class(o))
	{
		message("Adding ignoring ", o, " to ignore list")
		ignore_list <- update_ignore_list(ignore_list, o, ignore_file)
	}
	rm(x)
}
