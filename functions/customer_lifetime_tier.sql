case
    when lifetime_spend < 50 then 'bronze'
    when lifetime_spend < 200 then 'silver'
    else 'gold'
end
