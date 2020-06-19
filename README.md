# Automate the import of EBI datasets to OpenGWAS

To build container

```
docker build -t opengwas_ebi_import:latest .
```

Cron:

```
0 1 * * * /import.sh
```