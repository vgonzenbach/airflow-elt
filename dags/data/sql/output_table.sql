INSERT retail_sales.output_table(
    country,
    sales_date,
    outlet_id,
    outlet_name,
    region,
    sales_value ,
    sales_value_eur
)
WITH sales_daily_today AS ( -- filter in date of interest on `sales_daily` table
  SELECT 
    country, 
    sales_date,
    outlet_id,
    sales_value,
    product_id, -- will be dropped from final output
  FROM retail_sales.sales_daily
  WHERE sales_date = CURRENT_DATE() - 1
), 
products_info_excluding AS ( -- filter out own_brand products in `product_info` table
  SELECT 
    product_id,
    is_own_brand
  FROM retail_sales.products_info
  WHERE is_own_brand = FALSE
),
sales_daily_today_excluding AS ( -- inner join filtered tables `sales_daily_today` and `product_info_excluding`
  SELECT
      country, 
      sales_date, 
      outlet_id,
      sales_value -- dropped `product_id` from output
  FROM sales_daily_today s_d
  INNER JOIN products_info_excluding p_i 
      ON s_d.product_id = p_i.product_id
),
curr_exchange_today AS ( -- filter in date of interest on `curr_exchange_today`
    SELECT  
        country,      
        rate_date,
        ex_loc_to_eur
    FROM retail_sales.curr_exchange
    WHERE rate_date = CURRENT_DATE() - 1
)
SELECT
    s_d.country AS country, 
    s_d.sales_date AS sales_date, 
    o_i.outlet_id AS outlet_id,
    o_i.outlet_name AS outlet_name,
    o_i.region AS region,
    s_d.sales_value AS sales_value,
    (s_d.sales_value * c_e.ex_loc_to_eur) AS sales_value_eur
FROM sales_daily_today_excluding s_d 
LEFT JOIN retail_sales.outlets_info o_i 
    ON s_d.outlet_id = o_i.outlet_id
LEFT JOIN curr_exchange_today c_e 
    ON s_d.country = c_e.country;