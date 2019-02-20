#### Load file chat_create_team_chat.csv ####
LOAD CSV FROM "file:///Volumes/JL%20Drive/IMF/bd_files/big-data-capstone/chat-data/chat_create_team_chat.csv" AS row 
MERGE (u:User {id: toInt(row[0])}) 
MERGE (t:Team {id: toInt(row[1])}) 
MERGE (c:TeamChatSession {id: toInt(row[2])}) 
MERGE (u)-[:CreatesSession{timeStamp: row[3]}]->(c) 
MERGE (c)-[:OwnedBy{timeStamp: row[3]}]->(t)

#### Load file chat_join_team_chat.csv ####
LOAD CSV FROM "file:///Volumes/JL%20Drive/IMF/bd_files/big-data-capstone/chat-data/chat_join_team_chat.csv" AS row
MERGE (u:User {id: toInt(row[0])}) 
MERGE (t:TeamChatSession {id: toInt(row[1])}) 
MERGE (u)-[:Join {timeStamp: row[2]}]->(t) 

#### Load file chat_leave_team_chat.csv ####
LOAD CSV FROM "file:///Volumes/JL%20Drive/IMF/bd_files/big-data-capstone/chat-data/chat_leave_team_chat.csv" AS row
MERGE (u:User {id: toInt(row[0])}) 
MERGE (t:TeamChatSession {id: toInt(row[1])}) 
MERGE (u)-[:Leaves {timeStamp: row[2]}]->(t) 

#### Load file chat_item_team_chat.csv ####
LOAD CSV FROM "file:///Volumes/JL%20Drive/IMF/bd_files/big-data-capstone/chat-data/chat_item_team_chat.csv" AS row
MERGE (u:User {id: toInt(row[0])}) 
MERGE (t:TeamChatSession {id: toInt(row[1])}) 
MERGE (c:ChatItem {id: toInt(row[2])}) 
MERGE (c)-[:PartOf {timeStamp: row[3]}]->(t)
MERGE (u)-[:CreateChat {timeStamp: row[3]}]->(t)

#### Load file chat_mention_team_chat.csv ####
LOAD CSV FROM "file:///Volumes/JL%20Drive/IMF/bd_files/big-data-capstone/chat-data/chat_mention_team_chat.csv" AS row
MERGE (c:ChatItem {id: toInt(row[0])}) 
MERGE (u:User {id: toInt(row[1])}) 
MERGE (c)-[:Mentioned {timeStamp: row[2]}]->(u)

#### Load file chat_respond_team_chat.csv ####
LOAD CSV FROM "file:///Volumes/JL%20Drive/IMF/bd_files/big-data-capstone/chat-data/chat_respond_team_chat.csv" AS row
MERGE (c:ChatItem1 {id: toInt(row[0])}) 
MERGE (u:ChatItem2 {id: toInt(row[1])}) 
MERGE (c)-[:ResponseTo {timeStamp: row[2]}]->(u)

#### Counting the number of nodes =  45463 ####
match (n) return count(n)

#### Counting the number of edges =  118502 ####
match (n)-[r]->() return count(r)
