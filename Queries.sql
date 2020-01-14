SELECT emp_num, emp_fname, emp_lname, sal_amount FROM Employee JOIN Salary_history USING (emp_num) WHERE sal_end IS NULL AND dept_num = 300 ORDER BY sal_amount DESC;

SELECT e.emp_num, emp_lname, emp_fname, sal_amount FROM Employee e JOIN Salary_history s ON e.emp_num = s.emp_num WHERE sal_from = (SELECT Min(sal_from) FROM Salary_history s2 WHERE e.emp_num = s2.emp_num) ORDER BY e.emp_num;

SELECT l.inv_num, l.line_num, p.prod_sku, p.prod_descript, l2.line_num, p2.prod_sku, p2.prod_descript, p.brand_id FROM (line l JOIN Product p ON l.prod_sku = p.prod_sku) JOIN (line l2 JOIN Product p2 ON l2.prod_sku = p2.prod_sku) ON l.inv_num = l2.inv_num WHERE p.brand_id = p2.brand_id AND p.prod_category = 'Sealer' AND p2.prod_category = 'Top Coat' ORDER BY l.inv_num, l.line_num;

SELECT emp.emp_num, emp_fname, emp_lname, emp_email, total FROM Employee emp JOIN (SELECT employee_id, SUM (line_qty) AS total FROM Invoice i JOIN line l USING (inv_num) JOIN Product p USING (prod_sku) JOIN Brand b USING (brand_id) WHERE brand_name = 'BINDER PRIME' AND INV_DATE BETWEEN '2011-11-01' AND '2011-12-06' GROUP BY employee_id) sub ON emp.emp_num = sub.employee_id
WHERE total = (SELECT Max(total) FROM (SELECT employee_id, Sum(line_qty) AS total FROM Invoice i JOIN Line l USING (inv_num) JOIN Product p USING (prod_sku) JOIN Brand b USING (brand_id) WHERE brand_name = 'BINDER PRIME' AND INV_DATE BETWEEN '2011-11-01' AND '2011-12-06' GROUP BY employee_id) AS T);

SELECT cust_code, cust_fname, cust_lname FROM Customer JOIN Invoice USING (cust_code) WHERE employee_id = 83649 AND EXISTS (SELECT cust_code, cust_fname, cust_lname FROM Customer JOIN Invoice USING (cust_code) WHERE employee_id = 83677) ORDER BY cust_lname, cust_fname;

SELECT c.cust_code, cust_fname, cust_lname, cust_street, cust_city, cust_state, cust_zip,inv_date, inv_total AS "Largest Invoice" FROM Customer c JOIN Invoice i ON c.cust_code = i.cust_code WHERE cust_state = 'AL’ AND inv_total = (SELECT MAX(inv_total) FROM Invoice i2 WHERE i2.cust_code = c.cust_code) UNION SELECT cust_code, cust_fname, cust_lname, cust_street, cust_city, cust_state, cust_zip, NULL, 0 FROM Customer WHERE cust_state = 'AL' AND cust_code NOT IN (SELECT cust_code FROM Invoice) ORDER BY cust_lname, cust_fname;

SELECT brand_name, brand_type, ROUND(avgprice,2) AS "Average Price", Units_Sold AS "Units Sold" FROM Brand b JOIN (SELECT brand_id, AVG(prod_price) AS avgprice FROM Product GROUP BY brand_id) sub1 ON b.brand_id = sub1.brand_id JOIN (SELECT brand_id, SUM(line_qty) AS "Units_Sold" FROM Product p JOIN Line l ON p.prod_sku = l.prod_sku GROUP BY brand_id) sub2 ON b.brand_id = sub2.brand_id ORDER BY brand_name;

SELECT brand_name, brand_type, prod_sku, prod_descript, prod_price FROM Product p JOIN Brand b USING(brand_id) WHERE brand_type <> "PREMIUM" AND prod_price > (SELECT MAX(prod_price) FROM Product WHERE brand_type = "PREMIUM");

SELECT prod_sku, prod_descript FROM Product WHERE prod_price > 50;

SELECT SUM (prod_qoh*prod_price) as "total value" FROM Product;

SELECT COUNT(*) AS "number of customers", SUM(cust_balance) AS "total balance" FROM Customer;

SELECT cust.cust_state, SUM(invo.inv_total) AS inv_tot FROM Customer cust INNER JOIN Invoice invo ON cust.cust_code=invo.cust_code WHERE invo.inv_num NOT LIKE '-%' GROUP BY cust.cust_state ORDER BY inv_tot DESC LIMIT 3;