# Find all category names that contain the letter ‘a’ only once.
USE sakila;
SELECT DISTINCT name
FROM category
WHERE REGEXP_LIKE(name, '^([^a]*a[^a]*)$');
