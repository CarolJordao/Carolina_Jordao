use ddmban_sql_analysis;

-- ----------- STEP 1: DUPLICATES
/* First of all, it's important to check for duplicate rows (meaning dupllicate entries of the same product) 
so that we can dismiss them, if they exist */

SELECT product, COUNT(product) as nr_prod
FROM ddmban_data
GROUP BY product
HAVING COUNT(product) > 1;
-- The output returns 12 duplicate products. The next step is excluding them by using a distinct clause.

-- ----------- STEP 2: CLEAN DATA AND RUN T-TEST
/* To clean the database, we are using the WITH clause to create a new table called new_table only with the columns 
we need to run the t-tests. On this table, we are using the distinct function on the column "product", as we are 
cleaning the "price" data by replacing the '.' with nothing. This way the data we need to work with is clean and, 
thus, easier to work with.
After creating this table, we are creating plenty more. Please, refer to the comments of each new table.
*/
WITH new_table AS (
				SELECT distinct product, id, category, subcategory, vegan, glutenfree, ketofriendly , vegetarian , organic , dairyfree ,
                sugarconscious , paleofriendly , wholefoodsdiet ,lowsodium , kosher , lowfat, engine2,
                format(replace(price, '.', '')/100,2) AS price_adjusted,
                (vegan + glutenfree+ ketofriendly + vegetarian + organic + dairyfree + 
                sugarconscious + paleofriendly + wholefoodsdiet + lowsodium + kosher + lowfat +engine2) as sum_diet
                FROM ddmban_data
                ),
          
/*This block of tables were created so that it only shows the price per value. In other words, the first table vegan1
is only showing the price of products that are vegan (where vegan = 1), whereas vegan0 will only show prices
for the products where vegan = 0. The main goal for the creation of these tables is to ease the queries of the next block. 
Refer to those comments.*/
	vegan1 as (SELECT price_adjusted FROM new_table WHERE vegan = 1),
	vegan0 as (SELECT price_adjusted FROM new_table WHERE vegan = 0),
    gluten1 as (SELECT price_adjusted FROM new_table WHERE glutenfree = 1),
	gluten0 as (SELECT price_adjusted FROM new_table WHERE glutenfree = 0),
    keto1 as (SELECT price_adjusted FROM new_table WHERE ketofriendly = 1),
	keto0 as (SELECT price_adjusted FROM new_table WHERE ketofriendly = 0),
    vegetarian1 as (SELECT price_adjusted FROM new_table WHERE vegetarian = 1),
	vegetarian0 as (SELECT price_adjusted FROM new_table WHERE vegetarian = 0),
    organic1 as (SELECT price_adjusted FROM new_table WHERE organic = 1),
	organic0 as (SELECT price_adjusted FROM new_table WHERE organic = 0),
	dairy1 as (SELECT price_adjusted FROM new_table WHERE dairyfree = 1),
	dairy0 as (SELECT price_adjusted FROM new_table WHERE dairyfree = 0),
    sugar1 as (SELECT price_adjusted FROM new_table WHERE sugarconscious = 1),
	sugar0 as (SELECT price_adjusted FROM new_table WHERE sugarconscious = 0),
    paleo1 as (SELECT price_adjusted FROM new_table WHERE paleofriendly = 1),
	paleo0 as (SELECT price_adjusted FROM new_table WHERE paleofriendly = 0),
	wholefoods1 as (SELECT price_adjusted FROM new_table WHERE wholefoodsdiet = 1),
	wholefoods0 as (SELECT price_adjusted FROM new_table WHERE wholefoodsdiet = 0),
    lowsodium1 as (SELECT price_adjusted FROM new_table WHERE lowsodium = 1),
	lowsodium0 as (SELECT price_adjusted FROM new_table WHERE lowsodium = 0),
    kosher1 as (SELECT price_adjusted FROM new_table WHERE kosher = 1),
	kosher0 as (SELECT price_adjusted FROM new_table WHERE kosher = 0),
	lowfat1 as (SELECT price_adjusted FROM new_table WHERE lowfat = 1),
	lowfat0 as (SELECT price_adjusted FROM new_table WHERE lowfat = 0),
    engine1 as (SELECT price_adjusted FROM new_table WHERE engine2 = 1),
	engine0 as (SELECT price_adjusted FROM new_table WHERE engine2 = 0),


/* Now, we are ready to start building out t-tests. Because SQL is not a statistical type of software, the chosen strategy 
is to calculate the t-value with the statistical formula and after calculate the p-value in the statistical table. Since 
there is no formula for p-value, we need to hard code the value into the table.

For every dietary preference, 2 tables were created. The first one is to calculate the t-value of that specific dietary
preference. The second one is to draw the conclusions of the hypothesis testing with the CASE statement; in other words, \
conclude whether to reject the null hypothesis or accept it. The formulated null hypothesis is “there is
NO relationship between the dietary preferences and the price”
*/
-- VEGAN T-VALUE AND P-VALUE
	vegan_ttest as (
					SELECT "vegan" as diet,
                    FORMAT((((SELECT avg(price_adjusted) FROM vegan1) - (SELECT avg(price_adjusted) FROM vegan0)) -- meanX1 - meanX2
							/
							(SQRT ( 
									(SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM vegan1)/(SELECT COUNT(price_adjusted) FROM vegan1) -- stdevX1^2 / N1
									+ ((SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM vegan0)/(SELECT COUNT(price_adjusted) FROM vegan0))) -- stdevX2^2 / N2
					)),2) as t_value,     
                   0.19 as p_value
					FROM new_table),
                        
	vegan_pvalue AS (SELECT diet, t_value, p_value,  
					 CASE WHEN p_value > 0.05 THEN "Accept H0"
						  WHEN p_value <= 0.05 THEN "Reject H0"
                          END as hypothesis_testing
					FROM vegan_ttest),
                       	
                        
-- GLUTEN FREE T-VALUE AND P-VALUE
	gluten_ttest as (
					SELECT "gluten free" as diet,
                    FORMAT((((SELECT avg(price_adjusted) FROM gluten1) - (SELECT avg(price_adjusted) FROM gluten0)) -- meanX1 - meanX2
							/
							(SQRT ( 
									(SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM gluten1)/(SELECT COUNT(price_adjusted) FROM gluten1) -- stdevX1^2 / N1
									+ ((SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM gluten0)/(SELECT COUNT(price_adjusted) FROM gluten0))) -- stdevX2^2 / N2
					)),2) as t_value,
					0.62 as p_value
					FROM new_table),
                        
	gluten_pvalue AS (SELECT diet, t_value, p_value,  
					 CASE WHEN p_value > 0.05 THEN "Accept H0"
						  WHEN p_value <= 0.05 THEN "Reject H0"
                          END as hypothesis_testing
					FROM gluten_ttest),
                        
-- KETO FRIENDLY T-VALUE AND P-VALUE
	keto_ttest as (
					SELECT "keto friendly" as diet,
                    FORMAT((((SELECT avg(price_adjusted) FROM keto1) - (SELECT avg(price_adjusted) FROM keto0)) -- meanX1 - meanX2
							/
							(SQRT ( 
									(SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM keto1)/(SELECT COUNT(price_adjusted) FROM keto1) -- stdevX1^2 / N1
								+ ((SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM keto0)/(SELECT COUNT(price_adjusted) FROM keto0))) -- stdevX2^2 / N2
					)),2) as t_value,
					0.87 as p_value
					FROM new_table),
                        
	keto_pvalue AS (SELECT diet, t_value, p_value,  
					 CASE WHEN p_value > 0.05 THEN "Accept H0"
						  WHEN p_value <= 0.05 THEN "Reject H0"
                          END as hypothesis_testing
					FROM keto_ttest),
       
-- VEGETARIAN T-VALUE AND P-VALUE
	vegetarian_ttest as (
					SELECT "vegetarian" as diet,
                    FORMAT((((SELECT avg(price_adjusted) FROM vegetarian1) - (SELECT avg(price_adjusted) FROM vegetarian0)) -- meanX1 - meanX2
							/
							(SQRT ( 
									(SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM vegetarian1)/(SELECT COUNT(price_adjusted) FROM vegetarian1) -- stdevX1^2 / N1
									+ ((SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM vegetarian0)/(SELECT COUNT(price_adjusted) FROM vegetarian0))) -- stdevX2^2 / N2
					)),2) as t_value, 
					0.14 as p_value
					FROM new_table),
                        
	vegetarian_pvalue AS (SELECT diet, t_value, p_value,  
					 CASE WHEN p_value > 0.05 THEN "Accept H0"
						  WHEN p_value <= 0.05 THEN "Reject H0"
                          END as hypothesis_testing
					FROM vegetarian_ttest),
-- ORGANIC T-VALUE AND P-VALUE
	organic_ttest as (
					SELECT "organic" as diet,
                    FORMAT((((SELECT avg(price_adjusted) FROM organic1) - (SELECT avg(price_adjusted) FROM organic0)) -- meanX1 - meanX2
							/
							(SQRT ( 
									(SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM organic1)/(SELECT COUNT(price_adjusted) FROM organic1) -- stdevX1^2 / N1
									+ ((SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM organic0)/(SELECT COUNT(price_adjusted) FROM organic0))) -- stdevX2^2 / N2
					)),2) as t_value,
					0.03 as p_value
					FROM new_table),
                        
	organic_pvalue AS (SELECT diet, t_value, p_value,  
					 CASE WHEN p_value > 0.05 THEN "Accept H0"
						  WHEN p_value <= 0.05 THEN "Reject H0"
                          END as hypothesis_testing
					FROM organic_ttest),

-- DAIRY FREE T-VALUE AND P-VALUE
	dairy_ttest as (
					SELECT "dairy free" as diet,
                    FORMAT((((SELECT avg(price_adjusted) FROM dairy1) - (SELECT avg(price_adjusted) FROM dairy0)) -- meanX1 - meanX2
							/
							(SQRT (
									(SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM dairy1)/(SELECT COUNT(price_adjusted) FROM dairy1) -- stdevX1^2 / N1
									+ ((SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM dairy0)/(SELECT COUNT(price_adjusted) FROM dairy0))) -- stdevX2^2 / N2
					)),2) as t_value,
				    0.29 as p_value
					FROM new_table),
                        
	dairy_pvalue AS (SELECT diet, t_value, p_value,  
					 CASE WHEN p_value > 0.05 THEN "Accept H0"
						  WHEN p_value <= 0.05 THEN "Reject H0"
                          END as hypothesis_testing
					FROM dairy_ttest),

-- SUGAR CONSCIOUS T-VALUE AND P-VALUE
	sugar_ttest as (
					SELECT "sugar conscious" as diet,
                    format((((SELECT avg(price_adjusted) FROM sugar1) - (SELECT avg(price_adjusted) FROM sugar0)) -- meanX1 - meanX2
							/
							(SQRT ( 
									(SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM sugar1)/(SELECT COUNT(price_adjusted) FROM sugar1) -- stdevX1^2 / N1
									+ ((SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM sugar0)/(SELECT COUNT(price_adjusted) FROM sugar0))) -- stdevX2^2 / N2
					)),2) as t_value,
				    0.39 as p_value
					FROM new_table),
                        
	sugar_pvalue AS (SELECT diet, t_value, p_value,  
					 CASE WHEN p_value > 0.05 THEN "Accept H0"
						  WHEN p_value <= 0.05 THEN "Reject H0"
                          END as hypothesis_testing
					FROM sugar_ttest),

-- PALEO FRIENDLY T-VALUE AND P-VALUE
	paleo_ttest as (
					SELECT "paleo friendly" as diet,
                    FORMAT((((SELECT avg(price_adjusted) FROM paleo1) - (SELECT avg(price_adjusted) FROM paleo0)) -- meanX1 - meanX2
							/
							(SQRT ( 
									(SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM paleo1)/(SELECT COUNT(price_adjusted) FROM paleo1) -- stdevX1^2 / N1
									+ ((SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM paleo0)/(SELECT COUNT(price_adjusted) FROM paleo0))) -- stdevX2^2 / N2
					)),2) as t_value, 
					0.23 as p_value
					FROM new_table),
                        
	paleo_pvalue AS (SELECT diet, t_value, p_value,  
					 CASE WHEN p_value > 0.05 THEN "Accept H0"
						  WHEN p_value <= 0.05 THEN "Reject H0"
                          END as hypothesis_testing
					FROM paleo_ttest),
	
-- WHOLE FOODS DIET T-VALUE AND P-VALUE
    wholefoods_ttest as (
					SELECT "whole foods diet" as diet,
                   FORMAT( (((SELECT avg(price_adjusted) FROM wholefoods1) - (SELECT avg(price_adjusted) FROM wholefoods0)) -- meanX1 - meanX2
							/
							(SQRT ( 
									(SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM wholefoods1)/(SELECT COUNT(price_adjusted) FROM wholefoods1) -- stdevX1^2 / N1
									+ ((SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM wholefoods0)/(SELECT COUNT(price_adjusted) FROM wholefoods0))) -- stdevX2^2 / N2
					)),2) as t_value ,
					0.01 as p_value
					FROM new_table),
                        
	wholefoods_pvalue AS (SELECT diet, t_value, p_value,  
					 CASE WHEN p_value > 0.05 THEN "Accept H0"
						  WHEN p_value <= 0.05 THEN "Reject H0"
                          END as hypothesis_testing
					FROM wholefoods_ttest),

-- LOW SODIUM T-VALUE AND P-VALUE
	lowsodium_ttest as (
					SELECT "low sodium" as diet,
                   FORMAT( (((SELECT avg(price_adjusted) FROM lowsodium1) - (SELECT avg(price_adjusted) FROM lowsodium0)) -- meanX1 - meanX2
							/
							(SQRT ( 
									(SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM lowsodium1)/(SELECT COUNT(price_adjusted) FROM lowsodium1) -- stdevX1^2 / N1
									+ ((SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM lowsodium0)/(SELECT COUNT(price_adjusted) FROM lowsodium0))) -- stdevX2^2 / N2
					)), 2) as t_value, 
					0.12 as p_value
					FROM new_table),
                        
	lowsodium_pvalue AS (SELECT diet, t_value, p_value,  
					 CASE WHEN p_value > 0.05 THEN "Accept H0"
						  WHEN p_value <= 0.05 THEN "Reject H0"
                          END as hypothesis_testing
					FROM lowsodium_ttest),
-- KOSHER T-VALUE AND P-VALUE
	kosher_ttest as (
					SELECT "kosher" as diet,
                    FORMAT((((SELECT avg(price_adjusted) FROM kosher1) - (SELECT avg(price_adjusted) FROM kosher0)) -- meanX1 - meanX2
							/
							(SQRT ( 
									(SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM kosher1)/(SELECT COUNT(price_adjusted) FROM kosher1) -- stdevX1^2 / N1
									+ ((SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM lowsodium0)/(SELECT COUNT(price_adjusted) FROM lowsodium0))) -- stdevX2^2 / N2
					)),2) as t_value, 
					0.50 as p_value
					FROM new_table),
                        
	kosher_pvalue AS (SELECT diet, t_value, p_value,  
					 CASE WHEN p_value > 0.05 THEN "Accept H0"
						  WHEN p_value < 0.05 THEN "Reject H0"
                          END as hypothesis_testing
					FROM kosher_ttest),
-- LOW FAT T-VALUE AND P-VALUE
	lowfat_ttest as (
					SELECT "low fat" as diet,
                    FORMAT((((SELECT avg(price_adjusted) FROM lowfat1) - (SELECT avg(price_adjusted) FROM lowfat0)) -- meanX1 - meanX2
							/
							(SQRT ( 
									(SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM lowfat1)/(SELECT COUNT(price_adjusted) FROM lowfat1) -- stdevX1^2 / N1
									+ ((SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM lowfat0)/(SELECT COUNT(price_adjusted) FROM lowfat0))) -- stdevX2^2 / N2
					)),2 ) as t_value, 
					0.02 as p_value
					FROM new_table),
                        
	lowfat_pvalue AS (SELECT diet, t_value, p_value,  
					 CASE WHEN p_value > 0.05 THEN "Accept H0"
						  WHEN p_value <= 0.05 THEN "Reject H0"
                          END as hypothesis_testing
					FROM lowfat_ttest),

-- ENGINE 2 T-VALUE AND P-VALUE
	engine_ttest as (
					SELECT "engine 2" as diet,
                    FORMAT((((SELECT avg(price_adjusted) FROM engine1) - (SELECT avg(price_adjusted) FROM engine0)) -- meanX1 - meanX2
							/
							(SQRT ( 
									(SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM engine1)/(SELECT COUNT(price_adjusted) FROM engine1) -- stdevX1^2 / N1
									+ ((SELECT (stddev(price_adjusted)*stddev(price_adjusted)) FROM engine0)/(SELECT COUNT(price_adjusted) FROM engine0))) -- stdevX2^2 / N2
					)),2 ) as t_value, 
					0.00 as p_value
					FROM new_table),
                        
	engine_pvalue AS (SELECT diet, t_value, p_value,  
					 CASE WHEN p_value > 0.05 THEN "Accept H0"
						  WHEN p_value < 0.05 THEN "Reject H0"
                          END as hypothesis_testing
					FROM engine_ttest)

			select * from vegan_pvalue
			union select * from gluten_pvalue
            union select * from keto_pvalue
            union select * from vegetarian_pvalue
            union select * from organic_pvalue
            union select * from dairy_pvalue
            union select * from sugar_pvalue
            union select * from paleo_pvalue
            union select * from wholefoods_pvalue
            union select * from lowsodium_pvalue
            union select * from kosher_pvalue
            union select * from lowfat_pvalue
            union select * from engine_pvalue ;
            
            
            
            
                
      


