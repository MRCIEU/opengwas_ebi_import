# Automate the import of EBI datasets to OpenGWAS

To build container

```
docker build -t opengwas_ebi_import:latest .
```

To run

```
docker run -d --name opengwas_ebi_import -e PASSWORD=1234 -p 8787:8787 -v $(pwd):/app opengwas_ebi_import:latest
```
