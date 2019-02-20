### Node information ###
u > User
t > Team
c > TeamChatSession
i > ChatItem
ione > ChatItem
itwo > ChatItem

#### Clean environment ####
match (a)-[r]->() delete a,r
match (a) delete a

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
MERGE (c:TeamChatSession {id: toInt(row[1])}) 
MERGE (u)-[:Joins{timeStamp: row[2]}]->(c) 

#### Load file chat_leave_team_chat.csv ####
LOAD CSV FROM "file:///Volumes/JL%20Drive/IMF/bd_files/big-data-capstone/chat-data/chat_leave_team_chat.csv" AS row
MERGE (u:User {id: toInt(row[0])}) 
MERGE (c:TeamChatSession {id: toInt(row[1])}) 
MERGE (u)-[:Leaves{timeStamp: row[2]}]->(c) 

#### Load file chat_item_team_chat.csv ####
LOAD CSV FROM "file:///Volumes/JL%20Drive/IMF/bd_files/big-data-capstone/chat-data/chat_item_team_chat.csv" AS row
MERGE (u:User {id: toInt(row[0])}) 
MERGE (c:TeamChatSession {id: toInt(row[1])}) 
MERGE (i:ChatItem {id: toInt(row[2])})
MERGE (u)-[:CreateChat{timeStamp: row[3]}]->(i)
MERGE (i)-[:PartOf{timeStamp: row[3]}]->(c)


#### Load file chat_mention_team_chat.csv ####
LOAD CSV FROM "file:///Volumes/JL%20Drive/IMF/bd_files/big-data-capstone/chat-data/chat_mention_team_chat.csv" AS row
MERGE (i:ChatItem {id: toInt(row[0])}) 
MERGE (u:User {id: toInt(row[1])}) 
MERGE (i)-[:Mentioned{timeStamp: row[2]}]->(u)

#### Load file chat_respond_team_chat.csv ####
LOAD CSV FROM "file:///Volumes/JL%20Drive/IMF/bd_files/big-data-capstone/chat-data/chat_respond_team_chat.csv" AS row
MERGE (ione:ChatItem {id: toInt(row[0])}) 
MERGE (itwo:ChatItem {id: toInt(row[1])}) 
MERGE (ione)-[:ResponseTo{timeStamp: row[2]}]->(itwo)

#### Counting the number of nodes =  45463 ####
match (n) return count(n)

#### Counting the number of edges =  118502 ####
match (n)-[r]->() return count(r)

#### View part of the graph ####
match ()-[r]->() return r limit 25

#### Question 1: Find the longest conversation chain in the chat data using the "ResponseTo" edge label. This question has two parts, 1) How many chats are involved in it? , and 2) How many users participated in this chain? ####

#### Part 1 ####
match p = (ione)-[:ResponseTo*]->(itwo)
return length(p)
order by length(p) desc limit 5

#### Part 2 ####
match p=(ione)-[:ResponseTo*]->(itwo)
where length(p) = 11
with p
match (u)-[r:CreateChat]->(i)
where i in nodes(p)
return count(distinct u)

### Question 2: Do the top 10 the chattiest users belong to the top 10 chattiest teams? ###

#### Part 1 ####
match (u)-[:CreateChat*]->(i)
return u.id, count(i)
order by count(i) desc limit 10

#### Part 2 ####
match (i)-[:PartOf*]->(c)-[:OwnedBy*]->(t)
return t.id, count(c)
order by count(c) desc limit 10

### Question 3: How Active are Groups of Users? ###
match (u)-[:CreateChat*]->(i)-[:PartOf*]->(c)-[:OwnedBy*]->(t)
return u.id, t.id, count(c)
order by count(c) desc limit 10


