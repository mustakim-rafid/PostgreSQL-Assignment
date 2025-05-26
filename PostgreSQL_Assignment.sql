-- Active: 1747587842839@@localhost@5432@conservation_db@public
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(30)
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(50) UNIQUE,
    discovery_date DATE,
    conservation_status VARCHAR(10)
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INTEGER REFERENCES species(species_id),
    ranger_id INTEGER REFERENCES rangers(ranger_id),
    location VARCHAR(30) NOT NULL,
    sighting_time TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    notes TEXT
);

INSERT INTO rangers (name, region) VALUES
    ('Alice Green', 'Northern Hills'), 
    ('Bob White', 'River Delta'), 
    ('Carol King', 'Mountain Range');

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
    ('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
    ('Bengal Tiger', 'Panthera tigris', '1758-01-01', 'Endangered'),
    ('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
    ('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
    (1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
    (2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
    (3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
    (1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

-- Problem 1

INSERT INTO rangers (name, region) VALUES ('Derek Fox', 'Coastal Plains');

-- Problem 2

SELECT count(*) as "unique_species_count" FROM 
    (SELECT species_id FROM sightings GROUP BY species_id);

-- Problem 3

SELECT * FROM sightings
    WHERE location LIKE ('%Pass%');

-- Problem 4

SELECT name, count(name) as "total_sightings" FROM rangers
    JOIN sightings ON rangers.ranger_id = sightings.ranger_id
    GROUP BY name;

-- Problem 5

SELECT common_name FROM species
    LEFT JOIN sightings ON species.species_id = sightings.species_id
    WHERE sighting_id IS NULL;

-- Problem 6

SELECT common_name, sighting_time, name FROM sightings
    JOIN rangers ON sightings.ranger_id = rangers.ranger_id
    JOIN species ON sightings.species_id = species.species_id
    ORDER BY sighting_time DESC LIMIT 2;

-- Problem 7

UPDATE species SET conservation_status = 'Historic'
    WHERE extract(YEAR FROM discovery_date) < 1800;

-- Problem 8

SELECT sighting_id,
    CASE 
        WHEN extract(HOUR FROM sighting_time) < 12 AND extract(HOUR FROM sighting_time) > 5 THEN 'Morning'
        WHEN extract(HOUR FROM sighting_time) >= 12 AND extract(HOUR FROM sighting_time) < 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;

-- Problem 9

DELETE FROM rangers WHERE
    ranger_id NOT IN (SELECT ranger_id FROM sightings);