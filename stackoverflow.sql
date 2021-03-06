drop database if exists stackoverflow;
create database stackoverflow DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
use stackoverflow;

drop table if exists badges;
create table badges (
  Id INT NOT NULL PRIMARY KEY,
  UserId INT,
  Name VARCHAR(50),
  Date DATETIME
);
drop table if exists comments;
CREATE TABLE comments (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    PostId INT NOT NULL,
    Score INT NOT NULL DEFAULT 0,
    Text TEXT,
    CreationDate DATETIME,
    UserId INT 
);
drop table if exists post_history;
CREATE TABLE post_history (
    Id INT NOT NULL PRIMARY KEY,
    PostHistoryTypeId SMALLINT NOT NULL,
    PostId INT NOT NULL,
    RevisionGUID VARCHAR(36),
    CreationDate DATETIME,
    UserId INT,
    Text TEXT
);
drop table if exists post_links;
CREATE TABLE post_links (
  Id INT NOT NULL PRIMARY KEY,
  CreationDate DATETIME DEFAULT NULL,
  PostId INT NOT NULL,
  RelatedPostId INT NOT NULL,
  LinkTypeId INT DEFAULT NULL
);
drop table if exists posts;
CREATE TABLE posts (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    PostTypeId SMALLINT,
    AcceptedAnswerId INT,
    ParentId INT,
    Score INT NULL,
    ViewCount INT NULL,
    Body text NULL,
    OwnerUserId INT,
    OwnerDisplayName VARCHAR(256),
    LastEditorUserId INT,
    LastEditDate DATETIME,
    LastActivityDate DATETIME,
    Title VARCHAR(256),
    Tags VARCHAR(256),
    AnswerCount INT DEFAULT 0,
    CommentCount INT DEFAULT 0,
    FavoriteCount INT DEFAULT 0,
    CreationDate DATETIME
);
drop table if exists tags;
CREATE TABLE tags (
  Id INT NOT NULL PRIMARY KEY,
  TagName VARCHAR(50) CHARACTER SET latin1 DEFAULT NULL,
  Count INT DEFAULT NULL,
  ExcerptPostId INT DEFAULT NULL,
  WikiPostId INT DEFAULT NULL
);
drop table if exists users;
CREATE TABLE users (
    Id INT NOT NULL PRIMARY KEY,
    Reputation INT NOT NULL,
    CreationDate DATETIME,
    DisplayName VARCHAR(50) NULL,
    LastAccessDate  DATETIME,
    Views INT DEFAULT 0,
    WebsiteUrl VARCHAR(256) NULL,
    Location VARCHAR(256) NULL,
    AboutMe TEXT NULL,
    Age INT,
    UpVotes INT,
    DownVotes INT,
    EmailHash VARCHAR(32)
);
drop table if exists votes;
CREATE TABLE votes (
    Id INT NOT NULL PRIMARY KEY,
    PostId INT NOT NULL,
    VoteTypeId SMALLINT,
    CreationDate DATETIME
);

/*run this if using macOS*/
load xml infile '/tmp/stackoverflow/Badges.xml'
into table badges
rows identified by '<row>';

load xml infile '/tmp/stackoverflow/Comments.xml'
into table comments
rows identified by '<row>';

load xml infile '/tmp/stackoverflow/PostHistory.xml'
into table post_history
rows identified by '<row>';

load xml infile '/tmp/stackoverflow/PostLinks.xml'
into table post_links
rows identified BY '<row>';

load xml infile '/tmp/stackoverflow/Posts.xml'
into table posts
rows identified by '<row>';

load xml infile '/tmp/stackoverflow/Tags.xml'
into table tags
rows identified BY '<row>';

load xml infile '/tmp/stackoverflow/Users.xml'
into table users
rows identified by '<row>';

load xml infile '/tmp/stackoverflow/Votes.xml'
into table votes
rows identified by '<row>';

/* if using windows, run below code instead
SET GLOBAL local_infile = 1;
load xml infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Badges.xml' 
into table badges; 
rows identified by '<row>';

load xml infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Comments.xml' 
into table comments; 
rows identified by '<row>';

load xml infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/PostHistory.xml' 
into table post_history; 
rows identified by '<row>';

load xml infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/PostLinks.xml' 
into table post_links; 
rows identified by '<row>';

load xml infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Posts.xml' 
into table posts; 
rows identified by '<row>';

load xml infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Tags.xml' 
into table tags; 
rows identified by '<row>';

load xml infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Users.xml' 
into table users; 
rows identified by '<row>';

load xml infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Votes.xml' 
into table votes; 
rows identified by '<row>';
*/

create index badges_idx_1 on badges(UserId);

create index comments_idx_1 on comments(PostId);
create index comments_idx_2 on comments(UserId);

create index post_history_idx_1 on post_history(PostId);
create index post_history_idx_2 on post_history(UserId);

create index posts_idx_1 on posts(AcceptedAnswerId);
create index posts_idx_2 on posts(ParentId);
create index posts_idx_3 on posts(OwnerUserId);
create index posts_idx_4 on posts(LastEditorUserId);

create index votes_idx_1 on votes(PostId);

ALTER TABLE `stackoverflow`.`posts`
ADD COLUMN `Comments` JSON NULL AFTER `CreationDate`;