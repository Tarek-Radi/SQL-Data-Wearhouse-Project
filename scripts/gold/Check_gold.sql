-- Check customer Tables
SELECT  DISTINCT 
       ci.cst_gndr
      ,ca.gen
      ,CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr  --CRM is Master
           ELSE COALESCE(ci.cst_gndr,'n/a')
       END GEN
  FROM silver.crm_cust_info ci
  LEFT JOIN silver.erp_cust_az12 ca
  ON        ci.cst_key = ca.cid
  LEFT JOIN silver.erp_loc_a101 la
  ON        ci.cst_key = la.cid

-- Check Product Tables
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key -- Surrogate key
    ,pn.prd_id       AS product_id
    ,pn.prd_key      AS product_number
    ,pn.prd_nm       AS product_name
    ,pn.cat_id       AS category_id
    ,pc.cat          AS category
    ,pc.subcat       AS subcategory
    ,pc.maintenance  AS maintenance
    ,pn.prd_cost     AS cost
    ,pn.prd_line     AS product_line
    ,pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL; -- Filter out all historical data
