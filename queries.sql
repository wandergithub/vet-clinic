/*Queries that provide answers to the questions from all projects.*/
SELECT * FROM animals WHERE name LIKE '%mon%';
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-01-01';
SELECT * FROM animals WHERE neutered = B'1' AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = B'1';
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- Transactions 
-- 1
vet_clinic=# BEGIN;

vet_clinic=*# DELETE FROM animals;

vet_clinic=*# ROLLBACK;

vet_clinic=# SELECT * FROM animals;
-- 2
BEGIN;

DELETE FROM animals
WHERE date_of_birth > '2022-01-01';

SAVEPOINT SP1;

UPDATE animals
SET weight_kg = weight_kg * -1;

ROLLBACK TO SP1;

UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

COMMIT;

-- Answer questions
SELECT COUNT(*) FROM animals;

SELECT COUNT(escape_attempts)  
FROM animals
WHERE escape_attempts = 0;

SELECT AVG(weight_kg) FROM animals;

SELECT SUM(escape_attempts) FROM animals
GROUP BY neutered;

SELECT MAX(weight_kg), MIN(weight_kg) FROM animals
GROUP BY species;

SELECT AVG(escape_attempts) FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-01-01'
GROUP BY species;

-- Answer questions 2
SELECT *
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

SELECT *
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

SELECT o.full_name, a.name
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id;

SELECT COUNT(a.id)
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

SELECT COUNT(a.id)
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Digimon';

SELECT *
FROM animals 
JOIN owners ON animals.owner_id = owners.id
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

SELECT * 
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

SELECT owners.full_name, COUNT(animals.name)
FROM owners
JOIN animals ON animals.owner_id = owners.id
GROUP BY full_name;

-- Answer questions many to many project
SELECT visits.vet_id, MAX(visits.date_of_visit)
FROM visits 
JOIN animals ON visits.animal_id = animals.id
JOIN vets ON vets.id = visits.vet_id
WHERE vets.name = 'William Tatcher'
GROUP BY visits.vet_id;

SELECT vets.id, COUNT(animal_id)
FROM visits
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez'
GROUP BY vets.id;

SELECT vets.name, species.name
FROM vets
LEFT JOIN specializations ON specializations.vet_id = vets.id
LEFT JOIN species ON species.id = specializations.species_id;

SELECT animals.name
FROM animals
JOIN visits ON visits.animal_id = animals.id
JOIN vets ON vets.id = visits.vet_id
WHERE vets.name = 'Stephanie Mendez' AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

SELECT MAX(mycount)
FROM (SELECT animals.name, COUNT(visits.animal_id) mycount
FROM animals
JOIN visits ON visits.animal_id = animals.id
GROUP BY animals.name) AS foo;

SELECT animals.name, MIN(visits.date_of_visit) 
FROM animals
JOIN visits ON visits.animal_id = animals.id
JOIN vets ON vets.id = visits.vet_id
WHERE vets.name = 'Maisy Smith' 
GROUP BY animals.name
LIMIT 1;

SELECT animals.name, vets.name, lastVisitToMaisy
FROM
(SELECT MAX(visits.date_of_visit) myDate
FROM animals
JOIN visits ON visits.animal_id = animals.id
JOIN vets ON vets.id = visits.vet_id
WHERE vets.name = 'Maisy Smith'
) AS lastVisitToMaisy
JOIN visits ON visits.date_of_visit = lastVisitToMaisy.myDate
JOIN animals ON visits.animal_id = animals.id
JOIN vets ON vets.id = visits.vet_id;

SELECT COUNT(*)
FROM visits
JOIN vets ON vets.id = visits.vet_id
JOIN animals ON animals.id = visits.animal_id
WHERE animals.species_id NOT IN (
  SELECT specializations.species_id 
  FROM vets
  LEFT JOIN specializations ON specializations.vet_id = vets.id
  WHERE vets.id = visits.vet_id
  AND specializations.species_id IS NOT NULL
);

SELECT species.name, COUNT(animals.species_id)
FROM visits
JOIN vets ON vets.id = visits.vet_id
JOIN animals ON animals.id = animal_id
JOIN species ON species.id = animals.species_id
GROUP BY species.name
ORDER BY COUNT DESC
LIMIT 1;
