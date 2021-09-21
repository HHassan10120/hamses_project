--query for finding different different freight percentages
select sum(a.price) as sum_price, b.product_category_name, sum(a.freight_value) as sum_freight_v, 
sum(a.freight_value) / sum(a.price) as freight_percentage
 from `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_order_items_dataset` a
 left join  `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_products_dataset` b
 on a.product_id = b.product_id
 group by b.product_category_name
 order by freight_percentage desc
