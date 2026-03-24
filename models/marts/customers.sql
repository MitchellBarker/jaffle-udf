with

customers as (

    select * from {{ ref('stg_customers') }}

),

orders as (

    select * from {{ ref('orders') }}

),

customer_orders_summary as (

    select
        orders.customer_id,

        count(distinct orders.order_id) as count_lifetime_orders,
        count(distinct orders.order_id) > 1 as is_repeat_buyer,
        min(orders.ordered_at) as first_ordered_at,
        max(orders.ordered_at) as last_ordered_at,
        sum(orders.subtotal) as lifetime_spend_pretax,
        sum(orders.tax_paid) as lifetime_tax_paid,
        sum(orders.order_total) as lifetime_spend

    from orders

    group by 1

),

joined as (

    select
        customers.*,

        customer_orders_summary.count_lifetime_orders,
        customer_orders_summary.first_ordered_at,
        customer_orders_summary.last_ordered_at,
        customer_orders_summary.lifetime_spend_pretax,
        customer_orders_summary.lifetime_tax_paid,
        customer_orders_summary.lifetime_spend,

        {{ function('classify_customer') }}(customer_orders_summary.count_lifetime_orders) as customer_type,
        {{ function('customer_lifetime_tier') }}(customer_orders_summary.lifetime_spend) as customer_lifetime_tier

    from customers

    left join customer_orders_summary
        on customers.customer_id = customer_orders_summary.customer_id

)

select * from joined
