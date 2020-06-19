# Automate the import of EBI datasets to OpenGWAS

To build container

```
docker build -t opengwas_ebi_import:latest .
docker run -d --name opengwas_ebi_import -e PASSWORD=1234 -p8787:8787 opengwas_ebi_import:latest
```


## Cron:

Every dat at 1am:

```
0 1 * * * /import.sh
```

