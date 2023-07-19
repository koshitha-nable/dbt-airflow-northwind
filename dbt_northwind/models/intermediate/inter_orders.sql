with intermediate_orders as (
    select 
        distinct orderid as order_id,
        coalesce(customerid, 'Unknown') as customer_id,  --replace null values
        CAST(employeeid AS INT) AS employee_id,
        orderdate as order_date,
        requireddate as required_date,
        shippeddate as shipped_date,
        coalesce(shipvia, -1) as ship_via,  --replace null values
        coalesce(freight, 0) as freight,  --replace null values
        coalesce(shipname, 'Unknown') as ship_name,
        coalesce(shipaddress, 'Unknown') as ship_address,
        coalesce(shipcity, 'Unknown') as ship_city,
        coalesce(shipregion, 'Unknown') as ship_region,
        coalesce(shippostalcode, 'Unknown') as ship_postal_code,
        coalesce(shipcountry, 'Unknown') as ship_country,
        coalesce(shippeddate::date, null) - coalesce(orderdate::date, null) as order_duration, --aditional transformation
        'true' as current_flag -- add new column

    from {{ source('northwind_csv', 'orders') }} 
    where orderid is not null 
    order by order_id,customer_id,employee_id
    
    )


select 
    order_id,
    customer_id,
    employee_id,
    order_date,
    required_date,
    shipped_date,
    ship_via,
    freight,
    ship_name,
    ship_address,
    ship_city,
    ship_region,
    ship_postal_code,
    ship_country,
    current_flag

from intermediate_orders