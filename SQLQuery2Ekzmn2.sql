--create database DB_SquaurePart
--go

use DB_SquaurePart
go


--create table Articles
--(
--articleId int primary key identity,
--article nvarchar(20) not null,
--)

--insert into Articles(article)
--values('article 1'),('article 2'),('article 3'),('article 4'),('article 5'),('article 6'),('article 7'),('article 8')

go

--create table Caracteristics
--(
--carateristicId int primary key identity,
--caracteristic nvarchar(100),
--)

--insert into Caracteristics(caracteristic)
--values('caracteristic 1'),('caracteristic 2'),('caracteristic 3') , ('caracteristic 4'),('caracteristic 5')

go

create table Creator
(
creatorId int primary key identity,
articleId int foreign key references Articles(articleId),
carateristicId int foreign key references Caracteristics(carateristicId),
createAt date,
garantie int null
)
go

insert into Creator(articleId,carateristicId,createAt,garantie)
values(1, 1 , '2019-02-03' , 2),(2, 2 , '2013-02-03' , 15),(3, 3 , '2019-02-03' , 6),(4, 4 , '2020-02-03' , 3),(5, 5 , '2020-07-03' , 4) , (6, 1 , '2020-04-03' , 6),(7, 3 , '2017-02-03' , 6) , (8, 4 , '2019-02-03' , 2)

create table [provider]
(
 providerId int primary key identity,
 [name] nvarchar (20),
 creatorId int foreign key references Creator(creatorId),
)

insert into [provider](name,creatorId)
values('Provider 1' , 1),('Provider 2' , 3),('Provider 1' , 2),('Provider 1' , 4),('Provider 2' , 4),('Provider 1' , 3),('Provider 2' , 6),('Provider 1' , 3),('Provider 2' , 1)
go


go
update [provider]
set name= 'Provider 9'
where providerId=9

create table Customers
(
 customerId int primary key not null identity,
 customerName nvarchar(20),
 providerId int foreign key references [provider](providerId),
 boughtOn date not null
)

insert into Customers(customerName,providerId,boughtOn)
values('cust 1', 1 , '2020-01-02'),('cust 2' , 1,'2020-01-02') , ('cust 3' , 2,'2020-02-02'),('cust 4' , 4,'2020-04-06'),('cust 5' , 4,'2020-03-02'),('cust 6' , 2,'2020-01-02'),('cust 3' , 2,'2020-02-02'),('cust 3' , 6,'2020-01-02')


go;

--1

create function pc_provider() returns table
as

 return (
    select p.name 'Provider' , a.article 'Article' , ca.caracteristic 'Caracterist' ,c.createAt 'Created' , c.garantie 'Garantie' from [provider] p
	inner join Creator c on c.creatorId=p.creatorId
	inner join Caracteristics ca on c.carateristicId=ca.carateristicId
	inner join Articles a on a.articleId=c.articleId
 )

select * from pc_provider()

go

--2
create proc pc_ArticleExist @article nvarchar(20)
as
begin
   if exists (select * from pc_provider() p where lower(p.Article) =lower(@article))
   begin
     print 'This article exist'
   return;
   end
   else
   begin
     print 'this article is not disponible for now'
   return;
   end
end

exec pc_ArticleExist 'article 1'
go
--3
create view vw_provider
as
 select p.name 'Provider' , a.article 'Article' , ca.caracteristic 'Caracterist' ,c.createAt 'Created' , c.garantie 'Garantie' from [provider] p
	inner join Creator c on c.creatorId=p.creatorId
	inner join Caracteristics ca on c.carateristicId=ca.carateristicId
	inner join Articles a on a.articleId=c.articleId

	go


	create trigger tr_Provider on vw_provider
	instead of update
	as 
	begin
	   if(UPDATE(Article))
	   begin
	      declare @articleId int;
		  select i.Provider , i.Article , i.Caracterist,i.Created , i.Garantie from Articles a
		  join inserted i
		  on
		  i.Article=a.article
	   end
	end

	update vw_provider
	set Article = 'Article 2'
	where Provider = 'Provider 1'

	go;

	--5


	create function fn_getByProvider(@provider nvarchar(20)) returns table
	as
	return(
	select * from vw_provider v where lower(v.Provider) = lower(@provider)
	)

	go

	select * from fn_getByProvider('provider 1')
	   
--6
select o.name , c.text from sys.objects as o
inner join sys.syscomments as c
on o.object_id=c.id
where o.[type] = 'TR'
	  