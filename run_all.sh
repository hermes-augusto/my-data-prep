#!/bin/bash

# =========================
# CONFIG
# =========================
HOST="db"
PORT="5432"
USER="postgres"
DB="datawarehouse"

# Se quiser evitar prompt de senha:
export PGPASSWORD="password123"

echo "===> Executando OLTP..."

psql -h $HOST -p $PORT -U $USER -d $DB -f db-scripts/oltp/create_schemas.sql
psql -h $HOST -p $PORT -U $USER -d $DB -f db-scripts/oltp/script-ddl-oltp.sql
psql -h $HOST -p $PORT -U $USER -d $DB -f db-scripts/oltp/constraint.sql
psql -h $HOST -p $PORT -U $USER -d $DB -f db-scripts/oltp/insert_data.sql

echo "===> Executando DW..."

psql -h $HOST -p $PORT -U $USER -d $DB -f db-scripts/dw/ddl-dw.sql

echo "===> Carga inicial..."

psql -h $HOST -p $PORT -U $USER -d $DB -f db-scripts/dw/etl-dw-carga-inicial.sql

echo "===> ETL incremental..."

psql -h $HOST -p $PORT -U $USER -d $DB -f db-scripts/dw/etl-script.sql

echo "===> Validação..."

psql -h $HOST -p $PORT -U $USER -d $DB -f db-scripts/dw/querys_validacao.sql

echo "===> Concluído com sucesso."