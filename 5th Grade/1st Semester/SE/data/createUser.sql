CREATE USER 'leitrack'@'localhost' IDENTIFIED WITH mysql_native_password BY 'leitrack';
GRANT ALL PRIVILEGES on leitrack.* TO 'leitrack'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;