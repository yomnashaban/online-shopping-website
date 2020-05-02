---Procedures-- 
--Exec customerRegister 'ahmed.ashraf','ahmed','ashraf','pass123','ahmed@yahoo.com'

CREATE PROC customerRegister
@username varchar(20),
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@email varchar(50)
AS 
IF @username IS NULL or @first_name IS NULL or @last_name IS NULL or @password IS NULL or @email IS NULL
print 'One of the inputs is null'
ELse
INSERT INTO Users VALUES (@username,@first_name,@last_name,@password,@email)
INSERT INTO Customer (username) VALUES(@username)

---------------------------------

--exec vendorRegister 'eslam.mahmod','eslam' ,'mahmod','pass1234','hopa@gmail.com' ,'Market','132132513'

CREATE PROC vendorRegister
@username varchar(20),
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@email varchar(50),
@company_name varchar(20),
@bank_acc_no varchar(20)
AS
IF @username IS NULL or @first_name IS NULL or @last_name IS NULL or
@password IS NULL or @company_name IS NULL or @email Is NULL  or @bank_acc_no is NULL
print 'One of the inputs is null'
Else
INSERT INTO Users(username, first_name, last_name, password, email)
VALUES(@username, @first_name, @last_name, @password, @email)
INSERT INTO Vendor(username, company_name, bank_acc_no)
values (@username, @company_name, @bank_acc_no)

-----------------------------------

CREATE PROC userLogin
@username varchar(20),
@password varchar(20),
@success bit OUTPUT,
@type int OUTPUT 
AS
IF EXISTS (
SELECT u.username,u.password
FROM Users u
WHERE u.username=@username and u.password=@password )
BEGIN
print 'User name Exists'
SET @success=1

--Checking customers

IF EXISTS (
SELECT c.username from Customer c where c.username=@username
)
BEGIN
SET @type=0
END
--Vendor
IF EXISTS (
SELECT v.username from Vendor v where v.username=@username
)
BEGIN
SET @type=1
END
--Admin
IF EXISTS (
SELECT a.username from Admins a where a.username=@username
)
BEGIN
SET @type=2
END
--Delievery person
IF EXISTS (
SELECT d.username from Delivery_Person d where d.username=@username
)
BEGIN
SET @type=3
END


END


ELSE
BEGIN
Print'DOES NOT EXIST '
SET @success=0
SET @type=-1
END

-------------------------

--Exec addMobile 'ahmed.ashraf','01111211122'
--Exec addMobile 'ahmed.ashraf', '0124262652'

create proc addMobile
@username varchar(20) ,
@mobile_number varchar(20)
AS IF @username IS NULL or @mobile_number IS NULL
print 'One of the inputs is null'
ELSE
insert into User_mobile_numbers
values(@username,@mobile_number)

---------------------
--exec addAddress 'ahmed.ashraf','nasr city'

create proc addAddress
@username varchar(20) ,
@address varchar(100)
AS IF @username IS NULL or @address IS NULL
print 'One of the inputs is null'
ELSE
insert into User_Addresses
values(@username,@address)

------------------------
--exec showProducts

create proc showProducts
AS
Select P.product_name,p.product_description,P.price,P.final_price,P.color
From Product p
WHERE available='True'

---------------

--exec ShowProductsbyPrice

create proc ShowProductsbyPrice
AS
Select  P.product_name,p.product_description,P.price,P.color
From Product p
where available='true'
order by price
------------------
--farah's update

create proc allproducts
AS
Select  P.*
From Product p
where available='true'
order by price

-----------------------

create proc searchbyname
@text varchar(20)
As
select P.product_name,p.product_description,P.price,P.final_price,P.color
From Product p
where p.product_name like '%'+@text+'%' and available='True'

-----------------

--exec AddQuestion 1,'ahmed.ashraf','size?'

create proc  AddQuestion
@serial int, 
@customer varchar(20), 
@Question varchar(50)
AS
IF @serial IS NULL or  @customer IS NULL or @Question  IS NULL
print 'One of the inputs is null'
Else
Insert into Customer_Question_Product( serial_no, customer_name , question)
values(@serial, @customer, @Question )

--------------------
--exec addToCart 'ahmed.ashraf',1
--exec addToCart 'ahmed.ashraf',2


create proc addToCart
 @customername varchar(20), 
 @serial int
 AS
 Declare @available bit

 Select @available = p.available
 from Product p
 where p.serial_no=@serial

IF @serial IS NULL or  @customername IS NULL
print 'One of the inputs is null'
Else
If @available = 'True'
Insert into CustomerAddstoCartProduct( serial_no , customer_name)
values (@serial,@customername)

-------------------

--exec removefromCart 'ahmed.ashraf',2

create proc removefromCart
@customername Varchar(20),
@serial int
AS

IF @serial IS NULL or  @customername IS NULL
print 'One of the inputs is null'
Else
delete from CustomerAddstoCartProduct
where serial_no=@serial and
	  customer_name= @customername

-----------------------

--exec createWishlist 'ahmed.ashraf','fashion'

create proc createWishlist
@customername varchar(20),
@name varchar(20)
AS
IF @customername  IS NULL or  @name IS NULL
print 'One of the inputs is null'
Else
Insert into Wishlist( username , name)
values (@customername ,@name)

--------------------------

--exec AddtoWishlist 'ahmed.ashraf','fashion',1
--exec AddtoWishlist 'ahmed.ashraf','fashion',2


create proc AddtoWishlist
@customername varchar(20), 
@wishlistname varchar(20), 
@serial int
AS
IF @customername IS NULL OR @wishlistname is null OR @serial is null
print 'One of the inputs is null'
else
insert into Wishlist_Product
values(@customername,@wishlistname,@serial)
------------------
--exec removefromWishlist 'ahmed.ashraf','fashion',1


create proc removefromWishlist
@customername varchar(20), 
@wishlistname varchar(20), 
@serial int
AS
IF @customername IS NULL OR @wishlistname is null OR @serial is null
print 'One of the inputs is null'
else
delete from Wishlist_Product
where username=@customername AND wish_name=@wishlistname AND serial_no=@serial

------------------------
--exec showWishlistProduct 'ahmed.ashraf','fashion'


create proc showWishlistProduct
@customername varchar(20), 
@name varchar(20)
AS
Select p.product_name,p.product_description,p.price,p.final_price,p.color
From Wishlist_Product w
inner join Product p on w.serial_no=p.serial_no
where @customername= w.username and @name=w.wish_name

--------

--exec viewMyCart'ahmed.ashraf'

create proc viewMyCart
@customer varchar(20)
As
Select p.product_name,p.product_description,p.price,p.final_price,p.color
From CustomerAddstoCartProduct cc
inner join Product p on cc.serial_no=p.serial_no
where cc.customer_name=@customer

-------------------
--declare @sum decimal(10,2)
--exec calculatepriceOrder 'ahmed.ashraf',@sum output
--print @sum


create proc calculatepriceOrder
@customername varchar(20), 
@sum decimal(10,2) OUTPUT
AS
SELECT @sum=SUM(final_price)
FROM Product P inner join CustomerAddstoCartProduct C on C.serial_no=P.serial_no
where c.customer_name=@customername

--------------
--drop proc productsinorder

create proc productsinorder
@customername varchar(20),
@orderID int
AS


DECLARE @serial_no int



update Product set customer_username=@customername , available= 'False' ,customer_order_id=@orderID
where serial_no in (Select p.serial_no 
					From CustomerAddstoCartProduct cc
					inner join Product p on p.serial_no=cc.serial_no
					where cc.customer_name=@customername)

update Product set customer_order_id=@orderID 
where serial_no=@serial_no 

delete from CustomerAddstoCartProduct 
where serial_no=@serial_no and customer_name<>@customername

--------------create proc emptyCart

@customername varchar(20)
AS
delete from CustomerAddstoCartProduct where customer_name=@customername-----------exec makeOrder 'ahmed.ashraf'create proc makeOrder
@customername varchar(20)
AS
Declare  @sum decimal(10,2)
DECLARE @order_no int

EXEC calculatepriceOrder @customername, @sum output 

insert into Orders(customer_name,order_date,total_amount,order_status)
values (@customername,CURRENT_TIMESTAMP ,@sum,'not processed')

select @order_no=order_no
from Orders
where customer_name=@customername

exec productsinorder @customername,@order_no
exec emptyCart @customername ----------------------CREATE PROC cancelOrder
@orderid int
AS
DECLARE @status VARCHAR(20)
Declare @returnedpoints int
DECLARE @name varchar(20)
DECLARE @edate datetime
Declare @paymethod varchar(20)
DEclare @camount decimal(10,2)
DECLARE @orderamount decimal(10,2)
Declare @codeused varchar(20)

SELECT @status= order_status from Orders where order_no=@orderid 
IF @status='not processed' or @status ='in process'	
BEGIN 




 


Select @paymethod =o.payment_type
from Orders o
where o.order_no=@orderid

If @paymethod= 'cash'
BEGIN
Select @camount =o.cash_amount
from Orders o
where o.order_no=@orderid
END
Else
BEGIN
Select @camount =o.credit_amount
from Orders o
where o.order_no=@orderid
END

Select @orderamount=o.total_amount
from Orders o
where o.order_no= @orderid


set @returnedpoints= cast(@orderamount as INTEGER)-cast(@camount as INTEGER)




Select @edate=g.expiry_date, @codeused=g.code
from Giftcard g ,Orders o
where g.code =o.Gift_Card_code_used and o.order_no= @orderid

select @name=c.username
from Customer c, Orders o
where c.username=o.customer_name and o.order_no=@orderid

update product
 set available='true', customer_username=null,customer_order_id=null
 where customer_order_id=@orderid

DELETE FROM Orders where order_no=@orderid



if((DATEDIFF(DAY, GETDATE(), @edate)>0))
BEGIN
UPDATE Customer
SET points=@returnedpoints+points
where username=@name


update Admin_Customer_Giftcard 
SET remaining_points=remaining_points+@returnedpoints
where customer_name=@name and code=@codeused


END
END
ELSE
Print('Status is not "in process" or "not processed"' )------------create proc returnProduct
 @serialno int, 
 @orderid int
 AS
 DECLARE @codeused varchar(20)
 DECLARE @productprice decimal(10,2)
 DECLARE @orderamount decimal(10,2)
 DECLARE @edate datetime
 DECLARE @pointsused int
 Declare @status varchar(20)

 DECLARE @name varchar(20)
 Declare @paymethod varchar(20)
 DEclare @camount decimal(10,2)


 SELECT @status= O.order_status
 FROM orders o
 WHERE o.order_no=@orderid

 IF @status= 'delivered'
 
 BEGIN
 SELECT @codeused=O.Gift_Card_code_used
 FROM Product p inner join Orders o on p.customer_order_id= o.order_no
 where o.order_no=@orderid AND P.serial_no=@serialno


 SELECT @productprice=p.final_price
 from Product p
 where p.serial_no=@serialno

 select @orderamount=o.total_amount
 from Orders o
 where order_no=@orderid



 
 update Orders
 set total_amount=total_amount-@productprice
 where order_no=@orderid

 update product
 set available=1,customer_order_id=null,customer_username=null
 where serial_no=@serialno
 

 IF @codeused IS NOT NULL
 BEGIN


Select @edate=g.expiry_date
from Giftcard g ,Orders o
where  g.code =o.Gift_Card_code_used and o.order_no= @orderid

Select @paymethod =o.payment_type
from Orders o
where o.order_no=@orderid

 
 If((DATEDIFF(DAY, GETDATE(), @edate)>0))
 BEGIN
 
If @paymethod= 'cash'
BEGIN
Select @camount =o.cash_amount
from Orders o
where o.order_no=@orderid
END
Else
BEGIN
Select @camount =o.credit_amount
from Orders o
where o.order_no=@orderid
END


set @pointsused=Cast (@orderamount as INTEGER)-Cast (@camount as INTEGER)



select @name=c.username
from Customer c, Orders o
where c.username=o.customer_name and o.order_no=@orderid




UPDATE Customer
SET points=@pointsused+points
where username=@name

update Admin_Customer_Giftcard 
SET remaining_points=remaining_points+@pointsused
where customer_name=@name and code=@codeused




 END
 END
 END ---------------------------- CREATE PROC ShowproductsIbought    
@customername varchar(20)
AS
select p.serial_no,p.product_name,p.category,p.product_description,p.price,p.final_price,p.color
from Product p
inner join Orders o on o.order_no=p.customer_order_id
where p.customer_username=@customername
 
 --Exec ShowproductsIbought 'trial.final'
 --------------
CREATE PROC rate
@serialno int, 
@rate int ,
@customername varchar(20)
AS

UPDATE Product 
SET rate=@rate
WHERE customer_username =@customername and serial_no=@serialno 

--Exec rate 1,3,'trial.final'

---------


--drop proc SpecifyAmount
create proc SpecifyAmount
@customername varchar(20), @orderID int, @cash decimal(10,2), @credit decimal(10,2)
AS
Declare @customer_points int
Declare @gccused varchar(10)
Declare @edate datetime
Declare @totalamount decimal(10,2)
Declare @pointsused int


select @totalamount=O.total_amount
from Orders O
where O.order_no=@orderID 

select @gccused= a.code
from Admin_Customer_Giftcard a
WHERE a.customer_name=@customername





select @edate= g.expiry_date
from Giftcard g
where g.code= @gccused

Select @customer_points=C.points
from Customer C
where C.username=@customername

if  @credit>0 --pays totally in credit
begin

update Orders set payment_type='credit'
where order_no=@orderID

update Orders set credit_amount=@credit
where order_no=@orderID
end

if @cash>0  --pays totally in cash
begin

update Orders set payment_type='cash'
where order_no=@orderID

update Orders set cash_amount=@cash
where order_no=@orderID
end


If @credit>0 and @cash=0and @totalamount>@credit  and   (DATEDIFF(DAY, GETDATE(), @edate)>0) 
--pays partially in credit
begin
update Orders set Gift_Card_code_used=@gccused
where order_no=@orderID

update Orders set payment_type='credit'
where order_no=@orderID

update Orders set credit_amount=@credit
where order_no=@orderID
set @pointsused= Cast(@totalamount as integer)-Cast(@credit as integer)
update Customer set points=@customer_points- @pointsused where username=@customername
update Admin_Customer_Giftcard set remaining_points=remaining_points-@pointsused where code=@gccused and customer_name=@customername
end



if @cash>0 and @credit=0 and @totalamount>@cash and (DATEDIFF(DAY, GETDATE(), @edate)>0) 
--pays partially in credit
begin
update Orders set Gift_Card_code_used=@gccused
where order_no=@orderID

update Orders set payment_type='cash'
where order_no=@orderID

update Orders set cash_amount=@cash
where order_no=@orderID
set @pointsused= Cast(@totalamount as integer)-Cast(@cash as integer)
update Customer set points=@customer_points-@pointsused where username=@customername
update Admin_Customer_Giftcard set remaining_points=remaining_points-@pointsused where code=@gccused and customer_name=@customername

end

if(DATEDIFF(DAY, GETDATE(), @edate)<0)
print('This Giftcard is expired')
--Exec returnProduct 1, 42


--Exec SpecifyAmount 'trial.final',​ 45, ​5 ​, null 

--Exec cancelOrder 37

--Exec SpecifyAmount 'trial2.ashraf',​ 28 , ​null​, 5


--Exec SpecifyAmount 'ahmed.ashraf',​ 20, ​null​,90 --------------- create proc AddCreditCard
 @creditcardnumber varchar(20),
 @expirydate date , 
 @cvv varchar(4), 
 @customername varchar(20)
 AS
 insert into Credit_Card(number,expiry_date,cvv_code)
 values(@creditcardnumber,@expirydate,@cvv)
 insert into Customer_CreditCard(customer_name,cc_number)
 values(@customername,@creditcardnumber)
---------------------- create proc ChooseCreditCard
  @creditcard varchar(20),
  @orderid int
  AS
  update Orders set creditCard_number=@creditcard
  where order_no=@orderid  ---------------------------  create proc viewDeliveryTypes
 AS
 select d.type, d.time_duration as'Duration in days' ,d.fees
 from Delivery d ---------------------------- create proc specifydeliverytype
 @orderID int,
 @deliveryID int
 AS
 declare @days int
 declare @timeframe datetime
 declare @ordertime datetime

 select @ordertime = order_date
 from Orders
 where order_no=@orderID

 select @days=d.time_duration
 from Delivery d
 where d.id=@deliveryID

 set @timeframe =@days +@ordertime
 

 update Orders set delivery_id=@deliveryID , remaining_days=@days,time_limit=@timeframe
 where  order_no=@orderID ---------------- --declare @days int --exec trackRemainingDays 1,'ahmed.ashraf',@days OUTPUT create proc trackRemainingDays   -- DATEDIFF(interval, date1, date2)

 @orderid int, 
 @customername varchar(20),
 @days int Output
 AS
 Declare @timeframe datetime
 Declare @timeorder datetime


 select @timeframe=o.time_limit  ,  @timeorder=o.order_date
 From Orders o 
 where o.order_no=@orderid and o.customer_name=@customername


 set @days =DATEDIFF(DAY,TRY_CONVERT(DATE,CURRENT_TIMESTAMP),TRY_CONVERT(Date,@timeframe))
 --print @days

update Orders set remaining_days=@days  where order_no=@orderid------create proc recommmend
 @customername varchar(20)
AS
select p2.serial_no,p2.product_name,p2.category,p2.product_description,p2.price,p2.final_price,p2.color
from Product p2
where p2.serial_no in
(
select serial_no
from
 ( select top 3 p.serial_no,count(*) as '3addad serials'
 From Product p
 inner join Wishlist_Product w on w.serial_no=p.serial_no
 where p.category in

 (
select top 3  p1.category 
 From CustomerAddstoCartProduct c
 inner join Product p1 on c.serial_no=p1.serial_no
 where c.customer_name=@customername
group by p1.category
 order by count(*) DESC 
 )
 group by p.serial_no,p.product_name
 order by '3addad serials' desc
 ) as finaltemp
 
 



UNION
 select top 3 p.serial_no
 From Product p
 inner join Wishlist_Product w on w.serial_no=p.serial_no
 where w.username in

 (
   Select customer_name from
(
 
select top 3 c1.customer_name,  count(*) as 'common serials'
 from CustomerAddstoCartProduct c1
 where customer_name<>@customername and c1.serial_no in ( select  p.serial_no
 from CustomerAddstoCartProduct cc
 inner join Product p on p.serial_no=cc.serial_no
 where customer_name=@customername )
 group by customer_name
 order by 'common serials' desc
 ) as temptable1


 )


 ) --------------------  --------------------vendor---------------------
Create proc postProduct
@vendorUsername varchar(20),
@product_name varchar(20),
@category varchar(20),
@product_description text,
@price decimal(10,2),
@color varchar(20) 
AS
IF @vendorUsername IS NULL OR @product_name is null OR @price is null
print 'One of the inputs is null'
else
insert into Product(vendor_username,product_name,category,product_description,price,final_price,color,available)
values(@vendorUsername,@product_name,@category,@product_description,@price,@price,@color,1)

--Exec postProduct 'eslam.mahmod', 'pencil','stationary1', 'HB0.7', 10, 'red'
---------------------------------------

Create proc vendorviewProducts
@vendorname varchar(20) 
AS
Select  *
From Product
where vendor_username=@vendorname

--exec vendorviewProducts 'eslam.mahmod'
--------------------------
--drop proc EditProduct

create proc EditProduct
@vendorname varchar(20),
@serialnumber int,
@product_name varchar(20),
@category varchar(20),
@product_description text ,
@price decimal(10,2), 
@color varchar(20) 
AS
IF @product_name is Not NULL
BEGIN
update Product
set product_name=@product_name 
where vendor_username =@vendorname and serial_no=@serialnumber
END

IF @category  is Not NULL
BEGIN
update Product
set category=@category
where vendor_username =@vendorname and serial_no=@serialnumber
END


IF @product_description is Not NULL
BEGIN
update Product
set product_description=@product_description
where vendor_username =@vendorname and serial_no=@serialnumber
END

IF @price is Not NULL
BEGIN
update Product
set price=@price, final_price= @price
where vendor_username =@vendorname and serial_no=@serialnumber
END

IF @color is Not NULL
BEGIN
update Product
set color=@color
where vendor_username =@vendorname and serial_no=@serialnumber
END



--exec EditProduct @vendorname='eslam.mahmod',@serialnumber= 10,@product_name=null,@category=null, @price =null, @color='blue',@product_description=null

-----------------------------------

create proc deleteProduct 
@vendorname varchar(20),
@serialnumber int 
AS
DELETE FROM Product 
where vendor_username=@vendorname and serial_no=@serialnumber

--Exec deleteProduct 'eslam.mahmod',11

-----------------

create proc viewQuestions 
@vendorname varchar(20) 
AS
select c.serial_no,c.customer_name,c.question,c.answer
From Customer_Question_Product c inner join Product p on c.serial_no=p.serial_no
where p.vendor_username= @vendorname

--EXEC viewQuestions 'hadeel.adel'

--------------------------------------
--exec answerQuestions 'hadeel.adel',1,'ahmed.ashraf','40'
--drop proc  answerQuestions
create proc answerQuestions
@vendorname varchar(20),  --should we alter table and add a colume of product name
@serialno int, 
@customername varchar(20), 
@answer text

AS

IF EXISTS(
select p.serial_no , p.vendor_username
from Product p
where p.serial_no=@serialno and p.vendor_username=@vendorname
)
begin
update Customer_Question_Product
set answer=@answer
where serial_no=@serialno and customer_name=@customername
--producing a table even tho el mafrod nothing bas 3ashan 5ater el testcases
SELECT c.serial_no,c.customer_name,p.product_name,c.question,c.answer
FROM Customer_Question_Product c 
inner join Product p on p.serial_no=c.serial_no

end
Else
print 'This user can not answer the question'

--exec answerQuestions 'hadeel.adel',1,'ahmed.ashraf','40'
-----
--exec addOffer 50,'2019/11/25'

create proc addOffer
@offeramount int,
@expiry_date datetime
AS
insert into offer values (@offeramount,@expiry_date)

-----
--drop proc checkOfferonProduct

create proc checkOfferonProduct
@serial int,
@activeoffer bit OUTPUT

AS
--Declare @offerid int

IF EXISTS(
select op.offer_id,op.serial_no
from offersOnProduct op 
inner join offer o on o.offer_id =op.offer_id 
where op.serial_no=@serial -- and o.expiry_date >=CURRENT_TIMESTAMP --(DATEDIFF(DAY, GETDATE(), @exp_date)>0)
)
BEGIN 
set @activeoffer='True'
END
else
begin
set @activeoffer ='false'
end
----

--insert into offer values(50,'2011/12/12')
--exec checkandremoveExpiredoffer 2
--drop  proc checkandremoveExpiredoffer

create proc checkandremoveExpiredoffer
@offerid int
AS
declare @exp_date DATETIME
declare @offeramount int
declare @serialno int

select @exp_date =o.expiry_date,@offeramount=o.offer_amount
from offer o 
where o.offer_id=@offerid

select @serialno=serial_no
from offersOnProduct 
where offer_id =@offerid

IF EXISTS (
select o1.offer_id
from offer o1 
where o1.offer_id=@offerid and (DATEDIFF(DAY, GETDATE(), @exp_date)<0))
BEGIN

update Product 
set final_price =final_price +(price* @offeramount/100)
where serial_no=@serialno


delete from offer where offer_id =@offerid and (DATEDIFF(DAY, GETDATE(), @exp_date)<0)
delete from offersOnProduct where offer_id=@offerid and serial_no=@serialno


END

---------------------------------------

create proc applyOffer
@vendorname varchar(20), 
@offerid int, 
@serial int
AS 
declare @activeoff bit
declare @offeramount int
declare @expiray datetime

select @expiray=o.expiry_date
from offer o 
where o.offer_id=@offerid

select @offeramount=o.offer_amount
from offer o
where o.offer_id=@offerid


If (DATEDIFF(DAY, GETDATE(), @expiray)<0)
print ('This offer is expired')
Else
Begin
exec checkandremoveExpiredoffer @offerid

exec checkOfferonProduct @serial , @activeoff OUTPUT


IF (@activeoff ='TRUE')
BEGIN 

print 'The product has an active offer'
end 

ELSE
Begin
IF (DATEDIFF(DAY, GETDATE(), @expiray)>0)
Begin
insert into offersOnProduct VALUES (@offerid,@serial)
update Product set final_price = final_price -(price* @offeramount/100) where serial_no =@serial
end
end
end
---------------------------------------------------------
--sandy's update
alter proc applyOffer
@vendorname varchar(20), 
@offerid int, 
@serial int
AS 
declare @activeoff bit
declare @offeramount int
declare @expiray datetime
declare @vendorcompare varchar(20)

select @vendorcompare=vendor_username
from Product p where serial_no=@serial and vendor_username=@vendorname

select @expiray=o.expiry_date
from offer o 
where o.offer_id=@offerid

select @offeramount=o.offer_amount
from offer o
where o.offer_id=@offerid
If (DATEDIFF(DAY, GETDATE(), @expiray)>0)


Begin
exec checkandremoveExpiredoffer @offerid


exec checkOfferonProduct @serial , @activeoff OUTPUT


IF (@activeoff ='FALSE')



Begin
IF (DATEDIFF(DAY, GETDATE(), @expiray)>0 and @vendorcompare=@vendorname)
Begin
insert into offersOnProduct VALUES (@offerid,@serial)
update Product set final_price = final_price -(price* @offeramount/100) where serial_no =@serial and @vendorname=vendor_username
end
end
end

------------------------------------------------------------ADMINS-----go 
 create proc activateVendors
  @admin_username varchar(20),
  @vendor_username varchar(20)
  AS
  update Vendor set admin_username = @admin_username , activated=1
  where @vendor_username = username
  ----------------------


 -- go
create proc  inviteDeliveryPerson
 @delivery_username varchar(20), 
 @delivery_email varchar(50)
 AS
 
 insert into Users(username,email)
 values(@delivery_username , @delivery_email)

 insert into Delivery_Person(username , is_activated)
 values (@delivery_username , 0 )
 ---------------------------
--martha's update
create proc reviewOrders
AS 
select order_no,order_date,total_amount,cash_amount,credit_amount,payment_type,order_status,remaining_days,time_limit,Gift_Card_code_used,customer_name,delivery_id,creditCard_number
from Orders
----------------------------------

--go
  create proc updateOrderStatusInProcess
  @order_no int
AS
update Orders set order_status = 'in process'
where order_no  = @order_no


-------------------------------------

go
create proc  addDelivery
@delivery_type varchar(20),
@time_duration int,
@fees decimal(5,3),
@admin_username varchar(20)
AS
Insert INTO Delivery (type,time_duration ,fees ,username)
values(@delivery_type ,@time_duration ,@fees , @admin_username)


--------------------
create proc  assignOrdertoDelivery
@delivery_username varchar(20),
@order_no int,
@admin_username varchar(20)
AS
--update Admin_Delivery_Order set delivery_username = @delivery_username
--where @order_no=order_no and @admin_username=admin_username
insert into Admin_Delivery_Order(delivery_username,order_no,admin_username)
values (@delivery_username,@order_no,@admin_username)



--------------------

create proc  createTodaysDeal
 @deal_amount int,
 @admin_username varchar(20),
 @expiry_date datetime
 AS
 insert into Todays_Deals( deal_amount,expiry_date , admin_username)
 values(@deal_amount,@expiry_date,@admin_username)


 -------------------
 go
 create proc checkTodaysDealOnProduct
 @serial_no INT,
 @activeDeal BIT Output
 AS

 if EXISTS

 (select t.deal_id
 from Todays_Deals_Product t
 where t.serial_no=@serial_no
 )
 begin 
 set @activedeal=1
 end
 else
 begin
 set @activedeal=0
 end
 -------------------
 
 --martha's update2
 create proc addTodaysDealOnProduct
  @deal_id int, 
  @serial_no int
  AS 
  declare @activeDeal BIt
  exec checkTodaysDealOnProduct @serial_no,@activeDeal Output
  if exists(select * from Product where serial_no=@serial_no)
  begin

  declare @expdate datetime
  Declare  @amount int    
  Declare  @price decimal(10,2)
   Declare  @finalprice decimal(10,2)
   declare @finalfinalprice decimal(10,2)

   select @expdate= expiry_date
   from Todays_Deals
   where deal_id=@deal_id
 if (DATEDIFF(DAY, GETDATE(), @expdate)>0) 
 begin
 if @activeDeal=0
 begin
  insert into Todays_Deals_Product( deal_id,serial_no)
 values(@deal_id , @serial_no)

 select @amount=deal_amount
 from Todays_Deals 
 where deal_id=@deal_id

 select @price=final_price
 from Product
 where serial_no=@serial_no

 set @finalprice= @price *@amount/100
 set @finalfinalprice=@price-@finalprice


 if @finalfinalprice<0
 begin
 set @finalfinalprice=0
 end
 update Product set final_price=@finalfinalprice
 where serial_no = @serial_no
 end
 else 
 print('This product already has active deal')
 end
 else
  print('This deal is expired')
  end

 -----------



go
  create proc  removeExpiredDeal
 @deal_iD int
 AS

 Declare  @serial_no int
 Declare @exp_date datetime
 select @exp_date=expiry_date
 from Todays_Deals
 where deal_id=@deal_iD
	
if exists(select  *
 From Todays_Deals_Product t
 inner join Todays_Deals d on d.deal_id = t.deal_id
 inner join Product p on p.serial_no=t.serial_no
 where t.deal_id=@deal_iD) and (DATEDIFF(DAY, GETDATE(), @exp_date)<0)
 begin

 select  @serial_no= p.serial_no
 From Todays_Deals_Product t
 inner join Product p on p.serial_no=t.serial_no
 where t.deal_id=@deal_iD

 --set @finalprice= @price + @amount

 update Product set final_price=price
 where serial_no = @serial_no

  delete from Todays_Deals_Product where deal_id=@deal_iD
  end
  if (DATEDIFF(DAY, GETDATE(), @exp_date)<0)
 delete from Todays_Deals where deal_id = @deal_iD

 -------------------------



go
create proc createGiftCard
 @code varchar(10),
 @expiry_date datetime,
 @amount int,
 @admin_username varchar(20)
 AS
 insert into Giftcard (code , expiry_date , amount , username)
 values( @code,@expiry_date,@amount, @admin_username)

 ---------------------------
 go
create proc removeExpiredGiftCard
@code varchar(10)
AS
DECLARE @removedpoints int
declare @customer varchar(20)
declare @edate datetime


SELECT @removedpoints= a.remaining_points ,@customer=customer_name
FROM Admin_Customer_Giftcard a
WHERE a.code =@code

SELECT @edate=g.expiry_date
from Giftcard g
where g.code=@code

If (@edate<CURRENT_TIMESTAMP)
  
Begin 

--delete it from all customers since it is expired
Delete from Admin_Customer_Giftcard 
where code=@code

Update Customer 
set points =points-@removedpoints
where username=@customer 

update Orders
set Gift_Card_code_used= null
where Gift_Card_code_used=@code

DELETE FROM Giftcard WHERE code=@code

END
-----------------------



---------------
 go
Create proc giveGiftCardtoCustomer
@code varchar(10),
@customer_name varchar(20),
@admin_username varchar(20) 
AS
DECLARE @customerpoints int
DECLARE @addedpoints int

SELECT @addedpoints=g.amount
FROM  Giftcard g 
where g.code=@code


update Customer
set points= points+@addedpoints
where username=@customer_name

insert into Admin_Customer_Giftcard
values(@code,@customer_name,@admin_username,@addedpoints)

-----------
go
create proc checkGiftCardOnCustomer
@code varchar(10),
@activeGiftCard BIT OUTPUT
AS
Declare @exp_date Datetime
Select @exp_date=g.expiry_date
from Giftcard g
where g.code=@code
if (DATEDIFF(DAY, GETDATE(), @exp_date)>0)
  set @activeGiftCard = 1
 else
  set @activeGiftCard = 0
  --------------------------------DELIEVERY--  ----delivery person-----


 create proc  acceptAdminInvitation
 @delivery_username varchar(20)
 As
 update Delivery_Person set is_activated =1 
 where username= @delivery_username
 

 exec acceptAdminInvitation  'mohamed.tamer' 
 ----------------------------------------------------------------

 --drop proc deliveryPersonUpdateInfo
 --go
create proc deliveryPersonUpdateInfo
@username varchar(20),
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@email
varchar(50)
AS
update Users set first_name=@first_name , last_name=@last_name , password=@password , email=@email
where username=@username

--exec deliveryPersonUpdateInfo 'mohamed.tamer', 'mohamed' ,'tamer', 'pass16', '​mohamed.tamer@guc.edu.eg' 
---------------------------------------------------------------------------

--go
create proc viewmyorders
@deliveryperson varchar(20)
--@order_no int
AS
select o.*
from Admin_Delivery_Order d
inner join Orders o on o.order_no=d.order_no
where  d.delivery_username=@deliveryperson

--exec  viewmyorders  ​'mohamed.tamer' 
-------------------------------------------------------------------------

--drop proc specifyDeliveryWindow

--go 
create proc  specifyDeliveryWindow
@delivery_username varchar(20),
@order_no int,
@delivery_window varchar(50)
AS

update Admin_Delivery_Order set delivery_window = @delivery_window
where delivery_username=@delivery_username and order_no=@order_no



--exec specifyDeliveryWindow 'mohamed.tamer',​  44 ,'Today between 10 am and 3 pm' 

----------------------------------------------------------------------------

--drop proc updateOrderStatusOutforDelivery
go
create proc updateOrderStatusOutforDelivery
@order_no int
AS
update Orders set order_status = 'out for delivery'
where order_no  = @order_no

 --exec updateOrderStatusOutforDelivery 44
 ---------------------------------------------------------------------------

 --drop proc updateOrderStatusDelivered

go
create proc updateOrderStatusDelivered
@order_no int
AS
update Orders set order_status = 'delivered'
where order_no  = @order_no

update Orders set remaining_days = 0
where order_no  = @order_no