use stackoverflow;

CALL `stackoverflow`.`denormalizeComments`(1);

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `denormalizeComments`(IN postId int)
BEGIN
SELECT postId, JSON_OBJECT('Id', Id, 'PostId', PostId, 'Score', Score, 'Text', Text, 'CreationDate', CreationDate, 'UserId', UserId)
AS Com 
FROM comments WHERE comments.PostId = postId;
END$$
DELIMITER ;