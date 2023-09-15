--- Trigger a ---

CREATE OR REPLACE FUNCTION trigger_addrecruit() 
   RETURNS TRIGGER 
AS $$
DECLARE
	D1 DATE;
BEGIN
   SELECT date INTO D1 FROM recruits WHERE recruit = NEW.recruiter;

   IF NEW.date > D1 THEN
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_recruit BEFORE INSERT
    ON recruits FOR EACH ROW 
    EXECUTE PROCEDURE trigger_addrecruit();

--- Trigger b ---


--- Trigger c ---

--- Trigger d ---