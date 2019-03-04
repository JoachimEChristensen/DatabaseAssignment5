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
insert into comments (PostId, Score, Text, CreationDate, UserId) 
values (postsID, postsScore, postsText, NOW(), usersID);
END$$
DELIMITER ;

/* call below to run this stored procedure and remember to input all values, fx: CALL `stackoverflow`.`add_NewComment`(1,0,"some texts to save",1)
CALL `stackoverflow`.`add_NewComment`(<{IN postsID INT}>, <{postsScore INT}>, <{postsText TEXT}>, <{usersID INT}>);
*/

/* Excercise 4 */


/* Excercise 5 */