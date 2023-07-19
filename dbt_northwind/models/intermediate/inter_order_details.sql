
with intermediate_order_details as (
    select distinct CAST(orderid AS INTEGER) as order_id, --cast string id to interger
        productid as product_id,
        coalesce(unitprice, -1) as unit_price,  --replace null values
        quantity,
        coalesce(discount, 0) as discount,  --replace null values
        coalesce(unitprice, -1) * (1 - coalesce(discount, 0)) as discounted_unit_price,
        coalesce(unitprice, -1) * quantity * (1 - coalesce(discount, 0)) as line_total, --additional column
        'true' as current_flag -- add new coumn

    from {{ source('northwind_csv','order_details') }}
    where orderid is not null
    order by orderid
)

select 
    order_id,
    product_id,
    unit_price,
    quantity,
    discount,
    current_flag
from intermediate_order_details