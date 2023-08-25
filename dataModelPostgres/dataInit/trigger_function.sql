CREATE FUNCTION lastUpdated_Change() RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN NEW;
END;
$$;

CREATE TRIGGER achievement_lastUpdated
  BEFORE UPDATE ON achievement
  FOR EACH ROW
  EXECUTE PROCEDURE lastUpdated_Change();

CREATE TRIGGER address_lastUpdated
  BEFORE UPDATE ON address
  FOR EACH ROW
  EXECUTE PROCEDURE lastUpdated_Change();

CREATE TRIGGER alignment_lastUpdated
  BEFORE UPDATE ON alignment
  FOR EACH ROW
  EXECUTE PROCEDURE lastUpdated_Change();

CREATE TRIGGER artifact_lastUpdated
  BEFORE UPDATE ON artifact
  FOR EACH ROW
  EXECUTE PROCEDURE lastUpdated_Change();

CREATE TRIGGER assertion_lastUpdated
  BEFORE UPDATE ON assertion
  FOR EACH ROW
  EXECUTE PROCEDURE lastUpdated_Change();

CREATE TRIGGER association_lastUpdated
  BEFORE UPDATE ON association
  FOR EACH ROW
  EXECUTE PROCEDURE lastUpdated_Change();

CREATE TRIGGER clr_lastUpdated
  BEFORE UPDATE ON clr
  FOR EACH ROW
  EXECUTE PROCEDURE lastUpdated_Change();

CREATE TRIGGER criteria_lastUpdated
  BEFORE UPDATE ON criteria
  FOR EACH ROW
  EXECUTE PROCEDURE lastUpdated_Change();

CREATE TRIGGER cryptographickey_lastUpdated
  BEFORE UPDATE ON cryptographickey
  FOR EACH ROW
  EXECUTE PROCEDURE lastUpdated_Change();

CREATE TRIGGER endorsement_lastUpdated
  BEFORE UPDATE ON endorsement
  FOR EACH ROW
  EXECUTE PROCEDURE lastUpdated_Change();

CREATE TRIGGER endorsementclaim_lastUpdated
  BEFORE UPDATE ON endorsementclaim
  FOR EACH ROW
  EXECUTE PROCEDURE lastUpdated_Change();

CREATE TRIGGER identity_lastUpdated
  BEFORE UPDATE ON identity
  FOR EACH ROW
  EXECUTE PROCEDURE lastUpdated_Change();

CREATE TRIGGER profile_lastUpdated
  BEFORE UPDATE ON profile
  FOR EACH ROW
  EXECUTE PROCEDURE lastUpdated_Change();

CREATE TRIGGER result_lastUpdated
  BEFORE UPDATE ON result
  FOR EACH ROW
  EXECUTE PROCEDURE lastUpdated_Change();

CREATE TRIGGER resultdescription_lastUpdated
  BEFORE UPDATE ON resultdescription
  FOR EACH ROW
  EXECUTE PROCEDURE lastUpdated_Change();

CREATE TRIGGER verification_lastUpdated
  BEFORE UPDATE ON verification
  FOR EACH ROW
  EXECUTE PROCEDURE lastUpdated_Change();
