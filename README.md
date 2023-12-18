# Apple-AppStore-SQL-Project
A comprehensive analysis on what kind of app to build on Apple AppStore

<img src="https://github.com/Khalih-01/Apple-AppStore-SQL-Project/blob/main/Intro_image.png"/>

## Introduction
This project derives insights from Apple AppStore to make informed decisions like identifying popular app categories, determining pricing strategies, and optimizing user ratings for successful app development

## Problem Statement
An aspiring app developer who needs data-driven insights to decide what type of app to build so they are seeking answers to questions like 
-	What app categories are most popular ?
-	Should a price be set ?
-	How can user ratiings be maximised ?

## Skills Demonstrated
Exploratory Data Analysis(EDA), Analytical thinking

## Data Sourcing 
Data was sourced from kaggle ([Download Here](https://www.kaggle.com/datasets/gauthamp10/apple-appstore-app))

dataet consists of two csv files


```sql
SELECT COUNT(DISTINCT id) AS UniqueAppID
FROM AppleStore
```

