select * from diabetes d;

-- Validate Binary Values

delete FROM diabetes
WHERE "HighBP" NOT IN (0, 1)
   OR "HighChol" NOT IN (0, 1)
   OR "Smoker" NOT IN (0, 1)
   OR "Stroke" NOT IN (0, 1)
   OR "HeartDiseaseorAttack" NOT IN (0, 1)
   OR "PhysActivity" NOT IN (0, 1)
   OR "Fruits" NOT IN (0, 1)
   OR "Veggies" NOT IN (0, 1)
   OR "HvyAlcoholConsump" NOT IN (0, 1)
   OR "AnyHealthcare" NOT IN (0, 1)
   OR "NoDocbcCost" NOT IN (0, 1)
   OR "DiffWalk" NOT IN (0, 1)
   OR "Sex" NOT IN (0, 1);
  
-- Normalize BMI (Min-Max Scaling)
  
ALTER TABLE public.diabetes ADD COLUMN "BMI_normalized" float;

UPDATE diabetes
SET "BMI_normalized" = ("BMI" - (SELECT MIN("BMI") FROM diabetes)) /
          ((SELECT MAX("BMI") FROM diabetes) - (SELECT MIN("BMI") FROM diabetes));
          
-- Aggregate Age Categories
         
ALTER TABLE public.diabetes ADD COLUMN "age_category" integer;

ALTER TABLE public.diabetes ADD COLUMN "age_category_desc" varchar;
         
UPDATE diabetes
SET "age_category" = CASE
    WHEN "Age" BETWEEN 1 AND 3 THEN 1  -- Young
    WHEN "Age" BETWEEN 4 AND 7 THEN 2  -- Middle-aged
    WHEN "Age" BETWEEN 8 AND 13 THEN 3 -- Older
    ELSE "Age" 
END;

UPDATE diabetes
SET "age_category_desc" = CASE
    WHEN "age_category" = 1 then 'Young'
    WHEN "age_category" = 2 then 'Middle-aged'
    WHEN "age_category" = 3 THEN 'Older'
    ELSE 'Unlisted'
END;

-- Map Education Levels to Descriptive Categories

ALTER TABLE public.diabetes ADD COLUMN "education_desc" varchar;

UPDATE diabetes
SET "education_desc" = CASE
    WHEN "Education" = 1 THEN 'No School'
    WHEN "Education" = 2 THEN 'Elementary'
    WHEN "Education" = 3 THEN 'Some High School'
    WHEN "Education" = 4 THEN 'High School Graduate'
    WHEN "Education" = 5 THEN 'Some College'
    WHEN "Education" = 6 THEN 'College Graduate'
END;

-- Convert Income Levels into Descriptive Categories

ALTER TABLE public.diabetes ADD COLUMN "income_desc" varchar;

UPDATE diabetes
SET "income_desc" = CASE
    WHEN "Income" = 1 THEN 'Less than $10,000'
    WHEN "Income" = 2 THEN '$10,000 - $15,000'
    WHEN "Income" = 3 THEN '$15,000 - $20,000'
    WHEN "Income" = 4 THEN '$20,000 - $25,000'
    WHEN "Income" = 5 THEN '$25,000 - $35,000'
    WHEN "Income" = 6 THEN '$35,000 - $50,000'
    WHEN "Income" = 7 THEN '$50,000 - $75,000'
    WHEN "Income" = 8 THEN '$75,000 or more'
END;

-- Create Lifestyle Score (Fruits, Veggies, PhysActivity)

ALTER TABLE diabetes ADD COLUMN "LifestyleScore" INTEGER;

UPDATE diabetes
SET "LifestyleScore" = "Fruits" + "Veggies" + "PhysActivity";

-- Calculate Interaction Terms

ALTER TABLE diabetes ADD COLUMN "BMI_PhysActivity" FLOAT;

UPDATE diabetes
SET "BMI_PhysActivity" = "BMI" * "PhysActivity";

-- Convert Diabetes_012 into Descriptive Categories

ALTER TABLE diabetes ADD COLUMN "Diabetes_Type" VARCHAR(20);

UPDATE diabetes
SET "Diabetes_Type" = CASE
    WHEN "Diabetes_012" = 0 THEN 'No Diabetes'
    WHEN "Diabetes_012" = 1 THEN 'Prediabetes'
    WHEN "Diabetes_012" = 2 THEN 'Diabetes'
END;

-- Binarize Diabetes_binary

ALTER TABLE diabetes ADD COLUMN "Diabetes_Binary" INTEGER;

UPDATE diabetes
SET "Diabetes_Binary" = CASE
    WHEN "Diabetes_012" = 0 THEN 0  -- No Diabetes
    ELSE 1                          -- Prediabetes or Diabetes
END;

-- Bucketize Mental Health Days (MentHlth)

ALTER TABLE diabetes ADD COLUMN "MentHlth_Bucket" integer;

UPDATE diabetes
SET "MentHlth_Bucket" = CASE
    WHEN "MentHlth" BETWEEN 0 AND 7 THEN 2
    WHEN "MentHlth" BETWEEN 8 AND 14 THEN 1
    WHEN "MentHlth" > 14 THEN 0
END;

ALTER TABLE diabetes ADD COLUMN "MentHlth_Bucket_desc" VARCHAR(20);

UPDATE diabetes
SET "MentHlth_Bucket_desc" = CASE
    WHEN "MentHlth_Bucket" = 2 THEN 'Good'
    WHEN "MentHlth_Bucket" = 1 THEN 'Moderate'
    WHEN "MentHlth_Bucket" = 0 THEN 'Poor'
END;

-- Bucketize Physical Health Days (PhysHlth)

ALTER TABLE diabetes ADD COLUMN "PhysHlth_Bucket" integer;

UPDATE diabetes
SET "PhysHlth_Bucket" = CASE
    WHEN "PhysHlth" BETWEEN 0 AND 7 THEN 2
    WHEN "PhysHlth" BETWEEN 8 AND 14 THEN 1
    WHEN "PhysHlth" > 14 THEN 0
END;

ALTER TABLE diabetes ADD COLUMN "PhysHlth_Bucket_desc" VARCHAR(20);

UPDATE diabetes
SET "PhysHlth_Bucket_desc" = CASE
    WHEN "PhysHlth_Bucket" = 2 THEN 'Good'
    WHEN "PhysHlth_Bucket" = 1 THEN 'Moderate'
    WHEN "PhysHlth_Bucket" = 0 THEN 'Poor'
END;

-- Add the patient_id column
ALTER TABLE diabetes ADD COLUMN "patient_id" INT;

-- Create a temporary table with row numbers
CREATE TEMP TABLE temp_ranked_data AS
SELECT 
    ctid AS unique_ctid,
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + 1000 AS patient_id
FROM diabetes;

-- Update the original table using the temporary table
UPDATE diabetes
SET patient_id = temp_ranked_data.patient_id
FROM temp_ranked_data
WHERE diabetes.ctid = temp_ranked_data.unique_ctid;

-- Split into diabetes_descriptive
CREATE TABLE diabetes_class AS
SELECT 
    patient_id,
    "Diabetes_Binary" , "HighChol", "HighBP", "CholCheck", "Smoker", "Stroke", "HeartDiseaseorAttack",
    "PhysActivity", "Fruits", "Veggies", "HvyAlcoholConsump", "AnyHealthcare",
    "NoDocbcCost", "GenHlth", "MentHlth", "PhysHlth", "DiffWalk", "Sex", "Age", "age_category", 
    "BMI", "BMI_normalized", "LifestyleScore", "BMI_PhysActivity", "MentHlth_Bucket", "PhysHlth_Bucket"
FROM diabetes;

-- Split into diabetes_class
CREATE TABLE diabetes_descriptive AS
SELECT 
    patient_id,"Diabetes_012" ,"Diabetes_Type" , "Education" , education_desc , "Income" ,
    Income_desc, "Age",age_category, age_category_desc, "MentHlth", "MentHlth_Bucket", "MentHlth_Bucket_desc"
    "PhysHlth", "PhysHlth_Bucket", "PhysHlth_Bucket_desc"
FROM diabetes;

-- Use a Common Table Expression to assign random values
CREATE TEMP TABLE randomized_data AS
SELECT *, RANDOM() as random_value
FROM diabetes_class;

-- Create the train table with 80% of the data
SELECT *
INTO diabetes_class_train
FROM randomized_data
WHERE random_value <= 0.8;

-- Create the test table with the remaining 20% of the data
SELECT *
INTO diabetes_class_test
FROM randomized_data
WHERE random_value > 0.8;

-- Top correlation attributes based on feature selection

select "Diabetes_Binary", "HighBP", "DiffWalk", "HighChol", "HeartDiseaseorAttack", "CholCheck", "Smoker", "LifestyleScore",
"GenHlth", "PhysActivity", "Stroke", "PhysHlth", "PhysHlth_Bucket", age_category, "MentHlth_Bucket" 
into diabetes_train_final
from diabetes_class_train;

select "Diabetes_Binary", "HighBP", "DiffWalk", "HighChol", "HeartDiseaseorAttack", "CholCheck", "Smoker", "LifestyleScore",
"GenHlth", "PhysActivity", "Stroke", "PhysHlth", "PhysHlth_Bucket", age_category, "MentHlth_Bucket" 
into diabetes_test_final
from diabetes_class_test;
