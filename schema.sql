/* Database schema to keep the structure of entire database. */

 CREATE TABLE animals(
    id INT PRIMARY KEY NOT NULL,
    name CHAR(40),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BIT,
    weight_kg DECIMAL
);