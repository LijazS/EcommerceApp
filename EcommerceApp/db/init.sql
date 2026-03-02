-- initialize ecommerce database schema and sample data

CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

CREATE TABLE IF NOT EXISTS brand (
  bid INT PRIMARY KEY AUTO_INCREMENT,
  bname VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS category (
  cid INT PRIMARY KEY AUTO_INCREMENT,
  cname VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS product (
  pid INT PRIMARY KEY AUTO_INCREMENT,
  pname VARCHAR(50),
  pprice INT,
  pquantity INT,
  pimage VARCHAR(200),
  bid INT,
  cid INT,
  FOREIGN KEY (bid) REFERENCES brand(bid),
  FOREIGN KEY (cid) REFERENCES category(cid)
);

CREATE TABLE IF NOT EXISTS customer (
  Name VARCHAR(100),
  Password VARCHAR(20),
  Email_Id VARCHAR(100),
  Contact_No VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS contactus (
  id INT NOT NULL AUTO_INCREMENT,
  Name VARCHAR(100),
  Email_Id VARCHAR(100),
  Contact_No VARCHAR(20),
  Message VARCHAR(8000),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS cart (
  Name VARCHAR(100),
  bname VARCHAR(50),
  cname VARCHAR(50),
  pname VARCHAR(50),
  pprice INT,
  pquantity INT,
  pimage VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS orders (
  Order_Id INT NOT NULL AUTO_INCREMENT,
  Customer_Name VARCHAR(100),
  Customer_City VARCHAR(45),
  Date VARCHAR(100),
  Total_Price INT,
  Status VARCHAR(45),
  PRIMARY KEY (Order_Id)
);

CREATE TABLE IF NOT EXISTS order_details (
  Date VARCHAR(100),
  Name VARCHAR(100),
  bname VARCHAR(50),
  cname VARCHAR(50),
  pname VARCHAR(50),
  pprice INT,
  pquantity INT,
  pimage VARCHAR(200)
);

-- seed minimal data
INSERT INTO brand (bname) VALUES ('samsung'),('sony'),('lenovo'),('acer'),('onida')
  ON DUPLICATE KEY UPDATE bname=bname;
INSERT INTO category (cname) VALUES ('laptop'),('tv'),('mobile'),('watch')
  ON DUPLICATE KEY UPDATE cname=cname;
