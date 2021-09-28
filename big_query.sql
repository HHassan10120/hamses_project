--sales for 2016, 2017 and 2018
select sum(a.payment_value) as total_payment, 
       c.MERCH_YR
from `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_order_payments_dataset` a
left join `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_orders_dataset` b
on a.order_id = b.order_id
left join `encoded-metrics-150222.wood_green_data_team.dim_time` c
on date(b.order_approved_at) = c.CAL_DT
where b.order_status = 'delivered'
group by c.MERCH_YR
order by total_payment, 
         c.MERCH_YR desc;



--sum of the pay and the installments per method
select payment_type,
sum(payment_value) as total_payment, sum(payment_installments) as total_installments
from `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_order_payments_dataset`
where payment_type in ('credit_card', 'boleto', 'voucher')
group by payment_type
order by total_payment desc,
         total_installments;



--method sums and payment sums per state
select a.payment_type, 
       c.customer_state,
sum(a.payment_value) as total_payment, 
sum(a.payment_installments) as total_installments
from `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_order_payments_dataset` a
left join `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_orders_dataset` b 
on a.order_id = b.order_id
left join `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_customers_dataset` c
on b.customer_id = c.customer_id
where a.payment_type in ('credit_card', 'boleto', 'voucher')
group by a.payment_type, 
         c.customer_state
order by c.customer_state desc, 
         total_payment, 
         total_installments;



--sum prices per category and state 
select sum(c.price) as sum_price, 
       a.customer_state, 
       d.product_category_name
from `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_customers_dataset` a 
left join `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_orders_dataset`b 
on a.customer_id = b.customer_id
left join `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_order_items_dataset` c
on c.order_id = b.order_id
left join  `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_products_dataset` d
on d.product_id = c.product_id
group by a.customer_state, 
         d.product_category_name
order by sum_price desc;



--most valuable customers
select sum(a.payment_value) as total_payment, 
       sum(b.order_item_id) as total_items, 
       c.customer_id, d.MERCH_YR
from `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_order_payments_dataset` a
left join `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_order_items_dataset` b
on a.order_id = b.order_id
left join `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_orders_dataset` c
on b.order_id = c.order_id
left join `encoded-metrics-150222.wood_green_data_team.dim_time` d
on date(c.order_approved_at) = d.CAL_DT
where c.order_status = 'delivered'
group by c.customer_id, 
         d.MERCH_YR
order by total_payment desc, 
         total_items;



--freight percentages per category
select b.product_category_name,
       sum(a.price) as sum_price, 
       sum(a.freight_value) as sum_freight_v, 
       sum(a.freight_value) / sum(a.price) as freight_percentage
 from `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_order_items_dataset` a
 left join  `encoded-metrics-150222.kaggle_brazilian_ecommerce.olist_products_dataset` b
 on a.product_id = b.product_id
 group by b.product_category_name
 order by freight_percentage desc;