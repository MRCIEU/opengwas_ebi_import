library(GwasDataImport)

print(getwd())

# Get list of files
ignore_list <- scan("ignorelist.txt")
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
write.table(newignore, file="ignorelist.txt", row=F, col=F, qu=F)
