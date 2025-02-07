CREATE OR REPLACE FUNCTION login_user(_email VARCHAR) 
RETURNS TABLE (user_id INTEGER, user_password VARCHAR) AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        u.user_id, 
        u.password AS user_password 
    FROM users u 
    WHERE u.email = _email;
END;
$$ LANGUAGE plpgsql;