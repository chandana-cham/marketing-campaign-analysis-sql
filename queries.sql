-- Total campaign spend
SELECT campaign_id, SUM(amount_spent) AS total_spent
FROM marketing_spend
GROUP BY campaign_id;

-- Campaign revenue
SELECT c.campaign_name, SUM(o.order_amount) AS total_revenue
FROM campaigns c
JOIN users u ON c.campaign_id = u.campaign_id
JOIN orders o ON u.user_id = o.user_id
GROUP BY c.campaign_name;

-- Campaign profit view
CREATE VIEW campaign_profit AS
SELECT
    cost.campaign_name,
    revenue.total_revenue,
    cost.total_cost,
    (revenue.total_revenue - cost.total_cost) AS profit
FROM
(
    SELECT c.campaign_id, c.campaign_name, SUM(ms.amount_spent) AS total_cost
    FROM campaigns c
    JOIN marketing_spend ms ON c.campaign_id = ms.campaign_id
    GROUP BY c.campaign_id, c.campaign_name
) cost
JOIN
(
    SELECT c.campaign_id, SUM(o.order_amount) AS total_revenue
    FROM campaigns c
    JOIN users u ON c.campaign_id = u.campaign_id
    JOIN orders o ON u.user_id = o.user_id
    GROUP BY c.campaign_id
) revenue
ON cost.campaign_id = revenue.campaign_id;
