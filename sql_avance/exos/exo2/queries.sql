--1 synthèse commande

CREATE OR REPLACE VIEW order_total AS
	SELECT o.customer_id, c.full_name, o.order_id, o.order_date, o.status, 
		SUM(oi.quantity * oi.unit_price) AS total
	FROM orders o
	JOIN customers c on o.customer_id = c.customer_id
	LEFT JOIN order_items oi ON o.order_id = oi.order_id
	GROUP BY o.customer_id, c.full_name, o.order_id, o.order_date, o.status;

SELECT * FROM order_total
WHERE status = 'COMPLETED'
ORDER BY order_date DESC, order_id;

--2 statistiques de vente par jour
CREATE MATERIALIZED VIEW daily_stats AS
	SELECT o.order_date, COUNT(o.order_id) AS nb_orders, SUM(oi.quantity * oi.unit_price) AS revenue_by_day
	FROM orders o
	LEFT JOIN order_items oi on o.order_id = oi.order_id
	GROUP BY o.order_date;

SELECT * FROM daily_stats;
SELECT * FROM daily_stats WHERE revenue_by_day > 200;

--3 clients les plus rentables
CREATE MATERIALIZED VIEW IF NOT EXISTS most_valuable_customer AS
	SELECT customer_id, full_name, Count(order_id) as nb_commandes, SUM(total) as total FROM order_total
	WHERE status = 'COMPLETED'
	GROUP BY customer_id, full_name
	ORDER BY total DESC;

SELECT * FROM most_valuable_customer WHERE nb_commandes >= 2;

--4 optimisation via index
CREATE INDEX on orders(order_date); -- beaucoup de tris sur ce champ
CREATE INDEX ON order_items(order_id) 
/* c'est la clé étrangère 
qui permet de lier les tables orders et order_item. ces deux tables sont souvient liées
car elles permettent de retrouver le chiffre d'affaires.
Je ne mettrais pas forcément d'index sur les champs unit_price et quantity 
car ils sont ramenés par d'autres champs et ne subissent pas de tris
*/

INSERT INTO orders (order_id, customer_id, order_date, status)
VALUES (7, 2, DATE '2024-05-04', 'COMPLETED');

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
    (8, 7, 3, 1, 89.00),
    (9, 7, 4, 1, 19.90);

SELECT * FROM order_total
WHERE status = 'COMPLETED'
ORDER BY order_date DESC, order_id;

SELECT * FROM daily_stats; -- cf, capture1 d'écran, pas de mise à jour, pas de 2024-05-04
REFRESH MATERIALIZED VIEW daily_stats;
SELECT * FROM daily_stats;
-- mise à jour des données cf capture2
/* les données de la materialized view doivent être mises à jour manuellement
les données ne sont pas recalaculées à chaque appel
*/