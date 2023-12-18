# Apple-AppStore-SQL-Project
A comprehensive analysis on what kind of app to build on Apple AppStore

<img src="https://github.com/Khalih-01/Apple-AppStore-SQL-Project/blob/main/Images/Intro_image.png"/>


## Introduction
This project aims to derives insights from Apple AppStore data in order to make informed decisions like identifying popular app categories, determining pricing strategies, and optimizing user ratings for successful app development.

## Problem Statement
An aspiring app developer who needs data-driven insights to decide what type of app to build on the AppStore is seeking answers to the following questions;
- What app categories are most popular ?
- Should a price be set ?
- How can user ratiings be maximised ?

## Skills Demonstrated
Exploratory Data Analysis(EDA), Analytical thinking, Data exploration

## Data Sourcing 
Data was sourced from kaggle ([Download Here](https://www.kaggle.com/datasets/gauthamp10/apple-appstore-app)), It covers information about apps availaable on the Apple Store. 

The dataset consists of two csv files;
- appleStore.csv
- applestore_description.csv

## Analysis
I took advantage of a fantastic online resource called [SQLiteonline.com](https://sqliteonline.com/), this tool allows me to work directly with our data online no installations required, all i need to do is upload the data and start working with it straight away running SQL queries on the browser. However, there is one limitation I needed to work around, SQLite online.com allows us to upload files with a maximum size of 4 megabytes (4MB) and the dataset i am using is larger than this limit so what i have done is to split our large csv file into four smalller files each under the 4MB limit and upload those separately.

![SQLiteonline.com](https://github.com/Khalih-01/Apple-AppStore-SQL-Project/blob/main/Images/SQLiteonline.com.png)

SQL has a powerful feature known as UNION ALL which allows us to seamlessly combine our four separate tables back into a single one right within SQLiteonline.com

```sql
CREATE TABLE AppleStore_Description_Combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4
```

After importing the data, I explored the data in order to understand the characteristics of the data and often reveals issues in the data like missing or inconsistent data, errors or outliers so identifying issues early on can save us time and effort in later stage of the analysis

Since our dataset contains two tables, First I checked the number of unique apps in both tables cause a discrepancy can mean missing data in the dataset

```sql
SELECT COUNT(DISTINCT id) AS UniqueAppID
FROM AppleStore
```
UniqueAppID|
:-------:|
7197

```sql
SELECT COUNT(DISTINCT id) AS UniqueAppID
FROM AppleStore_Description_Combined
```
UniqueAppID|
:-------:|
7197

The result was the same meaning no missing data between the two tables. 

Second, I checked for missing values in some of the key fields of the two tables.

```sql
SELECT COUNT(*) AS MissingValue
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL
```

MissingValue|
:-------:|
0

```sql
SELECT COUNT(*) AS MissingValue
FROM AppleStore_Description_Combined
WHERE track_name IS NULL OR app_desc IS NULL
```

MissingValue|
:-------:|
0

From the result the data is clean so i started my analysis

***

I needed the number of apps for each genre to see the most popular app category

```sql
SELECT
	prime_genre,
COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC
```

prime_genre |	NumApps 
:-------|:-------:
Games |	3862
Entertainment | 535
Education |	453
Photo & Video	| 349
Utilities | 248"
Health & Fitness | 180
Productivity | 178
Social Networking | 167
Lifestyle | 144
Music | 138
Shopping | 122
Sports | 114
Book | 112
Finance | 104
Travel | 81
News | 75
Weather	| 72
Reference | 64
Food & Drink | 63
Business | 57
Navigation	| 46
Medical | 23
Catalogs | 10

According to the result the games and entertainment genres are leading with a huge number of Apps.

***

Now I  explore the user ratings, I want to see the average, minimum and maximum rating.

```sql
SELECT
	MIN(user_rating) AS MinUserRating,
	MAX(user_rating) AS MaxUserRating,
	AVG(user_rating) AS AvgUserRating
FROM AppleStore
```

MinUserRating	| MaxUserRating	| AvgUserRating
:-------:|:-------:|:-------:
0 | 5 |	3.526955675976101

***

A question popped into my head, Do paid apps get more ratings than free apps ?, time to investigate

```sql
SELECT 
	CASE WHEN price > 0 THEN 'Paid'
             ELSE 'Free' END AS AppType,
	AVG(user_rating) AS AvgUserRating
FROM AppleStore
GROUP BY AppType
```

AppType	| AvgUserRating
:-------:|:-------:
Free |	3.3767258382642997
Paid |	3.720948742438714

Paid apps average slightly more user ratings than free apps.

***

Do apps with more supported languages get more ratings ?

```sql
SELECT
	CASE WHEN lang_num < 10 THEN 'Less than 10 languages'
	     WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
             ELSE 'More than 30 languages' END AS LanguageBucket,
	AVG(user_rating) AS AvgUserRating
FROM AppleStore
GROUP BY LanguageBucket
ORDER BY AvgUserRating DESC
```

LanguageBucket | AvgUserRating
:-------:|:-------
10-30 languages| 4.1305120910384066
More than 30 languages | 3.7777777777777777 
Less than 10 languages | 3.368327402135231

So its not really about the quantity of languages your app supports, it is more about focusing on the right languages for your app, From the analysis we can see the middle bucket has a higher user rating so our client can focus his effort to other aspects of the app.

***

Next i checked genres with low ratings to see if there are genres where users feel unsatisfied.

```sql
SELECT
	prime_genre,
    	AVG(user_rating) AS AvgUserRating
FROM AppleStore
GROUP BY prime_genre
ORDER BY AvgUserRating ASC
LIMIT 10
```

prime_genre	| AvgUserRating
:-------|:-------
Catalogs | 2.1
Finance | 2.4326923076923075
Book | 2.4776785714285716
Navigation | 2.6847826086956523
Lifestyle | 2.8055555555555554
News | 2.98
Sports | 2.982456140350877
Social Networking | 2.9850299401197606
Food & Drink | 3.1825396825396823
Entertainment | 3.2467289719626167

Finance and book genres have the lowest ratings, In the above genres the users gave bad ratings meaning they are not satisfied and so there might be good opportunity to create an app in those spaces.

***

Then i wanted to know if the description length of apps mattered to users.

```sql
SELECT
	CASE WHEN LENGTH(B.app_desc) < 500 THEN 'Short'
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
ORDER BY AvgUserRating DESC
```

DescriptionLengthBucket	| AvgUserRating
:-------:|:-------:
Long | 3.855946944988041
Medium	| 3.232809430255403
Short | 2.533613445378151

We can see on average the longer the description the higher the user rating 

***

```sql
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
WHERE RankingApps.AppRank = 1
```

prime_genre |	track_name	| user_rating
:-------|:-------|:-------:
Book | Color Therapy Adult Coloring Book for Adults | 5
Business | TurboScan™ Pro - document & receipt scanner: scan multiple pages and photos to PDF | 5
Catalogs | CPlus for Craigslist app - mobile classifieds| 5
Education | Elevate - Brain Training and Games | 5
Entertainment | Bruh-Button | 5
Finance | Credit Karma: Free Credit Scores, Reports & Alerts | 5
Food & Drink | Domino's Pizza USA | 5
Games | Head Soccer | 5
Health & Fitness | Yoga Studio | 5
Lifestyle | ipsy - Makeup, subscription and beauty tips | 5
Medical | Blink Health | 5
Music | Tenuto | 5
Navigation | parkOmator – for Apple Watch meter expiration timer, notifications & GPS navigator to car location | 5
News | The Guardian | 5
Photo & Video | Pic Collage - Picture Editor & Photo Collage Maker | 5
Productivity | VPN Proxy Master - Unlimited WiFi security VPN | 5
Reference | Sky Guide: View Stars Night or Day | 5
Shopping | Zappos: shop shoes & clothes, fast free shipping | 5
Social Networking | We Heart It - Fashion, wallpapers, quotes, tattoos | 5
Sports | J23 - Jordan Release Dates and History | 5
Travel | Urlaubspiraten | 5
Utilities | Flashlight Ⓞ | 5
Weather | NOAA Hi-Def Radar Pro -  Storm Warnings, Hurricane Tracker & Weather Forecast"	| 5

This shows the app with the highest number of ratings and the best ratings, so the stakeholder can check this apps out as they are the top performers and try to emulate them

## RECOMMENDATIONS 
**1. Paid apps have better ratings.**
- This could be due to a number of reasons so users who pay for an app may have higher engagement and perceive more value leading to the better ratings, the stakeholder should consider charging a certain amount if they perceive their app is good.
   
**2. Apps supporting between 10 – 30 languages have better ratings.**
-It is not really about the quantity of languages your app supports, it is more about focusing on the right languages for your app.

**3. Apps in the Finance and book genres have lower ratings.**
- Finance and book genres have lower ratings meaning users needs are not fully met so this can represent a market opportunity because if the stakeholder can create a quality app in these categories that addresses user needs better than the current offerings there is potential for high user ratings and market penetration.

**4. Apps with longer descriptions have better ratings.**
- Users likely appreciate having a clear understanding of the apps features and capabilities before they download so a detailed well crafted app description can set clear expectations and eventually increase the satisfaction of users. 
   
**5. A new app should aim for an average rating above 3.5.** 
- The average app has a rating of about 3.5 so in order to stand out A new app should aim for an average rating above 3.5. 

**6. Apps in the games and entertainment genres have high competion.**
- Apps in the games and entertainment genres have a very high volume of apps which could suggest market saturation so entering this spaces might be challenging due to high competition however it also suggest high user demand in this sectors. 





