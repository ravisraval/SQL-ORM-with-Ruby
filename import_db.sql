DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname STRING,
  lname STRING
);

INSERT INTO
  users (fname, lname)
VALUES
  ("Ned", "Ruggeri"), ("Kush", "Patel"), ("Earl", "Cat");


DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title STRING,
  body STRING,
  author_id INTEGER,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO
  questions (title, body, author_id)
VALUES
  ("Halp", "I am stupid how do i fix this", 2),
  ("sdfasdf", "ow do i fix this", 2),
  ("Haasdfasdflp", "I am  do i fix this", 2);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)

);

INSERT INTO
  question_follows(question_id, user_id)
VALUES
  (1, 2), (1, 3);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  subject_question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body STRING NOT NULL, --TEXT? SAME THING

  FOREIGN KEY (subject_question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)

);

INSERT INTO
  replies(subject_question_id, parent_id, user_id, body)
VALUES
  (1, NULL, 2, "WHY I STILL DONT GET"),
  (1, 1, 2, "UR DUMB");
  (1, 1, 3, "NO U!");


DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  likes BOOLEAN DEFAULT 0,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)

);

INSERT INTO
  question_likes(likes, user_id, question_id)
VALUES
  (4, 1, 2),
  (100, 2, 1);
