CREATE OR REPLACE FUNCTION register_user(
    _name VARCHAR,
    _mobile VARCHAR,
    _email VARCHAR,
    _password VARCHAR,
    _role VARCHAR
) RETURNS TABLE (new_user_id INTEGER, message VARCHAR) AS $$
BEGIN
    -- Implementation
END;
$$ LANGUAGE plpgsql;