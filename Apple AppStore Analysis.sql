CREATE TABLE AppleStore_Description_Combined AS 

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4;

/* EXPLORATORY DATA ANALYSIS */

-- check the number of unique Apps in both tables 

SELECT COUNT(DISTINCT id) AS UniqueAppID
FROM AppleStore;

SELECT COUNT(DISTINCT id) AS UniqueAppID
FROM AppleStore_Description_Combined;

-- check for any missing values in some of the key fields of the tableAppleStore

SELECT COUNT(*) AS MissingValue
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL;

SELECT COUNT(*) AS MissingValue
FROM AppleStore_Description_Combined
WHERE track_name IS NULL OR app_desc IS NULL; 


-- Find out the number of apps per genre

SELECT
    prime_genre,
    COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC;

-- Get an overview of the app ratings

SELECT
    MIN(user_rating) AS MinUserRating,
    MAX(user_rating) AS MaxUserRating,
    AVG(user_rating) AS AvgUserRating
FROM AppleStore;
    
/* FINDING INSIGHTS */

-- determine whether paid apps have higher ratings than free apps

SELECT 
    CASE 
	    WHEN price > 0 THEN 'Paid'
	    ELSE 'Free' END AS AppType,
    AVG(user_rating) AS AvgUserRating
FROM AppleStore
GROUP BY AppType;

-- check if apps with more supported languages have higher ratings

SELECT 
    CASE 
	    WHEN lang_num < 10 THEN 'Less than 10 languages'
	    WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
	    ELSE 'More than 30 languages' END AS LanguageBucket,
    AVG(user_rating) AS AvgUserRating
FROM AppleStore
GROUP BY LanguageBucket
ORDER BY AvgUserRating DESC;

-- check genres with low ratings 

SELECT
    prime_genre,
    AVG(user_rating) AS AvgUserRating
FROM AppleStore
GROUP BY prime_genre
ORDER BY AvgUserRating ASC
LIMIT 10;

-- check if there is correlation between the app description length and the user ratings 

SELECT
    CASE 
	    WHEN LENGTH(B.app_desc) < 500 THEN 'Short'
	    WHEN LENGTH(B.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
	    ELSE 'Long' END AS DescriptionLengthBucket,
    AVG(user_rating) AS AvgUserRating
FROM
    AppleStore AS A
JOIN
    AppleStore_Description_Combined AS B 
ON
    A.id = B.id
GROUP BY DescriptionLengthBucket
ORDER BY AvgUserRating DESC;

-- check top rated apps per genre

SELECT
    prime_genre,
    track_name,
    user_rating
FROM (
  SELECT
      prime_genre,
      track_name,
      user_rating,
      RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS AppRank
  FROM 
      AppleStore
  ) AS RankingApps
WHERE RankingApps.AppRank = 1;






