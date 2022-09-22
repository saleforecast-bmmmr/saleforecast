
CREATE TABLE IF NOT EXISTS ecommerce (
	event_time TIMESTAMP NOT NULL,
	event_type VARCHAR (255),
	product_id NUMERIC,
	category_id VARCHAR (255),
	category_code VARCHAR (255),
	brand VARCHAR (255),
	price NUMERIC,
	user_id NUMERIC,
  user_session VARCHAR (65) 
);
CREATE TABLE IF NOT EXISTS purchase (
	user_id NUMERIC PRIMARY KEY UNIQUE NOT NULL
	);
	


copy public.ecommerce (event_time, event_type, product_id, category_id, category_code, brand, price, user_id, user_session) FROM '/Users/nacho/Desktop/Escritorio - MacBook Pro de MacConta/keepcoding/15 TFM/proyecto/archive/2019-Oct.csv' DELIMITER ',' CSV HEADER QUOTE '\"' ESCAPE '''';""

copy public.ecommerce (event_time, event_type, product_id, category_id, category_code, brand, price, user_id, user_session) FROM '/Users/nacho/Desktop/Escritorio - MacBook Pro de MacConta/keepcoding/15 TFM/proyecto/archive/2019-Nov.csv' DELIMITER ',' CSV HEADER QUOTE '\"' ESCAPE '''';""

copy public.ecommerce (event_time, event_type, product_id, category_id, category_code, brand, price, user_id, user_session) FROM '/Users/nacho/Desktop/Escritorio - MacBook Pro de MacConta/keepcoding/15 TFM/proyecto/archive/2019-Dic.csv' DELIMITER ',' CSV HEADER QUOTE '\"' ESCAPE '''';""

copy public.ecommerce (event_time, event_type, product_id, category_id, category_code, brand, price, user_id, user_session) FROM '/Users/nacho/Desktop/Escritorio - MacBook Pro de MacConta/keepcoding/15 TFM/proyecto/archive/2020-Jan.csv' DELIMITER ',' CSV HEADER QUOTE '\"' ESCAPE '''';""

copy public.ecommerce (event_time, event_type, product_id, category_id, category_code, brand, price, user_id, user_session) FROM '/Users/nacho/Desktop/Escritorio - MacBook Pro de MacConta/keepcoding/15 TFM/proyecto/archive/2019-Oct.csv' DELIMITER ',' CSV HEADER QUOTE '\"' ESCAPE '''';""

copy public.ecommerce (event_time, event_type, product_id, category_id, category_code, brand, price, user_id, user_session) FROM '/Users/nacho/Desktop/Escritorio - MacBook Pro de MacConta/keepcoding/15 TFM/proyecto/archive/2019-Oct.csv' DELIMITER ',' CSV HEADER QUOTE '\"' ESCAPE '''';""

copy public.ecommerce (event_time, event_type, product_id, category_id, category_code, brand, price, user_id, user_session) FROM '/Users/nacho/Desktop/Escritorio - MacBook Pro de MacConta/keepcoding/15 TFM/proyecto/archive/2019-Oct.csv' DELIMITER ',' CSV HEADER QUOTE '\"' ESCAPE '''';""


create table if not exists allpurchase as
	select * from ecommerce
	where  event_type  = 'purchase';
	


create table if not exists id_purchase as
	select  distinct user_id from allpurchase;
	

create table if not exists event_purchase as
 select e.* from ecommerce e
 inner join id_purchase ip on e.user_id  = ip.user_id
 where ip.user_id notnull;


drop table if exists public.ecommerce, public.purchase, public.allpurchase, public.id_purchase, public.event_purchase cascade;
