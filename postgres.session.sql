DROP TABLE IF EXISTS supplychaindc;

CREATE TABLE supplychaindc (
    id SERIAL PRIMARY KEY,          -- ID أوتوماتيك
    product_type VARCHAR(100),
    sku VARCHAR(50),
    price NUMERIC(10,2),
    number_of_products_sold INT,
    revenue_generated NUMERIC(18,2),
    order_quantities INT,
    shipping_costs NUMERIC(10,2),
    supplier_name VARCHAR(100),
    location VARCHAR(100),
    lead_time INT,
    manufacturing_costs NUMERIC(10,2),
    transportation_modes VARCHAR(50)
);
COPY supplychaindc(product_type, sku, price, number_of_products_sold,
                   revenue_generated, order_quantities, shipping_costs,
                   supplier_name, location, lead_time, manufacturing_costs,
                   transportation_modes)
FROM 'F:\S\SupplyChainDC - Copy.csv'
DELIMITER ',' CSV HEADER;
SELECT * FROM supplychaindc
LIMIT 5;
DROP TABLE IF EXISTS new_supply;
CREATE TABLE new_supply AS
SELECT DISTINCT* FROM supplychaindc;
SELECT COUNT(*) - COUNT(DISTINCT sku) AS no_duplicate FROM supplychaindc;
SELECT* FROM new_supply
WHERE SKU IS NULL OR SKU='' OR product_type IS NULL OR product_type='' OR
      price IS NULL OR price<=0 OR number_of_products_sold IS NULL OR
      number_of_products_sold<0 OR revenue_generated IS NULL OR
      revenue_generated<0 OR order_quantities IS NULL OR order_quantities<0 OR
      shipping_costs IS NULL OR shipping_costs<0 OR supplier_name IS NULL OR
      supplier_name='' OR location IS NULL OR location='' OR lead_time IS NULL OR
      lead_time<0 OR manufacturing_costs IS NULL OR manufacturing_costs<0 OR
      transportation_modes IS NULL OR transportation_modes=''; 
UPDATE new_supply
SET product_type = 'Unknown'
WHERE product_type IS NULL OR product_type='';
UPDATE new_supply
SET price = (SELECT AVG(price) FROM new_supply WHERE price>0)
WHERE price IS NULL OR price<=0;  
UPDATE new_supply
SET number_of_products_sold = (SELECT AVG(number_of_products_sold) FROM new_supply
                               WHERE number_of_products_sold>0)
WHERE number_of_products_sold IS NULL OR number_of_products_sold<0;     
UPDATE new_supply
SET shipping_costs = (SELECT AVG(shipping_costs) FROM new_supply
                      WHERE shipping_costs>0)
WHERE shipping_costs IS NULL OR shipping_costs<0;       
SELECT* FROM new_supply;
SELECT DISTINCT product_type FROM new_supply;
SELECT* FROM new_supply;
SELECT COUNT(*) FROM new_supply;
SELECT * FROM supplychaindc;

