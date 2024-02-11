PREPARED BY 
NAME: OLAOLUWA JOHNSON TAIWO

USE [Movie database];

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment


--for finding the number of null value in movies and ratings

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
-- To get the shape of the 'movies' table
SELECT COUNT(*) AS num_rows, COUNT(*) AS num_columns
FROM dbo.movies_data
--to get for ratings
SELECT COUNT(*) AS num_rows, COUNT(*) AS num_columns
FROM dbo.ratings

-- To get the shape of the 'genre' table
SELECT COUNT(*) AS num_rows, COUNT(*) AS num_columns
FROM genre;







-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'movies_data'
AND TABLE_SCHEMA = 'Movie database'
AND IS_NULLABLE = 'YES';

--let check one by one
SELECT 
    Count(*) as "ColumnsNmaewithNum"
FROM 
    movies_data 
WHERE 
    country IS NULL
    OR worlwide_gross_income IS NULL
    OR languages IS NULL
    OR production_company IS NULL
	or year IS NULL
	OR duration IS NULL;

SELECT  *
FROM  movies_data 
WHERE
    country IS NULL
    OR worlwide_gross_income IS NULL
    OR languages IS NULL
    OR production_company IS NULL
	or year IS NULL
	OR duration IS NULL;





-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

Select * from movies_data
--Number of released movie per year
SELECT 
    YEAR(date_published) AS ReleaseYear, 
    COUNT(*) AS NumberOfMovies
FROM 
    movies_data 
GROUP BY 
    YEAR(date_published)
ORDER BY 
    ReleaseYear;

	--Let get it one by one
	SELECT 
    YEAR(date_published) AS ReleaseYear, 
    MONTH(date_published) AS ReleaseMonth,
    COUNT(*) AS NumberOfMovies
FROM 
    movies_data 
GROUP BY 
    YEAR(date_published), MONTH(date_published)
ORDER BY 
    ReleaseYear, ReleaseMonth;


/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:










/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT 
    Country as Countries, COUNT(*) AS NumberOfMovies
FROM 
    movies_data 
WHERE 
    (country = 'USA' OR country = 'India')
    AND YEAR(date_published) = 2019
Group By country;








/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT * FROM movies_data
SELECT * FROM genre
--finding unique list in the genre table
SELECT DISTINCT genre
FROM Genre;









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT G.genre AS Genre, COUNT(*) AS NumberOfMovies
FROM movies_data M
JOIN Genre G ON M.id = G.movie_id
GROUP BY G.genre
ORDER BY NumberOfMovies DESC;











/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT COUNT(*) AS SingleGenreMoviesCount
FROM (
    SELECT movie_id
    FROM Genre
    GROUP BY movie_id
    HAVING COUNT(*) = 1
) AS SingleGenreMovies;

--LET make it display count by genre using LEFT JOIN
SELECT G.genre, COUNT(M.id) AS MovieCount
FROM Genre G
LEFT JOIN movies_data M ON G.movie_id = M.id
GROUP BY G.genre
HAVING COUNT(M.id) = 1 OR COUNT(M.id) IS NULL;








/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT G.genre AS Genre, AVG(M.duration) AS AVG_DURATION
FROM movies_data M
JOIN genre G ON M.id = G.movie_id
Group By G.genre
Order by AVG(duration) DESC;








/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
--GENERAL MOVIE COUNT
SELECT G.genre AS Genre, COUNT(*) AS MovieCount,
           RANK() OVER (ORDER BY COUNT(*) DESC) AS GenreRank
    FROM movies_data M
    JOIN Genre G ON M.id = G.movie_id
    GROUP BY G.genre

--NOW LET CHECK FOR THRILLER RANK
WITH GenreMovieCounts AS (
    SELECT G.genre AS Genre, COUNT(*) AS MovieCount,
           RANK() OVER (ORDER BY COUNT(*) DESC) AS GenreRank
    FROM movies_data M
    JOIN Genre G ON M.id = G.movie_id
    GROUP BY G.genre
)
SELECT Genre, MovieCount, GenreRank
FROM GenreMovieCounts
WHERE Genre = 'thriller';










/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM 
    ratings;






    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT TOP 10
    m.id,
    m.title,
    AVG(r.avg_rating) AS avg_rating
FROM
    movies_data m
INNER JOIN
    ratings r ON m.id = r.movie_id
GROUP BY
    m.id, m.title
ORDER BY
    avg_rating DESC;


	---TO USE Roll Number Function() FORMAT
	SELECT
    m.title AS title,
    AVG(r.avg_rating) AS avg_rating,
    ROW_NUMBER() OVER (ORDER BY AVG(r.avg_rating) DESC) AS movie_rank
FROM
    movies_data m
INNER JOIN
    ratings r ON m.id = r.movie_id
GROUP BY
    m.id, m.title
ORDER BY
    avg_rating DESC
LIMIT 10;


--USING RANK FUNCTION and limit it to 10
SELECT
    title,
    avg_rating,
    movie_rank
FROM (
    SELECT
        m.title AS title,
        AVG(r.avg_rating) AS avg_rating,
        RANK() OVER (ORDER BY AVG(r.avg_rating) DESC) AS movie_rank
    FROM
        movies_data m
    INNER JOIN
        ratings r ON m.id = r.movie_id
    GROUP BY
        m.id, m.title
) AS RankedMovies
WHERE
    movie_rank <= 10
ORDER BY
    movie_rank;









/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating AS Median_ratings, Count(*) AS Movie_Count
from ratings
Group By median_rating
Order by Movie_Count DESC;










/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT M.production_company, Count(*) AS Movie_count,
RANK() OVER (ORDER BY Count(*) DESC) AS Company_rank
from movies_data M
JOIN ratings R ON M.id = R.movie_id
WHERE R.avg_rating > 8
GROUP BY M.production_company
Order by Company_rank;








-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT
    G.genre AS genre,
    COUNT(*) AS movies_count
FROM
    movies_data M
JOIN
    Genre G ON M.id = G.movie_id
JOIN
    ratings R ON M.id = R.movie_id
WHERE
    M.country = 'USA'
    AND G.genre IN (
        SELECT genre
        FROM movies_data M
        JOIN Genre G ON M.id = G.movie_id
        WHERE MONTH(M.date_published) = 3 AND YEAR(M.date_published) = 2017
    )
    AND R.total_votes > 1000
GROUP BY
    G.genre
ORDER BY
    movies_count DESC;








-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT
    G.genre AS genre,
    M.title AS movie_title,
    R.avg_rating AS average_rating
FROM
    movies_data M
JOIN
    Genre G ON M.id = G.movie_id
JOIN
    ratings R ON M.id = R.movie_id
WHERE
    M.title LIKE 'The%'
    AND R.avg_rating > 8
GROUP BY
    G.genre, M.title, R.avg_rating
ORDER BY
    R.avg_rating DESC;


	--- for median rating
SELECT
    G.genre AS genre,
    M.title AS movie_title,
    R.median_rating AS median_rating
FROM
    movies_data M
JOIN
    Genre G ON M.id = G.movie_id
JOIN
    ratings R ON M.id = R.movie_id
WHERE
    M.title LIKE 'The%'
    AND R.median_rating > 8
GROUP BY
    G.genre, M.title, R.median_rating
ORDER BY
    R.median_rating DESC;








-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT * FROM movies_data
SELECT COUNT(*) AS movies_count_median_8
FROM movies_data M
JOIN ratings R ON M.id = R.movie_id
WHERE M.date_published >= '2018-04-01' 
  AND M.date_published  < '2019-04-01'
  AND R.median_rating = 8;








-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
select * from movies_data


SELECT 
    CASE 
        WHEN M.languages LIKE '%German%' THEN 'German'
        WHEN M.languages LIKE '%Italian%' THEN 'Italian'
    END AS origin_country,
    SUM(R.total_votes) AS total_votes
FROM 
    movies_data M
JOIN 
    ratings R ON M.id = R.movie_id
WHERE 
    M.languages LIKE '%German%' OR M.languages LIKE '%Italian%'
GROUP BY 
    CASE 
        WHEN M.languages LIKE '%German%' THEN 'German'
        WHEN M.languages LIKE '%Italian%' THEN 'Italian'
    END;





-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select *  from names
--View those with NULLS
SELECT
    CASE WHEN name IS NULL THEN 'name' ELSE NULL END AS null_columns,
    CASE WHEN height IS NULL THEN 'height' ELSE NULL END AS null_columns,
    CASE WHEN date_of_birth IS NULL THEN 'date_of_birth' ELSE NULL END AS null_columns,
    CASE WHEN Known_for_movies IS NULL THEN 'Known_for_movies' ELSE NULL END AS null_columns
FROM
    names
WHERE
    name IS NULL OR height IS NULL OR date_of_birth IS NULL OR Known_for_movies IS NULL;


----Counting if null per columns

SELECT
    COUNT(CASE WHEN name IS NULL THEN 1 END) AS name_nulls,
    COUNT(CASE WHEN height IS NULL THEN 1 END) AS height_nulls,
    COUNT(CASE WHEN date_of_birth IS NULL THEN 1 END) AS date_of_birth_nulls,
    COUNT(CASE WHEN Known_for_movies IS NULL THEN 1 END) AS Known_for_movies_nulls
FROM
    names
WHERE
    name IS NULL OR height IS NULL OR date_of_birth IS NULL OR Known_for_movies IS NULL;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

--List of the movie director with thie number of movies
SELECT 
    N.name,
    COUNT(G.genre) AS Movie_count
FROM 
    director_mapping DM
JOIN 
    Genre G ON DM.movie_id = G.movie_id
JOIN 
    ratings R ON G.movie_id = R.movie_id
JOIN 
    names N ON DM.name_id = N.id
WHERE
    R.avg_rating > 8
GROUP BY 
    N.name
ORDER BY 
    COUNT(G.genre) DESC; 


-- showing the TOP 3 only
SELECT TOP 3
    N.name,
    COUNT(G.genre) AS Movie_count
FROM 
    director_mapping DM
JOIN 
    Genre G ON DM.movie_id = G.movie_id
JOIN 
    ratings R ON G.movie_id = R.movie_id
JOIN 
    names N ON DM.name_id = N.id
WHERE
    R.avg_rating > 8
GROUP BY 
    N.name
ORDER BY 
    COUNT(G.genre) DESC;





    







/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT TOP 5
    N.name,
    COUNT(*) AS Movie_count
FROM 
    role_mapping RM
JOIN 
    ratings R ON RM.movie_id = R.movie_id
JOIN 
    names N ON RM.name_id = N.id
WHERE
    R.avg_rating > 8
GROUP BY 
    N.name
ORDER BY 
    Movie_count DESC;



SELECT TOP 2
    N.name AS Actor_name,
    COUNT(RM.movie_id) AS Movie_count
FROM 
    names N
JOIN 
    role_mapping RM ON N.id = RM.name_id
JOIN 
    ratings R ON RM.movie_id = R.movie_id
WHERE
    R.avg_rating >= 8
GROUP BY 
    N.name
ORDER BY 
    COUNT(RM.movie_id) DESC;




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT TOP 5
    Production_House,
    Total_Votes,
    DENSE_RANK() OVER (ORDER BY Total_Votes DESC) AS Production_House_Rank
FROM (
    SELECT 
        M.production_company AS Production_House,
        SUM(R.total_votes) AS Total_Votes
    FROM 
        movies_data M
    JOIN 
        ratings R ON M.id = R.movie_id
    GROUP BY 
        M.production_company
) AS VoteTotals
ORDER BY 
    Total_Votes DESC;










/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH IndianActors AS (
    SELECT 
        N.name AS Actor_Name,
        SUM(R.total_votes) AS Total_Votes,
        COUNT(DISTINCT M.id) AS Movie_Count,
        SUM(R.avg_rating * R.total_votes) / SUM(R.total_votes) AS Avg_Rating,
        RANK() OVER(ORDER BY SUM(R.avg_rating) DESC, SUM(R.total_votes) DESC) AS Actor_Rank
    FROM 
        role_mapping RM
    JOIN 
        ratings R ON RM.movie_id = R.movie_id
    JOIN 
        movies_data M ON RM.movie_id = M.id
    JOIN 
        names N ON RM.name_id = N.id
    WHERE 
        M.country = 'India'
        AND RM.category = 'actor' -- Considering only actors
    GROUP BY 
        N.name
    HAVING 
        COUNT(DISTINCT M.id) >= 5 -- Actors with at least 5 movies released in India
)
SELECT 
    Actor_Name,
    Total_Votes,
    Movie_Count,
    ROUND(Avg_Rating, 2) AS Avg_Rating,
    Actor_Rank
FROM 
    IndianActors
WHERE 
    Actor_Rank <= 10 -- Display top 10 actors based on ranking
ORDER BY 
   Actor_Rank;






-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH IndianActresses AS (
    SELECT 
        N.name AS Actress_Name,
        SUM(R.total_votes) AS Total_Votes,
        COUNT(DISTINCT M.id) AS Movie_Count,
        SUM(R.avg_rating * R.total_votes) / SUM(R.total_votes) AS Avg_Rating,
        RANK() OVER(ORDER BY SUM(R.avg_rating) DESC, SUM(R.total_votes) DESC) AS Actress_Rank
    FROM 
        role_mapping RM
    JOIN 
        ratings R ON RM.movie_id = R.movie_id
    JOIN 
        movies_data M ON RM.movie_id = M.id
    JOIN 
        names N ON RM.name_id = N.id
    WHERE 
        M.country = 'India'
        AND RM.category = 'actress' -- Considering only actresses
    GROUP BY 
        N.name
    HAVING 
        COUNT(DISTINCT M.id) >= 5 -- Actresses with at least 5 movies released in India
)
SELECT 
    Actress_Name,
    Total_Votes,
    Movie_Count,
    ROUND(Avg_Rating, 2) AS Avg_Rating,
    Actress_Rank
FROM 
    IndianActresses
WHERE 
    Actress_Rank <= 10 -- Display top 10 actresses based on ranking
ORDER BY 
   Actress_Rank;









/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT
    M.title AS Movie_Title,
    AVG(R.avg_rating) AS Avg_Rating,
    CASE
        WHEN AVG(R.avg_rating) > 8 THEN 'Superhit movies'
        WHEN AVG(R.avg_rating) BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN AVG(R.avg_rating) BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
    END AS Movie_Category
FROM
    movies_data M
JOIN
    genre G ON M.id = G.movie_id
JOIN
    ratings R ON M.id = R.movie_id
WHERE
    G.genre = 'Thriller'
GROUP BY
    M.title
ORDER BY
    Avg_Rating DESC;  








/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
    G.genre,
    ROUND(AVG(M.duration), 2) AS avg_duration,
    SUM(AVG(M.duration)) OVER(ORDER BY G.genre) AS running_total_duration,
    ROUND(AVG(AVG(M.duration)) OVER(ORDER BY G.genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
FROM
    movies_data M
JOIN
    genre G ON M.id = G.movie_id
GROUP BY
    G.genre
ORDER BY
    G.genre;









-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH TopGenres AS (
    SELECT 
        G.genre,
        COUNT(*) AS genre_count,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
    FROM 
        genre G
    GROUP BY 
        G.genre
)
SELECT 
    M.year, 
    G.genre,
    M.title,
    M.worlwide_gross_income
FROM 
    movies_data M
JOIN 
    genre G ON M.id = G.movie_id
JOIN 
    TopGenres TG ON G.genre = TG.genre
WHERE 
    TG.genre_rank <= 3
    AND M.title IN (
        SELECT TOP 5
            M2.title
        FROM 
            movies_data M2
        JOIN 
            genre G2 ON M2.id = G2.movie_id
        WHERE 
            M2.year = M.year
            AND G2.genre = G.genre
        ORDER BY 
            M2.worlwide_gross_income DESC
    )
ORDER BY 
    M.year, G.genre, M.worlwide_gross_income DESC;



--FOR DEISRE OUTPUT
WITH TopGenres AS (
    SELECT 
        G.genre,
        COUNT(*) AS genre_count,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
    FROM 
        genre G
    GROUP BY 
        G.genre
),
TopMovies AS (
    SELECT 
        M.year, 
        G.genre,
        M.title AS movie_name,
        M.worlwide_gross_income,
        ROW_NUMBER() OVER (PARTITION BY M.year, G.genre ORDER BY M.worlwide_gross_income DESC) AS movie_rank
    FROM 
        movies_data M
    JOIN 
        genre G ON M.id = G.movie_id
    JOIN 
        TopGenres TG ON G.genre = TG.genre
    WHERE 
        TG.genre_rank <= 3
)
SELECT 
    genre,
    year,
    movie_name,
    worlwide_gross_income,
    movie_rank
FROM 
    TopMovies
WHERE 
    movie_rank <= 5
ORDER BY 
    genre, year, movie_rank;









-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH HitMovies AS (
    SELECT 
        M.production_company,
        COUNT(DISTINCT M.id) AS distinct_movie_count,
        ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT M.id) DESC) AS prod_comp_rank
    FROM 
        movies_data M
    JOIN 
        ratings R ON M.id = R.movie_id
    WHERE 
        R.median_rating >= 8
        AND M.languages LIKE '%,%' -- Identifying movies with multiple languages (presence of a comma)
    GROUP BY 
        M.production_company
)
SELECT 
    production_company,
    distinct_movie_count AS movie_count,
    prod_comp_rank
FROM 
    HitMovies
WHERE 
    prod_comp_rank <= 2 -- Top two production companies
ORDER BY 
    prod_comp_rank;








-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH DramaActresses AS (
    SELECT 
        N.name AS actress_name,
        SUM(R.total_votes) AS total_votes,
        COUNT(DISTINCT M.id) AS movie_count,
        AVG(R.avg_rating) AS actress_avg_rating,
        ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT M.id) DESC) AS actress_rank
    FROM 
        role_mapping RM
    JOIN 
        ratings R ON RM.movie_id = R.movie_id
    JOIN 
        movies_data M ON RM.movie_id = M.id
    JOIN 
        names N ON RM.name_id = N.id
    JOIN 
        genre G ON M.id = G.movie_id
    WHERE 
        G.genre = 'Drama'
        AND R.avg_rating > 8
        AND RM.category = 'actress'
    GROUP BY 
        N.name
)
SELECT 
    actress_name,
    total_votes,
    movie_count,
    ROUND(actress_avg_rating, 2) AS actress_avg_rating,
    actress_rank
FROM 
    DramaActresses
WHERE 
    actress_rank <= 10 -- Top 3 actresses
ORDER BY 
    actress_rank;









/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH ActressStats AS (
    SELECT 
        N.name AS actress_name,
        DM.name_id AS actress_id,
        COUNT(DISTINCT M.id) AS number_of_movies,
        ROUND(AVG(DATEDIFF(day, LAG(M.date_published) OVER(PARTITION BY DM.name_id ORDER BY M.date_published)), 2)) AS avg_inter_movie_days,
        ROUND(AVG(R.avg_rating), 2) AS avg_rating,
        SUM(R.total_votes) AS total_votes,
        MIN(R.avg_rating) AS min_rating,
        MAX(R.avg_rating) AS max_rating,
        SUM(M.duration) AS total_duration
    FROM 
        role_mapping RM
    JOIN 
        director_mapping DM ON RM.movie_id = DM.movie_id
    JOIN 
        movies_data M ON RM.movie_id = M.id
    JOIN 
        ratings R ON M.id = R.movie_id
    JOIN 
        names N ON DM.name_id = N.id
    WHERE 
        RM.category = 'actress'
    GROUP BY 
        N.name, DM.name_id
)
SELECT TOP 3
    actress_id,
    actress_name,
    number_of_movies,
    COALESCE(avg_inter_movie_days, 0) AS avg_inter_movie_days,
    COALESCE(avg_rating, 0) AS avg_rating,
    COALESCE(total_votes, 0) AS total_votes,
    COALESCE(min_rating, 0) AS min_rating,
    COALESCE(max_rating, 0) AS max_rating,
    COALESCE(total_duration, 0) AS total_duration
FROM 
    ActressStats
ORDER BY 
    number_of_movies DESC;

	-----It bringing errors






