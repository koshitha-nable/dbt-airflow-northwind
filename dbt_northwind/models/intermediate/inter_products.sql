with intermediate_products as (
    select distinct productid as product_id,
        coalesce(productname, 'Unknown') as product_name,  --replace null values
        coalesce(categoryid, -1) as category_id,
        coalesce(supplierid, -1) as supplier_id,
        coalesce(quantityperunit, 'Unknown') as quantity_per_unit,  --replace null values
        coalesce(unitprice, -1) as unit_price,
        coalesce(unitsinstock, -1) as units_in_stock,
        coalesce(unitsonorder, -1) as units_on_order,
        coalesce(reorderlevel, -1) as reorder_level,
        discontinued,
        'true' as current_flag, -- add new coumn
        coalesce(unitprice, -1) * coalesce(unitsinstock, -1) as total_value_in_stock --additional transforamation

    from {{ source('northwind_csv', 'products') }}
    where productid is not null -- Exclude rows with null productid
    order by productid
)

select 
    product_id,
    product_name,
    category_id,
    supplier_id,
    quantity_per_unit,
    unit_price,
    units_in_stock,
    units_on_order,
    reorder_level,
    discontinued,
    current_flag
from intermediate_products