BEGIN;
SET search_path TO terasologykeys, public;
SELECT plan(2);
PREPARE bad_pass AS SELECT post_user_account('{"login": "test", "password1": "test11111", "password2": "test22222"}'::JSON);
SELECT throws_ok('bad_pass', 'customError');
SELECT post_user_account('{"login": "test", "password1": "pass12345", "password2": "pass12345"}'::JSON);
PREPARE expected AS (SELECT 'test'::TEXT AS login);
PREPARE actual AS SELECT login FROM user_account WHERE password=crypt('pass12345', password) ;
SELECT set_has('actual', 'expected');
SELECT finish();
ROLLBACK;
