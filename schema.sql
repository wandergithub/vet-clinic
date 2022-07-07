/* Database schema to keep the structure of entire database. */

 CREATE TABLE animals(
    id INT GENERATED ALWAYS AS IDENTITY,
    name CHAR(40),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BIT,
    weight_kg DECIMAL,
    species_id INT references species(id),
    owner_id INT references owners(id),
    PRIMARY KEY(id)
);

CREATE TABLE owners(
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name CHAR(40),
    age INT,
    PRIMARY KEY (id)
);

CREATE TABLE  species (
    id INT GENERATED ALWAYS AS IDENTITY,
    name CHAR(40),
    PRIMARY KEY (id)
);

CREATE TABLE vets (
    id INT GENERATED ALWAYS AS IDENTITY,
    name CHAR(40),
    age INT,
    date_of_graduation DATE,
    PRIMARY KEY (id)
);