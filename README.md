# graph-cluster-demo
TheGraphクラスタリング構成のデモンストレーション。

前提としてGraphノードは

- API専用
- インデクシング専用
- クエリ専用
- あるいはそれら全て

どの役割でもこなせるので[assets/graph.toml](assets/graph.toml)を用いて各ノードの挙動を制御する事でクラスタリングを行うという仕様である。


## コンテナ一覧
| コンテナ | 役割 
| --- | --- |
| db-writer | データベースのライターノード |
| db-replica01 | データベースのレプリカノード |
| ipfs | サブグラフのマニフェストファイル等を保存するIPFSノード |
| graph-api | サブグラフデプロイ専用APIノード <br /> インデクサーノード/クエリ専用ノードでも良いが構成パターン紹介として用意 |
| graph-indexer01 | インデクシング用ノード1(クエリも可能) |
| graph-indexer02 | インデクシング用ノード2(クエリも可能) |
| graph-query01 | クエリ専用ノード1(インデクシングも可能) |
| graph-query02 | クエリ専用ノード2(インデクシングも可能) |


## 起動手順
DBライターノードを起動。初期化時に`assets/00_init.sql`が実行される。
```shell
docker-compose up db-writer
```

10秒ほど待ってからDBレプリカノードを起動。自動でdb-writerとのレプリケーションが開始される。
```shell
docker-compose up db-replica01
```

IPFSノードを起動。
```shell
docker-compose up ipfs
```

グラフAPIノードを起動。数十秒待つとデータベースのマイグレーション処理が行われ利用可能な状態となる。
```shell
docker-compose up graph-api
```

グラフインデクサーノードを起動。
```shell
docker-compose up graph-indexer01 graph-indexer02
```

グラフクエリ専用ノードを起動。
```shell
docker-compose up graph-query01 graph-query02
```


## エンドポイント一覧
| 対象コンテナ | 用途 | URL |
| --- | --- | --- |
| ipfs | サブグラフのデプロイ | http://127.0.0.1:5001 |
| graph-api | サブグラフのデプロイ | http://127.0.0.1:8020 |
| graph-api | GraphQL | http://127.0.0.1:8000/subgraphs/name/{SUBGRAPH_NAME} |
| graph-query01 | GraphQL | http://127.0.0.1:8001/subgraphs/name/{SUBGRAPH_NAME} |
| graph-query01 | GraphQL | http://127.0.0.1:8002/subgraphs/name/{SUBGRAPH_NAME} |


## 参考：公式ドキュメント
| 説明 | URL |
| --- | --- |
| グラフノードの設定ファイルドキュメント | https://github.com/graphprotocol/graph-node/blob/master/docs/config.md |
| グラフノードで利用可能な環境変数 | https://github.com/graphprotocol/graph-node/blob/master/docs/environment-variables.md |
