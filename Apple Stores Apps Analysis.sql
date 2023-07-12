--OUR STAKEHOLDER IS AN ASPIRING APP DEVELOPER WHO WNATS DATA DRIVEN INSIGHTS TO FIND OUT WHICH APP TO BUILD

--EXPLORATORY DATA ANALYSIS

--CHECK THE NUMBER OF UNIQUE APPS

SELECT COUNT(DISTINCT(ID)) as UniqueAppIDs
FROM AppleStores..AppleStore

--CHECK FOR ANY MISSING VALUES IN KEY FIELDS

SELECT COUNT(*) as MissingValues
FROM AppleStores..AppleStore
WHERE track_name IS NULL OR price IS NULL OR user_rating IS NULL OR prime_genre IS NULL

--FIND OUT THE NUMBER OF APPS PER GENRE

SELECT prime_genre as genre, COUNT(*) as total
FROM AppleStores..AppleStore
GROUP BY prime_genre
ORDER BY COUNT(*) DESC

--GET AN OVERVIEW OF THE APPS RATINGS

SELECT MIN(user_rating) as Min_Rating, MAX(user_rating) as Max_Rating, ROUND(AVG(user_rating),2) as Avg_Rating
FROM AppleStores..AppleStore

--GET AN OVERVIEW OF PRICES OF APPS

SELECT MIN(price) as Min_Price, MAX(price) as Max_Price, ROUND(AVG(price),2) as Avg_Price
FROM AppleStores..AppleStore

--GET THE DISTRIBUTION OF APP PRICES

select dist_group, COUNT(*) as NumApps
from ( select (case when price between 0 and 2 then '(0, 2)'
			      when price between 2 and 5 then '(2, 5)'
				 when price between 5 and 10 then '(5, 10)' 
				when price between 10 and 50 then '(10, 50)'
				when price between 50 and 100 then '(50, 100)'
				when price between 100 and 200 then '(100, 200)'
				when price between 200 and 300 then '(200, 300)'
				end) as dist_group
        from AppleStores..AppleStore) as T1
GROUP BY dist_group
ORDER BY NumApps DESC

-- DATA ANALYSIS

--COMPARE THE RATINGS OF PAID APPS AND FREE APPS

SELECT CASE 
			WHEN price>0 THEN 'Paid'
            ELSE 'Free' 
	   END AS App_Type, ROUND(AVG(user_rating),2) as Avg_Rating , COUNT(*) as NumApps
FROM AppleStores..AppleStore
GROUP BY App_Type

--CHECK IF APPS WITH MORE SUPPORTED LANGUAUES HAVE HIGHER RATINGS

SELECT CASE 
			WHEN lang_num<10 THEN '<10 Languages'
			WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 Languages'
            ELSE '>30 Languages' 
	   END AS Num_Langs, ROUND(AVG(user_rating),2) as Avg_Rating , COUNT(*) as NumApps
FROM AppleStores..AppleStore
GROUP BY Num_Langs
ORDER BY Avg_Rating DESC

--CHECK GENRES WITH LOW RATINGS

SELECT TOP 10 prime_genre, ROUND(AVG(user_rating),2) as Avg_Rating
FROM AppleStores..AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating ASC


--CHECK GENRES WITH HIGH RATINGS

SELECT TOP 10 prime_genre, ROUND(AVG(user_rating),2) as Avg_Rating
FROM AppleStores..AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating DESC

--CHECKING IF THEIR IS A CORRELATION WITH THE LENGTH OF APP DESCRIPTION AND USER RATING

SELECT CASE 
			WHEN len(b.app_desc) < 500 THEN 'Short'
			WHEN len(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
			ELSE 'Large'
		END AS Description_Length, ROUND(AVG(a.user_rating),2) as Avg_Rating
FROM AppleStores..AppleStore A
JOIN AppleStores..AppleStore_Description B 
ON A.ID = B.id
GROUP BY Description_Length
ORDER BY Avg_Rating DESC

--CHECKING THE TOP APP BY GENRE

SELECT prime_genre,track_name,user_rating
FROM ( SELECT prime_genre,track_name,user_rating, RANK()OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS Rank
       FROM AppleStores..AppleStore) AS A
WHERE A.RANK = 1

--FINAL CONCLUSION:
--1) PAID APPS HAVE BETTER RATINGS
--2) APPS SUPPORTING LANGUAGES BETWEEN 10 AND 30 HAVE BETTER RATINGS
--3) WRITE A LONGER APP DESCRIPTION TO HAVE A BETTER SATISFACTION OF USERS AND BETTER RATING