CREATE TABLE "buyclicks" (
	timestamp TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	"txId" INTEGER NOT NULL, 
	"userSessionId" INTEGER NOT NULL, 
	team INTEGER NOT NULL, 
	"userId" INTEGER NOT NULL, 
	"buyId" INTEGER NOT NULL, 
	price FLOAT NOT NULL
);

CREATE TABLE "gameclicks" (
	timestamp TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	"clickId" INTEGER NOT NULL, 
	"userId" INTEGER NOT NULL, 
	"userSessionId" INTEGER NOT NULL, 
	"isHit" INTEGER NOT NULL, 
	"teamId" INTEGER NOT NULL, 
	"teamLevel" INTEGER NOT NULL
);

delete from buyclicks;
delete from gameclicks;

COPY buyclicks FROM '/home/cloudera/Downloads/big-data-3/postgres/buy-clicks.csv' DELIMITER ',' CSV HEADER;
COPY gameclicks FROM '/home/cloudera/Downloads/big-data-3/postgres/game-clicks.csv' DELIMITER ',' CSV HEADER;
