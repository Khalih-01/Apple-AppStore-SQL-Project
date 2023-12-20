# Apple-AppStore-SQL-Project
A comprehensive analysis on what kind of app to build on Apple AppStore

<img src="https://github.com/Khalih-01/Apple-AppStore-SQL-Project/blob/main/Images/Intro_image.png"/>


## Introduction
This project aims to derive insights from Apple AppStore data in order to make informed decisions like identifying popular app categories, determining pricing strategies, and optimizing user ratings for successful app development.

## Problem Statement
An aspiring app developer who needs data-driven insights to decide what type of app to build on the AppStore is seeking answers to the following questions;
- Which app categories are most popular ?
- Should a price be set ?
- How can user ratiings be maximised ?

## Skills Demonstrated
Exploratory Data Analysis(EDA), Analytical thinking, Data exploration

## Data Sourcing 
Data was sourced from kaggle ([Download Here](https://www.kaggle.com/datasets/gauthamp10/apple-appstore-app)), It covers information about apps available on the Apple Store. 

The dataset consists of two csv files;
- appleStore.csv
- applestore_description.csv

## Analysis
I leveraged a fantastic online resource [SQLiteonline.com](https://sqliteonline.com/), this tool enabled me to work directly with my data online without the need for installations. By simply uploading my datasets, I could instantly run SQL queries in the browser. However, I encountered a limitation — the platform permits file uploads up to a maximum of 4 megabytes (4MB). To circumvent this,  I split our larger CSV file into four smalller files , each staying within the 4MB limit, and uploaded them individually.

![SQLiteonline.com](https://github.com/Khalih-01/Apple-AppStore-SQL-Project/blob/main/Images/SQLiteonline.com.png)

SQL has a powerful feature known as UNION ALL which allows us to seamlessly combine our four separate tables back into a single one.

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

### Understanding the Dataset
After importing the data, I conducted an initial exploration to comprehend its characteristics. This step often unveils issues such as missing or inconsistent data, errors, or outliers. Identifying these issues early on can save time and effort in later stages of the analysis.

Since our dataset comprises two tables, my first check involved examining the number of unique apps in both tables, as a discrepancy could indicate missing data in the dataset.

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

The results showed consistency, indicating no missing data between the two tables, As we move forward trying to answer certain questions, I had to check for missing values in some of the key fields of the two tables.

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

The result showed the absence of missing values in both tables, signifying that the data is clean. With this assurance, I proceeded with my analysis.

### Exploratory Data Analysis


#### Most Popular App Genre

What is the most popular app category ? I want to know the number of apps within each genre, My aim is to identify the predominant app categories and shed light on the distribution of apps across various genres.

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
Utilities | 248
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

According to the result, it's evident that the Games and Entertainment genres dominate with a substantial number of apps. This observation raises considerations about potential market saturation, indicating potential challenges in entering these spaces due to heightened competition. On the flip side, the substantial presence of apps suggests a robust demand in these sectors, hinting at significant user engagement.

***

#### User Ratings

Next, I delved into user ratings, aiming to get an overview by assessing average, minimum, and maximum user ratings.

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

The average app has a rating of about 3.5, signaling that, for a new app to stand out, it should target an average rating exceeding this threshold.

***

#### Paid vs Free

Do paid apps get better ratings than free apps ? time to investigate

```sql
SELECT 
    CASE
        WHEN price > 0 THEN 'Paid'
        ELSE 'Free' END AS AppType,
    AVG(user_rating) AS AvgUserRating
FROM AppleStore
GROUP BY AppType
```

AppType	| AvgUserRating
:-------:|:-------:
Free |	3.3767258382642997
Paid |	3.720948742438714

Paid apps, on average, receive slightly more user ratings than free apps. This might be attributed to paying users having higher engagement and perceiving greater value, resulting in better ratings. This finding suggests that the stakeholder should carefully consider the pricing strategy, as users seem willing to pay for apps they find valuable.

***

#### Supported Languages 

Do apps with more supported languages get better ratings ?

```sql
SELECT
    CASE
        WHEN lang_num < 10 THEN 'Less than 10 languages'
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

So, it's not necessarily about the quantity of languages your app supports, but rather about focusing on the right languages for your app. The analysis reveals that the middle bucket of languages tends to have higher user ratings. This suggests that the stakeholder can optimize their efforts by prioritizing these languages and focusing on other aspects of the app to enhance user satisfaction.

***

#### Average User Ratings per Genre

Next, I checked genres with low user ratings to see if there are genres where users feel unsatisfied.

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

Upon investigating genres with low user ratings, it was found that Finance and Book genres have the lowest ratings. This indicates a potential market opportunity, as users in these genres might be dissatisfied with the current offerings. Creating a high-quality app in these categories that better addresses user needs could lead to higher user ratings and significant market penetration for the stakeholder.

***

#### App Description Length

Do apps with longer descriptions get better ratings ? I suspect that the length of an app's description has a positive correlation with how users rate the apps. time to find out.

```sql
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
ORDER BY AvgUserRating DESC
```

DescriptionLengthBucket	| AvgUserRating
:-------:|:-------:
Long | 3.855946944988041
Medium	| 3.232809430255403
Short | 2.533613445378151

Interestingly, the analysis indicates that, on average, longer app descriptions are associated with higher user ratings. This trend suggests that users might value a detailed understanding of an app's features and capabilities before downloading, so a detailed well crafted app description can set clear expectations and eventually increase the satisfaction of users. 

***

#### Best Apps

Which apps have the highest number of user ratings and the best user ratings across all categories ? 

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

It highlights the apps that not only have the best user ratings but also boast the highest number of user ratings. By examining these top-performing apps, the stakeholder can gain valuable insights and potentially identify key factors contributing to their success, offering valuable guidance for their own app development strategy.

## RECOMMENDATIONS 

1. Paid apps have better ratings.
   
2. Apps supporting between 10 – 30 languages have better ratings.

3. Apps in the Finance and Book genres have lower ratings.
- In the above genres the users gave bad ratings meaning they are not satisfied and so there might be good opportunity to create an app in those spaces.

4. Apps with longer descriptions have better ratings.
   
5. A new app should aim for an average rating above 3.5.

6. Apps in the games and entertainment genres have high competition.
- The above genres have a very high volume of apps which could suggest market saturation so entering this spaces might be challenging due to high competition however it also suggest high user demand in this sectors.  

 





