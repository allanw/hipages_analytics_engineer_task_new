
with customer as(
SELECT
    id,
    gender,
    {{ age_in_years('birth_date') }} AS age,
    sum(amount) as total_expense
FROM {{ ref('contacts_joined_with_transactions') }}
GROUP BY
    1,2,3
),

item_counts_pivoted as (
    SELECT 
        contact_id,
        {{ dbt_utils.pivot('category', dbt_utils.get_column_values(ref('stg_web__transactions'),
                                                                'category'), prefix='amount', then_value='item_count') }}
    FROM {{ ref('stg_web__transactions') }}
    GROUP BY contact_id
),

first_last_purchase as (
    SELECT
        id,
        FIRST_VALUE(transaction_date) OVER (PARTITION BY id ORDER BY transaction_date) as first_purchase_date,
        FIRST_VALUE(transaction_date) OVER (PARTITION BY id ORDER BY transaction_date DESC) as last_purchase_date
    FROM {{ ref('contacts_joined_with_transactions') }} 
)

select
    customer.id,
    customer.gender, 
    customer.age, 
    customer.total_expense, 
    "amountMovies & TV" as amountMovies_TV,
    "amountApps & Games" as amountApps_Games,
    "amountBeauty" as amountBeauty,
    "amountClothing, Shoes & Accessories" as amountClothing_Shoes_Accessories,
    "amountBooks" as amountBooks,
    "amountSports, Fitness & Outdoors" as amountSports_Fitness_Outdoors,
    "amountKitchen" as amountKitchen,
    first_last_purchase.first_purchase_date,
    first_last_purchase.last_purchase_date
FROM customer
JOIN item_counts_pivoted
ON customer.id = item_counts_pivoted.contact_id
JOIN first_last_purchase
ON first_last_purchase.id = customer.id
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13
