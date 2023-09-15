--- Query AnnualSalesVolume

CREATE OR REPLACE VIEW AnnualSalesVolume AS 
    SELECT year, sum(count*price*(1-(discount/100))) as weighted_Price 
    FROM includes 
    NATURAL JOIN invoice 
    NATURAL JOIN product 
    GROUP BY year;
SELECT * FROM AnnualSalesVolume;

--- Query AllRecruits

CREATE OR REPLACE VIEW AllRecruits AS
    WITH RECURSIVE recruits_rec(recruit, recruiter) AS (
        SELECT recruits.recruit, recruits.recruiter
        FROM recruits
        UNION 
        SELECT recruits.recruit, recruits_rec.recruiter
        FROM recruits_rec, recruits
        WHERE recruits.recruiter = recruits_rec.recruit
    )SELECT * FROM recruits_rec;

SELECT * FROM AllRecruits;

    --- Query AllRecruitionSteps

CREATE OR REPLACE VIEW AllRecruitionSteps AS
    WITH RECURSIVE recruits_rec(recruit, step, recruiter) AS (
        SELECT recruits.recruit, 1, recruits.recruiter
        FROM recruits
        UNION 
        SELECT recruits.recruit, step+1, recruits_rec.recruiter
        FROM recruits_rec, recruits
        WHERE recruits.recruiter = recruits_rec.recruit
    )SELECT * FROM recruits_rec;

SELECT * FROM AllRecruitionSteps;