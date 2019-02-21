### Node information ###
```cypher
CREATE CONSTRAINT ON (u:User) ASSERT u.id IS UNIQUE;
CREATE CONSTRAINT ON (t:Team) ASSERT t.id IS UNIQUE;
CREATE CONSTRAINT ON (c:TeamChatSession) ASSERT c.id IS UNIQUE;
CREATE CONSTRAINT ON (i:ChatItem) ASSERT i.id IS UNIQUE;
```

#### Clean environment ####
```cypher
match (a)-[r]->() delete a,r;
match (a) delete a;
```

#### Load file chat_create_team_chat.csv ####
```cypher
LOAD CSV FROM "file:///Volumes/JL%20Drive/IMF/bd_files/big-data-capstone/chat-data/chat_create_team_chat.csv" AS row 
MERGE (u:User {id: toInt(row[0])}) 
MERGE (t:Team {id: toInt(row[1])}) 
MERGE (c:TeamChatSession {id: toInt(row[2])}) 
MERGE (u)-[:CreatesSession{timeStamp: row[3]}]->(c) 
MERGE (c)-[:OwnedBy{timeStamp: row[3]}]->(t);
```

#### Load file chat_join_team_chat.csv ####
```cypher
LOAD CSV FROM "file:///Volumes/JL%20Drive/IMF/bd_files/big-data-capstone/chat-data/chat_join_team_chat.csv" AS row
MERGE (u:User {id: toInt(row[0])}) 
MERGE (c:TeamChatSession {id: toInt(row[1])}) 
MERGE (u)-[:Joins{timeStamp: row[2]}]->(c);
```

#### Load file chat_leave_team_chat.csv ####
```cypher
LOAD CSV FROM "file:///Volumes/JL%20Drive/IMF/bd_files/big-data-capstone/chat-data/chat_leave_team_chat.csv" AS row
MERGE (u:User {id: toInt(row[0])}) 
MERGE (c:TeamChatSession {id: toInt(row[1])}) 
MERGE (u)-[:Leaves{timeStamp: row[2]}]->(c);
```

#### Load file chat_item_team_chat.csv ####
```cypher
LOAD CSV FROM "file:///Volumes/JL%20Drive/IMF/bd_files/big-data-capstone/chat-data/chat_item_team_chat.csv" AS row
MERGE (u:User {id: toInt(row[0])}) 
MERGE (c:TeamChatSession {id: toInt(row[1])}) 
MERGE (i:ChatItem {id: toInt(row[2])})
MERGE (u)-[:CreateChat{timeStamp: row[3]}]->(i)
MERGE (i)-[:PartOf{timeStamp: row[3]}]->(c);
```

#### Load file chat_mention_team_chat.csv ####
```cypher
LOAD CSV FROM "file:///Volumes/JL%20Drive/IMF/bd_files/big-data-capstone/chat-data/chat_mention_team_chat.csv" AS row
MERGE (i:ChatItem {id: toInt(row[0])}) 
MERGE (u:User {id: toInt(row[1])}) 
MERGE (i)-[:Mentioned{timeStamp: row[2]}]->(u);
```

#### Load file chat_respond_team_chat.csv ####
```cypher
LOAD CSV FROM "file:///Volumes/JL%20Drive/IMF/bd_files/big-data-capstone/chat-data/chat_respond_team_chat.csv" AS row
MERGE (ione:ChatItem {id: toInt(row[0])}) 
MERGE (itwo:ChatItem {id: toInt(row[1])}) 
MERGE (ione)-[:ResponseTo{timeStamp: row[2]}]->(itwo);
```

#### Counting the number of nodes =  45463 ####
```cypher
match (n) return count(n);
```

#### Counting the number of edges =  118502 ####
```cypher
match (n)-[r]->() return count(r);
```

#### View part of the graph ####
```cypher
match ()-[r]->() return r limit 25;
```

#### Question 1: Find the longest conversation chain in the chat data using the "ResponseTo" edge label. This question has two parts, 1) How many chats are involved in it? , and 2) How many users participated in this chain? ####

#### Part 1 - Find the longest conversation chain ####
```cypher
match p = (ione)-[:ResponseTo*]->(itwo)
return length(p)
order by length(p) desc limit 1;
```

#### Part 2 - Find users in the longest conversation chain ####
```cypher
match p=(ione)-[:ResponseTo*9]->(itwo)
with p
match (u)-[:CreateChat]->(i)
where i in nodes(p)
return count(distinct u);
```

### Question 2: Do the top 10 the chattiest users belong to the top 10 chattiest teams? ###

#### Part 1 - Top chattiest users ####
```cypher
match (u)-[:CreateChat*]->(i)
return u.id, count(i)
order by count(i) desc limit 10;
```

#### Part 2 - Top chattiest teams ####
```cypher
match (i)-[:PartOf*]->(c)-[:OwnedBy*]->(t)
return t.id, count(c)
order by count(c) desc limit 10;
```

#### Part 3 - Results ####
```cypher
match (u)-[:CreateChat*]->(i)-[:PartOf*]->(c)-[:OwnedBy*]->(t)
return u.id, t.id, count(c)
order by count(c) desc limit 10;
```

### Question 3: How Active are Groups of Users? ###

#### Part 1 - Categorize who interacts with whom ####
```cypher
match (u1:User)-[:CreateChat]->(i)-[:Mentioned]->(u2:User)
create (u1)-[:InteractsWith]->(u2);
```
```cypher
match (u1:User)-[:CreateChat]->(i1:ChatItem)-[:ResponseTo]-(i2:ChatItem)
with u1, i1, i2
match (u2)-[:CreateChat]-(i2)
create (u1)-[:InteractsWith]->(u2);
```
```cypher
match (u1)-[r:InteractsWith]->(u1) delete r;
```

#### Part 2 - Creating the Clustering Coefficient ####
```cypher
match (u1:User)-[r1:InteractsWith]->(u2:User)
where u1.id <> u2.id
AND u1.id in [394,2067,1087,209,554,999,516,1627,461,668]
with u1, collect(u2.id) as neighbors, count(distinct(u2)) as neighborCount
match (u3:User)-[r2:InteractsWith]->(u4:User)
where (u3.id in neighbors) AND (u4.id in neighbors) AND (u3.id <> u4.id)
with u1, u3, u4, neighborCount,
case when count(r2) > 0 then 1
else 0
end as answer
return u1.id, sum(answer)*1.0/(neighborCount*(neighborCount-1)) as cte order by cte desc limit 10;
```