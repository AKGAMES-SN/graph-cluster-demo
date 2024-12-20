-- レプリケーション用ユーザを作成
CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'password';
SELECT PG_CREATE_PHYSICAL_REPLICATION_SLOT('replication_slot');

-- Graph用ユーザを作成
CREATE ROLE graph_user WITH CREATEDB LOGIN PASSWORD 'graph_password';

-- Graph用データベースを作成
CREATE DATABASE graph OWNER=graph_user TEMPLATE=template0 ENCODING='UTF8' LC_COLLATE='C' LC_CTYPE='C';

-- Graphが必要とする拡張機能を有効化
\c graph
CREATE EXTENSION pg_trgm;
CREATE EXTENSION pg_stat_statements;
CREATE EXTENSION btree_gist;
CREATE EXTENSION postgres_fdw;
GRANT USAGE ON FOREIGN DATA wrapper postgres_fdw TO graph_user;
