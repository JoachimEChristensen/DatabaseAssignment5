USE `stackoverflow`;

/* Excercise 1 */
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

/* call below to show the data and remember to input the ID you want
CALL `stackoverflow`.`denormalizeComments`(<{IN postsID INT}>);
select Comments from posts;
*/


/* Excercise 2 */
DROP trigger IF EXISTS after_comments_insertion;

DELIMITER $$
CREATE TRIGGER after_comments_insertion 
AFTER INSERT ON comments
FOR EACH ROW
BEGIN 
call denormalizeComments(NEW.PostId);
END$$
DELIMITER ;

/* call below to show the trigger
show triggers;
*/

/* Excercise 3 */
DROP procedure IF EXISTS `add_NewComment`;

DELIMITER $$
CREATE PROCEDURE `add_NewComment` (IN postsID INT, postsScore INT, postsText TEXT, usersID INT)
BEGIN
insert into comments (Id, PostId, Score, Text, CreationDate, UserId) 
values (postsID, postsScore, postsText, NOW(), usersID);
END$$
DELIMITER ;

/* call below to run this stored procedure and remember to input all values, fx: CALL `stackoverflow`.`add_NewComment`(1,0,"some texts to save",1)
CALL `stackoverflow`.`add_NewComment`(<{IN postsID INT}>, <{postsScore INT}>, <{postsText TEXT}>, <{usersID INT}>);
*/

/* Excercise 4 */
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

/* call below to show the materialized view and change the limit to see more rows
SELECT * FROM stackoverflow.qna_view
limit 5;

/* Excercise 5 */
DROP procedure IF EXISTS `match_posts`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `match_posts`(keyword Text)
BEGIN
select * from questions_answeres where Text in (select Text->'$.text'='%keyword%'
AND Text->'$.text'>=1); 
END$$
DELIMITER ;

DROP procedure IF EXISTS `match_comments`;
DELIMITER $$
CREATE PROCEDURE `match_comments` (keyword Text)
BEGIN
select * from add_view where jsonObject->'$.text'='%keyword%'>=2;
END$$
DELIMITER ;

/* call below to show the matching posts or comments
call parameterkeyword("keyword");
call postskeyword("keyword")
*/