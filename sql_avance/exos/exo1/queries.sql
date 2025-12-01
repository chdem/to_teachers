CREATE SCHEMA exo1_avance;
SET search_path TO exo1_avance;

-- 1 catalogue public des morceaux

CREATE OR REPLACE VIEW public_tracks AS
SELECT t.track_id, t.title, t.duration_s, a.name
FROM tracks t
JOIN artists a on t.artist_id = a.artist_id;

SELECT * FROM public_tracks;



--2 utilisateurs premium français
CREATE OR REPLACE VIEW french_premium_users AS
SELECT * FROM users
WHERE country = 'France' AND subscription = 'Premium';

SELECT * from french_premium_users
ORDER BY username DESC;

--3

CREATE MATERIALIZED VIEW listenings_from_users AS
SELECT u.user_id, u.username, u.country, pt.title, pt.duration_s, pt.name, l.listened_at, l.seconds_played
FROM public_tracks pt
JOIN listenings l ON pt.track_id = l.track_id
JOIN users u ON l.user_id = u.user_id;

SELECT * FROM listenings_from_users WHERE country = 'France';

--4

CREATE MATERIALIZED VIEW artist_stats AS
SELECT a.name, COUNT(l.listening_id) as nb_listenings, SUM(l.seconds_played) AS nb_seconds_played, ROUND(AVG(l.seconds_played), 2) AS seconds_played
FROM artists a
JOIN tracks t ON a.artist_id = t.artist_id
JOIN listenings l ON t.track_id = l.track_id
GROUP BY a.name;

SELECT * FROM artist_stats;

SELECT * FROM artist_stats
WHERE nb_listenings > 20;


SELECT * FROM artist_stats
WHERE seconds_played > (SELECT AVG(seconds_played) FROM listenings);

--5
CREATE OR REPLACE VIEW stats_by_country AS
	SELECT country, COUNT(l.listening_id) AS nb_listening, COUNT(DISTINCT(a.artist_id)) AS nb_artists
	FROM artists a
	JOIN tracks t ON a.artist_id = t.artist_id
	JOIN listenings l on t.track_id = l.track_id
	GROUP BY country
	ORDER BY nb_listening DESC;

SELECT * FROM stats_by_country;

--6  Optimisation et index
colonnes pertinentes pour index

--6 optimisation et index
-- colonnes les plus pertinentes :
-- listenings.listend_at listenings.seconds_played
-- artists.country 
-- users.country users.subscription


CREATE INDEX ON listenings(listened_at, seconds_played);
CREATE INDEX ON artists(country);
CREATE INDEX ON users(country, subscription);