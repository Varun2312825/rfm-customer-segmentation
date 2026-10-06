CREATE DATABASE IF NOT EXISTS dunnhumby_rfm;
USE dunnhumby_rfm;

CREATE TABLE transactions (
  household_key     INT,
  basket_id         BIGINT,
  day_num           INT,          
  product_id        INT,
  quantity          INT,
  sales_value       DECIMAL(10,2),
  store_id          INT,
  retail_disc       DECIMAL(10,2),
  trans_time        INT,
  week_no           INT,
  coupon_disc       DECIMAL(10,2),
  coupon_match_disc DECIMAL(10,2),
  INDEX idx_tx_household (household_key)
);

CREATE TABLE hh_demographic (
  age_desc            VARCHAR(20),
  marital_status_code CHAR(1),
  income_desc         VARCHAR(20),
  homeowner_desc      VARCHAR(30),
  hh_comp_desc        VARCHAR(30),
  household_size_desc VARCHAR(5),
  kid_category_desc   VARCHAR(20),
  household_key       INT PRIMARY KEY
);

CREATE TABLE campaign_table (
  description   VARCHAR(10),
  household_key INT,
  campaign      INT,
  INDEX idx_camp_household (household_key)
);