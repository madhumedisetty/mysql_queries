-- triggers
create database trigger_practise;

use trigger_practise;

create table customers(id int auto_increment primary key,
name varchar(100),
email varchar(100));

create table email_changes_log(
id int auto_increment primary key,
customer_id int,
old_email varchar(100),
new_email varchar(100),
changed_at timestamp default current_timestamp);


insert into customers(name,email) values('Auahdahd','dqhduiqwh@gmail.com');

select * from customers;

-- using before update trigger
DELIMITER //
CREATE TRIGGER log_email_changes
before update on customers
for each row
begin
     if old.email!=new.email then
           insert into email_changes_log(customer_id,old_email,new_email)
           values(old.id,old.email, new.email);
	 end if;
end//

delimiter ;

select * from email_changes_log;
update customers set email='jdiejweiod@gmail.com' where id =1;
select * from customers;


-- Create After Update Trigger
DELIMITER //
CREATE TRIGGER log_email_changes_after
AFTER UPDATE ON customers
FOR EACH ROW
BEGIN
    IF OLD.email != NEW.email THEN
        -- Log after the email change has been made
        INSERT INTO email_changes_log (customer_id, old_email, new_email)
        VALUES (OLD.id, OLD.email, NEW.email);
    END IF;
END//
DELIMITER ;

-- Update Email to Trigger the After Update Trigger
UPDATE customers SET email = 'anotheremail@gmail.com' WHERE id = 1;
select * from customers;
-- Check Logs for Email Changes (Both Before and After)
SELECT * FROM email_changes_log;


-- Create Before Insert Trigger
DELIMITER //
CREATE TRIGGER log_email_insert
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN
    -- Ensure email is not NULL or empty; provide default value if necessary
    IF NEW.email IS NULL OR NEW.email = '' THEN
        SET NEW.email = 'defaultemail@gmail.com';
    END IF;
END//
DELIMITER ;

SELECT * FROM customers;
SELECT * FROM email_changes_log;
-- Insert New Data to Trigger Before Insert
INSERT INTO customers(name, email) VALUES('NewUser', '');

-- Check Customers Data to See the Default Email Applied
SELECT * FROM customers;
SELECT * FROM email_changes_log;

