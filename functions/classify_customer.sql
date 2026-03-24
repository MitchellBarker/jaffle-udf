case
    when lifetime_orders = 1 then 'new'
    when lifetime_orders between 2 and 5 then 'returning'
    else 'loyal'
end
