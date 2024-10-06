create database ASSIGNMENTS;

SELECT * FROM employees;

-- Q1-a

SELECT employeeNumber, FIRSTNAME, lastName from employees where JOBTITLE = "Sales rep" AND REPORTSTO = 1102;

-- Q1-b

select distinct productLine from products where productLine like "%Cars";

-- Q2-a 

select customerNumber,customerName,
    case
        when country in ('USA', 'Canada') then 'North America'
        when country in ('UK', 'France', 'Germany') then 'Europe'
        else 'Other'
    end as CustomerSegment from Customers;

-- Q3-a 

select distinct(productCode),sum(quantityOrdered) as total_ordered from orderdetails group by productCode order by sum(quantityOrdered) desc limit 10;

-- Q3-b 

select monthname(paymentDate) as payment_month, count(monthname(paymentDate)) as num_payments from payments group by monthname(paymentDate) having count(monthname(paymentDate)) > 20 order by num_payments desc;

-- Q4 

create database Customers_Orders;

-- Q4-a 

create table Customers(customer_id int primary key auto_increment,first_name varchar(50) not null,last_name varchar(50) not null,email varchar(255) unique,phone_number varchar(20));

-- Q4-b 

create table Orders (order_id int primary key auto_increment, customer_id int, foreign key(customer_id) references customers(customer_id), order_date date,total_amount decimal(10,2) check(total_amount > 0));

-- Q5-a 

select country, count(country) as order_count from customers right join orders on customers.customerNumber = orders.customerNumber group by country order by count(country) desc limit 5;

-- Q6-a 

create table project (EmployeeID int primary key auto_increment, FullName varchar(50),Gender varchar(6) CHECK (gender IN ('Male', 'Female')), ManagerID int);

insert into project values( 1,'Pranaya','Male',3);
insert into project values( 2,'Priyanka','Female',1);
insert into project values( 3,'Preety','Female',null);
insert into project values( 4,'Anurag','Male',1);
insert into project values( 5,'Sambit','Male',1);
insert into project values( 6,'Rajesh','Male',3);
insert into project values( 7,'Hina','Female',3);

select * from project;

select m.FullName as Manage_Name, e.FullName as Emp_Name from project e left join project m on e.ManagerID = m.EmployeeID where m.FullName is not null order by m.EmployeeID asc;

-- Q7-a 

create table facility (Facility_ID int primary key auto_increment, Name varchar(100), City varchar(100) not null,State varchar(100),Country varchar(100));  

-- Q8-a 

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `product_category_sales` AS
    SELECT 
        `productlines`.`productLine` AS `productLine`,
        SUM((`orderdetails`.`quantityOrdered` * `orderdetails`.`priceEach`)) AS `total_sales`,
        COUNT(DISTINCT `orders`.`orderNumber`) AS `number_of_orders`
    FROM
        (((`productlines`
        JOIN `products` ON ((`productlines`.`productLine` = `products`.`productLine`)))
        JOIN `orderdetails` ON ((`products`.`productCode` = `orderdetails`.`productCode`)))
        JOIN `orders` ON ((`orderdetails`.`orderNumber` = `orders`.`orderNumber`)))
    GROUP BY `productlines`.`productLine`
    
    -- Q9-a
    
    CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_country_payments`(in input_year int, in input_country varchar(30))
BEGIN
select input_year as Year, input_country as Country, concat(floor(sum(payments.amount)/1000),'K') as TotalAmount 
from customers left join  payments on customers.customerNumber = payments.customerNumber 
where year(payments.paymentDate) = input_year and customers.country = input_country;
END   ;

-- Q10-a

select customers.customerName, count(distinct(orders.orderNumber)) as Order_count,
dense_rank() over (order by count(distinct(orders.orderNumber)) desc) as order_frequency_rnk
from customers left join orders on customers.customerNumber = orders.customerNumber
group by customers.customerName; 

-- Q10-b 

select year(orderDate) as YEAR, upper(monthname(orderDate)) as MONTH,count(orderNumber) as 'Total Orders',
concat(round(((count(orderNumber) - lag(count(orderNumber),1) over())/lag(count(orderNumber),1) over()) * 100),"%") as "% YOY Change"
from orders group by year(orderDate),upper(monthname(orderDate));

-- Q11-a 

SELECT productLine, COUNT(*) AS product_count
FROM products
WHERE buyPrice > (SELECT AVG(buyPrice) FROM products)
GROUP BY productLine order by COUNT(*) desc;

-- Q12-a 

create table Emp_EH (EmpID int primary key, EmpName varchar(100),EmailAddress varchar(100));

select * from Emp_EH;

-- error handlig 
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertEmp_EH`(in p_EmpID INT, in p_EmpName varchar(100), in p_EmailAddress varchar(100))
begin

    declare exit handler for sqlexception
    
    begin
    
        select 'Error occurred';
        
        rollback;
    END;
    
  start transaction;

   insert into Emp_EH (EmpID, EmpName, EmailAddress) values (p_EmpID, p_EmpName, p_EmailAddress);
  commit;
END ;

-- Q13-a

create table Emp_BIT(Name varchar(40),Occupation varchar(40),Working_Date date,Working_hours int);

select * from Emp_BIT;

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  

-- for verification I am taking an example

INSERT INTO Emp_BIT VALUES ('tonio', 'siness', '2020-10-04', -11);
INSERT INTO Emp_BIT VALUES ('onio', 'iness', '2020-10-04', -11);
