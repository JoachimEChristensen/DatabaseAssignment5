CREATE DEFINER=`root`@`localhost` PROCEDURE `denormalizeComments`(IN postsID INT)
BEGIN
select posts.Id, JSON_ARRAYAGG(commentArray) as commentArrays
from posts
inner join(select PostId, JSON_OBJECT('CommentId', Id, 'PostId', PostId, 'Score', Score, 'Text', Text, 'CreationDate', CreationDate, 'UserId', UserId)
as commentArray from comments) as comment_table on posts.Id = comment_table.PostId
where postsID = comment_table.PostId;
END
