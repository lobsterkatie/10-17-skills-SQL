-- Note: Please consult the directions for this assignment 
-- for the most explanatory version of each question.

-- 1. Select all columns for all brands in the Brands table.
SELECT * FROM Brands;

-- 2. Select all columns for all car models made by Pontiac in the Models table.
SELECT * FROM Models WHERE brand_name = 'Pontiac';

-- 3. Select the brand name and model 
--    name for all models made in 1964 from the Models table.
SELECT brand_name, name FROM Models WHERE year = 1964;

-- 4. Select the model name, brand name, and headquarters for the Ford Mustang 
--    from the Models and Brands tables.
SELECT b.name, m.name, b.headquarters 
FROM Models AS m JOIN Brands AS b ON m.brand_name = b.name
WHERE m.name = 'Mustang';

-- 5. Select all rows for the three oldest brands 
--    from the Brands table (Hint: you can use LIMIT and ORDER BY).
SELECT * FROM Brands ORDER BY founded LIMIT 3;

-- 6. Count the Ford models in the database (output should be a number).
SELECT COUNT(*)FROM Models WHERE brand_name = 'Ford';

-- 7. Select the name of any and all car brands that are not discontinued.
SELECT name FROM Brands WHERE discontinued IS NULL;

-- 8. Select rows 15-25 of the DB in alphabetical order by model name.
-- If you want those rows, alphabatized:
SELECT * 
FROM (SELECT * FROM Models LIMIT 11 OFFSET 14) 
ORDER BY name;
-- If you want those rows *from the alphabatized table*:
SELECT * FROM Models ORDER BY name LIMIT 11 OFFSET 14;

-- 9. Select the brand, name, and year the model's brand was 
--    founded for all of the models from 1960. Include row(s)
--    for model(s) even if its brand is not in the Brands table.
--    (The year the brand was founded should be NULL if 
--    the brand is not in the Brands table.)
SELECT m.brand_name, m.name, b.founded 
FROM Models as m LEFT JOIN Brands as b ON m.brand_name = b.name 
WHERE m.year = 1960;


-- Part 2: Change the following queries according to the specifications. 
-- Include the answers to the follow up questions in a comment below your
-- query.

-- 1. Modify this query so it shows all brands that are not discontinued
-- regardless of whether they have any models in the models table.
-- before:
    -- SELECT b.name,
    --        b.founded,
    --        m.name
    -- FROM Model AS m
    --   LEFT JOIN brands AS b
    --     ON b.name = m.brand_name
    -- WHERE b.discontinued IS NULL;
SELECT b.name, b.founded 
FROM Brands as b LEFT JOIN Models as m ON b.name = m.brand_name 
WHERE b.discontinued IS NULL 
GROUP BY b.name;

-- Note that I did two things which weren't explicitly called for but which made sense to me based on the way the question was worded, to wit: I grouped by brand name ('list all the brands' to me sounds like once each) and then I took off the model name (since we're talking about brands, not models, so just picking a random model to list next to the name seemed odd).


-- 2. Modify this left join so it only selects models that have brands in the Brands table.
-- before: 
    -- SELECT m.name,
    --        m.brand_name,
    --        b.founded
    -- FROM Models AS m
    --   LEFT JOIN Brands AS b
    --     ON b.name = m.brand_name;
SELECT m.name, m.brand_name, b.founded 
FROM Models as m LEFT JOIN Brands as b ON m.brand_name = b.name;

-- followup question: In your own words, describe the difference between 
-- left joins and inner joins.
-- A LEFT JOIN B is basically A union (A intersect B). In other words, you get everything from A, regardless of whether it's also in B, along with everything from B *which is also in A.*
-- A (INNER) JOIN B is basically A intersect B. In other words, you get only things which appear in both tables.


-- 3. Modify the query so that it only selects brands that don't have any models in the models table. 
-- (Hint: it should only show Tesla's row.)
-- before: 
    -- SELECT name,
    --        founded
    -- FROM Brands
    --   LEFT JOIN Models
    --     ON brands.name = Models.brand_name
    -- WHERE Models.year > 1940;
SELECT b.name 
FROM Brands AS b LEFT JOIN Models as m ON b.name = m.brand_name 
WHERE m.name IS NULL;


-- 4. Modify the query to add another column to the results to show 
-- the number of years from the year of the model until the brand becomes discontinued
-- Display this column with the name years_until_brand_discontinued.
-- before: 
    -- SELECT b.name,
    --        m.name,
    --        m.year,
    --        b.discontinued
    -- FROM Models AS m
    --   LEFT JOIN brands AS b
    --     ON m.brand_name = b.name
    -- WHERE b.discontinued NOT NULL;
SELECT m.year, b.name, m.name, b.founded, b.discontinued, 
       (b.discontinued - b.founded) AS years_until_brand_discontinued 
FROM Models as m JOIN Brands as b ON m.brand_name = b.name 
WHERE b.discontinued IS NOT NULL;

-- Note that I also added a column for when the brand was founded, because even though the columns were labeled with headers, it was still disconcerting to see two years and then a differene, wherein the difference wasn't actually the difference between those two years. For the same reason, I moved the model year to the first column.



-- Part 3: Further Study

-- 1. Select the name of any brand with more than 5 models in the database.
SELECT brand_name, COUNT(*) 
FROM Models 
GROUP BY brand_name 
HAVING COUNT(*) > 5;

-- 2. Add the following rows to the Models table.

-- year    name       brand_name
-- ----    ----       ----------
-- 2015    Chevrolet  Malibu
-- 2015    Subaru     Outback
INSERT INTO Models (year, brand_name, name) 
VALUES ('2015', 'Chevrolet', 'Malibu'), ('2015', 'Subaru', 'Outback');
--NOTE: the headings above are reversed, which I didn't realize until everything broke down in number 4.


-- 3. Write a SQL statement to crate a table called `Awards`
--    with columns `name`, `year`, and `winner`. Choose
--    an appropriate datatype and nullability for each column
--   (no need to do subqueries here).
CREATE TABLE Awards (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name VARCHAR(50) NOT NULL,
year INT(4) NOT NULL,
winner VARCHAR(50)
);


-- 4. Write a SQL statement that adds the following rows to the Awards table:

--   name                 year      winner_model_id
--   ----                 ----      ---------------
--   IIHS Safety Award    2015      the id for the 2015 Chevrolet Malibu
--   IIHS Safety Award    2015      the id for the 2015 Subaru Outback
INSERT INTO Awards(name, year, winner_model_id)
VALUES ('IIHS Safety Award',
        '2015',
        (SELECT id FROM Models WHERE
             year = 2015 AND
             brand_name LIKE 'Chevrolet' AND
             name LIKE 'Malibu')
        );
INSERT INTO Awards(name, year, winner_model_id)
VALUES ('IIHS Safety Award',
        '2015',
        (SELECT id FROM Models WHERE
             year = 2015 AND
             brand_name LIKE 'Subaru' AND
             name LIKE 'Outback')
        );
--NOTE: dropped and remade the table from #3 to reflect the more explanatory third column title.


-- 5. Using a subquery, select only the *name* of any model whose 
-- year is the same year that *any* brand was founded.
SELECT m.year AS model_year, 
       m.name AS model, 
       b.name AS brand, 
       b.founded 
FROM Models AS m JOIN Brands AS b ON m.year = b.founded;
--NOTE: this obviously gives three columns not requested, but they make it easier to tell that the answer is right. If you just wanted the model name, clearly you could just take those other columns out of the query.





