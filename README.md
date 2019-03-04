# DatabaseAssignment5

## Before all
Run the script 'stackoverflow.sql' and remember to change some of the codes depends on your operating system.

### For macOS only
1. Create a my.cnf file with the following statements: <br/>
[client] <br/>
port		= 3306 <br/>
[mysqld] <br/>
port		= 3306 <br/>
secure_file_priv='' <br/>
local-infile = 1 <br/>
2. Set the my.cnf file as the default configuration file
3. Restart the MySQL server
4. Move the folder you unzip from 7z file into the ***/tmp*** folder

### For Windows only
Just move the files you unzip from 7z file into ***C:/ProgramData/MySQL/MySQL Server 8.0/Uploads*** folder (**ONLY files not folder**)

## Excercise
More details about how to call the code are described in 'Assignment_5_Excercises.sql' file.

#### Excercise 1
```
DROP procedure IF EXISTS `denormalizeComments`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `denormalizeComments`(IN postsID INT)
BEGIN
update posts set Comments = (select JSON_ARRAYAGG(Text) 
from comments where PostId = postsID 
group by PostId) 
where Id = postsID;
END$$
DELIMITER ;
```

#### Excercise 2
```
DROP trigger IF EXISTS after_comments_insertion;

DELIMITER $$
CREATE TRIGGER after_comments_insertion 
AFTER INSERT ON comments
FOR EACH ROW
BEGIN 
call denormalizeComments(NEW.PostId);
END$$
DELIMITER ;
```

#### Excercise 3
```
DROP procedure IF EXISTS `add_NewComment`;

DELIMITER $$
CREATE PROCEDURE `add_NewComment` (IN postsID INT, postsScore INT, postsText TEXT, usersID INT)
BEGIN
insert into comments (PostId, Score, Text, CreationDate, UserId) 
values (postsID, postsScore, postsText, NOW(), usersID);
END$$
DELIMITER ;
```

#### Excercise 4
```
DROP table IF EXISTS questions_answeres;
create table questions_answeres(
 Id INT NOT NULL PRIMARY KEY,
 Text JSON
);

DROP procedure IF EXISTS `add_QnA_view`;
DELIMITER $$
CREATE PROCEDURE `add_QnA_view` ()
BEGIN
insert into questions_answeres (Text) values 
((select JSON_OBJECT("Name", users.DisplayName, "Score", posts.Score, "Body",JSON_ARRAYAGG(posts.Body)) as jsonObject
from posts, users, comments 
where UserId = users.Id AND posts.Id = PostId 
group by users.Id));
END$$
DELIMITER ;

DROP view IF EXISTS `QnA_view`;
CREATE  OR REPLACE VIEW `QnA_view` AS
select JSON_OBJECT("Name", users.DisplayName, "Score", posts.Score, "Body",JSON_ARRAYAGG(posts.Body)) as jsonObject
from posts, users, comments 
where UserId = users.Id AND posts.Id = PostId 
group by users.Id;

/* trigger that updates the material view on demand */
DROP trigger IF EXISTS add_view; 
DELIMITER $$
CREATE TRIGGER add_view 
AFTER UPDATE ON posts
FOR EACH ROW
BEGIN 
call add_QnA_view(); 
END$$
DELIMITER ;
```

#### Excercise 5
```
TODO
```
