-- sports day CRICKET MATCH
CREATE DATABASE CRICKET;
USE CRICKET;
-- Table: Teams
CREATE TABLE Teams (
    TeamID INT PRIMARY KEY AUTO_INCREMENT,
    TeamName VARCHAR(50) NOT NULL,
    CoachName VARCHAR(50)
);

-- Table: Players
CREATE TABLE Players (
    PlayerID INT PRIMARY KEY AUTO_INCREMENT,
    PlayerName VARCHAR(50) NOT NULL,
    TeamID INT,
    Role VARCHAR(20),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);

-- Table: Matches
CREATE TABLE Matches (
    MatchID INT PRIMARY KEY AUTO_INCREMENT,
    MatchDate DATE,
    TeamA_ID INT,
    TeamB_ID INT,
    TeamA_Score INT,
    TeamB_Score INT,
    WinnerTeamID INT,
    FOREIGN KEY (TeamA_ID) REFERENCES Teams(TeamID),
    FOREIGN KEY (TeamB_ID) REFERENCES Teams(TeamID),
    FOREIGN KEY (WinnerTeamID) REFERENCES Teams(TeamID)
);

-- Table: Stats
CREATE TABLE Stats (
    StatID INT PRIMARY KEY AUTO_INCREMENT,
    MatchID INT,
    PlayerID INT,
    Runs INT DEFAULT 0,
    Wickets INT DEFAULT 0,
    Assists INT DEFAULT 0,
    FOREIGN KEY (MatchID) REFERENCES Matches(MatchID),
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID)
);
-- Teams
INSERT INTO Teams (TeamName, CoachName) VALUES
('Titans', 'Coach A'),
('Warriors', 'Coach B');
-- TEAM A
INSERT INTO Players (PlayerName, TeamID, Role) VALUES
('Alice', 1, 'Batsman'),
('Bob', 1, 'Bowler'),
('Chris', 1, 'Allrounder'),
('Dylan', 1, 'Wicket Keeper'),
('Evan', 1, 'Bowler'),
('Frank', 1, 'Batsman'),
('George', 1, 'Allrounder'),
('Harry', 1, 'Bowler'),
('Ivan', 1, 'Batsman'),
('Jack', 1, 'Allrounder'),
('Kevin', 1, 'Bowler');
--- TEAM B
INSERT INTO Players (PlayerName, TeamID, Role) VALUES
('Liam', 2, 'Batsman'),
('Noah', 2, 'Bowler'),
('Oscar', 2, 'Allrounder'),
('Paul', 2, 'Wicket Keeper'),
('Quinn', 2, 'Bowler'),
('Ryan', 2, 'Batsman'),
('Steve', 2, 'Allrounder'),
('Tom', 2, 'Bowler'),
('Umair', 2, 'Batsman'),
('Victor', 2, 'Allrounder'),
('Will', 2, 'Bowler');
-- Matches
INSERT INTO Matches (MatchDate, TeamA_ID, TeamB_ID, TeamA_Score, TeamB_Score, WinnerTeamID) VALUES
('2025-07-10', 1, 2, 180, 175, 1),
('2025-07-12', 2, 1, 160, 165, 1);
-- Stats
INSERT INTO Stats (MatchID, PlayerID, Runs, Wickets, Assists) VALUES
(1, 1, 75, 0, 1),
(1, 2, 10, 2, 0),
(1, 3, 60, 1, 2),
(2, 4, 55, 0, 0),
(2, 1, 50, 0, 1),
(2, 2, 15, 3, 0);
-- All Match Results
SELECT MatchID, MatchDate, 
       T1.TeamName AS TeamA, T2.TeamName AS TeamB, 
       TeamA_Score, TeamB_Score, 
       TW.TeamName AS Winner
FROM Matches
JOIN Teams T1 ON Matches.TeamA_ID = T1.TeamID
JOIN Teams T2 ON Matches.TeamB_ID = T2.TeamID
JOIN Teams TW ON Matches.WinnerTeamID = TW.TeamID;

-- Player Performance in a Match
SELECT P.PlayerName, M.MatchDate, S.Runs, S.Wickets, S.Assists
FROM Stats S
JOIN Players P ON S.PlayerID = P.PlayerID
JOIN Matches M ON S.MatchID = M.MatchID
WHERE M.MatchID = 1;
-- Player Leaderboard by Runs
CREATE VIEW PlayerLeaderboard AS
SELECT P.PlayerName, T.TeamName, SUM(S.Runs) AS TotalRuns, SUM(S.Wickets) AS TotalWickets
FROM Stats S
JOIN Players P ON S.PlayerID = P.PlayerID
JOIN Teams T ON P.TeamID = T.TeamID
GROUP BY P.PlayerID
ORDER BY TotalRuns DESC;
-- Team Points Table
CREATE VIEW TeamPoints AS
SELECT T.TeamName,
       COUNT(M.MatchID) AS MatchesPlayed,
       SUM(CASE WHEN M.WinnerTeamID = T.TeamID THEN 1 ELSE 0 END) AS Wins,
       SUM(CASE WHEN M.WinnerTeamID != T.TeamID THEN 1 ELSE 0 END) AS Losses,
       SUM(CASE WHEN M.WinnerTeamID = T.TeamID THEN 2 ELSE 0 END) AS Points
FROM Teams T
LEFT JOIN Matches M ON T.TeamID IN (M.TeamA_ID, M.TeamB_ID)
GROUP BY T.TeamID;
-- Average Runs & Wickets using CTE
WITH PlayerAvg AS (
  SELECT P.PlayerID, P.PlayerName, AVG(S.Runs) AS AvgRuns, AVG(S.Wickets) AS AvgWickets
  FROM Stats S
  JOIN Players P ON S.PlayerID = P.PlayerID
  GROUP BY P.PlayerID
)
SELECT * FROM PlayerAvg;
-- Team-wise Total Runs and Wickets
SELECT T.TeamName, SUM(S.Runs) AS TeamRuns, SUM(S.Wickets) AS TeamWickets
FROM Stats S
JOIN Players P ON S.PlayerID = P.PlayerID
JOIN Teams T ON P.TeamID = T.TeamID
GROUP BY T.TeamID;


