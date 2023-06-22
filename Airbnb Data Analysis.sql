--WE ARE ANALYSING AIRBNB DATA FOR AUSTIN,TX.

--LOOKING AT OVERVIEW OF ALL THE LISTINGS

SELECT * FROM PortfolioProject..listings

--CLEANING THE PRICE COLUMN TO MAKE IT CALCULATABLE

SELECT *,Price, CONVERT(float,REPLACE(REPLACE(Price,'$',''),',','')) AS price_clean
FROM PortfolioProject..listings

--TO GET THE ROOMS BOOKED WE USE AVAILABLE_30 AS AN INDICATOR TO CALCULATE THE UNAVAIALBLE/BOOKED ROOMS FOR 30 DAYS.

SELECT TOP 10 id,listing_url,name, 30-availability_30 as booked_out_of_30, CONVERT(float,REPLACE(REPLACE(Price,'$',''),',','')) AS price_clean, CONVERT(float,REPLACE(REPLACE(Price,'$',''),',',''))*(30-availability_30) AS proj_rev
FROM PortfolioProject..listings
ORDER BY proj_rev DESC

--what is the most common room type and property type available?

SELECT room_type, COUNT(*) as frequency
FROM PortfolioProject..listings
GROUP BY room_type
ORDER BY frequency DESC


SELECT TOP 15 property_type, COUNT(*) as frequency
FROM PortfolioProject..listings
GROUP BY property_type
ORDER BY COUNT(*) DESC

--let’s check the top 10 and bottom 10 property type based on the average price for a property type with at least 50 different listings.

SELECT TOP 10 property_type, CONVERT(INT,average_price) as average_price, frequency
FROM 
    (SELECT property_type, AVG(CONVERT(FLOAT,REPLACE(REPLACE(Price,'$',''),',',''))) as average_price, COUNT(*) as frequency
     FROM PortfolioProject..listings
     GROUP BY property_type) as new_table
WHERE frequency >= 50
ORDER BY average_price DESC

SELECT TOP 10 property_type,CONVERT(INT,average_price) as average_price, frequency
FROM      
      (SELECT property_type, AVG(CONVERT(FLOAT,REPLACE(REPLACE(Price,'$',''),',',''))) as average_price, COUNT(*) as frequency
      FROM PortfolioProject..listings
	  GROUP BY property_type) as new_table
WHERE frequency >= 50
ORDER BY average_price

--let’s check if there are significant difference in average of rating of the overall experience for certain property type.
--TOP 10 Property based on review score

SELECT property_type, ROUND(average_score,2) as avg_rating, frequency
FROM 
    (SELECT property_type, AVG(review_scores_rating) as average_score, COUNT(*) as frequency
     FROM PortfolioProject..listings
     WHERE review_scores_rating IS NOT NULL
     GROUP BY property_type) as new_table
WHERE frequency >= 50
ORDER BY average_score DESC

--CORRELATION BETWEEN PRICE AND RATING

SELECT property_type, CONVERT(float,REPLACE(REPLACE(Price,'$',''),',','')) AS price_clean, review_scores_rating
FROM PortfolioProject..listings
WHERE review_scores_rating IS NOT NULL AND number_of_reviews > 10
ORDER BY review_scores_rating DESC

--we can plot this graph in a data visualisation tool and find a relation between the two. As the prices go up, the avg rating also goes up

--MOST PROVIDED AMENITIES

SELECT TOP 10 VALUE as Amenities, COUNT(*) as frequency
FROM PortfolioProject..listings CROSS APPLY STRING_SPLIT(amenities,',')
GROUP BY VALUE
ORDER BY frequency DESC

--ESTIMATED TOP HOST BY EARNING(min total earning= SUM of Price*no. of reviews*minimum nights)

SELECT TOP 10 host_id, host_name, SUM(total_earning) as total_earning, COUNT(*) as number_of_listing, ROUND(AVG(CONVERT(float,REPLACE(REPLACE(price,'$',''),',',''))),2) as average_price
FROM
   (SELECT host_id, host_name, price, number_of_reviews, minimum_nights,(CONVERT(float,REPLACE(REPLACE(price,'$',''),',','')) * minimum_nights) as total_earning
    FROM PortfolioProject..Listings) as new_table
GROUP BY host_id, host_name
HAVING SUM(number_of_reviews)>=5
ORDER BY SUM(total_earning) DESC

--we can also see the top host by number of listings

SELECT TOP 10 host_id, host_name, SUM(total_earning) as total_earning, COUNT(*) as number_of_listing, ROUND(AVG(CONVERT(float,REPLACE(REPLACE(price,'$',''),',',''))),2) as average_price
FROM
   (SELECT host_id, host_name, price, number_of_reviews, minimum_nights,(CONVERT(float,REPLACE(REPLACE(price,'$',''),',','')) * minimum_nights) as total_earning
    FROM PortfolioProject..Listings) as new_table
GROUP BY host_id, host_name
ORDER BY number_of_listing DESC


--A Detailed Data Analysis is done to better understand the information regarding the room listing and host from Airbnb. 
--We have seen analysis on various different parameters and can still be further continued based on our requirements.