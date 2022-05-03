#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER boutique;
	CREATE DATABASE boutique;
    GRANT ALL PRIVILEGES ON DATABASE boutique TO boutique;
    \c boutique;
    create table products(id varchar(100) primary key not null, name varchar(255), description varchar(255), picture varchar(255), units integer, nanos integer, categories varchar(255));
    insert into products values ('OLJCESPC7Z', 'Sunglasses', 'Add a modern touch to your outfits with these sleek aviator sunglasses.', '/static/img/products/sunglasses.jpg', 19, 99, 'accessories');
    insert into products values ('1YMWWN1N4O', 'Watch', 'This gold-tone stainless steel watch will work with most of your outfits.', '/static/img/products/watch.jpg', 109, 99, 'accessories');
    insert into products values ('L9ECAV7KIM', 'Loafers', 'A neat addition to your summer wardrobe.', '/static/img/products/loafers.jpg', 89, 99, 'footwear');
    insert into products values ('2ZYFJ3GM2N', 'Hairdryer', 'This lightweight hairdryer has 3 heat and speed settings. Its perfect for travel.', '/static/img/products/hairdryer.jpg', 24, 99, 'hair,beauty');
    insert into products values ('0PUK6V6EV0', 'Candle Holder', 'This small but intricate candle holder is an excellent gift.', '/static/img/products/candle-holder.jpg', 18, 99, 'decor,home');
    insert into products values ('LS4PSXUNUM', 'Salt & Pepper Shakers', 'Add some flavor to your kitchen.', '/static/img/products/salt-and-pepper-shakers.jpg', 18, 49, 'kitchen');
    insert into products values ('9SIQT8TOJO', 'Bamboo Glass Jar', 'This bamboo glass jar can hold 57 oz (1.7 l) and is perfect for any kitchen.', '/static/img/products/bamboo-glass-jar.jpg', 5, 49, 'kitchen');
    insert into products values ('6E92ZMYYFZ', 'Mug', 'A simple mug with a mustard interior.', '/static/img/products/mug.jpg', 8, 99, 'kitchen');

EOSQL