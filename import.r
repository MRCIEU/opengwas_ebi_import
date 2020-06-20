#!/usr/bin/env Rscript

library(GwasDataImport)

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

wd <- scriptdir()

ignore_file <- file.path(wd, "ignorelist.txt")

# Get list of files
if(file.exists(ignore_file))
{
	ignore_list <- scan(ignore_file, what="character")
} else {
	ignore_list <- c()
}
newdats <- determine_new_datasets(blacklist=ignore_list)
newdats <- being_processed(newdats) %>% subset(., need)
print(newdats)

ignore <- list()
for(i in 1:nrow(newdats))
{
	message(newdats$ebi_id[i])
	x <- EbiDataset$new(
		ebi_id = newdats$ebi_id[i], 
		ftp_path = newdats$path[i]
	)
	o <- x$pipeline()
	if(! "NULL" %in% class(o))
	{
		ignore[[newdats$ebi_id[i]]] <- o
	}
	rm(x)
}

ignore <- unlist(ignore)
newignore <- unique(c(ignore, ignore_list))
write.table(newignore, file=ignore_file, row=F, col=F, qu=F)
