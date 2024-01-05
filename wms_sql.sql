USE [master]
GO
/****** Object:  Database [WMS_modern]    Script Date: 2024-01-05 15:41:22 ******/
CREATE DATABASE [WMS_modern]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'WMS_modern', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\WMS_modern.mdf' , SIZE = 5184KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'WMS_modern_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\WMS_modern_log.ldf' , SIZE = 1040KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [WMS_modern] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WMS_modern].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [WMS_modern] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [WMS_modern] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [WMS_modern] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [WMS_modern] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [WMS_modern] SET ARITHABORT OFF 
GO
ALTER DATABASE [WMS_modern] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [WMS_modern] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [WMS_modern] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [WMS_modern] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [WMS_modern] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [WMS_modern] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [WMS_modern] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [WMS_modern] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [WMS_modern] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [WMS_modern] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [WMS_modern] SET  ENABLE_BROKER 
GO
ALTER DATABASE [WMS_modern] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [WMS_modern] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [WMS_modern] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [WMS_modern] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [WMS_modern] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [WMS_modern] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [WMS_modern] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [WMS_modern] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [WMS_modern] SET  MULTI_USER 
GO
ALTER DATABASE [WMS_modern] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [WMS_modern] SET DB_CHAINING OFF 
GO
ALTER DATABASE [WMS_modern] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [WMS_modern] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [WMS_modern]
GO
/****** Object:  StoredProcedure [dbo].[AddUserAndRole]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[AddUserAndRole]
    @u_name VARCHAR(50),
    @u_true_name VARCHAR(100),
    @u_password VARCHAR(50),
	@U_State VARCHAR(50),
	@is_del char(1),
    @RolesID INT
AS
BEGIN
    -- 添加用户到Users表
    INSERT INTO Users (u_name, u_true_name, u_password,U_State,is_del)
    VALUES (@u_name, @u_true_name, @u_password,@U_State,@is_del)

    -- 获取刚插入的用户的UserID
    DECLARE @UserID INT
    SET @UserID = SCOPE_IDENTITY()

    -- 添加角色到UserRoles表
    INSERT INTO UserRoles (UserID, RolesID)
    VALUES (@UserID, @RolesID)
END


GO
/****** Object:  StoredProcedure [dbo].[cx]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[cx]
@cd int ,
@str varchar(20)
as
   
	declare @length int;
	declare @douh varchar(2);
	set @douh=',';
	declare @cuowu int --执行的错误号
	set @cuowu=0
    BEGIN TRANSACTION;

	 set @length=charindex(@douh,@str)--返回逗号所在的位置
	 insert into [RolesAuthority]([RolesID],[AuthorityID]) select  @cd,value from  SUBSTRING(@str,0,@length);
GO
/****** Object:  StoredProcedure [dbo].[proc_FenYe]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[proc_FenYe]
@pageSize int,--每页显示数
@keyName varchar(20),--主键名
@tableName varchar(20),--表名
@currentPage int,--当前页
@rows int output --总页数
as
declare @sql nvarchar(800)
set @sql='select top '+str(@pageSize)+' *
from (
select ROW_NUMBER() over(order by '+@keyName+') rowIndex,*
from '+@tableName+'
) a
where rowIndex>'+str((@currentPage-1)*@pageSize)+''

exec sp_executesql @sql

--获取总页数--(总行数-1)/每页显示数+1
declare @row int
set @sql='select @rows=count(*) from '+@tableName+''
--select @rows=count(*) from Trees
exec sp_executesql @sql,N'@rows int output',@row output
--总页数
set @rows=@row
GO
/****** Object:  StoredProcedure [dbo].[procFenYe_Where]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--分页的存储过程
create proc [dbo].[procFenYe_Where]
@pageSize int,--每页显示数
@keyName varchar(20),--主键名
@tableName varchar(20),--表名
@currentPage int,--当前页
@where varchar(400), --条件
@rows int output --总页数
as
declare @sql nvarchar(800)
declare @whereTest varchar(400)
if(@where='')
begin
set @whereTest=''
end
else
begin
set @whereTest='  where '+@where
end

set @sql='select top '+str(@pageSize)+' *
from (
select ROW_NUMBER() over(order by '+@keyName+') rowIndex,*
from '+@tableName+' '+@whereTest+'
) a
where rowIndex>'+str((@currentPage-1)*@pageSize)+''

exec sp_executesql @sql

--获取总页数--(总行数-1)/每页显示数+1
declare @row int
set @sql='select @rows=count(*) from '+@tableName+''+@whereTest
--select @rows=count(*) from Trees
exec sp_executesql @sql,N'@rows int output',@row output
--总页数
set @rows=@row
GO
/****** Object:  StoredProcedure [dbo].[rolesUpdate]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[rolesUpdate]
    @RolesID int,
    @RolesName varchar(50),
	@RolesAuthority varchar(50),
	@RolesState char(2),
    @AuthorityID VARCHAR(MAX)
	
AS

    DECLARE @previousId INT;
	declare @length int;
	declare @douh varchar(2);
	declare @cuowu int --执行的错误号
	set @cuowu=0

    BEGIN TRANSACTION;

    -- 第一个修改语句
	UPDATE [dbo].[roles] SET  [RolesName]=@RolesName,RolesAuthority=@RolesAuthority,[RolesState]=@RolesState WHERE [rolesID]=@RolesID
	set @cuowu=@cuowu+@@error

	--删除该角色已存在的权限
	delete from [dbo].[RolesAuthority] where [rolesID]=@RolesID

    -- 添加语句
	 INSERT INTO [dbo].[RolesAuthority]([rolesID], [AuthorityID])
		 SELECT @RolesID,value
        FROM substring(@AuthorityID,',');
	set @cuowu=@cuowu+@@error
	if(@cuowu>0)
		begin
			rollback transaction
		end
	else
		begin
			commit transaction
		end



GO
/****** Object:  StoredProcedure [dbo].[ss]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ss]
   
	@RolesAuthority varchar(50)
	
AS
	declare @length int;
	declare @douh varchar(2);
declare @tag varchar(2)
declare @i int ;
set @tag=','
    BEGIN TRANSACTION;
	  set @length=charindex(@tag,@RolesAuthority)--返回逗号所在的位置
     set @i =0;
	  while(LEN(@RolesAuthority)<@i)
    begin 

      	 INSERT INTO [dbo].[RolesAuthority]( [AuthorityID])
		 SELECT SUBSTRING(@RolesAuthority,0,@length)
		set @i=@i+1;
	end	

GO
/****** Object:  StoredProcedure [dbo].[UserAdd]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[UserAdd]
@userName varchar(50),
@userPwd varchar(500),
@userTrueName varchar(50),
@is_del varchar(50),
@U_State varchar(50),
@rolesID  smallint 
as
 DECLARE @previousId INT;
	declare @cuowu int --执行的错误号
	set @cuowu=0

	BEGIN TRANSACTION;
	
    -- 第一个插入语句，并获取主键ID
    INSERT INTO [dbo].[users] ([u_name], [u_true_name], [u_password],[U_State],[is_del])
    VALUES (@userName,@userTrueName,@userPwd,@U_State,@is_del);
	set @cuowu=@cuowu+@@error
    SET @previousId = SCOPE_IDENTITY(); -- 获取前一条插入的主键ID

    -- 第二个插入语句，使用前一条插入的主键ID
    INSERT INTO [dbo].[UserRoles]([UserID], [RolesID])
	values(@previousId,@rolesID)
	set @cuowu=@cuowu+@@error
	if(@cuowu>0)
		begin
			rollback transaction
		end
	else
		begin
			commit transaction
		end


GO
/****** Object:  StoredProcedure [dbo].[UserUpdate]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[UserUpdate]
@userID int,
@userName varchar(50),
@userPwd varchar(500),
@userTrueName varchar(50),
@UserRolesID smallint,
@rolesID  smallint 
as
 DECLARE @previousId INT;
	declare @cuowu int --执行的错误号
	set @cuowu=0

	BEGIN TRANSACTION;

    -- 第一个插入语句，并获取主键ID
	UPDATE [dbo].[users] SET [u_name]=@userName,[u_true_name]=@userTrueName,[u_password]=@userPwd WHERE u_id=@userID
	set @cuowu=@cuowu+@@error
   

    -- 第二个插入语句，使用前一条插入的主键ID
	UPDATE [UserRoles] SET [RolesID] =@rolesID where UserRolesID=@UserRolesID
	set @cuowu=@cuowu+@@error
	if(@cuowu>0)
		begin
			rollback transaction
		end
	else
		begin
			commit transaction
		end


GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Audit]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Audit](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[AuditResults] [char](1) NULL,
	[Opinions] [varchar](500) NULL,
	[AuditUser] [varchar](50) NULL,
	[AuditTime] [datetime] NULL,
	[AuditDH] [char](10) NULL,
 CONSTRAINT [PK_Audit] PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Authority]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Authority](
	[AuthorityID] [int] IDENTITY(1,1) NOT NULL,
	[AuthorityName] [nvarchar](20) NOT NULL,
	[GroupID] [int] NOT NULL,
	[AuthorityAddress] [nvarchar](100) NULL,
	[Pid] [int] NOT NULL,
 CONSTRAINT [PK_Authority] PRIMARY KEY CLUSTERED 
(
	[AuthorityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Bs_customer]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Bs_customer](
	[customer_id] [int] IDENTITY(1,1) NOT NULL,
	[cust_code] [char](16) NOT NULL,
	[cust_name] [varchar](64) NULL,
	[link_man] [varchar](64) NULL,
	[link_tel] [varchar](30) NULL,
	[e_mail] [varchar](80) NULL,
	[cust_adr] [varchar](225) NULL,
	[inbill_state] [char](1) NULL,
	[cust_from] [varchar](10) NULL,
	[is_del] [char](1) NULL,
	[head_of_Sales] [varchar](64) NULL,
	[line_type] [varchar](10) NULL,
	[operatoro] [varchar](64) NULL,
	[opetime] [datetime] NULL,
	[finance_id] [int] NULL,
	[remark] [varchar](100) NULL,
 CONSTRAINT [PK_Bs_customer] PRIMARY KEY CLUSTERED 
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Bs_finance]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Bs_finance](
	[finance_id] [int] IDENTITY(1,1) NOT NULL,
	[finance_name] [varchar](80) NULL,
	[tax_no] [varchar](80) NULL,
	[bank_no] [varchar](80) NULL,
	[open_bank] [varchar](80) NULL,
	[open_adr] [varchar](225) NULL,
	[finance_type] [varchar](10) NULL,
	[fis_del] [char](1) NULL,
 CONSTRAINT [PK_Bs_finance] PRIMARY KEY CLUSTERED 
(
	[finance_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Bs_item]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Bs_item](
	[item_id] [int] IDENTITY(1,1) NOT NULL,
	[item_code] [char](16) NOT NULL,
	[item_name] [varchar](100) NULL,
	[item_type] [char](16) NULL,
	[sort_code] [int] NULL,
	[inbill_state] [char](1) NULL,
	[model_code] [varchar](64) NULL,
	[outbill_price] [decimal](18, 2) NULL,
	[inbill_price] [decimal](18, 2) NULL,
	[item_up] [int] NULL,
	[item_down] [int] NULL,
	[below_down] [decimal](18, 2) NULL,
	[above_up] [decimal](18, 2) NULL,
	[unit] [varchar](64) NULL,
	[is_del] [char](1) NULL,
	[item_inventory] [decimal](18, 2) NULL,
	[item_type_code] [char](16) NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NULL,
	[update_by] [varchar](64) NULL,
	[update_time] [datetime] NULL,
	[remark] [varchar](500) NULL,
	[ImgUrl] [varchar](500) NULL,
 CONSTRAINT [PK_Bs_item] PRIMARY KEY CLUSTERED 
(
	[item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Bs_item_type]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Bs_item_type](
	[item_type_id] [int] IDENTITY(1,1) NOT NULL,
	[item_type_code] [char](16) NOT NULL,
	[item_type_name] [varchar](100) NULL,
	[father_code] [varchar](64) NULL,
	[sort_code] [int] NOT NULL,
	[inbill_state] [char](1) NULL,
	[remark] [varchar](500) NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NOT NULL,
	[update_by] [varchar](64) NULL,
	[update_time] [datetime] NULL,
	[is_del] [char](1) NULL,
 CONSTRAINT [PK_Bs_item_type] PRIMARY KEY CLUSTERED 
(
	[item_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Bs_supply]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Bs_supply](
	[supply_id] [int] IDENTITY(1,1) NOT NULL,
	[supply_code] [char](16) NOT NULL,
	[supply_name] [varchar](100) NULL,
	[line_type] [varchar](10) NULL,
	[supply_type_code] [varchar](80) NULL,
	[link_man] [varchar](64) NULL,
	[link_tel] [varchar](30) NULL,
	[e_mail] [varchar](80) NULL,
	[stock_duty_man] [varchar](64) NULL,
	[inbill_state] [char](1) NULL,
	[supply_adr] [varchar](100) NULL,
	[finance_id] [int] NULL,
	[operatoro] [varchar](64) NULL,
	[opetime] [datetime] NULL,
	[is_del] [char](1) NULL,
	[remark] [varchar](100) NULL,
 CONSTRAINT [PK_Bs_supply] PRIMARY KEY CLUSTERED 
(
	[supply_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Bs_ware_area]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Bs_ware_area](
	[ware_area_id] [int] IDENTITY(1,1) NOT NULL,
	[area_code] [char](16) NULL,
	[area_name] [varchar](50) NULL,
	[area_cap] [int] NOT NULL,
	[area_duty_man] [varchar](64) NULL,
	[sort_code] [int] NOT NULL,
	[area_state] [char](1) NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NOT NULL,
	[update_time] [datetime] NULL,
	[update_by] [varchar](64) NULL,
	[is_del] [char](1) NULL,
	[warehouse_id] [varchar](50) NULL,
	[remark] [varchar](50) NULL,
	[dh] [varchar](50) NULL,
 CONSTRAINT [PK_Bs_ware_area] PRIMARY KEY CLUSTERED 
(
	[ware_area_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Bs_warehouse]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Bs_warehouse](
	[warehouse_id] [int] IDENTITY(1,1) NOT NULL,
	[ware_code] [char](16) NOT NULL,
	[ware_cap] [int] NOT NULL,
	[ware_state] [char](1) NULL,
	[ware_adr] [varchar](50) NULL,
	[is_default] [char](1) NULL,
	[is_lock] [int] NOT NULL,
	[ware_duty_man] [varchar](64) NULL,
	[sort_code] [int] NOT NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NOT NULL,
	[update_by] [varchar](64) NULL,
	[update_time] [datetime] NULL,
	[is_del] [char](1) NULL,
	[ware_name] [varchar](50) NOT NULL,
	[ware_code3] [varchar](6) NULL,
	[remark] [varchar](50) NULL,
	[dh] [varchar](50) NULL,
 CONSTRAINT [PK_Bs_warehouse] PRIMARY KEY CLUSTERED 
(
	[warehouse_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[RolesID] [int] IDENTITY(1,1) NOT NULL,
	[RolesName] [nvarchar](20) NOT NULL,
	[RolesAuthority] [nvarchar](100) NULL,
	[RolesState] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[RolesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RolesAuthority]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolesAuthority](
	[RolesAuthorityID] [int] IDENTITY(1,1) NOT NULL,
	[RolesID] [int] NOT NULL,
	[AuthorityID] [int] NOT NULL,
 CONSTRAINT [PK_RolesAuthority] PRIMARY KEY CLUSTERED 
(
	[RolesAuthorityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Sys_attach_file]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sys_attach_file](
	[saf_id] [int] IDENTITY(1,1) NOT NULL,
	[bill_code] [varchar](20) NOT NULL,
	[file_id] [int] NOT NULL,
	[file_type] [varchar](10) NULL,
	[file_url] [varchar](225) NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NOT NULL,
 CONSTRAINT [PK_Sys_attach_file] PRIMARY KEY CLUSTERED 
(
	[saf_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sys_dict_data]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sys_dict_data](
	[dict_code] [int] IDENTITY(1,1) NOT NULL,
	[dict_name] [varchar](100) NULL,
	[dict_label] [varchar](100) NULL,
	[dict_type] [varchar](64) NULL,
	[is_default] [char](1) NULL,
	[status] [char](1) NULL,
	[dict_value] [varchar](100) NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NOT NULL,
	[update_by] [varchar](64) NULL,
	[update_time] [datetime] NULL,
	[remark] [varchar](64) NULL,
	[is_del] [char](1) NULL,
	[dict_id] [int] NULL,
 CONSTRAINT [PK_Sys_dict_data] PRIMARY KEY CLUSTERED 
(
	[dict_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sys_dict_type]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sys_dict_type](
	[dict_id] [int] IDENTITY(1,1) NOT NULL,
	[dict_name] [varchar](100) NULL,
	[dict_label] [varchar](100) NULL,
	[dict_value] [varchar](100) NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NOT NULL,
	[update_by] [varchar](64) NULL,
	[update_time] [datetime] NULL,
	[remark] [varchar](500) NULL,
	[is_del] [char](1) NULL,
	[status] [char](1) NULL,
 CONSTRAINT [PK_Sys_dict_type] PRIMARY KEY CLUSTERED 
(
	[dict_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sys_encode]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sys_encode](
	[en_code] [int] IDENTITY(1,1) NOT NULL,
	[en_step] [int] NOT NULL,
	[en_form] [varchar](64) NULL,
	[en_prefix] [varchar](30) NULL,
	[en_time] [varchar](50) NULL,
	[en_num] [int] NOT NULL,
	[en_rules] [varchar](80) NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NOT NULL,
	[is_del] [char](1) NULL,
	[en_max] [int] NULL,
 CONSTRAINT [PK_Sys_encode] PRIMARY KEY CLUSTERED 
(
	[en_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sys_message]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sys_message](
	[msg_id] [int] IDENTITY(1,1) NOT NULL,
	[msg_content] [varchar](500) NULL,
	[msg_type] [varchar](10) NULL,
	[msg_state] [char](1) NULL,
	[send_man] [varchar](64) NULL,
	[send_time] [datetime] NOT NULL,
	[rcv_man] [varchar](64) NULL,
	[rcv_time] [datetime] NOT NULL,
	[is_read] [char](1) NULL,
	[deal_url] [varchar](100) NULL,
 CONSTRAINT [PK_Sys_message] PRIMARY KEY CLUSTERED 
(
	[msg_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sys_wh_warn]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sys_wh_warn](
	[warn_id] [int] IDENTITY(1,1) NOT NULL,
	[warn_day] [int] NOT NULL,
	[notice_man] [varchar](100) NULL,
	[warn_time] [datetime] NOT NULL,
 CONSTRAINT [PK_Sys_wh_warn] PRIMARY KEY CLUSTERED 
(
	[warn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserRoles]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoles](
	[UserRolesID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[RolesID] [int] NOT NULL,
 CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED 
(
	[UserRolesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[U_id] [int] IDENTITY(1,1) NOT NULL,
	[U_name] [nvarchar](20) NOT NULL,
	[U_True_name] [nvarchar](20) NOT NULL,
	[U_password] [nvarchar](500) NOT NULL,
	[U_State] [nvarchar](max) NOT NULL,
	[is_del] [char](1) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[U_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_batch_storage]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_batch_storage](
	[batch_storage_id] [int] IDENTITY(1,1) NOT NULL,
	[ware_code] [char](8) NOT NULL,
	[area_code] [char](6) NOT NULL,
	[inbill_type] [char](10) NOT NULL,
	[item_code] [char](8) NOT NULL,
	[unit] [varchar](10) NULL,
	[inbill_num] [decimal](18, 2) NOT NULL,
	[outbill_num] [decimal](18, 2) NOT NULL,
	[plan_outbill_num] [decimal](18, 2) NOT NULL,
	[buy_price] [decimal](18, 2) NOT NULL,
	[product_date] [datetime] NOT NULL,
	[batch_no] [varchar](30) NULL,
 CONSTRAINT [PK_Wh_batch_storage] PRIMARY KEY CLUSTERED 
(
	[batch_storage_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_buy_order_h]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_buy_order_h](
	[buy_codeId] [int] IDENTITY(1,1) NOT NULL,
	[buy_code] [char](16) NOT NULL,
	[buy_date] [datetime] NOT NULL,
	[supply_code] [char](9) NULL,
	[link_man] [varchar](64) NULL,
	[link_way] [varchar](50) NULL,
	[buy_man] [varchar](80) NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NOT NULL,
	[update_time] [datetime] NULL,
	[update_by] [varchar](64) NULL,
	[sure_state] [char](1) NULL,
	[sure_man] [varchar](64) NULL,
	[sure_date] [datetime] NULL,
	[remark] [varchar](500) NULL,
	[is_del] [char](1) NULL,
	[sale_state] [char](1) NULL,
	[sale_state_yj] [varchar](50) NULL,
 CONSTRAINT [PK_Wh_buy_order_h] PRIMARY KEY CLUSTERED 
(
	[buy_codeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_inbill_d]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_inbill_d](
	[inbill_id] [int] IDENTITY(1,1) NOT NULL,
	[item_code] [char](16) NOT NULL,
	[inbill_code] [char](16) NOT NULL,
	[item_type] [varchar](10) NULL,
	[unit] [varchar](30) NULL,
	[buy_num] [decimal](18, 2) NOT NULL,
	[inbill_num] [decimal](18, 2) NOT NULL,
	[area_code] [char](6) NULL,
	[buy_price] [decimal](18, 2) NOT NULL,
	[product_date] [datetime] NOT NULL,
	[batch_no] [varchar](30) NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NOT NULL,
	[update_time] [datetime] NULL,
	[update_by] [varchar](64) NULL,
	[remark] [varchar](500) NULL,
	[zong] [decimal](18, 2) NULL,
 CONSTRAINT [PK_Wh_inbill_d] PRIMARY KEY CLUSTERED 
(
	[inbill_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_inbill_h]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_inbill_h](
	[inbill_code] [int] IDENTITY(1,1) NOT NULL,
	[inbill_type] [char](10) NULL,
	[inbill_state] [char](1) NULL,
	[inbll_date] [datetime] NOT NULL,
	[buy_code] [char](16) NULL,
	[supply_code] [char](16) NULL,
	[link_man] [varchar](64) NULL,
	[link_way] [varchar](50) NULL,
	[inbill_duty_man] [varchar](80) NULL,
	[remark] [varchar](500) NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NOT NULL,
	[update_time] [datetime] NULL,
	[update_by] [varchar](64) NULL,
	[sure_state] [char](1) NULL,
	[sure_man] [varchar](64) NULL,
	[sure_date] [datetime] NULL,
	[is_del] [char](1) NULL,
	[ware_name] [varchar](50) NULL,
	[inbill_bh] [char](16) NULL,
 CONSTRAINT [PK_Wh_inbill_h] PRIMARY KEY CLUSTERED 
(
	[inbill_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_inventory_d]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_inventory_d](
	[inventory_d_id] [int] IDENTITY(1,1) NOT NULL,
	[inventory_code] [char](16) NOT NULL,
	[item_code] [char](16) NULL,
	[model_code] [varchar](64) NULL,
	[unit] [varchar](30) NULL,
	[item_type] [varchar](10) NULL,
	[account_num] [decimal](18, 2) NOT NULL,
	[area_code] [char](6) NULL,
	[inventory_num] [decimal](18, 2) NOT NULL,
	[break_even_num] [decimal](18, 2) NOT NULL,
	[inventory_state] [char](1) NULL,
	[inbill_price] [decimal](18, 2) NOT NULL,
	[remark] [varchar](500) NULL,
 CONSTRAINT [PK_Wh_inventory_d] PRIMARY KEY CLUSTERED 
(
	[inventory_d_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_inventory_h]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_inventory_h](
	[inventory_h_id] [int] IDENTITY(1,1) NOT NULL,
	[inventory_code] [char](16) NOT NULL,
	[inventory_type] [varchar](10) NULL,
	[ware_code] [char](8) NULL,
	[begin_date] [datetime] NOT NULL,
	[end_date] [datetime] NOT NULL,
	[sure_state] [char](1) NULL,
	[sure_man] [varchar](64) NULL,
	[sure_date] [datetime] NULL,
	[remark] [varchar](500) NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NULL,
	[is_del] [char](1) NULL,
	[zt] [char](1) NULL,
 CONSTRAINT [PK_Wh_inventory_h] PRIMARY KEY CLUSTERED 
(
	[inventory_h_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_now_storage]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_now_storage](
	[ware_code] [char](8) NOT NULL,
	[now_storage_id] [int] IDENTITY(1,1) NOT NULL,
	[area_code] [char](6) NULL,
	[item_code] [char](8) NULL,
	[inbill3_num] [decimal](18, 2) NOT NULL,
	[plan_outnum] [decimal](18, 2) NOT NULL,
	[is_del] [char](1) NULL,
 CONSTRAINT [PK_Wh_now_storage_1] PRIMARY KEY CLUSTERED 
(
	[now_storage_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_orderbuy_d]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_orderbuy_d](
	[buy_codeId] [int] IDENTITY(1,1) NOT NULL,
	[buy_code] [char](16) NOT NULL,
	[item_name] [varchar](100) NULL,
	[item_code] [varchar](80) NULL,
	[model_code] [varchar](64) NULL,
	[unit] [varchar](30) NULL,
	[item_type_name] [varchar](10) NULL,
	[buy_num] [decimal](18, 2) NOT NULL,
	[treat_num] [decimal](18, 2) NULL,
	[inbill_num] [decimal](18, 2) NOT NULL,
	[return_goods_num] [decimal](18, 2) NOT NULL,
	[buy_goods_money] [decimal](18, 2) NULL,
	[is_del] [char](1) NULL,
	[remark] [varchar](500) NULL,
 CONSTRAINT [PK_Wh_orderbuy_d] PRIMARY KEY CLUSTERED 
(
	[buy_codeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_outbill_d]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_outbill_d](
	[outbill_d_id] [int] IDENTITY(1,1) NOT NULL,
	[outbill_code] [char](16) NOT NULL,
	[item_code] [char](16) NULL,
	[item_type] [varchar](10) NULL,
	[unit] [varchar](30) NULL,
	[sale_num] [decimal](18, 2) NOT NULL,
	[outbill_num] [decimal](18, 2) NOT NULL,
	[area_code] [char](6) NULL,
	[sale_price] [decimal](18, 2) NULL,
	[batch_no] [nvarchar](max) NULL,
	[product_date] [datetime] NULL,
	[barcode] [varchar](50) NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NULL,
	[update_time] [datetime] NULL,
	[update_by] [varchar](64) NULL,
	[remark] [varchar](500) NULL,
	[zong] [decimal](18, 2) NULL,
	[is_del] [char](1) NOT NULL,
 CONSTRAINT [PK_Wh_outbill_d] PRIMARY KEY CLUSTERED 
(
	[outbill_d_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_outbill_h]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_outbill_h](
	[outbill_h_id] [int] IDENTITY(1,1) NOT NULL,
	[outbill_code] [char](16) NOT NULL,
	[outbill_type] [varchar](10) NULL,
	[outbill_date] [datetime] NOT NULL,
	[sale_code] [char](16) NULL,
	[cust_code] [char](8) NULL,
	[link_man] [varchar](64) NULL,
	[link_way] [varchar](50) NULL,
	[duty_man] [varchar](80) NULL,
	[ware_code] [varchar](8) NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NOT NULL,
	[update_time] [datetime] NULL,
	[update_by] [nvarchar](max) NULL,
	[sure_state] [char](1) NULL,
	[sure_man] [varchar](64) NULL,
	[sure_date] [datetime] NULL,
	[remark] [varchar](500) NULL,
	[outbill_state] [char](1) NOT NULL,
	[is_del] [char](1) NOT NULL,
 CONSTRAINT [PK_Wh_outbill_h] PRIMARY KEY CLUSTERED 
(
	[outbill_h_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_return_supply_d]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_return_supply_d](
	[item_codeId] [int] IDENTITY(1,1) NOT NULL,
	[returns_code] [char](16) NULL,
	[item_code] [char](16) NOT NULL,
	[item_name] [varchar](100) NULL,
	[inbill3_num] [decimal](18, 2) NULL,
	[return_goods_num] [decimal](18, 2) NOT NULL,
	[buy_price] [decimal](18, 2) NOT NULL,
	[return_money] [decimal](18, 2) NOT NULL,
	[batch_no] [varchar](30) NOT NULL,
	[model_code] [varchar](64) NOT NULL,
	[is_del] [char](1) NULL,
 CONSTRAINT [PK_Wh_return_supply_d] PRIMARY KEY CLUSTERED 
(
	[item_codeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_return_supply_h]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_return_supply_h](
	[buy_codeId] [int] IDENTITY(1,1) NOT NULL,
	[returns_code] [char](16) NOT NULL,
	[buy_code] [char](16) NOT NULL,
	[sale_state] [char](1) NULL,
	[sr_date] [datetime] NOT NULL,
	[supply_code] [char](9) NULL,
	[link_man] [varchar](64) NULL,
	[link_way] [varchar](50) NULL,
	[buy_man] [varchar](80) NULL,
	[returns_num] [decimal](18, 2) NOT NULL,
	[returns_money] [decimal](18, 2) NOT NULL,
	[buy_price] [decimal](18, 2) NOT NULL,
	[remark] [varchar](500) NULL,
	[create_by] [varchar](500) NULL,
	[create_time] [datetime] NOT NULL,
	[update_time] [datetime] NULL,
	[update_by] [varchar](64) NULL,
	[sure_state] [char](1) NULL,
	[sure_man] [varchar](64) NULL,
	[remarks] [varchar](500) NULL,
	[sure_yj] [varchar](500) NULL,
	[sure_date] [datetime] NULL,
	[is_del] [char](1) NULL,
 CONSTRAINT [PK_Wh_return_supply_h] PRIMARY KEY CLUSTERED 
(
	[buy_codeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_sale_d]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_sale_d](
	[sale_codeId] [int] IDENTITY(1,1) NOT NULL,
	[sale_code] [char](16) NOT NULL,
	[item_name] [varchar](500) NULL,
	[item_code] [char](16) NULL,
	[model_code] [varchar](64) NULL,
	[unit] [varchar](10) NULL,
	[item_type_name] [varchar](10) NULL,
	[inbill3_num] [decimal](18, 2) NOT NULL,
	[return_num] [decimal](18, 2) NOT NULL,
	[outbill_num] [decimal](18, 2) NOT NULL,
	[sale_price] [decimal](18, 2) NOT NULL,
	[is_del] [char](1) NULL,
	[remark] [varchar](500) NULL,
 CONSTRAINT [PK_Wh_sale_d] PRIMARY KEY CLUSTERED 
(
	[sale_codeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_sale_h]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_sale_h](
	[sale_codeId] [int] IDENTITY(1,1) NOT NULL,
	[sale_code] [char](16) NOT NULL,
	[sale_state] [char](1) NULL,
	[sale_date] [datetime] NOT NULL,
	[cust_code] [char](8) NULL,
	[link_man] [varchar](64) NULL,
	[link_way] [varchar](50) NULL,
	[sale_duty_man] [varchar](64) NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NOT NULL,
	[sure_man] [varchar](64) NULL,
	[sure_date] [datetime] NULL,
	[is_del] [char](1) NULL,
	[remark] [varchar](500) NULL,
	[sure_yj] [varchar](500) NULL,
 CONSTRAINT [PK_Wh_sale_h] PRIMARY KEY CLUSTERED 
(
	[sale_codeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_sale_return_d]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_sale_return_d](
	[sr_codeId] [int] IDENTITY(1,1) NOT NULL,
	[sr_code] [char](16) NOT NULL,
	[item_name] [varchar](500) NULL,
	[item_code] [char](16) NULL,
	[inbill3_num] [decimal](18, 2) NULL,
	[return_num] [decimal](18, 2) NOT NULL,
	[ware_code] [char](8) NULL,
	[area_code] [char](6) NULL,
	[batch_no] [varchar](30) NULL,
	[return_money] [decimal](18, 2) NULL,
	[sale_price] [decimal](18, 2) NOT NULL,
	[is_del] [char](1) NULL,
 CONSTRAINT [PK_Wh_sale_return_d] PRIMARY KEY CLUSTERED 
(
	[sr_codeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_sale_return_h]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_sale_return_h](
	[sr_codeId] [int] IDENTITY(1,1) NOT NULL,
	[sr_code] [char](16) NOT NULL,
	[sr_date] [datetime] NOT NULL,
	[sale_code] [char](16) NOT NULL,
	[cust_code] [char](8) NOT NULL,
	[link_man] [varchar](64) NULL,
	[link_way] [varchar](50) NULL,
	[sale_duty_man] [varchar](64) NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NOT NULL,
	[sure_man] [varchar](64) NULL,
	[sure_date] [datetime] NULL,
	[sure_state] [char](1) NULL,
	[buy_price] [decimal](18, 2) NULL,
	[return_num] [decimal](18, 2) NULL,
	[return_money] [decimal](18, 2) NOT NULL,
	[sale_state] [char](1) NULL,
	[remark] [varchar](500) NULL,
	[remarks] [varchar](500) NULL,
	[sale_yj] [varchar](500) NULL,
	[is_del] [char](1) NULL,
 CONSTRAINT [PK_Wh_sale_return_h] PRIMARY KEY CLUSTERED 
(
	[sr_codeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_transfer_d]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_transfer_d](
	[transfer_d_id] [int] IDENTITY(1,1) NOT NULL,
	[transfer_code] [char](16) NOT NULL,
	[wh__transfer_code] [char](16) NULL,
	[item_code] [char](16) NULL,
	[model_code] [varchar](64) NULL,
	[unit] [varchar](30) NULL,
	[outarea_code] [char](6) NULL,
	[inarea_code] [char](6) NULL,
	[out_num] [int] NOT NULL,
	[in_num] [int] NOT NULL,
	[inbill_price] [decimal](18, 2) NOT NULL,
	[remark] [varchar](500) NULL,
 CONSTRAINT [PK_Wh_transfer_d] PRIMARY KEY CLUSTERED 
(
	[transfer_d_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Wh_transfer_h]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wh_transfer_h](
	[transfer_h_id] [int] IDENTITY(1,1) NOT NULL,
	[transfer_code] [char](16) NOT NULL,
	[transfer_date] [datetime] NOT NULL,
	[out_warecode] [char](8) NULL,
	[in_warecode] [char](8) NULL,
	[sure_state] [char](1) NULL,
	[transfer_type] [varchar](10) NULL,
	[outware_state] [char](1) NULL,
	[inware_state] [char](1) NULL,
	[create_by] [varchar](64) NULL,
	[create_time] [datetime] NOT NULL,
	[sure_man] [varchar](64) NULL,
	[sure_date] [datetime] NULL,
	[remark] [varchar](100) NULL,
	[is_del] [char](1) NULL,
 CONSTRAINT [PK_Wh_transfer_h] PRIMARY KEY CLUSTERED 
(
	[transfer_h_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[Bb_view]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[Bb_view]
as
select  item_id, item_code, item_name,  inbill_price, unit, model_code, tt.item_type_name from [dbo].[Bs_item] bb inner join [dbo].[Bs_item_type] tt on tt.item_type_code=bb.item_type_code
GO
/****** Object:  View [dbo].[CKView]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CKView]
AS
SELECT   h.warehouse_id, h.ware_code, h.ware_name, h.ware_cap, h.ware_adr, h.ware_duty_man, h.ware_state, h.create_by, 
                h.create_time,
                    (SELECT   COUNT(0) AS Expr1
                     FROM      dbo.Bs_ware_area
                     WHERE   (warehouse_id = h.ware_name)) AS sum, h.is_del, h.update_by, h.update_time, h.dh, h.remark
FROM      dbo.Bs_warehouse AS h LEFT OUTER JOIN
                dbo.Bs_ware_area AS w ON h.ware_name = w.warehouse_id
GROUP BY h.warehouse_id, h.ware_code, h.ware_name, h.ware_cap, h.ware_adr, h.ware_duty_man, h.ware_state, h.create_by, 
                h.create_time, h.is_del, h.update_by, h.update_time, h.dh, h.remark

GO
/****** Object:  View [dbo].[CustomerView]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CustomerView]
AS
SELECT   bc.customer_id, bf.finance_id, bc.cust_code, bc.cust_name, bc.line_type, bc.cust_from, bc.link_man, bc.link_tel, 
                bc.e_mail, bc.head_of_Sales, bc.inbill_state, bc.cust_adr, bf.finance_name, bf.tax_no, bf.bank_no, bf.open_bank, 
                bf.open_adr, bc.operatoro, bc.opetime, bc.is_del, bf.fis_del, bc.remark
FROM      dbo.Bs_customer AS bc INNER JOIN
                dbo.Bs_finance AS bf ON bf.finance_id = bc.finance_id

GO
/****** Object:  View [dbo].[GoodsInfo]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[GoodsInfo]
AS
SELECT A.item_id,A.item_code,A.item_name,A.item_type,A.sort_code, A.inbill_state,A.model_code, A.outbill_price, A.inbill_price, A.item_up,A.item_down,A.below_down, A.above_up,
 A.unit, A.is_del, item_inventory, A.item_type_code,B.item_type_name,A.create_by,A.create_time,A.update_by,A.update_time,A.remark,B.father_code,A.ImgUrl,B.item_type_id
 FROM [dbo].[Bs_item]
 A INNER JOIN  [dbo].[Bs_item_type] B
ON A.item_type_code=B.item_type_code

GO
/****** Object:  View [dbo].[GoodsInfo7]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[GoodsInfo7]
AS
SELECT A.item_id,A.item_code,A.item_name,A.item_type,A.sort_code, A.inbill_state,A.model_code, A.outbill_price, A.inbill_price, A.item_up,A.item_down,A.below_down, A.above_up,
 A.unit, A.is_del, item_inventory, A.item_type_code,B.item_type_name,A.create_by,A.create_time,A.update_by,A.update_time,A.remark,B.father_code,A.ImgUrl,B.item_type_id FROM BS_item_type B inner join bs_item A
on B.item_type_id=A.item_type
GO
/****** Object:  View [dbo].[gysRK]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[gysRK]
AS
SELECT   h.inbill_bh, h.inbill_type, h.inbll_date, d.item_code, h.ware_name, SUM(d.inbill_num) AS inbill_num, SUM(d.zong) AS zong, 
                h.inbill_duty_man, h.create_by, h.create_time, h.inbill_code, h.supply_code
FROM      dbo.Wh_inbill_h AS h INNER JOIN
                dbo.Wh_inbill_d AS d ON h.inbill_bh = d.inbill_code
GROUP BY h.inbill_bh, h.inbill_type, h.inbll_date, h.ware_name, h.inbill_duty_man, h.create_by, h.create_time, h.inbill_code, 
                h.supply_code,d.item_code


GO
/****** Object:  View [dbo].[Inventory]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[Inventory]
as
select  s.[now_storage_id], b.item_code,[item_name],b.inbill_state,t.item_type_name,b.model_code,b.unit,s.ware_code,s.area_code,s.inbill3_num,(s.inbill3_num*b.inbill_price) as jin, (s.inbill3_num-s.plan_outnum) as ky,((s.inbill3_num-s.plan_outnum)*b.inbill_price) as kyjin ,
ISNULL(Sum(d.inbill_num), 0) as ru ,ISNULL(Sum(od.outbill_num), 0) as cu 
from
 [dbo].[Wh_now_storage] s inner join [dbo].[Bs_item] b on s.item_code=b.item_code 
 inner join [dbo].[Bs_item_type] t on b.item_type_code=t.item_type_code
 left outer join [dbo].[Wh_inbill_d] d on d.item_code=s.item_code
 left outer join [dbo].[Wh_inbill_h] h on h.inbill_bh=d.inbill_code and h.inbill_state='0'
  left outer join [dbo].[Wh_outbill_d] od on od.item_code=s.item_code
   left outer join [dbo].[Wh_outbill_h] oh on od.outbill_code=oh.outbill_code and oh.outbill_state='0'
 where  s.is_del=0   and(d.area_code IS NULL OR s.area_code = d.area_code) 
 group by 
  b.item_code,
  [item_name],
  b.inbill_state,
  t.item_type_name,
  b.model_code,
  b.unit,
  s.ware_code,
  s.area_code,
  s.inbill3_num,
  s.[now_storage_id],
  b.inbill_price,
  s.plan_outnum

GO
/****** Object:  View [dbo].[KK]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[KK]
as
SELECT   h.outbill_code, h.outbill_type, h.outbill_date, d.item_code, h.ware_code, SUM(d.outbill_num) AS outbill_num, SUM(d.zong) AS zong, 
                h.duty_man, h.create_by, h.create_time,  h.cust_code,h.outbill_h_id
FROM      dbo.Wh_outbill_h AS h INNER JOIN
                dbo.Wh_outbill_d AS d ON h.outbill_code = d.outbill_code
GROUP BY  h.outbill_code, h.outbill_type, h.outbill_date, d.item_code, h.ware_code, d. outbill_num, d. zong, 
                h.duty_man, h.create_by, h.create_time,  h.cust_code,h.outbill_h_id
GO
/****** Object:  View [dbo].[KK1]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[KK1]
as
 SELECT
h.inventory_h_id,
    h.[inventory_code],
    h.[ware_code],
    h.inventory_type,
	h.begin_date,
	h.end_date,
    h.sure_man,
    h.[sure_date],
	h.sure_state,
	h.zt,
    h.create_by,
    h.[create_time],
	dd.[item_code],
    total_buy_num = SUM(dd.inventory_num),
    total_price = SUM(dd.inventory_num*dd.inbill_price),
	total_y_num = SUM(CASE WHEN dd.break_even_num > 1 THEN break_even_num ELSE 0 END),
	total_k_num = SUM(CASE WHEN dd.break_even_num < 1 THEN break_even_num ELSE 0 END),
	total_k_price = SUM(CASE WHEN dd.break_even_num < 1 THEN break_even_num*inbill_price ELSE 0 END),
	total_y_price = SUM(CASE WHEN dd.break_even_num > 1 THEN break_even_num*inbill_price ELSE 0 END)
   
FROM [dbo].[Wh_inventory_h] h
INNER JOIN [dbo].[Wh_inventory_d] dd ON h.inventory_code = dd.inventory_code
WHERE h.is_del = 0
GROUP BY 
h.inventory_h_id,
    h.[inventory_code],
    h.[ware_code],
    h.inventory_type,
    h.sure_man,
    h.[sure_date],
	dd.[item_code],
    h.create_by,
	h.begin_date,
	h.end_date,
	h.zt,
	h.sure_state,
    h.[create_time]
GO
/****** Object:  View [dbo].[KK2]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[KK2]
as
 SELECT
h.transfer_h_id,
    h.transfer_code,
    h.out_warecode,
	h.in_warecode,
    h.transfer_type,
	h.transfer_date,
    h.sure_man,
    h.[sure_date],
	h.sure_state,
	h.outware_state,
	h.inware_state,
    h.create_by,
    h.[create_time],
	dd.item_code,
    total_buy_num = SUM(dd.out_num),
    total_price = SUM(dd.out_num*dd.inbill_price)
   
FROM [dbo].[Wh_transfer_h] h
INNER JOIN [dbo].[Wh_transfer_d] dd ON h.transfer_code = dd.transfer_code
WHERE h.is_del = 0
GROUP BY 
h.transfer_h_id,
    h.[transfer_code],
    h.out_warecode,
	h.in_warecode,
    h.transfer_type,
	h.transfer_date,
    h.sure_man,
    h.[sure_date],
	h.sure_state,
	h.outware_state,
	h.inware_state,
    h.create_by,
	dd.item_code,
    h.[create_time]
GO
/****** Object:  View [dbo].[LIU]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[LIU]
as
SELECT  h.inbill_code,NULL as out1, d.item_code, h.inbill_bh, h.inbill_type, h.inbll_date, h.create_by, h.inbill_duty_man, h.ware_name, d.inbill_num, NULL AS outbill_num, d.zong, NULL AS czong, h.create_time
    FROM [dbo].[Wh_inbill_h] h 
    INNER JOIN Wh_inbill_d d ON h.inbill_bh = d.inbill_code
    WHERE h.inbill_state = '2' 
    UNION ALL
    SELECT NULL,h.outbill_h_id, d.item_code, h.outbill_code, h.outbill_type, h.outbill_date, h.create_by, h.duty_man, h.ware_code, NULL, d.outbill_num, NULL, d.zong, h.create_time
    FROM [dbo].[Wh_outbill_h] h 
    INNER JOIN Wh_outbill_d d ON h.outbill_code = d.outbill_code
    WHERE h.outbill_state = '2' 

GO
/****** Object:  View [dbo].[ST]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ST]
AS
SELECT  top(100) h.[inbill_code], h.[ware_name], h.inbill_bh, h.inbill_type, h.inbill_state, h.inbll_date, h.buy_code, h.inbill_duty_man, 
                h.sure_man, h.[sure_date], h.create_by, h.[create_time], total_buy_num = SUM(dd.inbill_num), 
                total_price = SUM(dd.zong), names = STUFF
                    ((SELECT   ',' + bb.item_name
                      FROM      [dbo].[Wh_inbill_d] d INNER JOIN
                                      [dbo].[Bs_item] bb ON d .item_code = bb.item_code
                      WHERE   d .inbill_code = h.inbill_bh FOR XML PATH('')), 1, 1, '')
FROM      [dbo].[Wh_inbill_h] h INNER JOIN
                [dbo].[Wh_inbill_d] dd ON h.[inbill_bh] = dd.[inbill_code]
WHERE   h.is_del = 0
GROUP BY h.[inbill_code], h.[ware_name], h.inbill_bh, h.inbill_type, h.inbill_state, h.inbll_date, h.buy_code, h.inbill_duty_man, 
                h.sure_man, h.[sure_date], h.create_by, h.[create_time]
order by  h.create_time desc

GO
/****** Object:  View [dbo].[ST1]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE View [dbo].[ST1]
 as
 SELECT
 top(100)
h.outbill_h_id,
    h.[outbill_code],
    h.[ware_code],
	h.cust_code,
	h.link_man,
	h.link_way,
    h.outbill_type,
    h.outbill_state,
    h.outbill_date,
    h.sale_code,
    h.duty_man,
    h.sure_man,
    h.[sure_date],
    h.create_by,
    h.[create_time],
    total_buy_num = SUM(dd.outbill_num),
    total_price = SUM(dd.zong),
    names = STUFF((SELECT ',' + bb.item_name
                  FROM [dbo].[Wh_outbill_d] d
                  INNER JOIN [dbo].[Bs_item] bb ON d.item_code = bb.item_code
                  WHERE d.outbill_code = h.outbill_code
                  FOR XML PATH('')), 1, 1, '') 
FROM [dbo].[Wh_outbill_h] h
INNER JOIN [dbo].[Wh_outbill_d] dd ON h.outbill_code = dd.outbill_code
WHERE h.is_del = 0
GROUP BY 
h.outbill_h_id,
    h.[outbill_code],
    h.ware_code,
	h.cust_code,
    h.outbill_type,
    h.outbill_state,
    h.outbill_date,
    h.sale_code,
    h.duty_man,
    h.sure_man,
    h.[sure_date],
    h.create_by,
	h.link_man,
	h.link_way,
    h.[create_time]

	order by  h.[create_time] desc

GO
/****** Object:  View [dbo].[ST2]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ST2]
AS
SELECT top(100)  h.inventory_h_id, h.[inventory_code], h.[ware_code], h.inventory_type, h.begin_date, h.end_date, h.sure_man, 
                h.[sure_date], h.sure_state, h.zt, h.create_by, h.[create_time], total_buy_num = SUM(dd.inventory_num), 
                total_price = SUM(dd.inventory_num * dd.inbill_price), 
                total_y_num = SUM(CASE WHEN dd.break_even_num > 1 THEN break_even_num ELSE 0 END), 
                total_k_num = SUM(CASE WHEN dd.break_even_num < 1 THEN break_even_num ELSE 0 END), 
                total_k_price = SUM(CASE WHEN dd.break_even_num < 1 THEN break_even_num * inbill_price ELSE 0 END), 
                total_y_price = SUM(CASE WHEN dd.break_even_num > 1 THEN break_even_num * inbill_price ELSE 0 END), 
                names = STUFF
                    ((SELECT   ',' + bb.item_name
                      FROM      [dbo].[Wh_inventory_d] d INNER JOIN
                                      [dbo].[Bs_item] bb ON d .item_code = bb.item_code
                      WHERE   d .inventory_code = h.inventory_code FOR XML PATH('')), 1, 1, '')
FROM      [dbo].[Wh_inventory_h] h INNER JOIN
                [dbo].[Wh_inventory_d] dd ON h.inventory_code = dd.inventory_code
WHERE   h.is_del = 0
GROUP BY h.inventory_h_id, h.[inventory_code], h.[ware_code], h.inventory_type, h.sure_man, h.[sure_date], h.create_by, 
                h.begin_date, h.end_date, h.zt, h.sure_state, h.[create_time]
order by  h.[create_time]
 desc

GO
/****** Object:  View [dbo].[ST3]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ST3]
AS
SELECT  top(100)  h.transfer_h_id, h.transfer_code, h.out_warecode, h.in_warecode, h.transfer_type, h.transfer_date, h.sure_man, 
                h.[sure_date], h.sure_state, h.outware_state, h.inware_state, h.create_by, h.[create_time], 
                total_buy_num = SUM(dd.out_num), total_price = SUM(dd.out_num * dd.inbill_price), names = STUFF
                    ((SELECT   ',' + bb.item_name
                      FROM      [dbo].[Wh_transfer_d] d INNER JOIN
                                      [dbo].[Bs_item] bb ON d .item_code = bb.item_code
                      WHERE   d .transfer_code = h.transfer_code FOR XML PATH('')), 1, 1, '')
FROM      [dbo].[Wh_transfer_h] h INNER JOIN
                [dbo].[Wh_transfer_d] dd ON h.transfer_code = dd.transfer_code
WHERE   h.is_del = 0
GROUP BY h.transfer_h_id, h.[transfer_code], h.out_warecode, h.in_warecode, h.transfer_type, h.transfer_date, h.sure_man, 
                h.[sure_date], h.sure_state, h.outware_state, h.inware_state, h.create_by, h.[create_time]
order by  h.[create_time]
desc

GO
/****** Object:  View [dbo].[SupplyView]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SupplyView]
AS
SELECT   bs.supply_id, bf.finance_id, bs.supply_code, bs.supply_name, bs.line_type, bs.supply_type_code, bs.link_man, 
                bs.link_tel, bs.e_mail, bs.stock_duty_man, bs.inbill_state, bs.supply_adr, bf.finance_name, bf.tax_no, bf.bank_no, 
                bf.open_bank, bf.open_adr, bs.operatoro, bs.opetime, bs.is_del, bf.fis_del, bs.remark
FROM      dbo.Bs_supply AS bs INNER JOIN
                dbo.Bs_finance AS bf ON bf.finance_id = bs.finance_id

GO
/****** Object:  View [dbo].[UserRoleView]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[UserRoleView]
as
select u.*,r.RolesID,r.RolesName,UR.UserRolesID from Users u INNER JOIN UserRoles UR ON u.U_id=ur.UserID inner join Roles r on ur.RolesID=r.RolesID

GO
/****** Object:  View [dbo].[view_Bs_Item]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[view_Bs_Item]
as
select
		h.[item_id],
      h.[item_code],
      h.[item_name],
      h.[item_type],
      h.[sort_code],
      h.[inbill_state],
      h.[model_code],
      h.[outbill_price],
      h.[inbill_price],
      h.[item_up],
      h.[item_down],
      h.[below_down],
      h.[above_up],
      h.[unit],
      h.[is_del],
      h.[item_inventory],
      h.[item_type_code],
	  dd.[item_type_name]
		from [dbo].[Bs_item] h inner join [dbo].[Bs_item_type] dd on h.[item_type_code]=dd.[item_type_code] GROUP BY
		h.[item_id],
      h.[item_code],
      h.[item_name],
      h.[item_type],
      h.[sort_code],
      h.[inbill_state],
      h.[model_code],
      h.[outbill_price],
      h.[inbill_price],
      h.[item_up],
      h.[item_down],
      h.[below_down],
      h.[above_up],
      h.[unit],
      h.[is_del],
      h.[item_inventory],
      h.[item_type_code],
	  dd.[item_type_name]

GO
/****** Object:  View [dbo].[view_Order]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Order]
AS
SELECT  top(100)  h.[buy_codeId], h.[buy_code], h.[buy_date], h.[supply_code], h.[link_man], h.[link_way], h.[buy_man], h.[create_by], 
                h.[create_time], h.[update_time], h.[update_by], h.[sure_state], h.[sure_man], h.[sure_date], h.[remark], h.[is_del], 
                h.[sale_state], total_buy_num = SUM(dd.buy_num), total_price = SUM(dd.buy_goods_money), STUFF
                    ((SELECT   ',' + t2.item_Name
                      FROM      Wh_orderbuy_d t2
                      WHERE   h.buy_code = t2.buy_code FOR XML PATH('')), 1, 1, '') AS names
FROM      [dbo].[Wh_buy_order_h] h INNER JOIN
                [dbo].[Wh_orderbuy_d] dd ON h.[buy_code] = dd.[buy_code]
GROUP BY h.[buy_codeId], h.[buy_code], h.[buy_date], h.[supply_code], h.[link_man], h.[link_way], h.[buy_man], h.[create_by], 
                h.[create_time], h.[update_time], h.[update_by], h.[sure_state], h.[sure_man], h.[sure_date], h.[remark], h.[is_del], 
                h.[sale_state]
order by h.[create_time] desc

GO
/****** Object:  View [dbo].[view_Order1]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[view_Order1]
as
select
     h.[buy_codeId],
	
       h.[buy_code],
       h.[buy_date],
       h.[supply_code],
       h.[link_man],
       h.[link_way],
       h.[buy_man],
       h.[create_by],
       h.[create_time],
       h.[update_time],
       h.[update_by],
       h.[sure_state],
       h.[sure_man],
       h.[sure_date],
       h.[remark],
       h.[is_del],
       h.[sale_state],
	    dd.[item_code],

	total_buy_num = SUM(dd.buy_num),
    total_price = SUM(dd.buy_goods_money),
     STUFF((SELECT ',' + t2.item_Name
              FROM Wh_orderbuy_d t2
              WHERE h.buy_code = t2.buy_code
              FOR XML PATH ('')), 1, 1, '') AS names from [dbo].[Wh_buy_order_h] h inner join [dbo].[Wh_orderbuy_d] dd on h.[buy_code]=dd.[buy_code] GROUP BY
   h.[buy_codeId],
       h.[buy_code],
       h.[buy_date],
       h.[supply_code],
       h.[link_man],
       h.[link_way],
       h.[buy_man],
       h.[create_by],
       h.[create_time],
       h.[update_time],
       h.[update_by],
       h.[sure_state],
       h.[sure_man],
       h.[sure_date],
       h.[remark],
       h.[is_del],
       h.[sale_state],
	    dd.[item_code]


GO
/****** Object:  View [dbo].[view_Return_supply]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Return_supply]
AS
SELECT  top(100)  h.[buy_codeId], h.[returns_code], h.[buy_code], h.[sale_state], h.[sr_date], h.[supply_code], h.[link_man], h.[link_way], 
                h.[buy_man], h.[returns_num], h.[returns_money], h.[buy_price], h.[remark], h.[create_by], h.[create_time], 
                h.[update_time], h.[update_by], h.[sure_state], h.[sure_man], h.[remarks], h.[sure_date], h.[is_del], STUFF
                    ((SELECT   ',' + t2.item_Name
                      FROM      [Wh_return_supply_d] t2
                      WHERE   h.[returns_code] = t2.[returns_code] FOR XML PATH('')), 1, 1, '') AS names
FROM      [dbo].[Wh_return_supply_h] h INNER JOIN
                [dbo].[Wh_return_supply_d] dd ON h.returns_code = dd.returns_code
GROUP BY h.[buy_codeId], h.[returns_code], h.[buy_code], h.[sale_state], h.[sr_date], h.[supply_code], h.[link_man], h.[link_way], 
                h.[buy_man], h.[returns_num], h.[returns_money], h.[buy_price], h.[remark], h.[create_by], h.[create_time], 
                h.[update_time], h.[update_by], h.[sure_state], h.[sure_man], h.[remarks], h.[sure_date], h.[is_del]
order by h.[create_time] desc

GO
/****** Object:  View [dbo].[view_Sale]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sale]
AS
SELECT top(100)  h.[sale_codeId], h.[sale_code], h.[sale_date], h.[cust_code], h.[link_man], h.[link_way], h.[sale_duty_man], h.[create_by], 
                h.[create_time], h.[sure_man], h.[sure_date], h.[remark], h.[is_del], h.[sale_state], total_buy_num = SUM(dd.inbill3_num), 
                total_price = SUM(dd.sale_price), STUFF
                    ((SELECT   ',' + bb.item_name
                      FROM      [Wh_sale_d] t2 INNER JOIN
                                      [dbo].[Bs_item] bb ON t2.item_code = bb.item_code
                      WHERE   h.sale_code = t2.sale_code FOR XML PATH('')), 1, 1, '') AS names
FROM      [dbo].[Wh_sale_h] h INNER JOIN
                [dbo].[Wh_sale_d] dd ON h.[sale_code] = dd.[sale_code]
GROUP BY h.[sale_codeId], h.[sale_code], h.[sale_date], h.[cust_code], h.[link_man], h.[link_way], h.[sale_duty_man], 
                h.[create_by], h.[create_time], h.[sure_man], h.[sure_date], h.[remark], h.[is_del], h.[sale_state]
order by h.[create_time] desc

GO
/****** Object:  View [dbo].[view_sale_return_h]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create view [dbo].[view_sale_return_h]
as
select
	h.[sr_codeId]
      ,h.[sr_code]
      ,h.[sr_date]
      ,h.[sale_code]
      ,h.[cust_code]
      ,h.[link_man]
      ,h.[link_way]
      ,h.[sale_duty_man]
      ,h.[create_by]
      ,h.[create_time]
      ,h.[sure_man]
      ,h.[sure_date]
      ,h.[sure_state]
      ,h.[buy_price]
      ,h.[return_num]
      ,h.[return_money]
      ,h.[sale_state]
      ,h.[remark]
      ,h.[remarks]
      ,h.[is_del],

     STUFF((SELECT ',' + t2.item_Name
              FROM [dbo].[Wh_sale_return_d] t2
              WHERE h.sr_code= t2.sr_code
              FOR XML PATH ('')), 1, 1, '') AS names from [dbo].[Wh_sale_return_h] h inner join [dbo].[Wh_sale_return_d] dd on h.sr_code=dd.sr_code GROUP BY

  h.[sr_codeId]
      ,h.[sr_code]
      ,h.[sr_date]
      ,h.[sale_code]
      ,h.[cust_code]
      ,h.[link_man]
      ,h.[link_way]
      ,h.[sale_duty_man]
      ,h.[create_by]
      ,h.[create_time]
      ,h.[sure_man]
      ,h.[sure_date]
      ,h.[sure_state]
      ,h.[buy_price]
      ,h.[return_num]
      ,h.[return_money]
      ,h.[sale_state]
      ,h.[remark]
      ,h.[remarks]
      ,h.[is_del]


GO
/****** Object:  View [dbo].[view_xiaoshouJL]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create view [dbo].[view_xiaoshouJL]
as
select
     h.[sale_codeId],
       h.[sale_code],
       h.[sale_date],
       h.[cust_code],
       h.[link_man],
       h.[link_way],
       h.[sale_duty_man],
       h.[create_by],
       h.[create_time],
       h.[sure_man],
       h.[sure_date],
       h.[remark],
       h.[is_del],
       h.[sale_state],
	   dd.item_code,
	total_buy_num = SUM(dd.inbill3_num),
    total_price = SUM(dd.sale_price),
     STUFF((SELECT ',' + bb.item_name
              FROM [Wh_sale_d] t2
			   INNER JOIN [dbo].[Bs_item] bb ON t2.item_code = bb.item_code
              WHERE h.sale_code = t2.sale_code
              FOR XML PATH ('')), 1, 1, '') AS names from [dbo].[Wh_sale_h] h inner join [dbo].[Wh_sale_d] dd on h.[sale_code]=dd.[sale_code]GROUP BY
   h.[sale_codeId],
       h.[sale_code],
       h.[sale_date],
       h.[cust_code],
       h.[link_man],
       h.[link_way],
       h.[sale_duty_man],
       h.[create_by],
       h.[create_time],
       h.[sure_man],
       h.[sure_date],
       h.[remark],
       h.[is_del],
       h.[sale_state],
	    dd.item_code



GO
/****** Object:  View [dbo].[view_XSGoods]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[view_XSGoods]
as
select  DISTINCT b.item_id,b.item_name ,s.item_code ,t.[item_type_name],b.model_code,b.[unit] ,b.inbill_price,SUM(inbill3_num-plan_outnum) KC
from [dbo].[Wh_now_storage] s inner join [dbo].[Bs_item] b on s.item_code=b.item_code 
inner join [dbo].[Bs_item_type] t on b.item_type_code=t.item_type_code 
WHERE s.is_del=0
GROUP BY  b.item_id,b.item_name ,s.item_code ,t.[item_type_name],b.model_code,b.[unit] ,b.inbill_price ,s.is_del


GO
/****** Object:  View [dbo].[Wh_GoodsReturn_dXX]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE view [dbo].[Wh_GoodsReturn_dXX]
 as
 select
 d.returns_code,
 d.[item_name],
 ite.[item_code],
 tt.[item_type_name],
 d.return_goods_num,
 ite.inbill_price,
 h.[remark],
 ite.model_code,
 ite.unit
 
  from [dbo].[Wh_return_supply_d] d 
  inner join[dbo].[Wh_return_supply_h]  h on d.returns_code=h.returns_code
   inner join Bs_item ite on d.item_name =ite.item_name 
   inner join [dbo].[Bs_item_type] tt on ite.[item_type_code] =tt.[item_type_code]

GO
/****** Object:  View [dbo].[Wh_GoodsReturn_dXX1]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 CREATE view [dbo].[Wh_GoodsReturn_dXX1]
 as
 select
 d.returns_code,
 d.[item_name],
 ite.[item_code],
 tt.[item_type_name],
 d.inbill3_num,

 d.return_goods_num,
 ite.inbill_price,
 h.[remark],
 ite.model_code,
 ite.unit
 
  from [dbo].[Wh_return_supply_d] d 
  inner join[dbo].[Wh_return_supply_h]  h on d.returns_code=h.returns_code
   inner join Bs_item ite on d.item_name =ite.item_name 
   inner join [dbo].[Bs_item_type] tt on ite.[item_type_code] =tt.[item_type_code]


GO
/****** Object:  View [dbo].[Wh_inbill_dXX]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[Wh_inbill_dXX]
as
select inbill_id,inbill_code,buy_num, t.item_type_name, item_name,d.item_code,model_code,d.unit,area_code,buy_price,inbill_num,zong,batch_no,d.remark from   
[dbo].[Wh_inbill_d] d inner join  
 [dbo].[Bs_item] b on d.item_code=b.item_code inner join 
[dbo].[Bs_item_type] t on b.item_type_code=t.item_type_code 


GO
/****** Object:  View [dbo].[Wh_inventory_dXX]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[Wh_inventory_dXX]
as
select inventory_d_id, d.item_code, t.item_type_name,inventory_code, b.item_name, d.model_code, d.unit, d.item_type, account_num, area_code, inventory_num, break_even_num, inventory_state, d.inbill_price, d.remark from   
[dbo].[Wh_inventory_d] d inner join  
 [dbo].[Bs_item] b on d.item_code=b.item_code inner join 
[dbo].[Bs_item_type] t on b.item_type_code=t.item_type_code 

GO
/****** Object:  View [dbo].[Wh_orderbuy_dXX]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE view [dbo].[Wh_orderbuy_dXX]
 as
 select
 d.buy_code,
 d.[item_name],
 ite.[item_code],
 tt.[item_type_name],
 d.model_code,
 d.unit,
 d.buy_num,
 d.inbill_num,
 ite.inbill_price,
 h.[remark]
 
  from [dbo].[Wh_orderbuy_d] d 
  inner join [dbo].[Wh_buy_order_h] h on d.buy_code=h.buy_code
   inner join Bs_item ite on d.item_name =ite.item_name 
   inner join [dbo].[Bs_item_type] tt on ite.[item_type_code] =tt.[item_type_code]

GO
/****** Object:  View [dbo].[Wh_outbill_dXX]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Wh_outbill_dXX]
as
select outbill_d_id,outbill_code,sale_num, t.item_type_name, item_name,d.item_code,model_code,d.unit,area_code,sale_price,outbill_num,zong,batch_no,d.remark from   
[dbo].[Wh_outbill_d] d inner join  
 [dbo].[Bs_item] b on d.item_code=b.item_code inner join 
[dbo].[Bs_item_type] t on b.item_type_code=t.item_type_code 
GO
/****** Object:  View [dbo].[Wh_sale_dXX]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[Wh_sale_dXX]
as
select
 d.sale_code,
 d.[item_code],
 ite.[item_name],
 tt.[item_type_name],
 d.model_code,
 d.unit,
 d.[inbill3_num],
 d.outbill_num,
 d.sale_price as inbill_price,
 h.[remark]
 
  from [dbo].[Wh_sale_d] d 
  inner join [dbo].[Wh_sale_h] h on d.sale_code=h.sale_code
   inner join Bs_item ite on d.item_code =ite.item_code 
   inner join [dbo].[Bs_item_type] tt on ite.[item_type_code] =tt.[item_type_code]



GO
/****** Object:  View [dbo].[Wh_saleRe_dXX]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 CREATE view [dbo].[Wh_saleRe_dXX]
 as
 select
 d.sale_code,
 d.[item_name],
 ite.[item_code],
 tt.[item_type_name],
 d.model_code,
 d.unit,
 d.inbill3_num,
 d.return_num,
 ite.inbill_price,
 h.[remark]
 
  from [dbo].[Wh_sale_d] d 
  inner join [dbo].[Wh_sale_h] h on d.sale_code=h.sale_code
   inner join Bs_item ite on d.item_name =ite.item_name 
   inner join [dbo].[Bs_item_type] tt on ite.[item_type_code] =tt.[item_type_code]


GO
/****** Object:  View [dbo].[Wh_saleReturn_dXX]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE view [dbo].[Wh_saleReturn_dXX]
 as
 select
 d.sr_code,
 d.[item_name],
 ite.[item_code],
 tt.[item_type_name],
 d.inbill3_num,
 d.return_num,
 ite.inbill_price,
 h.[remark],
 ite.model_code,
 ite.unit
 
  from [dbo].[Wh_sale_return_d] d 
  inner join[dbo].[Wh_sale_return_h]  h on d.sr_code=h.sr_code
   inner join Bs_item ite on d.item_name =ite.item_name 
   inner join [dbo].[Bs_item_type] tt on ite.[item_type_code] =tt.[item_type_code]


GO
/****** Object:  View [dbo].[Wh_transfer_dXX]    Script Date: 2024-01-05 15:41:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create view [dbo].[Wh_transfer_dXX]
 as
select transfer_d_id, d.item_code, t.item_type_name,transfer_code, b.item_name, d.model_code, d.unit, outarea_code, inarea_code, out_num, in_num,   d.inbill_price, d.remark from   
[dbo].[Wh_transfer_d] d inner join  
 [dbo].[Bs_item] b on d.item_code=b.item_code inner join 
[dbo].[Bs_item_type] t on b.item_type_code=t.item_type_code 
GO
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20231120123331_init', N'7.0.13')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20231122012110_init5', N'7.0.13')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20231122071941_init6', N'7.0.13')
SET IDENTITY_INSERT [dbo].[Audit] ON 

INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (1, N'2', N'1111', N'罗桓杰', CAST(0x0000B0CF009B1D67 AS DateTime), N'12        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (2, N'1', N'表现', N'罗桓杰', CAST(0x0000B0CF00AE2890 AS DateTime), N'22        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (3, N'2', N'好好好', N'罗桓杰', CAST(0x0000B0CE00000000 AS DateTime), N'11        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (4, N'2', N'非常', N'罗桓杰', CAST(0x0000B0CF014F1841 AS DateTime), N'66        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (5, N'2', N'测试测试', N'罗桓杰', CAST(0x0000B0CF0151644C AS DateTime), N'61        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (6, N'0', N'重新提交 ', N'罗桓杰', CAST(0x0000B0D000B1C2E6 AS DateTime), N'22        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (12, N'3', N'撤销', N'罗桓杰', CAST(0x0000B0D000C09581 AS DateTime), N'11        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (13, N'3', N'撤销', N'罗桓杰', CAST(0x0000B0D000C13247 AS DateTime), N'66        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (14, N'1', N'不会', N'罗桓杰', CAST(0x0000B0D000C2AB4F AS DateTime), N'66        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (15, N'3', N'撤销', N'罗桓杰', CAST(0x0000B0D000F4E8BF AS DateTime), N'12        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (16, N'1', N'多大点', N'罗桓杰', CAST(0x0000B0D000F512EF AS DateTime), N'12        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (17, N'0', N'重新提交 ', N'罗桓杰', CAST(0x0000B0D000FA355A AS DateTime), N'12        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (18, N'2', N'很好', N'罗桓杰', CAST(0x0000B0D000FB6674 AS DateTime), N'12        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (19, N'2', N'哈哈哈哈', N'罗桓杰', CAST(0x0000B0D5010967C2 AS DateTime), N'13        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (20, N'2', N'好好好', N'罗桓杰', CAST(0x0000B0D50110DE27 AS DateTime), N'RK12003   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (21, N'2', N'好好好', N'罗桓杰', CAST(0x0000B0D50110EBD8 AS DateTime), N'64        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (22, N'2', N'哈哈哈哈', N'罗桓杰', CAST(0x0000B0D6009D0FAD AS DateTime), N'1         ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (23, N'2', N'哈哈哈哈', N'罗桓杰', CAST(0x0000B0D6009D3139 AS DateTime), N'665       ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (24, N'2', N'好好好', N'罗桓杰', CAST(0x0000B0D600A2617D AS DateTime), N'CK12030   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (25, N'2', N'提供', N'罗桓杰', CAST(0x0000B0D600A3BABF AS DateTime), N'665       ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (26, N'2', N'哈哈哈哈', N'罗桓杰', CAST(0x0000B0D600A768DE AS DateTime), N'665       ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (27, N'2', N'通过', N'罗桓杰', CAST(0x0000B0D801217B8F AS DateTime), N'43        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (28, N'2', N'通过', N'罗桓杰', CAST(0x0000B0D801222E3A AS DateTime), N'48        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (29, N'2', N'涛涛涛涛', N'罗桓杰', CAST(0x0000B0D80122E176 AS DateTime), N'RK12009   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (30, N'2', N'6666', N'罗桓杰', CAST(0x0000B0D801237549 AS DateTime), N'RK12010   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (34, N'2', N'好好好', N'罗桓杰', CAST(0x0000B0D8016034F0 AS DateTime), N'PD13037   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (35, N'2', N'涛涛涛涛', N'罗桓杰', CAST(0x0000B0D900ECBD3F AS DateTime), N'41        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (36, N'2', N'11111111', N'罗桓杰', CAST(0x0000B0DC00BDCE52 AS DateTime), N'DB16002   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (37, N'2', N'4444', N'罗桓杰', CAST(0x0000B0DC00BE8C0F AS DateTime), N'DB16002   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (39, N'2', N'iiiii', N'罗桓杰', CAST(0x0000B0DC00BF077D AS DateTime), N'DB16002   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (40, N'2', N'酷酷酷酷酷', N'罗桓杰', CAST(0x0000B0DC00C18677 AS DateTime), N'DB16002   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (41, N'2', N'哈哈哈哈', N'罗桓杰', CAST(0x0000B0DC00F15FCE AS DateTime), N'DB16002   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (42, N'2', N'酷酷酷酷酷', N'罗桓杰', CAST(0x0000B0DC00F38A81 AS DateTime), N'PD18052   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (43, N'2', N'好好好', N'罗桓杰', CAST(0x0000B0DD00FD8FBA AS DateTime), N'PD19053   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (44, N'2', N'哈哈哈哈', N'罗桓杰', CAST(0x0000B0E6009E6FBC AS DateTime), N'RK120112  ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (45, N'2', N'借鉴借鉴', N'罗桓杰', CAST(0x0000B0E6009F0C46 AS DateTime), N'RK120113  ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (46, N'2', N'222', N'罗桓杰', CAST(0x0000B0E600F687CC AS DateTime), N'RK120121  ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (47, N'2', N'111', N'罗桓杰', CAST(0x0000B0E600FAA3E2 AS DateTime), N'PD28066   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (48, N'2', N'222', N'罗桓杰', CAST(0x0000B0E600FB169B AS DateTime), N'PD28066   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (49, N'2', N'11111', N'罗桓杰', CAST(0x0000B0E600FBCB69 AS DateTime), N'DB28022   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (50, N'2', N'1111', N'罗桓杰', CAST(0x0000B0E600FBF2C0 AS DateTime), N'DB28022   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (51, N'2', N'222', N'罗桓杰', CAST(0x0000B0E601015BD6 AS DateTime), N'JHTH19002 ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (52, N'2', N'12', N'罗桓杰', CAST(0x0000B0E6012395F7 AS DateTime), N'22        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (53, N'2', N'通过', N'罗桓杰', CAST(0x0000B0EB014E15BD AS DateTime), N'RK10137   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (54, N'2', N'通过', N'罗桓杰', CAST(0x0000B0EC00FABB95 AS DateTime), N'RK10142   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (55, N'2', N'通过', N'罗桓杰', CAST(0x0000B0EC01135733 AS DateTime), N'62        ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (56, N'2', N'通过', N'罗桓杰', CAST(0x0000B0EC01136A77 AS DateTime), N'CK12046   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (57, N'2', N'通过', N'罗桓杰', CAST(0x0000B0ED00EF4245 AS DateTime), N'RK10158   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (58, N'2', N'通过', N'罗桓杰', CAST(0x0000B0ED00F03388 AS DateTime), N'RK10159   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (59, N'2', N'通过', N'罗桓杰', CAST(0x0000B0ED00F13D83 AS DateTime), N'CK10153   ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (60, N'2', N'通过', N'罗桓杰', CAST(0x0000B0ED00F313DB AS DateTime), N'PD4082    ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (61, N'2', N'通过', N'罗桓杰', CAST(0x0000B0ED00F33421 AS DateTime), N'PD4082    ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (62, N'2', N'通过', N'罗桓杰', CAST(0x0000B0ED00F40F13 AS DateTime), N'DB4035    ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (63, N'2', N'通过', N'罗桓杰', CAST(0x0000B0ED00F44A59 AS DateTime), N'DB4035    ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (64, N'2', N'通过', N'罗桓杰', CAST(0x0000B0ED00F484F8 AS DateTime), N'DB4035    ')
INSERT [dbo].[Audit] ([AuditID], [AuditResults], [Opinions], [AuditUser], [AuditTime], [AuditDH]) VALUES (65, N'2', N'通过', N'罗桓杰', CAST(0x0000B0ED00F4E4AB AS DateTime), N'DB4036    ')
SET IDENTITY_INSERT [dbo].[Audit] OFF
SET IDENTITY_INSERT [dbo].[Authority] ON 

INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (4, N'货品管理', 0, NULL, 0)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (6, N'用户管理', 0, NULL, 0)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (7, N'出入货管理', 0, NULL, 0)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (10, N'订单管理', 0, NULL, 0)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (11, N'往来单位', 0, NULL, 0)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (12, N'统计报表', 0, N'', 0)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (13, N'仓库管理', 0, NULL, 0)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (14, N'系统设置', 0, NULL, 0)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (15, N'货品信息', 0, N'/GoodsMessage', 4)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (16, N'货品类型', 0, N'/GoodsType', 4)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (17, N'入库管理', 0, N'/Wh_inbill_h', 7)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (18, N'出库管理', 0, N'/Wh_outbill_h', 7)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (19, N'库存盘点', 0, N'/Wh_inventory_h', 7)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (20, N'库存调拨', 0, N'/Wh_transfer_h', 7)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (21, N'进货订单', 0, N'/IncomingOrders', 10)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (22, N'进货退货', 0, N'/ReturnedGoods', 10)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (23, N'销售订单', 0, N'/SalesOrders', 10)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (24, N'销售退货', 0, N'/SalesReturns', 10)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (25, N'供应商管理', 0, N'/Supplier', 11)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (26, N'客户管理', 0, N'/Customer', 11)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (27, N'库存预警', 0, NULL, 5)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (29, N'库存查询', 0, N'/StockInquire', 5)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (30, N'仓库管理', 0, N'/WareHouse', 13)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (31, N'库位管理', 0, N'/WareArea', 13)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (33, N'用户管理', 0, N'/Users', 6)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (34, N'角色管理', 0, N'/Roles', 6)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (35, N'菜单管理', 0, N'/Purview', 6)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (36, N'编码规则', 0, N'/CodingRule', 14)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (37, N'数据字典', 0, N'/DictionaryManage', 14)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (38, N'系统消息', 0, NULL, 14)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (67, N'流失警告', 0, N'/', 14)
INSERT [dbo].[Authority] ([AuthorityID], [AuthorityName], [GroupID], [AuthorityAddress], [Pid]) VALUES (87, N'库存查询', 0, N'/StockInquire', 12)
SET IDENTITY_INSERT [dbo].[Authority] OFF
SET IDENTITY_INSERT [dbo].[Bs_customer] ON 

INSERT [dbo].[Bs_customer] ([customer_id], [cust_code], [cust_name], [link_man], [link_tel], [e_mail], [cust_adr], [inbill_state], [cust_from], [is_del], [head_of_Sales], [line_type], [operatoro], [opetime], [finance_id], [remark]) VALUES (1, N'KHDH5735        ', N'客户一', N'李依依', N'19099003838', N'cmd@tom.com', N'河南省三门峡市卢氏县文化路956号', N'0', N'现有客户', N'0', N'李依依', N'零售', N'李依依', CAST(0x0000B0C700F794DC AS DateTime), 1, NULL)
INSERT [dbo].[Bs_customer] ([customer_id], [cust_code], [cust_name], [link_man], [link_tel], [e_mail], [cust_adr], [inbill_state], [cust_from], [is_del], [head_of_Sales], [line_type], [operatoro], [opetime], [finance_id], [remark]) VALUES (2, N'KHDH6465        ', N'客户二', N'李依依', N'17677768656', N'cdk@tom.com', N'河南省三门峡市卢氏县文化路956号', N'0', N'现有客户', N'0', N'李依依', N'制造', N'李依依', CAST(0x0000B0C700F7A544 AS DateTime), 1, NULL)
INSERT [dbo].[Bs_customer] ([customer_id], [cust_code], [cust_name], [link_man], [link_tel], [e_mail], [cust_adr], [inbill_state], [cust_from], [is_del], [head_of_Sales], [line_type], [operatoro], [opetime], [finance_id], [remark]) VALUES (3, N'KHDH5823        ', N'客户三', N'李依依', N'18788776646', N'ksh@tom.com', N'河南省三门峡市卢氏县文化路956号', N'0', N'现有客户', N'0', N'李依依', N'制药厂', N'罗桓杰', CAST(0x0000B0C700F84CD8 AS DateTime), 1, N'的说法是打发')
INSERT [dbo].[Bs_customer] ([customer_id], [cust_code], [cust_name], [link_man], [link_tel], [e_mail], [cust_adr], [inbill_state], [cust_from], [is_del], [head_of_Sales], [line_type], [operatoro], [opetime], [finance_id], [remark]) VALUES (10, N'KH27056         ', N'客户四', N'李欢欢', N'19918026397', N'3523966028@qq.com', N'湖南省', N'0', N'现有客户', N'0', N'刘子怡', N'零售', N'罗桓杰', CAST(0x0000B0E50144575F AS DateTime), 46, N'1111')
INSERT [dbo].[Bs_customer] ([customer_id], [cust_code], [cust_name], [link_man], [link_tel], [e_mail], [cust_adr], [inbill_state], [cust_from], [is_del], [head_of_Sales], [line_type], [operatoro], [opetime], [finance_id], [remark]) VALUES (11, N'KH27057         ', N'客户五', N'牛逼', N'19918026397', N'352398800@qq.com', N'长沙', N'0', N'现有客户', N'0', N'刘子怡', N'制造', N'罗桓杰', CAST(0x0000B0E50144B85D AS DateTime), 47, N'11111')
INSERT [dbo].[Bs_customer] ([customer_id], [cust_code], [cust_name], [link_man], [link_tel], [e_mail], [cust_adr], [inbill_state], [cust_from], [is_del], [head_of_Sales], [line_type], [operatoro], [opetime], [finance_id], [remark]) VALUES (12, N'KH28060         ', N'方俊豪', N'方俊豪', N'18974022095', N'598911527@qq.com', N'湖南省长沙市', N'0', N'网络平台', N'0', N'罗桓杰', N'服务商', N'罗桓杰', CAST(0x0000B0E600F026EB AS DateTime), 49, N'呵呵哈哈哈')
INSERT [dbo].[Bs_customer] ([customer_id], [cust_code], [cust_name], [link_man], [link_tel], [e_mail], [cust_adr], [inbill_state], [cust_from], [is_del], [head_of_Sales], [line_type], [operatoro], [opetime], [finance_id], [remark]) VALUES (13, N'KH2061          ', N'李太白', N'小白', N'13203023638', N'3042998714@qq,com', N'长沙', N'0', N'供应商', N'0', N'霍建华', N'服务商', N'罗桓杰', CAST(0x0000B0EB0104AA8D AS DateTime), 51, N'白白爱便便')
INSERT [dbo].[Bs_customer] ([customer_id], [cust_code], [cust_name], [link_man], [link_tel], [e_mail], [cust_adr], [inbill_state], [cust_from], [is_del], [head_of_Sales], [line_type], [operatoro], [opetime], [finance_id], [remark]) VALUES (14, N'KH2062          ', N'袁天罡', N'小白白', N'13203023638', N'3042998714@qq.com', N'长沙北大', N'0', N'外出拜访', N'0', N'刘子怡', N'零售', N'罗桓杰', CAST(0x0000B0EB01051C68 AS DateTime), 52, N'啊实打实的')
INSERT [dbo].[Bs_customer] ([customer_id], [cust_code], [cust_name], [link_man], [link_tel], [e_mail], [cust_adr], [inbill_state], [cust_from], [is_del], [head_of_Sales], [line_type], [operatoro], [opetime], [finance_id], [remark]) VALUES (15, N'KH2063          ', N'李淳风', N'小白', N'13203023738', N'3042998714@qq.com', N'长沙市开福区蔡锷北路', N'0', N'网络平台', N'0', N'黄妍妮', N'制造', N'罗桓杰', CAST(0x0000B0EB01057EC7 AS DateTime), 53, N'123')
INSERT [dbo].[Bs_customer] ([customer_id], [cust_code], [cust_name], [link_man], [link_tel], [e_mail], [cust_adr], [inbill_state], [cust_from], [is_del], [head_of_Sales], [line_type], [operatoro], [opetime], [finance_id], [remark]) VALUES (16, N'KH2064          ', N'李星云', N'天暗星', N'13203023637', N'3042997714@qq.com', N'唐朝', N'0', N'现有客户', N'0', N'刘子怡', N'制造', N'罗桓杰', CAST(0x0000B0EB0119BE99 AS DateTime), 55, N'唐昭宗李晔之子')
INSERT [dbo].[Bs_customer] ([customer_id], [cust_code], [cust_name], [link_man], [link_tel], [e_mail], [cust_adr], [inbill_state], [cust_from], [is_del], [head_of_Sales], [line_type], [operatoro], [opetime], [finance_id], [remark]) VALUES (17, N'KH3066          ', N'刘子怡', N'罗桓杰', N'13203023738', N'3042997714@qq.com', N'长沙市开福区蔡锷北路', N'0', N'现有客户', N'0', N'黄妍妮', N'制造', N'罗桓杰', CAST(0x0000B0EC00EAF1B1 AS DateTime), 57, N'嗯嗯嗯')
INSERT [dbo].[Bs_customer] ([customer_id], [cust_code], [cust_name], [link_man], [link_tel], [e_mail], [cust_adr], [inbill_state], [cust_from], [is_del], [head_of_Sales], [line_type], [operatoro], [opetime], [finance_id], [remark]) VALUES (18, N'KH4067          ', N'罗桓杰', N'罗桓杰', N'13203023738', N'3042997714@qq.com', N'长沙市开福区蔡锷北路', N'0', N'现有客户', N'0', N'刘子怡', N'零售', N'罗桓杰', CAST(0x0000B0ED00ED16F0 AS DateTime), 59, N'ss')
SET IDENTITY_INSERT [dbo].[Bs_customer] OFF
SET IDENTITY_INSERT [dbo].[Bs_finance] ON 

INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (1, N'有限公司', N'900000000', N'6000000000000000000002', N'中国银行', N'X市中国银行公交路支行', N'哈哈', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (2, N'有限公司', N'900000000', N'6000000000000000000002', N'中国银行', N'X市中国银行公交路支行', N'看看', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (3, N'有限公司', N'900000000', N'6000000000000000000003', N'中国银行', N'X市中国银行公交路支行', N'密码', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (4, N'1', N'1', N'1', N'1', N'1', N'1', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (5, N'ewq', N'ewq', N'ewq', N'eq', N'eq', N'qe', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (6, N'1', N'1', N'1', N'1', N'1', N'1', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (9, N'2', N'2', N'2', N'2', N'2', N'2', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (31, N'11', N'11', N'11', N'11', N'11', N'11', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (32, N'22', N'22', N'22', N'22', N'22', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (33, N'6543', N'23456543456', N'354675432', N'34567543234566', N'56集合割发代首', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (34, N'44', N'44', N'44', N'44', N'的双方各回割发代首', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (35, N'ew', N'66', N'66', N'66', N'66', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (36, N'11', N'11', N'11', N'11', N'11', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (37, N'11', N'11', N'11', N'11', N'11', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (38, N'33333', N'3333', N'333', N'333', N'33333', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (39, N'77', N'77', N'77', N'77', N'77', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (40, N'2', N'2', N'2', N'2', N'2', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (41, N'1', N'1', N'1', N'1', N'1', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (42, N'123', N'123', N'3123', N'123', N'1231', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (43, N'123', N'123', N'123', N'123', N'123', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (44, N'有限公司', N'900000000', N'6000000000000001', N'中国银行', N'哈哈哈哈', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (45, N'实力有限公司', N'900000001', N'6000000000000002', N'中国银行', N'湖南省', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (46, N'有限公司', N'9000000004', N'232323232', N'中国银行', N'1111', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (47, N'有限', N'988888', N'111114', N'开服', N'111', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (48, N'有限公司', N'9000000003', N'600000000000000000006', N'中国银行', N'湖南省长沙市', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (49, N'有限公司', N'900000003', N'60000002', N'中国银行', N'湖南省', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (50, N'格式', N'9000000003', N'600000000000000000006', N'工商', N'长沙市开福区', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (51, N'有限公司', N'900000000', N'6000000000000001', N'中国银行', N'长沙市中国银行公交路支行', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (52, N'有限公司', N'900000000', N'6000000000000001', N'中国银行', N'长沙市中国银行公交路支行', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (53, N'有限公司', N'900000000', N'6000000000000001', N'中国银行', N'长沙市中国银行公交路支行', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (54, N'有限公司', N'900000000 ', N'6000000000000001 ', N'中国银行', N'长沙市中国银行公交路支行
', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (55, N'有限公司', N'900000000 ', N'6000000000000001 ', N' 中国银行', N'长沙市中国银行公路支行', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (56, N'有限公司', N'900000000', N'6000000000000001', N'中国银行', N'长沙市中国银行公交路支行', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (57, N'有限公司', N'900000000', N'6000000000000001', N'中国银行', N'长沙市中国银行公交路支行', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (58, N'有限公司', N'900000000', N'6000000000000001', N'中国银行', N'
长沙市中国银行公交路支行
', N'', N'0')
INSERT [dbo].[Bs_finance] ([finance_id], [finance_name], [tax_no], [bank_no], [open_bank], [open_adr], [finance_type], [fis_del]) VALUES (59, N'有限公司', N'900000000', N'6000000000000001', N'中国银行', N'长沙市中国银行公交路支行', N'', N'0')
SET IDENTITY_INSERT [dbo].[Bs_finance] OFF
SET IDENTITY_INSERT [dbo].[Bs_item] ON 

INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (1, N'1               ', N'货品一', N'HP12025         ', 1, N'0', N'blue', CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), 0, 0, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'箱', N'0', CAST(200.00 AS Decimal(18, 2)), N'HP12025         ', N'张三', CAST(0x0000B0D600000000 AS DateTime), N'undefined', CAST(0x0000B0E60124D559 AS DateTime), N'234', N'123.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (2, N'2               ', N'货品二', N'HP12025         ', 2, N'0', N'blue', CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), 0, 0, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'瓶', N'0', CAST(300.00 AS Decimal(18, 2)), N'HP12025         ', N'刘子怡', CAST(0x0000B0D700000000 AS DateTime), NULL, NULL, NULL, NULL)
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (4, N'3               ', N'货品三', N'0               ', 3, N'1', N'blur', CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), 0, 0, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'箱', N'0', CAST(200.00 AS Decimal(18, 2)), N'0               ', N'罗桓杰', CAST(0x0000B0D900000000 AS DateTime), N'罗桓杰', CAST(0x0000B0E600BEF187 AS DateTime), N'null', N'ca_1.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (5, N'4               ', N'货品四', N'HP12027         ', 4, N'0', N'blur', CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), 0, 0, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'瓶', N'0', CAST(400.00 AS Decimal(18, 2)), N'HP12027         ', N'李四', CAST(0x0000B0D400000000 AS DateTime), NULL, NULL, NULL, NULL)
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (6, N'5               ', N'货品五', N'HP12026         ', 5, N'0', N'blur ', CAST(0.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), 0, 0, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'瓶', N'0', CAST(500.00 AS Decimal(18, 2)), N'HP12026         ', N'易蕾', CAST(0x0000B0D300000000 AS DateTime), NULL, NULL, NULL, NULL)
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (7, N'HP12042         ', N'苹果手机', N'HP12027         ', 7, N'0', N'blur', CAST(200.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'台', N'0', NULL, N'HP12027         ', N'罗桓杰', CAST(0x0000B0D6013ED56B AS DateTime), NULL, NULL, N'确实挺不错的', NULL)
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (8, N'HP12077         ', N'小米手机', N'HP12026         ', 8, N'0', N'blue', CAST(200.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'台', N'0', NULL, N'HP12026         ', N'罗桓杰', CAST(0x0000B0D70097F04E AS DateTime), N'罗桓杰', CAST(0x0000B0DC01129AD6 AS DateTime), N'罗hj专用11', N'u6633.png,u6634.png')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (9, N'HP12087         ', N'等离子', N'34              ', 9, N'0', N'blur', CAST(200.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'台', N'0', NULL, N'HP12023         ', N'罗桓杰', CAST(0x0000B0D7009AB7EF AS DateTime), N'罗桓杰', CAST(0x0000B0D800E07D3E AS DateTime), N'..18测试111122', NULL)
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (10, N'HP120167        ', N'CES', N'34              ', 23, N'0', N'12', CAST(321.00 AS Decimal(18, 2)), CAST(312.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'3213', N'0', NULL, N'HP12023         ', N'罗桓杰', CAST(0x0000B0D80138444E AS DateTime), N'罗桓杰', CAST(0x0000B0DD01069734 AS DateTime), N'1231', N'QQ图片20220812201500.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (11, N'HP120168        ', N'12313', N'21              ', 312, N'1', N'312', CAST(312.00 AS Decimal(18, 2)), CAST(312.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'231', N'0', NULL, N'HP12028         ', N'罗桓杰', CAST(0x0000B0D8013C6E79 AS DateTime), N'罗桓杰', CAST(0x0000B0E600BEDF24 AS DateTime), N'312', N'ca_1.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (12, N'HP120169        ', N'777', N'21              ', 7, N'0', N'77', CAST(7.00 AS Decimal(18, 2)), CAST(77.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'77', N'0', NULL, N'34              ', N'罗桓杰', CAST(0x0000B0D801464A12 AS DateTime), N'undefined', CAST(0x0000B0DF011F48F7 AS DateTime), N'71', N'005Uzdlrly1g4cal42urpj30rq0rqq55.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (13, N'HP120170        ', N'123', N'17              ', 321, N'0', N'123', CAST(321.00 AS Decimal(18, 2)), CAST(123.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'32', N'0', NULL, N'HP12026         ', N'罗桓杰', CAST(0x0000B0D801467666 AS DateTime), N'undefined', CAST(0x0000B0DF015DA8CD AS DateTime), N'312', N'109951167080121523.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (14, N'HP120173        ', N'等待', N'18              ', 312, N'0', N'123', CAST(132.00 AS Decimal(18, 2)), CAST(3123.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'12312', N'0', NULL, N'HP12026         ', N'罗桓杰', CAST(0x0000B0DC00C47E0B AS DateTime), N'罗桓杰', CAST(0x0000B0DF016B8D29 AS DateTime), N'12311', N'121.png')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (15, N'HP120219        ', N'鼠标', N'17              ', 3, N'0', N'2*2', CAST(222.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'个', N'0', NULL, N'HP12025         ', N'罗桓杰', CAST(0x0000B0DE00BB2FB7 AS DateTime), N'罗桓杰', CAST(0x0000B0DF016B136B AS DateTime), N'22232', N'0073VZtcgy1h0hht157caj34002o0b2c.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (16, N'HP120250        ', N'bb', N'18              ', 123, N'0', N'123', CAST(12312.00 AS Decimal(18, 2)), CAST(123.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'123', N'0', NULL, N'HP12026         ', N'罗桓杰', CAST(0x0000B0E00109D10C AS DateTime), NULL, NULL, N'31231', N'hzw2.jpg,maomao.jpg,微信图片_20230911083904.jpg,279d40da7cb908f2cccdc83dc6b06b14.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (17, N'HP120253        ', N'口红', N'21              ', 1, N'0', N'4cm', CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'支', N'0', NULL, N'HP12028         ', N'罗桓杰', CAST(0x0000B0E300B20872 AS DateTime), N'罗桓杰', CAST(0x0000B0E500AF55F1 AS DateTime), N'艾未未', N'005Uzdlrly1g4cal42urpj30rq0rqq55.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (18, N'HP120387        ', N'柜子', N'40              ', 10, N'0', N'120*3', CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'个', N'0', NULL, N'HP120379        ', N'罗桓杰', CAST(0x0000B0E6009A7997 AS DateTime), NULL, NULL, N'阿萨德', N'bk_1.jpg,baby_b1.jpg,home_b2.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (19, N'HP120388        ', N'尿不湿', N'17              ', 23, N'0', N'3*6', CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'包', N'0', NULL, N'HP120384        ', N'罗桓杰', CAST(0x0000B0E6009ABFEC AS DateTime), N'undefined', CAST(0x0000B0E60133B8FB AS DateTime), N'123', N'123.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (20, N'HP120389        ', N'洗发水', N'39              ', 32, N'0', N'100*3', CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'瓶', N'0', NULL, N'HP120384        ', N'罗桓杰', CAST(0x0000B0E6009AF7F4 AS DateTime), N'undefined', CAST(0x0000B0E6012526BF AS DateTime), N'123213', N'121.png')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (21, N'HP120390        ', N'沐浴', N'39              ', 2, N'0', N'bule', CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'瓶', N'0', NULL, N'HP120378        ', N'罗桓杰', CAST(0x0000B0E6009B2EC3 AS DateTime), N'罗桓杰', CAST(0x0000B0E600C08B7E AS DateTime), N'123', N'home_b2.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (22, N'HP120396        ', N'衣', N'42              ', 1, N'0', N'130', CAST(200.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'件', N'0', NULL, N'HP120395        ', N'罗桓杰', CAST(0x0000B0E600F49F2E AS DateTime), N'undefined', CAST(0x0000B0E6014F96E0 AS DateTime), N'12', N'01228d5a216f56a801216e8d32b405.jpg@1280w_1l_2o_100sh.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (23, N'HP120397        ', N'波鞋', N'18              ', 321, N'0', N'1', CAST(321.00 AS Decimal(18, 2)), CAST(321.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'12', N'0', NULL, N'HP120379        ', N'罗桓杰', CAST(0x0000B0E601258C6D AS DateTime), N'undefined', CAST(0x0000B0E60127F86F AS DateTime), N'312', N'123.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (24, N'HP120423        ', N'棉服', N'HP120378        ', 3, N'0', N'12', CAST(233.00 AS Decimal(18, 2)), CAST(122.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'3123', N'0', NULL, N'HP120378        ', N'罗桓杰', CAST(0x0000B0E601348E79 AS DateTime), N'undefined', CAST(0x0000B0E60138BEE2 AS DateTime), N'213', N'123.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (25, N'HP120424        ', N'孩子', N'40              ', 123, N'0', N'45', CAST(122.00 AS Decimal(18, 2)), CAST(222.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'个', NULL, NULL, N'HP120395        ', N'罗环节', NULL, NULL, NULL, N'213', N'123.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (26, N'HP120429        ', N'无敌雷碧', N'HP120480        ', 321, N'0', N'123', CAST(312.00 AS Decimal(18, 2)), CAST(213.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'312', N'0', NULL, N'HP120504        ', N'罗桓杰', CAST(0x0000B0E601528035 AS DateTime), N'罗桓杰', CAST(0x0000B0E70112D5A4 AS DateTime), N'321', N'123.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (27, N'HP120436        ', N'可可乐了乐', N'HP120499        ', 11, N'0', N'120ml', CAST(20.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'个', N'0', NULL, N'HP120499        ', N'罗桓杰', CAST(0x0000B0E700A84F6E AS DateTime), N'罗桓杰', CAST(0x0000B0E8016B8F4F AS DateTime), N'买买买', N'123.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (28, N'HP120531        ', N'壁垒哥', N'HP120483        ', 12, N'0', N'21', CAST(12.00 AS Decimal(18, 2)), CAST(21.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'12', N'0', NULL, N'HP120483        ', N'undefined', CAST(0x0000B0E700F57F74 AS DateTime), N'罗桓杰', CAST(0x0000B0E80142CC2C AS DateTime), N'21132', N'123.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (29, N'HP120533        ', N'烈酒', N'HP120500        ', 21, N'0', N'112', CAST(21.00 AS Decimal(18, 2)), CAST(12.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'12', N'0', NULL, N'HP120500        ', N'undefined', CAST(0x0000B0E7011A4811 AS DateTime), N'罗桓杰', CAST(0x0000B0E80142AF5D AS DateTime), N'1212', N'123.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (30, N'HP10541         ', N'小米电视', N'HP12024         ', 12, N'0', N'120', CAST(3000.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'台', N'0', NULL, N'HP12024         ', N'undefined', CAST(0x0000B0EB009797C1 AS DateTime), NULL, NULL, N'21', N'109951167080121523.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (31, N'HP10542         ', N'白酒', N'HP120479        ', 12, N'0', N'132', CAST(12332.00 AS Decimal(18, 2)), CAST(1233.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'瓶', N'0', NULL, N'HP120479        ', N'罗桓杰', CAST(0x0000B0EB0098698C AS DateTime), N'罗桓杰', CAST(0x0000B0EB0098C8C5 AS DateTime), N'21112', N'u6633.png')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (32, N'HP10543         ', N'xo', N'HP10562         ', 12, N'0', N'3123', CAST(31231.00 AS Decimal(18, 2)), CAST(121.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'个', N'0', NULL, N'HP10562         ', N'undefined', CAST(0x0000B0EB01206C58 AS DateTime), N'罗桓杰', CAST(0x0000B0EB014B5C08 AS DateTime), N'123', N'fre_b2.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (33, N'HP10544         ', N'上衣', N'HP120490        ', 12, N'0', N'12', CAST(1231.00 AS Decimal(18, 2)), CAST(123.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'件', N'0', NULL, N'HP120490        ', N'undefined', CAST(0x0000B0EB0125164D AS DateTime), N'罗桓杰', CAST(0x0000B0EB01364EB3 AS DateTime), N'312', N'123.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (34, N'HP10550         ', N'无糖可乐', N'HP120499        ', 321, N'0', N'12', CAST(321.00 AS Decimal(18, 2)), CAST(123.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'瓶', N'0', NULL, N'HP120499        ', N'undefined', CAST(0x0000B0EB0137BDF6 AS DateTime), N'罗桓杰', CAST(0x0000B0EB013866E0 AS DateTime), N'123', N'121.png')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (35, N'HP10567         ', N'羽绒服', N'HP120490        ', 12, N'0', N'12', CAST(500.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'件', N'0', NULL, N'HP120490        ', N'罗桓杰', CAST(0x0000B0EB014CC38B AS DateTime), N'罗桓杰', CAST(0x0000B0EB014CE60F AS DateTime), N'121', N'home_b1.jpg,food_b2.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (36, N'HP10570         ', N'睡裤', N'HP10569         ', 12, N'0', N'12', CAST(300.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'件', N'0', NULL, N'HP10569         ', N'罗桓杰', CAST(0x0000B0EC00ED81D6 AS DateTime), N'罗桓杰', CAST(0x0000B0EC00EDDB0A AS DateTime), N'123', N'home_b2.jpg,home_b1.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (37, N'HP10574         ', N'哔哔机', N'HP120490        ', 5, N'0', N'2*3', CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'台', N'0', NULL, N'HP120490        ', N'罗桓杰', CAST(0x0000B0ED00C9B553 AS DateTime), NULL, NULL, N'123', N'ca_4.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (38, N'HP10578         ', N'荣耀', N'HP12027         ', 1, N'0', N'12', CAST(3000.00 AS Decimal(18, 2)), CAST(1500.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'台', N'0', NULL, N'HP12027         ', N'罗桓杰', CAST(0x0000B0ED00CDF0EC AS DateTime), N'罗桓杰', CAST(0x0000B0ED00CE1919 AS DateTime), N'1', N'sj2.jpg')
INSERT [dbo].[Bs_item] ([item_id], [item_code], [item_name], [item_type], [sort_code], [inbill_state], [model_code], [outbill_price], [inbill_price], [item_up], [item_down], [below_down], [above_up], [unit], [is_del], [item_inventory], [item_type_code], [create_by], [create_time], [update_by], [update_time], [remark], [ImgUrl]) VALUES (39, N'HP10580         ', N'华为', N'HP10579         ', 12, N'0', N'12', CAST(3000.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, N'台', N'0', NULL, N'HP10579         ', N'罗桓杰', CAST(0x0000B0ED00EE3103 AS DateTime), N'罗桓杰', CAST(0x0000B0ED00EE46B6 AS DateTime), N'12', N'sjj.jpg,sj1.jpg')
SET IDENTITY_INSERT [dbo].[Bs_item] OFF
SET IDENTITY_INSERT [dbo].[Bs_item_type] ON 

INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (17, N'HP12025         ', N'电子产品', N'0', 1, N'0', N'发送到广东佛山公司1', N'张三', CAST(0x0000AF9E00000000 AS DateTime), N'罗桓杰', CAST(0x0000B0E700D3F7A2 AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (18, N'HP12026         ', N'手机', N'HP12025', 2, N'0', N'规范大范甘迪1CE', N'李四', CAST(0x0000B0C10100E474 AS DateTime), N'罗桓杰', CAST(0x0000B0D601032AAF AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (19, N'HP12027         ', N'智能手机', N'HP12026         ', 3, N'0', N'1', N'1', CAST(0x0000B0C4006BD365 AS DateTime), N'罗桓杰', CAST(0x0000B0D600977107 AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (21, N'HP12028         ', N'电视', N'0', 4, N'0', N'还会看电视', N'张三', CAST(0x0000B0D5011E69A6 AS DateTime), N'罗桓杰', CAST(0x0000B0E40143B4E6 AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (33, N'HP12024         ', N'智能电视', N'HP12028', 5, N'0', N'x', N'张三', CAST(0x0000B0D5013DA2B8 AS DateTime), N'罗桓杰', CAST(0x0000B0D600974AFE AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (34, N'HP12023         ', N'显示器', N'HP12028         ', 6, N'0', N'好用', N'罗桓杰', CAST(0x0000B0D5013F4E56 AS DateTime), N'罗桓杰', CAST(0x0000B0E700BE9DD7 AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (35, N'HP120127        ', N'测试', N'18', 7, N'0', N'1', N'罗桓杰', CAST(0x0000B0D7015D1F12 AS DateTime), NULL, NULL, N'1')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (36, N'HP120301        ', N'2', N'0', 8, N'0', N'12', N'罗桓杰', CAST(0x0000B0E401467C0D AS DateTime), NULL, NULL, N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (37, N'HP120316        ', N'1', N'0', 9, N'0', N'22', N'罗桓杰', CAST(0x0000B0E50144F683 AS DateTime), NULL, NULL, N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (38, N'HP120318        ', N'12345', N'0', 10, N'0', N'121', N'罗桓杰', CAST(0x0000B0E501452EBF AS DateTime), NULL, NULL, N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (39, N'HP120378        ', N'服装', N'0', 11, N'0', N'衣服', N'罗桓杰', CAST(0x0000B0E600994718 AS DateTime), NULL, NULL, N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (40, N'HP120379        ', N'男装', N'HP120378', 12, N'0', N'1', N'罗桓杰', CAST(0x0000B0E600996E31 AS DateTime), NULL, NULL, N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (41, N'HP120382        ', N'牛仔裤', N'HP120379        ', 13, N'0', N'1231', N'罗桓杰', CAST(0x0000B0E60099AB58 AS DateTime), N'罗桓杰', CAST(0x0000B0E700D3B7DD AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (42, N'HP120384        ', N'连衣裙', N'HP120384        ', 14, N'0', N'21', N'罗桓杰', CAST(0x0000B0E60099E37C AS DateTime), N'罗桓杰', CAST(0x0000B0E700BE787D AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (43, N'HP120395        ', N'卫衣', N'HP120379', 15, N'0', N'12', N'罗桓杰', CAST(0x0000B0E600F3EA0E AS DateTime), N'罗桓杰', CAST(0x0000B0E600F40869 AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (44, N'HP120457        ', N'可乐', N'HP120479        ', 16, N'0', N'好用', N'罗桓杰', CAST(0x0000B0E700BAC9D8 AS DateTime), N'罗桓杰', CAST(0x0000B0E700CAFE7A AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (45, N'HP120467        ', N'装饰', N'HP12025         ', 17, N'0', N'美美哒', N'罗桓杰', CAST(0x0000B0E700C44BC9 AS DateTime), NULL, NULL, N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (46, N'HP120479        ', N'饮料', N'0', 18, N'0', N'喝喝喝', N'罗桓杰', CAST(0x0000B0E700CAA1CA AS DateTime), NULL, NULL, N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (47, N'HP120480        ', N'雪碧', N'HP120479 ', 19, N'0', N'透心凉', N'罗桓杰', CAST(0x0000B0E700D363B8 AS DateTime), NULL, NULL, N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (48, N'HP120483        ', N'冰雪碧', N'HP120480        ', 20, N'0', N'好喝到爆炸', N'罗桓杰', CAST(0x0000B0E700D46774 AS DateTime), N'罗桓杰', CAST(0x0000B0E700D4A02F AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (49, N'HP120486        ', N'可口可乐', N'HP120457        ', 21, N'0', N'2112', N'罗桓杰', CAST(0x0000B0E700D4E0F2 AS DateTime), N'罗桓杰', CAST(0x0000B0E700D5A93B AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (50, N'HP120490        ', N'女装', N'HP120378        ', 22, N'0', N'1', N'罗桓杰', CAST(0x0000B0E700D5E237 AS DateTime), NULL, NULL, N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (51, N'HP120499        ', N'百世可乐1', N'HP120457        ', 23, N'0', N'1', N'罗桓杰', CAST(0x0000B0E700D886BD AS DateTime), N'罗桓杰', CAST(0x0000B0E700D8C873 AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (52, N'HP120500        ', N'酒', N'HP120479', 24, N'0', N'1', N'罗桓杰', CAST(0x0000B0E700D8F824 AS DateTime), N'罗桓杰', CAST(0x0000B0E700D94F0D AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (53, N'HP120504        ', N'常温雪碧', N'HP120480        ', 25, N'0', N'1212', N'罗桓杰', CAST(0x0000B0E700E2839B AS DateTime), N'罗桓杰', CAST(0x0000B0E801722B55 AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (54, N'HP10562         ', N'八喜1', N'HP120479        ', 26, N'0', N'12', N'罗桓杰', CAST(0x0000B0EB0148895A AS DateTime), N'罗桓杰', CAST(0x0000B0EC00B6D339 AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (55, N'HP10568         ', N'橙汁', N'HP120479        ', 27, N'0', N'12', N'罗桓杰', CAST(0x0000B0EC00BCD096 AS DateTime), NULL, NULL, N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (56, N'HP10569         ', N'棉裤1', N'HP120490        ', 28, N'0', N'21', N'罗桓杰', CAST(0x0000B0EC00ED1DBD AS DateTime), N'罗桓杰', CAST(0x0000B0EC00ED33C0 AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (57, N'HP10573         ', N'果粒橙', N'HP10568         ', 29, N'0', N'好喝', N'罗桓杰', CAST(0x0000B0ED00C0DBB9 AS DateTime), NULL, NULL, N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (58, N'HP10577         ', N'超智能', N'HP12027         ', 1, N'0', N'11', N'罗桓杰', CAST(0x0000B0ED00CD7BA2 AS DateTime), N'罗桓杰', CAST(0x0000B0ED00CD934D AS DateTime), N'0')
INSERT [dbo].[Bs_item_type] ([item_type_id], [item_type_code], [item_type_name], [father_code], [sort_code], [inbill_state], [remark], [create_by], [create_time], [update_by], [update_time], [is_del]) VALUES (59, N'HP10579         ', N'智能', N'HP12027         ', 1, N'0', N'1', N'罗桓杰', CAST(0x0000B0ED00EDEB9F AS DateTime), N'罗桓杰', CAST(0x0000B0ED00EDFBE8 AS DateTime), N'0')
SET IDENTITY_INSERT [dbo].[Bs_item_type] OFF
SET IDENTITY_INSERT [dbo].[Bs_supply] ON 

INSERT [dbo].[Bs_supply] ([supply_id], [supply_code], [supply_name], [line_type], [supply_type_code], [link_man], [link_tel], [e_mail], [stock_duty_man], [inbill_state], [supply_adr], [finance_id], [operatoro], [opetime], [is_del], [remark]) VALUES (3, N'GYSDH8351       ', N'供应商一', N'零售', N'成品供应商', N'李依依', N'18918918998', N'cwm@tom.com', N'李依依', N'0', N'河南省三门峡市卢氏县文化路956号', 1, N'罗桓杰', CAST(0x0000B0B700000000 AS DateTime), N'0', N'大是大非国际化的辅导辅导')
INSERT [dbo].[Bs_supply] ([supply_id], [supply_code], [supply_name], [line_type], [supply_type_code], [link_man], [link_tel], [e_mail], [stock_duty_man], [inbill_state], [supply_adr], [finance_id], [operatoro], [opetime], [is_del], [remark]) VALUES (4, N'GYSDH6727       ', N'供应商二', N'制造', N'成品供应商', N'李依依', N'18788393737', N'cwb@tom.com', N'李依依', N'0', N'河南省三门峡市卢氏县文化路956号', 2, N'罗桓杰', CAST(0x0000B0B600000000 AS DateTime), N'0', N'null')
INSERT [dbo].[Bs_supply] ([supply_id], [supply_code], [supply_name], [line_type], [supply_type_code], [link_man], [link_tel], [e_mail], [stock_duty_man], [inbill_state], [supply_adr], [finance_id], [operatoro], [opetime], [is_del], [remark]) VALUES (5, N'GYSDH1472       ', N'供应商三', N'制药厂', N'成品供应商', N'李依依', N'16689849373', N'cej@tom.com', N'李依依', N'0', N'河南省三门峡市卢氏县文化路956号', 3, N'李依依', CAST(0x0000B0C200000000 AS DateTime), N'0', NULL)
INSERT [dbo].[Bs_supply] ([supply_id], [supply_code], [supply_name], [line_type], [supply_type_code], [link_man], [link_tel], [e_mail], [stock_duty_man], [inbill_state], [supply_adr], [finance_id], [operatoro], [opetime], [is_del], [remark]) VALUES (19, N'GYS25046        ', N'荣耀', N'零售', N'成品供应商', N'刘子怡', N'13203023638', N'3042998714@qq.com', N'刘子怡', N'0', N'2', 40, N'罗桓杰', CAST(0x0000B0E3012343C7 AS DateTime), N'0', N'2')
INSERT [dbo].[Bs_supply] ([supply_id], [supply_code], [supply_name], [line_type], [supply_type_code], [link_man], [link_tel], [e_mail], [stock_duty_man], [inbill_state], [supply_adr], [finance_id], [operatoro], [opetime], [is_del], [remark]) VALUES (20, N'GYS26061        ', N'苹果', N'零售', N'成品供应商', N'李依依', N'13232323222', N'3042998714@qq.com', N'黄妍妮', N'0', N'123', 42, N'罗桓杰', CAST(0x0000B0E401220904 AS DateTime), N'0', N'123')
INSERT [dbo].[Bs_supply] ([supply_id], [supply_code], [supply_name], [line_type], [supply_type_code], [link_man], [link_tel], [e_mail], [stock_duty_man], [inbill_state], [supply_adr], [finance_id], [operatoro], [opetime], [is_del], [remark]) VALUES (21, N'GYS27064        ', N'供应商五', N'制药厂', N'成品供应商', N'丽姨姨', N'19918026397', N'3523966028@qq.com', N'黄妍妮', N'0', N'湖南省长沙市开福区', 44, N'罗桓杰', CAST(0x0000B0E501431360 AS DateTime), N'0', N'哈哈哈哈哈')
INSERT [dbo].[Bs_supply] ([supply_id], [supply_code], [supply_name], [line_type], [supply_type_code], [link_man], [link_tel], [e_mail], [stock_duty_man], [inbill_state], [supply_adr], [finance_id], [operatoro], [opetime], [is_del], [remark]) VALUES (22, N'GYS27065        ', N'供应商六', N'零售', N'成品供应商', N'李欢欢', N'19918026397', N'3523966028@qq.com', N'易蕾', N'0', N'湖南省长沙市开福区', 45, N'罗桓杰', CAST(0x0000B0E50143A224 AS DateTime), N'0', N'1111')
INSERT [dbo].[Bs_supply] ([supply_id], [supply_code], [supply_name], [line_type], [supply_type_code], [link_man], [link_tel], [e_mail], [stock_duty_man], [inbill_state], [supply_adr], [finance_id], [operatoro], [opetime], [is_del], [remark]) VALUES (23, N'GYS28069        ', N'华为', N'服务商', N'零件供应商', N'李媛媛', N'18974022095', N'598911527@qq.com', N'黄妍妮', N'0', N'湖南省', 48, N'罗桓杰', CAST(0x0000B0E600EF79AC AS DateTime), N'0', N'欢迎你')
INSERT [dbo].[Bs_supply] ([supply_id], [supply_code], [supply_name], [line_type], [supply_type_code], [link_man], [link_tel], [e_mail], [stock_duty_man], [inbill_state], [supply_adr], [finance_id], [operatoro], [opetime], [is_del], [remark]) VALUES (24, N'GYS2071         ', N'小米', N'服务商', N'集合供应商', N'小白', N'13232323223', N'3042998714@qq.com', N'余开学', N'0', N'华南长', 50, N'罗桓杰', CAST(0x0000B0EB010336D7 AS DateTime), N'0', N'123')
INSERT [dbo].[Bs_supply] ([supply_id], [supply_code], [supply_name], [line_type], [supply_type_code], [link_man], [link_tel], [e_mail], [stock_duty_man], [inbill_state], [supply_adr], [finance_id], [operatoro], [opetime], [is_del], [remark]) VALUES (25, N'GYS2074         ', N'三星', N'制造', N'集合供应商', N'年天币', N'13203023738', N'3042997714@qq.com ', N'刘子怡', N'0', N'长沙市开福区蔡锷北路', 54, N'罗桓杰', CAST(0x0000B0EB0119205F AS DateTime), N'0', N'长沙市123')
INSERT [dbo].[Bs_supply] ([supply_id], [supply_code], [supply_name], [line_type], [supply_type_code], [link_man], [link_tel], [e_mail], [stock_duty_man], [inbill_state], [supply_adr], [finance_id], [operatoro], [opetime], [is_del], [remark]) VALUES (26, N'GYS3078         ', N'iqoo', N'制造', N'零件供应商', N'李依依', N'13203023738', N'3042997714@qq.com', N'罗桓杰', N'0', N'长沙市开福区蔡锷北路', 56, N'罗桓杰', CAST(0x0000B0EC00E9F258 AS DateTime), N'0', N'edwcdfe')
INSERT [dbo].[Bs_supply] ([supply_id], [supply_code], [supply_name], [line_type], [supply_type_code], [link_man], [link_tel], [e_mail], [stock_duty_man], [inbill_state], [supply_adr], [finance_id], [operatoro], [opetime], [is_del], [remark]) VALUES (27, N'GYS4079         ', N'vivo', N'零售', N'集合供应商', N'李依依1', N'13203023733', N'3042997714@qq.com', N'易蕾', N'0', N'长沙市开福区蔡锷北路', 58, N'罗桓杰', CAST(0x0000B0ED00EC6290 AS DateTime), N'0', N'搜索')
SET IDENTITY_INSERT [dbo].[Bs_supply] OFF
SET IDENTITY_INSERT [dbo].[Bs_ware_area] ON 

INSERT [dbo].[Bs_ware_area] ([ware_area_id], [area_code], [area_name], [area_cap], [area_duty_man], [sort_code], [area_state], [create_by], [create_time], [update_time], [update_by], [is_del], [warehouse_id], [remark], [dh]) VALUES (1, N'KWBH1           ', N'库位一', 500, N'yy', 1, N'0', N'yy', CAST(0x0000B0C200000000 AS DateTime), CAST(0x0000B0C200000000 AS DateTime), N'罗桓杰', N'0', N'仓库三', N'师德师风', N'undefined')
INSERT [dbo].[Bs_ware_area] ([ware_area_id], [area_code], [area_name], [area_cap], [area_duty_man], [sort_code], [area_state], [create_by], [create_time], [update_time], [update_by], [is_del], [warehouse_id], [remark], [dh]) VALUES (2, N'KWBH2           ', N'库位二', 500, N'yl', 1, N'0', N'yl', CAST(0x0000B0C200000000 AS DateTime), CAST(0x0000B0C200000000 AS DateTime), N'罗桓杰', N'0', N'仓库二', N'气温低', N'null')
INSERT [dbo].[Bs_ware_area] ([ware_area_id], [area_code], [area_name], [area_cap], [area_duty_man], [sort_code], [area_state], [create_by], [create_time], [update_time], [update_by], [is_del], [warehouse_id], [remark], [dh]) VALUES (3, N'KWBH3           ', N'库位三', 500, N'yxs', 1, N'0', N'yxs', CAST(0x0000B0C200000000 AS DateTime), CAST(0x0000B0C200000000 AS DateTime), N'罗桓杰', N'0', N'仓库四', N'阿萨德', N'123456')
INSERT [dbo].[Bs_ware_area] ([ware_area_id], [area_code], [area_name], [area_cap], [area_duty_man], [sort_code], [area_state], [create_by], [create_time], [update_time], [update_by], [is_del], [warehouse_id], [remark], [dh]) VALUES (4, N'KWBH4           ', N'库位四', 500, N'张三', 1, N'0', N'张三', CAST(0x0000B0C200000000 AS DateTime), CAST(0x0000B0C200000000 AS DateTime), N'罗桓杰', N'0', N'仓库四', N'阿萨德', N'null')
INSERT [dbo].[Bs_ware_area] ([ware_area_id], [area_code], [area_name], [area_cap], [area_duty_man], [sort_code], [area_state], [create_by], [create_time], [update_time], [update_by], [is_del], [warehouse_id], [remark], [dh]) VALUES (29, N'CW26067         ', N'B2', 400, N'5', 3, N'0', N'罗桓杰', CAST(0x0000B0E40127A769 AS DateTime), CAST(0x0000B0E40127A769 AS DateTime), N'罗桓杰', N'0', N'仓库七', N'111', N'12331535')
INSERT [dbo].[Bs_ware_area] ([ware_area_id], [area_code], [area_name], [area_cap], [area_duty_man], [sort_code], [area_state], [create_by], [create_time], [update_time], [update_by], [is_del], [warehouse_id], [remark], [dh]) VALUES (30, N'CW28070         ', N'A1', 100, N'4', 2, N'0', N'罗桓杰', CAST(0x0000B0E600F29689 AS DateTime), CAST(0x0000B0E600F29689 AS DateTime), N'罗桓杰', N'0', N'司马里仓', N'111', N'18974022095')
INSERT [dbo].[Bs_ware_area] ([ware_area_id], [area_code], [area_name], [area_cap], [area_duty_man], [sort_code], [area_state], [create_by], [create_time], [update_time], [update_by], [is_del], [warehouse_id], [remark], [dh]) VALUES (31, N'CW29071         ', N'A2', 210, N'1', 12, N'0', N'罗桓杰', CAST(0x0000B0E700BA6C54 AS DateTime), CAST(0x0000B0E700BA6C54 AS DateTime), N'罗桓杰', N'0', N'仓库二', N'12', N'21')
INSERT [dbo].[Bs_ware_area] ([ware_area_id], [area_code], [area_name], [area_cap], [area_duty_man], [sort_code], [area_state], [create_by], [create_time], [update_time], [update_by], [is_del], [warehouse_id], [remark], [dh]) VALUES (32, N'CW2073          ', N'B1', 200, N'8', 23, N'0', N'罗桓杰', CAST(0x0000B0EB011A565A AS DateTime), CAST(0x0000B0EB011A565A AS DateTime), N'罗桓杰', N'0', N'蔡锷仓', N'232', N'132032323')
INSERT [dbo].[Bs_ware_area] ([ware_area_id], [area_code], [area_name], [area_cap], [area_duty_man], [sort_code], [area_state], [create_by], [create_time], [update_time], [update_by], [is_del], [warehouse_id], [remark], [dh]) VALUES (33, N'CW2074          ', N'C1', 300, N'2', 5, N'0', N'罗桓杰', CAST(0x0000B0EB011A8103 AS DateTime), CAST(0x0000B0EB011A8103 AS DateTime), N'罗桓杰', N'0', N'司马里仓', N'QEWEWQE', N'13445234321')
INSERT [dbo].[Bs_ware_area] ([ware_area_id], [area_code], [area_name], [area_cap], [area_duty_man], [sort_code], [area_state], [create_by], [create_time], [update_time], [update_by], [is_del], [warehouse_id], [remark], [dh]) VALUES (34, N'CW2075          ', N'C2', 400, N'4', 7, N'0', N'罗桓杰', CAST(0x0000B0EB011A9EC5 AS DateTime), CAST(0x0000B0EB011A9EC5 AS DateTime), N'罗桓杰', N'0', N'星沙仓', N'123213', N'13234564325')
INSERT [dbo].[Bs_ware_area] ([ware_area_id], [area_code], [area_name], [area_cap], [area_duty_man], [sort_code], [area_state], [create_by], [create_time], [update_time], [update_by], [is_del], [warehouse_id], [remark], [dh]) VALUES (36, N'CW2086          ', N'B', 1, N'2', 1, N'0', N'罗桓杰', CAST(0x0000B0EB01226C46 AS DateTime), CAST(0x0000B0EB01226C46 AS DateTime), N'罗桓杰', N'0', N'仓库四', N'null', N'1')
INSERT [dbo].[Bs_ware_area] ([ware_area_id], [area_code], [area_name], [area_cap], [area_duty_man], [sort_code], [area_state], [create_by], [create_time], [update_time], [update_by], [is_del], [warehouse_id], [remark], [dh]) VALUES (37, N'CW3087          ', N'D1', 400, N'2', 8, N'0', N'罗桓杰', CAST(0x0000B0EC00EC6871 AS DateTime), CAST(0x0000B0EC00EC6871 AS DateTime), N'罗桓杰', N'0', N'芙蓉仓', N'吃的', N'13203023738')
INSERT [dbo].[Bs_ware_area] ([ware_area_id], [area_code], [area_name], [area_cap], [area_duty_man], [sort_code], [area_state], [create_by], [create_time], [update_time], [update_by], [is_del], [warehouse_id], [remark], [dh]) VALUES (38, N'CW4090          ', N'E1', 200, N'5', 4, N'0', N'罗桓杰', CAST(0x0000B0ED00ED9DBD AS DateTime), CAST(0x0000B0ED00ED9DBD AS DateTime), N'罗桓杰', N'0', N'蔡锷中路仓', N'的东西', N'13203023738')
SET IDENTITY_INSERT [dbo].[Bs_ware_area] OFF
SET IDENTITY_INSERT [dbo].[Bs_warehouse] ON 

INSERT [dbo].[Bs_warehouse] ([warehouse_id], [ware_code], [ware_cap], [ware_state], [ware_adr], [is_default], [is_lock], [ware_duty_man], [sort_code], [create_by], [create_time], [update_by], [update_time], [is_del], [ware_name], [ware_code3], [remark], [dh]) VALUES (1, N'CKBH1           ', 500, N'0', N'河南省三门峡市卢氏县文化路956号', N'1', 0, N'yy', 1, N'yy', CAST(0x0000B0C100000000 AS DateTime), N'罗桓杰', CAST(0x0000B0C100000000 AS DateTime), N'0', N'仓库一', NULL, N'11111', N'11111')
INSERT [dbo].[Bs_warehouse] ([warehouse_id], [ware_code], [ware_cap], [ware_state], [ware_adr], [is_default], [is_lock], [ware_duty_man], [sort_code], [create_by], [create_time], [update_by], [update_time], [is_del], [ware_name], [ware_code3], [remark], [dh]) VALUES (5, N'CKBH2           ', 500, N'0', N'河南省三门峡市卢氏县文化路956号', N'0', 0, N'张三', 2, N'YL', CAST(0x0000B0C100000000 AS DateTime), N'罗桓杰', CAST(0x0000B0C100000000 AS DateTime), N'0', N'仓库二', NULL, N'1范文芳', N'234513')
INSERT [dbo].[Bs_warehouse] ([warehouse_id], [ware_code], [ware_cap], [ware_state], [ware_adr], [is_default], [is_lock], [ware_duty_man], [sort_code], [create_by], [create_time], [update_by], [update_time], [is_del], [ware_name], [ware_code3], [remark], [dh]) VALUES (6, N'CKBH3           ', 500, N'0', N'河南省三门峡市卢氏县文化路956号', N'0', 0, N'张三', 3, N'yxs', CAST(0x0000B0C100000000 AS DateTime), N'罗桓杰', CAST(0x0000B0C100000000 AS DateTime), N'0', N'仓库三', NULL, N'123123', N'111')
INSERT [dbo].[Bs_warehouse] ([warehouse_id], [ware_code], [ware_cap], [ware_state], [ware_adr], [is_default], [is_lock], [ware_duty_man], [sort_code], [create_by], [create_time], [update_by], [update_time], [is_del], [ware_name], [ware_code3], [remark], [dh]) VALUES (7, N'CKBH4           ', 500, N'2', N'河南省三门峡市卢氏县文化路956号', N'0', 1, N'张三', 4, N'张三', CAST(0x0000B0C100000000 AS DateTime), N'罗桓杰', CAST(0x0000B0C100000000 AS DateTime), N'0', N'仓库四', NULL, N'123123', N'undefined')
INSERT [dbo].[Bs_warehouse] ([warehouse_id], [ware_code], [ware_cap], [ware_state], [ware_adr], [is_default], [is_lock], [ware_duty_man], [sort_code], [create_by], [create_time], [update_by], [update_time], [is_del], [ware_name], [ware_code3], [remark], [dh]) VALUES (60, N'CKD25047        ', 400, N'0', N'11111', N'0', 0, N'刘子怡', 1, N'罗桓杰', CAST(0x0000B0E30124AB28 AS DateTime), N'罗桓杰', CAST(0x0000B0E30124AB28 AS DateTime), N'0', N'星沙仓', NULL, N'11', N'1111')
INSERT [dbo].[Bs_warehouse] ([warehouse_id], [ware_code], [ware_cap], [ware_state], [ware_adr], [is_default], [is_lock], [ware_duty_man], [sort_code], [create_by], [create_time], [update_by], [update_time], [is_del], [ware_name], [ware_code3], [remark], [dh]) VALUES (61, N'CKD26081        ', 300, N'2', N'千万11', N'0', 1, N'黄妍妮', 3, N'罗桓杰', CAST(0x0000B0E401402BC9 AS DateTime), N'罗桓杰', CAST(0x0000B0E401402BC9 AS DateTime), N'0', N'北大仓', NULL, N'1111', N'12312312312')
INSERT [dbo].[Bs_warehouse] ([warehouse_id], [ware_code], [ware_cap], [ware_state], [ware_adr], [is_default], [is_lock], [ware_duty_man], [sort_code], [create_by], [create_time], [update_by], [update_time], [is_del], [ware_name], [ware_code3], [remark], [dh]) VALUES (62, N'CKD27084        ', 300, N'0', N'湖南', N'0', 0, N'易蕾', 2, N'罗桓杰', CAST(0x0000B0E501450D5E AS DateTime), N'罗桓杰', CAST(0x0000B0E501450D5E AS DateTime), N'0', N'仓库五', NULL, N'111', N'19918026397')
INSERT [dbo].[Bs_warehouse] ([warehouse_id], [ware_code], [ware_cap], [ware_state], [ware_adr], [is_default], [is_lock], [ware_duty_man], [sort_code], [create_by], [create_time], [update_by], [update_time], [is_del], [ware_name], [ware_code3], [remark], [dh]) VALUES (63, N'CKD28086        ', 200, N'0', N'长沙市开福区司马里', N'0', 0, N'刘子怡', 6, N'罗桓杰', CAST(0x0000B0E600F1D7D8 AS DateTime), N'罗桓杰', CAST(0x0000B0E600F1D7D8 AS DateTime), N'0', N'司马里仓', NULL, N'1111', N'18974022095')
INSERT [dbo].[Bs_warehouse] ([warehouse_id], [ware_code], [ware_cap], [ware_state], [ware_adr], [is_default], [is_lock], [ware_duty_man], [sort_code], [create_by], [create_time], [update_by], [update_time], [is_del], [ware_name], [ware_code3], [remark], [dh]) VALUES (64, N'CKD29087        ', 200, N'2', N'北大青鸟', N'0', 1, N'霍建华', 2, N'罗桓杰', CAST(0x0000B0E700BA5090 AS DateTime), N'罗桓杰', CAST(0x0000B0E700BA5090 AS DateTime), N'0', N'仓库七', NULL, N'213', N'13203023638')
INSERT [dbo].[Bs_warehouse] ([warehouse_id], [ware_code], [ware_cap], [ware_state], [ware_adr], [is_default], [is_lock], [ware_duty_man], [sort_code], [create_by], [create_time], [update_by], [update_time], [is_del], [ware_name], [ware_code3], [remark], [dh]) VALUES (65, N'CKD2091         ', 210, N'2', N'长沙市开福区蔡锷北路', N'0', 1, N'余开学', 2, N'罗桓杰', CAST(0x0000B0EB011A0933 AS DateTime), N'罗桓杰', CAST(0x0000B0EB011A0933 AS DateTime), N'0', N'蔡锷仓', NULL, N'23123', N'13203023373')
INSERT [dbo].[Bs_warehouse] ([warehouse_id], [ware_code], [ware_cap], [ware_state], [ware_adr], [is_default], [is_lock], [ware_duty_man], [sort_code], [create_by], [create_time], [update_by], [update_time], [is_del], [ware_name], [ware_code3], [remark], [dh]) VALUES (66, N'CKD3096         ', 500, N'0', N'长沙市开福区芙蓉中路', N'0', 0, N'罗桓杰', 11, N'罗桓杰', CAST(0x0000B0EC00EC0B06 AS DateTime), N'罗桓杰', CAST(0x0000B0EC00EC0B06 AS DateTime), N'0', N'芙蓉仓', NULL, N'我文档我', N'13203023738')
INSERT [dbo].[Bs_warehouse] ([warehouse_id], [ware_code], [ware_cap], [ware_state], [ware_adr], [is_default], [is_lock], [ware_duty_man], [sort_code], [create_by], [create_time], [update_by], [update_time], [is_del], [ware_name], [ware_code3], [remark], [dh]) VALUES (67, N'CKD4099         ', 500, N'0', N'长沙市开福区蔡锷中路', N'0', 0, N'罗桓杰', 11, N'罗桓杰', CAST(0x0000B0ED00ED5799 AS DateTime), N'罗桓杰', CAST(0x0000B0ED00ED5799 AS DateTime), N'0', N'蔡锷中路仓', NULL, N'我失望', N'13203023739')
SET IDENTITY_INSERT [dbo].[Bs_warehouse] OFF
SET IDENTITY_INSERT [dbo].[Roles] ON 

INSERT [dbo].[Roles] ([RolesID], [RolesName], [RolesAuthority], [RolesState]) VALUES (1, N'超级管理员', N'我是超级管理员', N'0')
INSERT [dbo].[Roles] ([RolesID], [RolesName], [RolesAuthority], [RolesState]) VALUES (2, N'行政', N'我高人一等', N'1')
INSERT [dbo].[Roles] ([RolesID], [RolesName], [RolesAuthority], [RolesState]) VALUES (3, N'普通用户', N'我只是一个普通的人', N'1')
INSERT [dbo].[Roles] ([RolesID], [RolesName], [RolesAuthority], [RolesState]) VALUES (8, N'采购员', N'负责采购', N'0')
INSERT [dbo].[Roles] ([RolesID], [RolesName], [RolesAuthority], [RolesState]) VALUES (9, N'仓管部', N'负责管理出入库管理', N'0')
INSERT [dbo].[Roles] ([RolesID], [RolesName], [RolesAuthority], [RolesState]) VALUES (10, N'录入员', N'负责录入基本信息', N'0')
SET IDENTITY_INSERT [dbo].[Roles] OFF
SET IDENTITY_INSERT [dbo].[RolesAuthority] ON 

INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (668, 2, 15)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (669, 2, 4)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (670, 2, 35)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (671, 2, 18)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (672, 2, 17)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (673, 2, 7)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (674, 2, 20)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (675, 2, 19)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (676, 2, 34)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (677, 2, 21)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (678, 2, 10)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (679, 2, 22)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (680, 2, 23)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (681, 2, 13)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (682, 2, 24)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (683, 2, 30)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (684, 2, 31)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (685, 2, 16)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (686, 2, 33)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (687, 2, 6)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (872, 1, 16)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (873, 1, 4)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (874, 1, 35)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (875, 1, 7)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (876, 1, 17)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (877, 1, 18)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (878, 1, 19)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (879, 1, 20)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (880, 1, 15)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (881, 1, 22)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (882, 1, 10)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (883, 1, 21)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (884, 1, 23)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (885, 1, 24)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (886, 1, 11)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (887, 1, 25)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (888, 1, 26)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (889, 1, 12)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (890, 1, 87)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (891, 1, 30)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (892, 1, 13)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (893, 1, 31)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (894, 1, 37)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (895, 1, 6)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (896, 1, 34)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (897, 1, 33)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (898, 1, 14)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (899, 1, 36)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (900, 8, 24)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (901, 8, 22)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (902, 8, 21)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (903, 8, 23)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (904, 8, 10)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (923, 9, 7)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (924, 9, 17)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (925, 9, 87)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (926, 9, 20)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (927, 9, 18)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (928, 9, 19)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (929, 9, 12)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (930, 10, 4)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (931, 10, 15)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (932, 10, 16)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (933, 10, 6)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (934, 10, 11)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (935, 10, 25)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (936, 10, 26)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (937, 10, 35)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (938, 10, 13)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (939, 10, 36)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (940, 10, 31)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (941, 10, 30)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (942, 10, 37)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (943, 10, 14)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (944, 10, 34)
INSERT [dbo].[RolesAuthority] ([RolesAuthorityID], [RolesID], [AuthorityID]) VALUES (945, 10, 33)
SET IDENTITY_INSERT [dbo].[RolesAuthority] OFF
SET IDENTITY_INSERT [dbo].[Sys_dict_data] ON 

INSERT [dbo].[Sys_dict_data] ([dict_code], [dict_name], [dict_label], [dict_type], [is_default], [status], [dict_value], [create_by], [create_time], [update_by], [update_time], [remark], [is_del], [dict_id]) VALUES (17, N'1', N'男', N'0', NULL, N'0', N'0', N'张三', CAST(0x0000B0CE00000000 AS DateTime), NULL, NULL, N'性别男', N'0', 3)
INSERT [dbo].[Sys_dict_data] ([dict_code], [dict_name], [dict_label], [dict_type], [is_default], [status], [dict_value], [create_by], [create_time], [update_by], [update_time], [remark], [is_del], [dict_id]) VALUES (20, N'2', N'女', N'0', NULL, N'0', N'1', N'张三', CAST(0x0000B0CE0100C6EC AS DateTime), NULL, NULL, N'性别女', N'0', 3)
INSERT [dbo].[Sys_dict_data] ([dict_code], [dict_name], [dict_label], [dict_type], [is_default], [status], [dict_value], [create_by], [create_time], [update_by], [update_time], [remark], [is_del], [dict_id]) VALUES (21, N'1', N'显示', N'sys_show_hide', N'0', N'0', N'0', N'张三', CAST(0x0000B0D000EC216D AS DateTime), N'罗桓杰', CAST(0x0000B0D000F91AE7 AS DateTime), N'显示菜单', N'0', 4)
INSERT [dbo].[Sys_dict_data] ([dict_code], [dict_name], [dict_label], [dict_type], [is_default], [status], [dict_value], [create_by], [create_time], [update_by], [update_time], [remark], [is_del], [dict_id]) VALUES (22, N'2', N'隐藏', N'sys_show_hide', N'0', N'0', N'1', N'罗桓杰', CAST(0x0000B0D000F476F4 AS DateTime), NULL, NULL, N'隐藏菜单', N'0', 4)
SET IDENTITY_INSERT [dbo].[Sys_dict_data] OFF
SET IDENTITY_INSERT [dbo].[Sys_dict_type] ON 

INSERT [dbo].[Sys_dict_type] ([dict_id], [dict_name], [dict_label], [dict_value], [create_by], [create_time], [update_by], [update_time], [remark], [is_del], [status]) VALUES (3, N'用户性别', N'sys_user_sex', N'0', N'张三', CAST(0x0000B0CE00000000 AS DateTime), N'罗桓杰', CAST(0x0000B0D000EB775D AS DateTime), N'用户性别列表', N'0', N'0')
INSERT [dbo].[Sys_dict_type] ([dict_id], [dict_name], [dict_label], [dict_value], [create_by], [create_time], [update_by], [update_time], [remark], [is_del], [status]) VALUES (4, N'菜单状态', N'sys_show_hide', N'1', N'张三', CAST(0x0000B0CD00000000 AS DateTime), N'罗桓杰', CAST(0x0000B0D000EB5AAD AS DateTime), N'菜单状态列表', N'0', N'0')
INSERT [dbo].[Sys_dict_type] ([dict_id], [dict_name], [dict_label], [dict_value], [create_by], [create_time], [update_by], [update_time], [remark], [is_del], [status]) VALUES (6, N'系统开关', N'sys_normal_disable', N'2', N'罗桓杰', CAST(0x0000B0CC00000000 AS DateTime), N'罗桓杰', CAST(0x0000B0CF00BEC749 AS DateTime), N'系统开关列表', N'0', N'0')
INSERT [dbo].[Sys_dict_type] ([dict_id], [dict_name], [dict_label], [dict_value], [create_by], [create_time], [update_by], [update_time], [remark], [is_del], [status]) VALUES (8, N'测试', N'sys', NULL, N'罗桓杰', CAST(0x0000B0CF00EE5009 AS DateTime), N'罗桓杰', CAST(0x0000B0E600BE68B2 AS DateTime), N'测试列表', N'0', N'0')
SET IDENTITY_INSERT [dbo].[Sys_dict_type] OFF
SET IDENTITY_INSERT [dbo].[Sys_encode] ON 

INSERT [dbo].[Sys_encode] ([en_code], [en_step], [en_form], [en_prefix], [en_time], [en_num], [en_rules], [create_by], [create_time], [is_del], [en_max]) VALUES (1, 1, N'货品信息', N'HP', N'月', 3, N'HPMM001', N'罗桓杰', CAST(0x0000B0D5013F1609 AS DateTime), N'0', 580)
INSERT [dbo].[Sys_encode] ([en_code], [en_step], [en_form], [en_prefix], [en_time], [en_num], [en_rules], [create_by], [create_time], [is_del], [en_max]) VALUES (3, 1, N'进货单', N'JH', N'年', 3, N'JHYYYY001', N'罗桓杰', CAST(0x0000B0CE009D2136 AS DateTime), N'0', 79)
INSERT [dbo].[Sys_encode] ([en_code], [en_step], [en_form], [en_prefix], [en_time], [en_num], [en_rules], [create_by], [create_time], [is_del], [en_max]) VALUES (4, 1, N'出库单', N'CK', N'年月', 3, N'CKYYYYMM001', N'罗环节', CAST(0x0000B0CD00000000 AS DateTime), N'0', 154)
INSERT [dbo].[Sys_encode] ([en_code], [en_step], [en_form], [en_prefix], [en_time], [en_num], [en_rules], [create_by], [create_time], [is_del], [en_max]) VALUES (7, 1, N'入库单', N'RK', N'年月', 3, N'RKYYYYMM001', N'刘子怡', CAST(0x0000B0D700000000 AS DateTime), N'0', 160)
INSERT [dbo].[Sys_encode] ([en_code], [en_step], [en_form], [en_prefix], [en_time], [en_num], [en_rules], [create_by], [create_time], [is_del], [en_max]) VALUES (8, 1, N'盘点单', N'PD', N'日', 3, N'PDDD001', N'刘子怡', CAST(0x0000B0D6011A3599 AS DateTime), N'0', 82)
INSERT [dbo].[Sys_encode] ([en_code], [en_step], [en_form], [en_prefix], [en_time], [en_num], [en_rules], [create_by], [create_time], [is_del], [en_max]) VALUES (9, 1, N'调拨单

', N'DB', N'日', 3, N'DBDD001', N'罗桓杰', CAST(0x0000B0D6011A888E AS DateTime), N'0', 36)
INSERT [dbo].[Sys_encode] ([en_code], [en_step], [en_form], [en_prefix], [en_time], [en_num], [en_rules], [create_by], [create_time], [is_del], [en_max]) VALUES (11, 1, N'进货退货单', N'JHTH', N'日', 3, N'JHTHDD001', N'罗桓杰', CAST(0x0000B0DC0146E842 AS DateTime), N'0', 90)
INSERT [dbo].[Sys_encode] ([en_code], [en_step], [en_form], [en_prefix], [en_time], [en_num], [en_rules], [create_by], [create_time], [is_del], [en_max]) VALUES (16, 1, N'销售单', N'XS', N'日', 3, N'XSDD001', N'罗桓杰', CAST(0x0000B0DC00000000 AS DateTime), N'0', 48)
INSERT [dbo].[Sys_encode] ([en_code], [en_step], [en_form], [en_prefix], [en_time], [en_num], [en_rules], [create_by], [create_time], [is_del], [en_max]) VALUES (17, 1, N'销售退货单', N'XSTH', N'日', 3, N'XSTHDD001', N'罗桓杰', CAST(0x0000B0DC014750C3 AS DateTime), N'0', 59)
INSERT [dbo].[Sys_encode] ([en_code], [en_step], [en_form], [en_prefix], [en_time], [en_num], [en_rules], [create_by], [create_time], [is_del], [en_max]) VALUES (18, 1, N'供应商单', N'GYS', N'日', 3, N'GYSDD001', N'罗桓杰', CAST(0x0000B0DC014750C3 AS DateTime), N'0', 79)
INSERT [dbo].[Sys_encode] ([en_code], [en_step], [en_form], [en_prefix], [en_time], [en_num], [en_rules], [create_by], [create_time], [is_del], [en_max]) VALUES (19, 1, N'客户单', N'KH', N'日', 3, N'KHDD001', N'罗桓杰', CAST(0x0000B0DC014750C3 AS DateTime), N'0', 67)
INSERT [dbo].[Sys_encode] ([en_code], [en_step], [en_form], [en_prefix], [en_time], [en_num], [en_rules], [create_by], [create_time], [is_del], [en_max]) VALUES (22, 1, N'仓库单', N'CKD', N'日', 3, N'CKDD001', N'罗桓杰', CAST(0x0000B0DC014750C3 AS DateTime), N'0', 99)
INSERT [dbo].[Sys_encode] ([en_code], [en_step], [en_form], [en_prefix], [en_time], [en_num], [en_rules], [create_by], [create_time], [is_del], [en_max]) VALUES (23, 1, N'仓位单', N'CW', N'日', 3, N'CWDD001', N'罗桓杰', CAST(0x0000B0DC014750C3 AS DateTime), N'0', 90)
SET IDENTITY_INSERT [dbo].[Sys_encode] OFF
SET IDENTITY_INSERT [dbo].[UserRoles] ON 

INSERT [dbo].[UserRoles] ([UserRolesID], [UserID], [RolesID]) VALUES (1, 1, 1)
INSERT [dbo].[UserRoles] ([UserRolesID], [UserID], [RolesID]) VALUES (2, 2, 10)
INSERT [dbo].[UserRoles] ([UserRolesID], [UserID], [RolesID]) VALUES (3, 8, 10)
INSERT [dbo].[UserRoles] ([UserRolesID], [UserID], [RolesID]) VALUES (4, 4, 9)
INSERT [dbo].[UserRoles] ([UserRolesID], [UserID], [RolesID]) VALUES (5, 5, 3)
INSERT [dbo].[UserRoles] ([UserRolesID], [UserID], [RolesID]) VALUES (7, 9, 8)
INSERT [dbo].[UserRoles] ([UserRolesID], [UserID], [RolesID]) VALUES (8, 10, 8)
SET IDENTITY_INSERT [dbo].[UserRoles] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([U_id], [U_name], [U_True_name], [U_password], [U_State], [is_del]) VALUES (1, N'admin', N'罗桓杰', N'E10ADC3949BA59ABBE56E057F20F883E', N'0', N'0')
INSERT [dbo].[Users] ([U_id], [U_name], [U_True_name], [U_password], [U_State], [is_del]) VALUES (2, N'hyn', N'黄妍妮', N'e10adc3949ba59abbe56e057f20f883e', N'0', N'0')
INSERT [dbo].[Users] ([U_id], [U_name], [U_True_name], [U_password], [U_State], [is_del]) VALUES (4, N'lzy', N'刘子怡', N'e10adc3949ba59abbe56e057f20f883e', N'0', N'0')
INSERT [dbo].[Users] ([U_id], [U_name], [U_True_name], [U_password], [U_State], [is_del]) VALUES (5, N'yl', N'易蕾', N'e10adc3949ba59abbe56e057f20f883e', N'0', N'0')
INSERT [dbo].[Users] ([U_id], [U_name], [U_True_name], [U_password], [U_State], [is_del]) VALUES (8, N'ykx', N'余开学', N'e10adc3949ba59abbe56e057f20f883e', N'0', N'0')
INSERT [dbo].[Users] ([U_id], [U_name], [U_True_name], [U_password], [U_State], [is_del]) VALUES (10, N'kjh', N'霍建华', N'e10adc3949ba59abbe56e057f20f883e', N'0', N'0')
SET IDENTITY_INSERT [dbo].[Users] OFF
SET IDENTITY_INSERT [dbo].[Wh_buy_order_h] ON 

INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (5, N'1               ', CAST(0x0000AF9D00000000 AS DateTime), N'供应商一 ', N'小罗', N'13203023638', N'小k', N'罗桓杰', CAST(0x0000AF9D00000000 AS DateTime), CAST(0x0000B0AF00000000 AS DateTime), NULL, NULL, N'罗桓杰', CAST(0x0000B0C901083AD1 AS DateTime), N'很好吃哦123123', N'0', N'0', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (10, N'2               ', CAST(0x0000AF7D00000000 AS DateTime), N'供应商二 ', N'小余', N'13203054748', N'小看', N'罗桓杰', CAST(0x0000AF7E00000000 AS DateTime), CAST(0x0000B0AE00000000 AS DateTime), NULL, NULL, N'罗桓杰', CAST(0x0000B0CA009A3592 AS DateTime), N'超级好吃', N'0', N'3', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (11, N'3               ', CAST(0x0000B0CB01198B00 AS DateTime), N'供应商三 ', N'李依依', N'16689849373', N'刘子怡', N'罗桓杰', CAST(0x0000AF9E00000000 AS DateTime), CAST(0x0000B0AF00000000 AS DateTime), NULL, NULL, N'罗桓杰', CAST(0x0000B0C9012476A8 AS DateTime), N'究极好吃1123123123123123', N'0', N'1', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (13, N'4               ', CAST(0x0000AF9E00000000 AS DateTime), N'供应商二 ', N'小k', N'13203847565', N'小看', N'小王', CAST(0x0000AFBA00000000 AS DateTime), CAST(0x0000B07800000000 AS DateTime), NULL, NULL, N'罗桓杰', CAST(0x0000B0CA0099EEDE AS DateTime), N'FoFoFoFo', N'0', N'3', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (52, N'666             ', CAST(0x0000B0CA00BB0AD0 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'黄妍妮', N'小王', CAST(0x0000B0CA00BB23FD AS DateTime), NULL, NULL, NULL, NULL, NULL, N'qwe', N'0', N'0', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (53, N'777             ', CAST(0x0000B0CA00BCE56C AS DateTime), N'供应商三 ', N'李依依', N'16689849373', N'黄妍妮', N'小王', CAST(0x0000B0CA00BCFA0F AS DateTime), NULL, NULL, NULL, N'罗桓杰', CAST(0x0000B0CA00BD2868 AS DateTime), N'132', N'0', N'1', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (54, N'888             ', CAST(0x0000B0CA00C05904 AS DateTime), N'供应商一 ', N'李依依', N'18918918998', N'刘子怡', N'罗桓杰', CAST(0x0000B0CA00C06EB2 AS DateTime), NULL, NULL, NULL, N'罗桓杰', CAST(0x0000B0CA01247679 AS DateTime), N'阿萨德啊实打实的阿斯达说的阿萨德', N'0', N'3', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (55, N'999             ', CAST(0x0000B0CA00C1F200 AS DateTime), N'供应商一 ', N'李依依', N'18918918998', N'刘子怡', N'罗桓杰', CAST(0x0000B0CA00C205EE AS DateTime), NULL, NULL, NULL, NULL, NULL, N'2', N'0', N'0', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (60, N'567             ', CAST(0x0000B0CB00B491C8 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'黄妍妮', N'罗桓杰', CAST(0x0000B0CB00B4A656 AS DateTime), NULL, NULL, NULL, N'罗桓杰', CAST(0x0000B0CB00B4B2F2 AS DateTime), N'123', N'0', N'3', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (61, N'7899            ', CAST(0x0000B0CB00B578A4 AS DateTime), N'供应商三 ', N'李依依', N'16689849373', N'黄妍妮', N'罗桓杰', CAST(0x0000B0CB00B58F85 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'qwe123', N'0', N'0', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (62, N'123456          ', CAST(0x0000B0CB011D1158 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'刘子怡', N'罗桓杰', CAST(0x0000B0CB011D29EF AS DateTime), NULL, NULL, NULL, N'罗桓杰', CAST(0x0000B0CE00EAF55E AS DateTime), N'测测测测地上手术圣诞树打实打实', N'0', N'2', N'通过')
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (63, N'987             ', CAST(0x0000B0CD0146F8B0 AS DateTime), N'供应商三 ', N'李依依', N'16689849373', N'易蕾', N'罗桓杰', CAST(0x0000B0CD0147083D AS DateTime), NULL, NULL, NULL, NULL, NULL, N'7899999', N'0', N'0', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (64, N'3042            ', CAST(0x0000B0CE00F96168 AS DateTime), N'供应商一 ', N'李依依', N'18918918998', N'罗桓杰', N'罗桓杰', CAST(0x0000B0CE00F9822E AS DateTime), NULL, NULL, NULL, NULL, NULL, N'气味儿', N'0', N'0', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (65, N'5656            ', CAST(0x0000B0CE0112C5CC AS DateTime), N'供应商一 ', N'李依依', N'18918918998', N'黄妍妮', N'罗桓杰', CAST(0x0000B0CE0112FDAA AS DateTime), NULL, NULL, NULL, NULL, NULL, N'123', N'0', N'0', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (66, N'6665654         ', CAST(0x0000B0D500BED64C AS DateTime), N'供应商三 ', N'李依依', N'16689849373', N'黄妍妮', N'罗桓杰', CAST(0x0000B0D500BEEC1B AS DateTime), NULL, NULL, NULL, N'罗桓杰', CAST(0x0000B0D600A3BB6D AS DateTime), N'1123', N'0', N'2', N'21332131313213')
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (67, N'JH123456        ', CAST(0x0000B0D800938E38 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'罗桓杰', N'罗桓杰', CAST(0x0000B0D800939421 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'123123', N'0', N'0', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (68, N'jh123           ', CAST(0x0000B0DC00ED123C AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'刘子怡', N'罗桓杰', CAST(0x0000B0DC00ED3E10 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'1231123', N'0', N'0', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (69, N'2131231231      ', CAST(0x0000B0DC01274B50 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'罗桓杰', N'罗桓杰', CAST(0x0000B0DC0127DB01 AS DateTime), NULL, NULL, NULL, N'罗桓杰', CAST(0x0000B0DD0105BD7D AS DateTime), N'', N'0', N'2', N'123')
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (70, N'JH2023010       ', CAST(0x0000B0DD00FA2648 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'刘子怡', N'罗桓杰', CAST(0x0000B0DD00FA7B53 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'其味无穷二', N'0', N'0', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (71, N'JH2023034       ', CAST(0x0000B0E6009B9934 AS DateTime), N'供应商五 ', N'丽姨姨', N'19918026397', N'余开学', N'罗桓杰', CAST(0x0000B0E6009BCB44 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'阿萨德', N'0', N'0', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (72, N'JH2023035       ', CAST(0x0000B0E6009BDC00 AS DateTime), N'供应商六 ', N'李欢欢', N'19918026397', N'黄妍妮', N'罗桓杰', CAST(0x0000B0E6009BFB72 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'123', N'0', N'0', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (73, N'JH2023036       ', CAST(0x0000B0E6009C0888 AS DateTime), N'供应商五 ', N'丽姨姨', N'19918026397', N'黄妍妮', N'罗桓杰', CAST(0x0000B0E6009C3234 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'123', N'0', N'0', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (74, N'JH2023037       ', CAST(0x0000B0E6009C3D44 AS DateTime), N'供应商三 ', N'李依依', N'16689849373', N'易蕾', N'罗桓杰', CAST(0x0000B0E6009C5AF9 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'123', N'0', N'0', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (75, N'JH2023038       ', CAST(0x0000B0E6009C7A34 AS DateTime), N'供应商三 ', N'李依依', N'16689849373', N'黄妍妮', N'罗桓杰', CAST(0x0000B0E6009CC4FE AS DateTime), NULL, NULL, NULL, N'罗桓杰', CAST(0x0000B0E6009D7833 AS DateTime), N'123', N'0', N'2', N'11111')
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (76, N'JH2023039       ', CAST(0x0000B0E6009CD920 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'罗桓杰', N'罗桓杰', CAST(0x0000B0E6009CEDB9 AS DateTime), NULL, NULL, NULL, N'罗桓杰', CAST(0x0000B0E6009D716C AS DateTime), N'123', N'0', N'3', N'11111')
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (77, N'JH2023049       ', CAST(0x0000B0E600B1EA18 AS DateTime), N'供应商一 ', N'李依依', N'18918918998', N'易蕾', N'罗桓杰', CAST(0x0000B0E600B1FC57 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'123', N'0', N'0', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (78, N'JH2023050       ', CAST(0x0000B0E600F5175C AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'刘子怡', N'罗桓杰', CAST(0x0000B0E600F53603 AS DateTime), NULL, NULL, NULL, N'罗桓杰', CAST(0x0000B0E600F5B842 AS DateTime), N'123', N'0', N'3', N'123')
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (79, N'JH2023064       ', CAST(0x0000B0E60114DC2C AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'易蕾', N'罗桓杰', CAST(0x0000B0E60114E74F AS DateTime), NULL, NULL, NULL, NULL, NULL, N'123', N'0', N'0', NULL)
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (80, N'JH2023067       ', CAST(0x0000B0E700B7A098 AS DateTime), N'供应商三 ', N'李依依', N'16689849373', N'刘子怡', N'罗桓杰', CAST(0x0000B0E700B7B351 AS DateTime), NULL, NULL, NULL, N'罗桓杰', CAST(0x0000B0E700B7DBCF AS DateTime), N'123', N'0', N'2', N'通过')
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (81, N'JH2024074       ', CAST(0x0000B0EB014D2C94 AS DateTime), N'小米     ', N'小白', N'13232323223', N'余开学', N'罗桓杰', CAST(0x0000B0EB014D7BF3 AS DateTime), NULL, NULL, NULL, N'罗桓杰', CAST(0x0000B0EB014DA09C AS DateTime), N'123123', N'0', N'3', N'通过')
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (82, N'JH2024075       ', CAST(0x0000B0EC00BA4F50 AS DateTime), N'小米     ', N'小白', N'13232323223', N'刘子怡', N'罗桓杰', CAST(0x0000B0EC00BA6074 AS DateTime), NULL, NULL, NULL, N'罗桓杰', CAST(0x0000B0EC00BA863C AS DateTime), N'123', N'0', N'2', N'通过')
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (83, N'JH2024076       ', CAST(0x0000B0EC00EE7C58 AS DateTime), N'iqoo     ', N'李依依', N'13203023738', N'刘子怡', N'罗桓杰', CAST(0x0000B0EC00EE8C5C AS DateTime), NULL, NULL, NULL, N'罗桓杰', CAST(0x0000B0EC00EEA4EE AS DateTime), N'223', N'0', N'4', N'通过')
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (84, N'JH2024077       ', CAST(0x0000B0ED00C9D3F8 AS DateTime), N'iqoo     ', N'李依依', N'13203023738', N'易蕾', N'罗桓杰', CAST(0x0000B0ED00CA097C AS DateTime), NULL, NULL, NULL, N'罗桓杰', CAST(0x0000B0ED00CF8FCD AS DateTime), N'13', N'0', N'2', N'通过')
INSERT [dbo].[Wh_buy_order_h] ([buy_codeId], [buy_code], [buy_date], [supply_code], [link_man], [link_way], [buy_man], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [is_del], [sale_state], [sale_state_yj]) VALUES (85, N'JH2024079       ', CAST(0x0000B0ED00EE8A68 AS DateTime), N'苹果     ', N'李依依', N'13232323222', N'刘子怡', N'罗桓杰', CAST(0x0000B0ED00EEA6B1 AS DateTime), NULL, NULL, NULL, N'罗桓杰', CAST(0x0000B0ED00EEC39A AS DateTime), N'2', N'0', N'3', N'通过')
SET IDENTITY_INSERT [dbo].[Wh_buy_order_h] OFF
SET IDENTITY_INSERT [dbo].[Wh_inbill_d] ON 

INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (5, N'2               ', N'11              ', N'进货入库', N'箱', CAST(100.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0CA009E2F50 AS DateTime), NULL, N'创建人', CAST(0x0000B0CA009E2F50 AS DateTime), NULL, NULL, N'dfdsfdsf', CAST(4000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (6, N'4               ', N'11              ', N'进货入库', N'瓶', CAST(50.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0CA009E2F50 AS DateTime), NULL, N'创建人', CAST(0x0000B0CA009E2F50 AS DateTime), NULL, NULL, N'wdwdwqdwq', CAST(6000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (7, N'2               ', N'12              ', N'进货入库', N'箱', CAST(100.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位四', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0CA00B9742C AS DateTime), NULL, N'创建人', CAST(0x0000B0CA00B9742C AS DateTime), CAST(0x0000B0D000000000 AS DateTime), N'罗桓杰', N'额威风威风', CAST(4000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (8, N'4               ', N'12              ', N'进货入库', N'瓶', CAST(50.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位四', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0CA00B9742C AS DateTime), NULL, N'创建人', CAST(0x0000B0CA00B9742C AS DateTime), CAST(0x0000B0D000000000 AS DateTime), N'罗桓杰', N'额我热温热', CAST(6000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (9, N'2               ', N'13              ', N'进货入库', N'箱', CAST(100.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0CA0117C324 AS DateTime), NULL, N'创建人', CAST(0x0000B0CA0117C324 AS DateTime), CAST(0x0000B0D000000000 AS DateTime), N'罗桓杰', N'11', CAST(1000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (10, N'4               ', N'13              ', N'进货入库', N'瓶', CAST(50.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0CA0117C324 AS DateTime), NULL, N'创建人', CAST(0x0000B0CA0117C324 AS DateTime), CAST(0x0000B0D000000000 AS DateTime), N'罗桓杰', N'22', CAST(300.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (17, N'1               ', N'48              ', N'生产入库', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位四', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0CB00B1B688 AS DateTime), NULL, N'创建人', CAST(0x0000B0CB00B1B688 AS DateTime), NULL, NULL, N'1', CAST(100.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (18, N'2               ', N'48              ', N'生产入库', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位四', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0CB00B1B688 AS DateTime), NULL, N'创建人', CAST(0x0000B0CB00B1B688 AS DateTime), NULL, NULL, N'1', CAST(200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (19, N'3               ', N'48              ', N'生产入库', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位四', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0CB00B1B688 AS DateTime), NULL, N'创建人', CAST(0x0000B0CB00B1B688 AS DateTime), NULL, NULL, N'1', CAST(6000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (20, N'4               ', N'48              ', N'生产入库', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), N'库位四', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0CB00B1B688 AS DateTime), NULL, N'创建人', CAST(0x0000B0CB00B1B688 AS DateTime), NULL, NULL, N'1', CAST(3000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (21, N'2               ', N'49              ', N'生产入库', N'瓶', CAST(7.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0CB011B21A4 AS DateTime), NULL, N'创建人', CAST(0x0000B0CB011B21A4 AS DateTime), NULL, NULL, N'1', CAST(400.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (22, N'3               ', N'49              ', N'生产入库', N'箱', CAST(7.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0CB011B21A4 AS DateTime), NULL, N'创建人', CAST(0x0000B0CB011B21A4 AS DateTime), NULL, NULL, N'1', CAST(600.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (23, N'4               ', N'49              ', N'生产入库', N'瓶', CAST(7.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0CB011B21A4 AS DateTime), NULL, N'创建人', CAST(0x0000B0CB011B21A4 AS DateTime), NULL, NULL, N'1', CAST(600.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (24, N'1               ', N'49              ', N'生产入库', N'箱', CAST(7.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'库位一', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0CB011B21A4 AS DateTime), NULL, N'创建人', CAST(0x0000B0CB011B21A4 AS DateTime), NULL, NULL, N'1', CAST(200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (25, N'1               ', N'41              ', N'换货入库', N'箱', CAST(10.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'库位一', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0CE009C02AC AS DateTime), NULL, N'创建人', CAST(0x0000B0CE009C02AC AS DateTime), NULL, NULL, N'1111', CAST(200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (37, N'5               ', N'61              ', N'进货入库', N'箱', CAST(100.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), N'库位四', CAST(400.00 AS Decimal(18, 2)), CAST(0x0000B0CF011EFD88 AS DateTime), NULL, N'刘子怡', CAST(0x0000B0CF011EFD88 AS DateTime), NULL, NULL, N'测试测试', CAST(4000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (38, N'5               ', N'62              ', N'进货入库', N'箱', CAST(100.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), N'库位三', CAST(400.00 AS Decimal(18, 2)), CAST(0x0000B0CF0120D374 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0CF0120D374 AS DateTime), NULL, NULL, N'顶顶顶顶', CAST(4000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (39, N'2               ', N'63              ', N'进货入库', N'箱', CAST(100.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位二', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0CF01434378 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0CF01434378 AS DateTime), CAST(0x0000B0D000000000 AS DateTime), N'罗桓杰', N'全部入库', CAST(4000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (40, N'4               ', N'63              ', N'进货入库', N'瓶', CAST(50.00 AS Decimal(18, 2)), CAST(7.00 AS Decimal(18, 2)), N'库位二', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0CF01434378 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0CF01434378 AS DateTime), CAST(0x0000B0D000000000 AS DateTime), N'罗桓杰', N'全部入库', CAST(2100.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (47, N'1               ', N'22              ', N'退货入库  ', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位三', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0D000B1C240 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D000B1C240 AS DateTime), CAST(0x0000B0D000000000 AS DateTime), N'罗桓杰', N'20', CAST(2000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (48, N'2               ', N'22              ', N'退货入库  ', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位三', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0D000B1C240 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D000B1C240 AS DateTime), CAST(0x0000B0D000000000 AS DateTime), N'罗桓杰', N'20', CAST(4000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (49, N'4               ', N'22              ', N'退货入库  ', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位三', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0D000B1C240 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D000B1C240 AS DateTime), CAST(0x0000B0D000000000 AS DateTime), N'罗桓杰', N'20', CAST(6000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (54, N'5               ', N'66              ', N'退货入库  ', N'箱', CAST(100.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'库位四', CAST(400.00 AS Decimal(18, 2)), CAST(0x0000B0D000C3F0F0 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D000C3F0F0 AS DateTime), CAST(0x0000B0D000000000 AS DateTime), N'罗桓杰', N'哈哈哈哈哈', CAST(20000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (55, N'1               ', N'64              ', N'换货入库', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位二', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0D001287750 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D001287750 AS DateTime), NULL, NULL, N'11', CAST(2000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (56, N'3               ', N'64              ', N'换货入库', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位二', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0D001287750 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D001287750 AS DateTime), NULL, NULL, N'111', CAST(6000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (57, N'4               ', N'64              ', N'换货入库', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位二', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0D001287750 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D001287750 AS DateTime), NULL, NULL, N'1111', CAST(6000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (58, N'1               ', N'RK12003         ', N'生产入库', N'箱', CAST(10.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), N'库位一', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0D500FDE4E0 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D500FDE4E0 AS DateTime), NULL, NULL, N'111', CAST(300.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (59, N'1               ', N'43              ', N'进货入库  ', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'库位二', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0D801216140 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D801216140 AS DateTime), CAST(0x0000B0D800000000 AS DateTime), N'罗桓杰', N'哈哈哈哈哈哈哈哈哈', CAST(5000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (60, N'3               ', N'43              ', N'进货入库  ', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'库位二', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0D801216140 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D801216140 AS DateTime), CAST(0x0000B0D800000000 AS DateTime), N'罗桓杰', N'呵呵呵呵', CAST(15000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (61, N'1               ', N'RK12009         ', N'进货入库', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(60.00 AS Decimal(18, 2)), N'库位四', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0D80122D714 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D80122D714 AS DateTime), NULL, NULL, N'333', CAST(6000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (62, N'2               ', N'RK12009         ', N'进货入库', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(60.00 AS Decimal(18, 2)), N'库位四', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0D80122D714 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D80122D714 AS DateTime), NULL, NULL, N'444', CAST(12000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (63, N'1               ', N'RK12010         ', N'进货入库', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(77.00 AS Decimal(18, 2)), N'库位一', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0D801236ABC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D801236ABC AS DateTime), NULL, NULL, N'6', CAST(7700.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (64, N'2               ', N'RK12010         ', N'进货入库', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(33.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0D801236ABC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D801236ABC AS DateTime), NULL, NULL, N'7', CAST(6600.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (65, N'3               ', N'RK12010         ', N'进货入库', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0D801236ABC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D801236ABC AS DateTime), NULL, NULL, N'8', CAST(6000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (67, N'4               ', N'PD13037         ', N'智能电视', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(26.00 AS Decimal(18, 2)), N'库位四', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0D8016032E4 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D8016032E4 AS DateTime), NULL, NULL, NULL, CAST(7800.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (68, N'1               ', N'RK12013         ', N'进货入库', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'库位二', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0D900EBF6A4 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D900EBF6A4 AS DateTime), NULL, NULL, N'1', CAST(200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (69, N'2               ', N'RK12013         ', N'进货入库', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(8.00 AS Decimal(18, 2)), N'库位二', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0D900EBF6A4 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D900EBF6A4 AS DateTime), NULL, NULL, N'2', CAST(1600.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (70, N'4               ', N'RK12013         ', N'进货入库', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), N'库位二', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0D900EBF6A4 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D900EBF6A4 AS DateTime), NULL, NULL, N'3', CAST(1200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (71, N'2               ', N'RK12014         ', N'进货入库', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位二', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0D900EC6D00 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D900EC6D00 AS DateTime), NULL, NULL, N'333', CAST(4000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (72, N'1               ', N'RK12015         ', N'生产入库', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(44.00 AS Decimal(18, 2)), N'库位三', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0D900ED45CC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D900ED45CC AS DateTime), NULL, NULL, N'444', CAST(4400.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (73, N'1               ', N'RK12016         ', N'生产入库', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(70.00 AS Decimal(18, 2)), N'库位一', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0D900ED6FFC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D900ED6FFC AS DateTime), NULL, NULL, N'44', CAST(7000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (78, N'1               ', N'DB16002         ', N'电子产品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位三', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0DC00C1875C AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DC00C1875C AS DateTime), NULL, NULL, NULL, CAST(2000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (79, N'2               ', N'DB16002         ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), N'库位三', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0DC00C1875C AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DC00C1875C AS DateTime), NULL, NULL, NULL, CAST(2000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (80, N'3               ', N'PD18052         ', N'手机', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'库位四', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DC00F38B44 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DC00F38B44 AS DateTime), NULL, NULL, NULL, CAST(15000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (81, N'4               ', N'PD18052         ', N'智能电视', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'库位四', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DC00F38B44 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DC00F38B44 AS DateTime), NULL, NULL, NULL, CAST(15000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (82, N'2               ', N'PD19053         ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'库位四', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0DD00FD8F54 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DD00FD8F54 AS DateTime), NULL, NULL, NULL, CAST(20000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (83, N'1               ', N'RK12098         ', N'退货入库', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'库位二', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0DF00C29610 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00C29610 AS DateTime), NULL, NULL, N'123', CAST(10000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (84, N'3               ', N'XSTH21026       ', N'手机', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF00C3900D AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00C3900D AS DateTime), NULL, NULL, NULL, CAST(300.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (85, N'2               ', N'XSTH21026       ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0DF00C39020 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00C39020 AS DateTime), NULL, NULL, NULL, CAST(200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (86, N'4               ', N'XSTH21026       ', N'智能电视', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位三', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF00C39030 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00C39030 AS DateTime), NULL, NULL, NULL, CAST(300.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (87, N'1               ', N'XSTH21029       ', N'电子产品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位三', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0DF00EC3886 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00EC3886 AS DateTime), NULL, NULL, NULL, CAST(100.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (88, N'3               ', N'XSTH21029       ', N'手机', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF00EC38A1 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00EC38A1 AS DateTime), NULL, NULL, NULL, CAST(300.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (89, N'2               ', N'XSTH21029       ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0DF00EC38C2 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00EC38C2 AS DateTime), NULL, NULL, NULL, CAST(200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (90, N'1               ', N'XSTH21032       ', N'电子产品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), N'库位一', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0DF00EEB0AD AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00EEB0AD AS DateTime), NULL, NULL, NULL, CAST(800.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (91, N'3               ', N'XSTH21032       ', N'手机', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF00EEB0E6 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00EEB0E6 AS DateTime), NULL, NULL, NULL, CAST(800.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (92, N'2               ', N'XSTH21032       ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0DF00EEB104 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00EEB104 AS DateTime), NULL, NULL, NULL, CAST(800.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (93, N'3               ', N'XSTH21033       ', N'手机', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF00F00967 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00F00967 AS DateTime), NULL, NULL, NULL, CAST(1200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (94, N'2               ', N'XSTH21033       ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0DF00F00988 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00F00988 AS DateTime), NULL, NULL, NULL, CAST(1200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (95, N'4               ', N'XSTH21033       ', N'智能电视', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF00F009F0 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00F009F0 AS DateTime), NULL, NULL, NULL, CAST(1200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (96, N'3               ', N'XSTH19005       ', N'手机', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位三', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF00F16AB9 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00F16AB9 AS DateTime), NULL, NULL, NULL, CAST(300.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (97, N'2               ', N'XSTH19005       ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0DF00F16B1F AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00F16B1F AS DateTime), NULL, NULL, NULL, CAST(200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (98, N'4               ', N'XSTH19005       ', N'智能电视', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF00F16B46 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00F16B46 AS DateTime), NULL, NULL, NULL, CAST(300.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (99, N'2               ', N'TH987654        ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), N'库位三', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0DF00F7962E AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00F7962E AS DateTime), NULL, NULL, NULL, CAST(600.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (100, N'2               ', N'TH123456        ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0DF00F7E9F4 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00F7E9F4 AS DateTime), NULL, NULL, NULL, CAST(200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (101, N'3               ', N'TH123456        ', N'手机', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位三', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF00F7EA15 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00F7EA15 AS DateTime), NULL, NULL, NULL, CAST(300.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (102, N'4               ', N'TH123456        ', N'智能电视', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF00F7EA43 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00F7EA43 AS DateTime), NULL, NULL, NULL, CAST(300.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (103, N'3               ', N'XSTH19005       ', N'手机', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位三', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF00FBF274 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00FBF274 AS DateTime), NULL, NULL, NULL, CAST(300.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (104, N'2               ', N'XSTH19005       ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0DF00FBF2AA AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00FBF2AA AS DateTime), NULL, NULL, NULL, CAST(200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (105, N'4               ', N'XSTH19005       ', N'智能电视', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF00FBF2DA AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF00FBF2DA AS DateTime), NULL, NULL, NULL, CAST(300.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (106, N'3               ', N'XSTH21018       ', N'手机', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(19.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF01168CB0 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF01168CB0 AS DateTime), NULL, NULL, NULL, CAST(5700.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (107, N'2               ', N'XSTH21018       ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(19.00 AS Decimal(18, 2)), N'库位三', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0DF01168CCD AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF01168CCD AS DateTime), NULL, NULL, NULL, CAST(3800.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (108, N'4               ', N'XSTH21018       ', N'智能电视', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(19.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF01168CEC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF01168CEC AS DateTime), NULL, NULL, NULL, CAST(5700.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (109, N'2               ', N'TH123456        ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0DF011ABBA6 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF011ABBA6 AS DateTime), NULL, NULL, NULL, CAST(200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (110, N'3               ', N'TH123456        ', N'手机', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'库位三', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF011ABC08 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF011ABC08 AS DateTime), NULL, NULL, NULL, CAST(600.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (111, N'4               ', N'TH123456        ', N'智能电视', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF011ABC73 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF011ABC73 AS DateTime), NULL, NULL, NULL, CAST(300.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (112, N'1               ', N'XSTH21036       ', N'电子产品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0DF01228283 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF01228283 AS DateTime), NULL, NULL, NULL, CAST(100.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (113, N'3               ', N'XSTH21036       ', N'手机', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位三', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF012282AD AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF012282AD AS DateTime), NULL, NULL, NULL, CAST(300.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (114, N'2               ', N'XSTH21036       ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0DF012282F0 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF012282F0 AS DateTime), NULL, NULL, NULL, CAST(200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (115, N'1               ', N'XSTH21037       ', N'电子产品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位三', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0DF0123E00C AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF0123E00C AS DateTime), NULL, NULL, NULL, CAST(100.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (116, N'3               ', N'XSTH21037       ', N'手机', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF0123E070 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF0123E070 AS DateTime), NULL, NULL, NULL, CAST(300.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (117, N'2               ', N'XSTH21037       ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0DF0123E0A3 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF0123E0A3 AS DateTime), NULL, NULL, NULL, CAST(200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (118, N'1               ', N'XSTH21041       ', N'电子产品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)), N'库位三', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0DF0144DD0F AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF0144DD0F AS DateTime), NULL, NULL, NULL, CAST(500.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (119, N'3               ', N'XSTH21041       ', N'手机', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(7.00 AS Decimal(18, 2)), N'库位三', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF0144DD3F AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF0144DD3F AS DateTime), NULL, NULL, NULL, CAST(2100.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (120, N'2               ', N'XSTH21041       ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(6.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0DF0144DD6F AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF0144DD6F AS DateTime), NULL, NULL, NULL, CAST(1200.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (121, N'1               ', N'XSTH21042       ', N'电子产品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位三', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0DF014966B4 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF014966B4 AS DateTime), NULL, NULL, NULL, CAST(100.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (122, N'3               ', N'XSTH21042       ', N'手机', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0DF014966F1 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF014966F1 AS DateTime), NULL, NULL, NULL, CAST(900.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (123, N'2               ', N'XSTH21042       ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0DF01496716 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DF01496716 AS DateTime), NULL, NULL, NULL, CAST(400.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (124, N'HP120390        ', N'RK120112        ', N'生产入库', N'瓶', CAST(60.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'库位二', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0E6009E5AAC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E6009E5AAC AS DateTime), NULL, NULL, N'1', CAST(5000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (125, N'HP120388        ', N'RK120112        ', N'生产入库', N'瓶', CAST(60.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'库位二', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0E6009E5AAC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E6009E5AAC AS DateTime), NULL, NULL, N'2', CAST(5000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (126, N'HP120389        ', N'RK120112        ', N'生产入库', N'瓶', CAST(60.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'库位二', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0E6009E5AAC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E6009E5AAC AS DateTime), NULL, NULL, N'3', CAST(15000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (127, N'HP120250        ', N'RK120113        ', N'进货入库', N'箱', CAST(50.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位一', CAST(123.00 AS Decimal(18, 2)), CAST(0x0000B0E6009EF8E0 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E6009EF8E0 AS DateTime), NULL, NULL, N'3', CAST(2460.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (128, N'HP120387        ', N'RK120113        ', N'进货入库', N'瓶', CAST(50.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0E6009EF8E0 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E6009EF8E0 AS DateTime), NULL, NULL, N'3', CAST(6000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (129, N'HP120253        ', N'RK120113        ', N'进货入库', N'箱', CAST(50.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0E6009EF8E0 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E6009EF8E0 AS DateTime), NULL, NULL, N'3', CAST(4000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (130, N'HP120219        ', N'RK120113        ', N'进货入库', N'瓶', CAST(50.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0E6009EF8E0 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E6009EF8E0 AS DateTime), NULL, NULL, N'3', CAST(4000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (131, N'HP120390        ', N'RK120115        ', N'进货入库', N'瓶', CAST(60.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), N'库位一', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0E600A0260C AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E600A0260C AS DateTime), NULL, NULL, N'1', CAST(300.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (132, N'HP120388        ', N'RK120115        ', N'进货入库', N'瓶', CAST(60.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)), N'库位一', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0E600A0260C AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E600A0260C AS DateTime), NULL, NULL, N'1', CAST(500.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (133, N'HP120389        ', N'RK120115        ', N'进货入库', N'瓶', CAST(60.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), CAST(0x0000B0E600A0260C AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E600A0260C AS DateTime), NULL, NULL, N'1', CAST(600.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (134, N'HP120390        ', N'RK120121        ', N'进货入库', N'瓶', CAST(100.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'库位二', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0E600F65BF8 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E600F65BF8 AS DateTime), NULL, NULL, N'1', CAST(5000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (135, N'HP120396        ', N'RK120121        ', N'进货入库', N'件', CAST(200.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'库位二', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0E600F65BF8 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E600F65BF8 AS DateTime), NULL, NULL, N'2', CAST(10000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (136, N'1               ', N'PD28066         ', N'电子产品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(30.00 AS Decimal(18, 2)), N'库位三', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0E600FAA3AC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E600FAA3AC AS DateTime), NULL, NULL, NULL, CAST(3000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (137, N'1               ', N'DB28022         ', N'电子产品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位四', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0E600FBCAFC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E600FBCAFC AS DateTime), NULL, NULL, NULL, CAST(2000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (138, N'2               ', N'DB28022         ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位四', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0E600FBCAFC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E600FBCAFC AS DateTime), NULL, NULL, NULL, CAST(4000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (139, N'HP120390        ', N'RK120131        ', N'进货入库', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), N'库位一', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0E60120D11C AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E60120D11C AS DateTime), NULL, NULL, N'', CAST(50000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (140, N'HP120396        ', N'RK120131        ', N'进货入库', N'件', CAST(0.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), N'库位一', CAST(100.00 AS Decimal(18, 2)), CAST(0x0000B0E60120D11C AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E60120D11C AS DateTime), NULL, NULL, N'', CAST(40000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (141, N'HP10550         ', N'RK10137         ', N'进货入库', N'瓶', CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'B1    ', CAST(123.00 AS Decimal(18, 2)), CAST(0x0000B0EB014DD680 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0EB014DD680 AS DateTime), NULL, NULL, N'234', CAST(12300.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (142, N'HP10567         ', N'RK10137         ', N'进货入库', N'件', CAST(200.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'B1    ', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0EB014DD680 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0EB014DD680 AS DateTime), NULL, NULL, N'234', CAST(20000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (143, N'HP10567         ', N'XSTH2058        ', N'女装', N'件', CAST(0.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), N'B1    ', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0EB01530A1A AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0EB01530A1A AS DateTime), NULL, NULL, NULL, CAST(2000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (144, N'HP10550         ', N'XSTH2058        ', N'百世可乐1', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), N'B1    ', CAST(123.00 AS Decimal(18, 2)), CAST(0x0000B0EB01530A43 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0EB01530A43 AS DateTime), NULL, NULL, NULL, CAST(1230.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (145, N'HP10570         ', N'RK10142         ', N'进货入库', N'件', CAST(150.00 AS Decimal(18, 2)), CAST(150.00 AS Decimal(18, 2)), N'D1    ', CAST(200.00 AS Decimal(18, 2)), CAST(0x0000B0EC00EEF3E0 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0EC00EEF3E0 AS DateTime), NULL, NULL, N'', CAST(30000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (146, N'HP10580         ', N'RK10158         ', N'进货入库', N'台', CAST(150.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'E1    ', CAST(2000.00 AS Decimal(18, 2)), CAST(0x0000B0ED00EF29C8 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0ED00EF29C8 AS DateTime), NULL, NULL, N'1', CAST(200000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (147, N'HP10580         ', N'RK10159         ', N'进货入库', N'台', CAST(150.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'B2    ', CAST(2000.00 AS Decimal(18, 2)), CAST(0x0000B0ED00EFAAB0 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0ED00EFAAB0 AS DateTime), NULL, NULL, N'1', CAST(40000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (148, N'HP10580         ', N'XSTH4059        ', N'智能', N'台', CAST(0.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)), N'A2    ', CAST(2000.00 AS Decimal(18, 2)), CAST(0x0000B0ED00F269F9 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0ED00F269F9 AS DateTime), NULL, NULL, NULL, CAST(10000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (149, N'HP10580         ', N'PD4082          ', N'智能', N'台', CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'B2    ', CAST(2000.00 AS Decimal(18, 2)), CAST(0x0000B0ED00F31290 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0ED00F31290 AS DateTime), NULL, NULL, NULL, CAST(200000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (150, N'HP10580         ', N'DB4035          ', N'智能', N'台', CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'库位一', CAST(2000.00 AS Decimal(18, 2)), CAST(0x0000B0ED00F40E84 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0ED00F40E84 AS DateTime), NULL, NULL, NULL, CAST(200000.00 AS Decimal(18, 2)))
INSERT [dbo].[Wh_inbill_d] ([inbill_id], [item_code], [inbill_code], [item_type], [unit], [buy_num], [inbill_num], [area_code], [buy_price], [product_date], [batch_no], [create_by], [create_time], [update_time], [update_by], [remark], [zong]) VALUES (151, N'HP10580         ', N'DB4036          ', N'智能', N'台', CAST(0.00 AS Decimal(18, 2)), CAST(60.00 AS Decimal(18, 2)), N'A1    ', CAST(2000.00 AS Decimal(18, 2)), CAST(0x0000B0ED00F4E3CC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0ED00F4E3CC AS DateTime), NULL, NULL, NULL, CAST(120000.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[Wh_inbill_d] OFF
SET IDENTITY_INSERT [dbo].[Wh_inbill_h] ON 

INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (1, N'进货入库  ', N' ', CAST(0x0000B0C2008F1276 AS DateTime), N'1               ', N'string          ', N'string', N'string', N'string', N'string', N'string', CAST(0x0000B0C2008F1276 AS DateTime), CAST(0x0000B0C2008F1276 AS DateTime), N'string', N'2', N'11', CAST(0x0000B0CE00000000 AS DateTime), N'0', N'仓库一    ', N'lzy22           ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (2, N'生产入库  ', N'2', CAST(0x0000B08500000000 AS DateTime), N'2               ', N'2               ', N'kk', N'19918026397', N'pp', N'22', N'kk', CAST(0x0000B08500000000 AS DateTime), CAST(0x0000B07A00000000 AS DateTime), N'pp', N'2', N'ee', CAST(0x0000B07A00000000 AS DateTime), N'0', N'仓库二    ', N'lzy33           ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (3, N'生产入库  ', N'0', CAST(0x0000B07A00000000 AS DateTime), N'3               ', N'3               ', N'hh', N'11111111', N'pp', N'11', N'ff', CAST(0x0000B07A00000000 AS DateTime), NULL, NULL, N'1', N'ee', CAST(0x0000B07A00000000 AS DateTime), N'0', N'仓库三    ', N'lzy44           ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (6, N'退货入库  ', N'1', CAST(0x0000B07A00000000 AS DateTime), N'string          ', N'string          ', N'string', N'string', N'string', N'string', N'string', CAST(0x0000B0B500000000 AS DateTime), NULL, NULL, N'0', N'string', CAST(0x0000B0C20065CBA3 AS DateTime), N'0', N'仓库四    ', NULL)
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (7, N'换货入库  ', N'1', CAST(0x0000B0C200738EED AS DateTime), N'string          ', N'string          ', N'string', N'string', N'string', N'string', N'string', CAST(0x0000B0B500000000 AS DateTime), NULL, NULL, N'1', N'string', CAST(0x0000B0C200738EED AS DateTime), N'0', N'仓库一    ', NULL)
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (12, N'进货入库  ', N'1', CAST(0x0000B0B700000000 AS DateTime), N'string          ', N'string          ', N'string', N'string', N'string', N'string', N'string', CAST(0x0000B0B800000000 AS DateTime), NULL, NULL, N'1', N'string', CAST(0x0000B0B900000000 AS DateTime), N'0', N'仓库二    ', N'lzy111          ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (42, N'进货入库  ', N'0', CAST(0x0000B0CA009D416C AS DateTime), N'2               ', N'供应商二        ', N'李依依', N'18788393737', N'罗桓杰', N'23r3erer', N'制单人', CAST(0x0000B0CA009E2F50 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库一', N'11              ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (43, N'进货入库  ', N'2', CAST(0x0000B0CA00B942F4 AS DateTime), N'2               ', N'供应商二        ', N'李依依', N'18788393737', N'罗桓杰', N'二二二', N'制单人', CAST(0x0000B0CA00B9742C AS DateTime), CAST(0x0000B0D000000000 AS DateTime), N'黄妍妮', N'2', N'罗桓杰', CAST(0x0000B0D000000000 AS DateTime), N'0', N'仓库四', N'12              ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (44, N'进货入库  ', N'2', CAST(0x0000B0CA0117ABB4 AS DateTime), N'2               ', N'供应商二        ', N'李依依', N'18788393737', N'罗桓杰', N'11111', N'制单人', CAST(0x0000B0CA0117C324 AS DateTime), CAST(0x0000B0D000000000 AS DateTime), N'罗桓杰', N'2', N'罗桓杰', CAST(0x0000B0D500000000 AS DateTime), N'0', N'仓库一', N'13              ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (46, N'进货入库  ', N'2', CAST(0x0000B0CA01867440 AS DateTime), N'                ', N'供应商二        ', N'李依依', N'18788393737', N'罗桓杰', N'111', N'制单人', CAST(0x0000B0CA018693E4 AS DateTime), CAST(0x0000B0D800000000 AS DateTime), N'罗桓杰', N'2', N'罗桓杰', CAST(0x0000B0D800000000 AS DateTime), N'0', N'仓库二', N'43              ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (47, N'生产入库  ', N'2', CAST(0x0000B0CB00B18C58 AS DateTime), N'                ', N'供应商二        ', N'李依依', N'18788393737', N'罗桓杰', N'六', N'制单人', CAST(0x0000B0CB00B1B688 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0D800000000 AS DateTime), N'0', N'仓库四', N'48              ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (48, N'生产入库  ', N'0', CAST(0x0000B0CB011B00D4 AS DateTime), N'567             ', N'供应商二        ', N'李依依', N'18788393737', N'罗桓杰', N'哈哈哈哈哈', N'制单人', CAST(0x0000B0CB011B21A4 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库一', N'49              ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (49, N'换货入库  ', N'2', CAST(0x0000B0CE009C0054 AS DateTime), N'888             ', N'供应商一        ', N'李依依', N'18918918998', N'罗桓杰', N'efeeewdw', N'制单人', CAST(0x0000B0CE009C02AC AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0D900000000 AS DateTime), N'1', N'仓库一', N'41              ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (51, N'退货入库  ', N'2', CAST(0x0000B0CE013FAA60 AS DateTime), N'                ', N'供应商二        ', N'李依依', N'18788393737', N'罗桓杰', N'1111111111111', N'罗桓杰', CAST(0x0000B0CE013FCA04 AS DateTime), CAST(0x0000B0D000000000 AS DateTime), N'罗桓杰', N'2', N'罗桓杰', CAST(0x0000B0E600000000 AS DateTime), N'0', N'仓库三', N'22              ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (52, N'退货入库  ', N'1', CAST(0x0000B0CF00E96B14 AS DateTime), N'4               ', N'供应商二        ', N'李依依', N'18788393737', N'罗桓杰', N'1111111', N'易蕾', CAST(0x0000B0CF00E98AB8 AS DateTime), NULL, NULL, N'1', N'罗桓杰', CAST(0x0000B0D000000000 AS DateTime), N'0', N'仓库四', N'66              ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (53, N'进货入库  ', N'2', CAST(0x0000B0CF011EE294 AS DateTime), N'4               ', N'供应商二        ', N'李依依', N'18788393737', N'罗桓杰', N'反对恢复恢复', N'刘子怡', CAST(0x0000B0CF011EFD88 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0CF00000000 AS DateTime), N'0', N'仓库四', N'61              ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (54, N'进货入库  ', N'2', CAST(0x0000B0CF0120C1E0 AS DateTime), N'4               ', N'供应商二        ', N'李依依', N'18788393737', N'黄妍妮', N'顶顶顶顶', N'罗桓杰', CAST(0x0000B0CF0120D374 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0EC00000000 AS DateTime), N'0', N'仓库三', N'62              ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (55, N'进货入库  ', N'0', CAST(0x0000B0CF01432500 AS DateTime), N'2               ', N'供应商二        ', N'李依依', N'18788393737', N'罗桓杰', N'如果人的光荣', N'罗桓杰', CAST(0x0000B0CF01434378 AS DateTime), CAST(0x0000B0D000000000 AS DateTime), N'黄妍妮', N'0', NULL, NULL, N'0', N'仓库二', N'63              ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (56, N'换货入库  ', N'2', CAST(0x0000B0D001285A04 AS DateTime), N'                ', N'供应商二        ', N'李依依', N'18788393737', N'黄妍妮', N'钱钱钱钱钱', N'罗桓杰', CAST(0x0000B0D001287750 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0D500000000 AS DateTime), N'0', N'仓库二', N'64              ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (57, N'生产入库  ', N'2', CAST(0x0000B0D500FDD7FC AS DateTime), N'888             ', N'供应商一        ', N'李依依', N'18918918998', N'罗桓杰', N'222', N'罗桓杰', CAST(0x0000B0D500FDE4E0 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0D500000000 AS DateTime), N'0', N'仓库一', N'RK12003         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (58, N'进货入库  ', N'2', CAST(0x0000B0D80122B644 AS DateTime), N'                ', N'供应商三        ', N'李依依', N'16689849373', N'黄妍妮', N'111', N'罗桓杰', CAST(0x0000B0D80122D714 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0D800000000 AS DateTime), N'0', N'仓库四', N'RK12009         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (59, N'进货入库  ', N'2', CAST(0x0000B0D700000000 AS DateTime), N'                ', N'供应商二        ', N'李依依', N'18788393737', N'刘子怡', N'4444', N'罗桓杰', CAST(0x0000B0D801236ABC AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0D800000000 AS DateTime), N'0', N'仓库一', N'RK12010         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (61, N'盘点入库  ', N'0', CAST(0x0000B0D800000000 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', NULL, N'罗桓杰', CAST(0x0000B0D800000000 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库四  ', N'PD13037         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (62, N'进货入库  ', N'0', CAST(0x0000B0D900EBD4A8 AS DateTime), N'                ', N'供应商二        ', N'李依依', N'18788393737', N'刘子怡', N'热热退热', N'罗桓杰', CAST(0x0000B0D900EBF6A4 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'RK12013         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (63, N'进货入库  ', N'0', CAST(0x0000B0D900EC5338 AS DateTime), N'                ', N'供应商一        ', N'李依依', N'18918918998', N'刘子怡', N'111', N'罗桓杰', CAST(0x0000B0D900EC6D00 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'RK12014         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (64, N'生产入库  ', N'0', CAST(0x0000B0D900ED1A70 AS DateTime), N'                ', N'供应商一        ', N'李依依', N'18918918998', N'黄妍妮', N'333', N'罗桓杰', CAST(0x0000B0D900ED45CC AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库三', N'RK12015         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (65, N'生产入库  ', N'0', CAST(0x0000B0D900ED61EC AS DateTime), N'                ', N'供应商二        ', N'李依依', N'18788393737', N'罗桓杰', N'333', N'罗桓杰', CAST(0x0000B0D900ED6FFC AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库一', N'RK12016         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (68, N'调拨入库  ', N'2', CAST(0x0000B0DC00000000 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', NULL, N'罗桓杰', CAST(0x0000B0DC00000000 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0DC00000000 AS DateTime), N'0', N'仓库三  ', N'DB16002         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (69, N'盘点入库  ', N'0', CAST(0x0000B0DC00000000 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', NULL, N'罗桓杰', CAST(0x0000B0DC00000000 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库四  ', N'PD18052         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (70, N'盘点入库  ', N'0', CAST(0x0000B0DD00000000 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', NULL, N'罗桓杰', CAST(0x0000B0DD00000000 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库四  ', N'PD19053         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (76, N'退货入库  ', N'0', CAST(0x0000B0DF00C2847C AS DateTime), N'                ', N'供应商二        ', N'李依依', N'18788393737', N'黄妍妮', N'123', N'罗桓杰', CAST(0x0000B0DF00C29610 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'RK12098         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (83, N'退货入库  ', N'0', CAST(0x0000B0DF00C3819C AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', N'123', N'罗桓杰', CAST(0x0000B0DF00C38FED AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'XSTH21026       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (84, N'退货入库  ', N'0', CAST(0x0000B0DF00EC26B0 AS DateTime), N'                ', NULL, NULL, NULL, N'刘子怡', N'123', N'罗桓杰', CAST(0x0000B0DF00EC383B AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'XSTH21029       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (85, N'退货入库  ', N'0', CAST(0x0000B0DF00EEA0AC AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', N'123', N'罗桓杰', CAST(0x0000B0DF00EEB07D AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'XSTH21032       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (86, N'退货入库  ', N'0', CAST(0x0000B0DF00EFFF10 AS DateTime), N'                ', NULL, NULL, NULL, N'刘子怡', N'123', N'罗桓杰', CAST(0x0000B0DF00F0093A AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'XSTH21033       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (87, N'退货入库  ', N'0', CAST(0x0000B0DF00F15EA0 AS DateTime), N'                ', NULL, NULL, NULL, N'黄妍妮', N'123', N'罗桓杰', CAST(0x0000B0DF00F16A4A AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'XSTH19005       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (88, N'退货入库  ', N'0', CAST(0x0000B0DF00F77538 AS DateTime), N'                ', NULL, NULL, NULL, N'刘子怡', N'123', N'罗桓杰', CAST(0x0000B0DF00F795CE AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'TH987654        ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (89, N'退货入库  ', N'0', CAST(0x0000B0DF00F7AEA4 AS DateTime), N'                ', NULL, NULL, NULL, N'', N'123', N'罗桓杰', CAST(0x0000B0DF00F7E9B8 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'TH123456        ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (90, N'退货入库  ', N'0', CAST(0x0000B0DF00FBD330 AS DateTime), N'                ', NULL, NULL, NULL, N'刘子怡', N'123', N'罗桓杰', CAST(0x0000B0DF00FBF1FA AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'XSTH19005       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (91, N'退货入库  ', N'0', CAST(0x0000B0DF011634B4 AS DateTime), N'                ', NULL, NULL, NULL, N'刘子怡', N'123', N'罗桓杰', CAST(0x0000B0DF01168C0A AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'XSTH21018       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (92, N'退货入库  ', N'0', CAST(0x0000B0DF011AA314 AS DateTime), N'                ', NULL, NULL, NULL, N'刘子怡', N'21', N'罗桓杰', CAST(0x0000B0DF011ABB16 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'TH123456        ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (93, N'退货入库  ', N'0', CAST(0x0000B0DF012201CC AS DateTime), N'                ', NULL, NULL, NULL, N'黄妍妮', N'123', N'罗桓杰', CAST(0x0000B0DF01228173 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'XSTH21036       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (94, N'退货入库  ', N'0', CAST(0x0000B0DF0123C624 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', N'123', N'罗桓杰', CAST(0x0000B0DF0123DFA7 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'XSTH21037       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (95, N'退货入库  ', N'0', CAST(0x0000B0DF013BFE88 AS DateTime), N'                ', NULL, NULL, NULL, N'', N'123', N'罗桓杰', CAST(0x0000B0DF013C5F8A AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库一', N'XSTH21033       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (96, N'退货入库  ', N'0', CAST(0x0000B0DF013E1E48 AS DateTime), N'                ', NULL, NULL, NULL, N'黄妍妮', N'123', N'罗桓杰', CAST(0x0000B0DF013E3001 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'XSTH21032       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (97, N'退货入库  ', N'0', CAST(0x0000B0DF013EDFA4 AS DateTime), N'                ', NULL, NULL, NULL, N'黄妍妮', N'123', N'罗桓杰', CAST(0x0000B0DF013F054F AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'XSTH21040       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (98, N'退货入库  ', N'0', CAST(0x0000B0DF0142D67C AS DateTime), N'                ', NULL, NULL, NULL, N'黄妍妮', N'33', N'罗桓杰', CAST(0x0000B0DF014143B1 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'XSTH21028       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (99, N'退货入库  ', N'0', CAST(0x0000B0DF0142D67C AS DateTime), N'                ', NULL, NULL, NULL, N'黄妍妮', N'33', N'罗桓杰', CAST(0x0000B0DF01427080 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'XSTH21028       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (100, N'退货入库  ', N'0', CAST(0x0000B0DF0142D67C AS DateTime), N'                ', NULL, NULL, NULL, N'黄妍妮', N'33', N'罗桓杰', CAST(0x0000B0DF0142E369 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'XSTH21028       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (101, N'退货入库  ', N'0', CAST(0x0000B0DF01489B0C AS DateTime), N'                ', NULL, NULL, NULL, N'黄妍妮', N'12', N'罗桓杰', CAST(0x0000B0DF0144DCE8 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库三', N'XSTH21041       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (102, N'退货入库  ', N'0', CAST(0x0000B0DF014950B0 AS DateTime), N'                ', NULL, NULL, NULL, N'黄妍妮', N'123', N'罗桓杰', CAST(0x0000B0DF01496690 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'XSTH21042       ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (103, N'生产入库  ', N'2', CAST(0x0000B0E500000000 AS DateTime), N'JH2023039       ', N'供应商二        ', N'李依依', N'18788393737', N'易蕾', N'1111', N'罗桓杰', CAST(0x0000B0E6009E5AAC AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0E600000000 AS DateTime), N'0', N'仓库二', N'RK120112        ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (104, N'进货入库  ', N'2', CAST(0x0000B0E500000000 AS DateTime), N'JH2023038       ', N'供应商三        ', N'李依依', N'16689849373', N'黄妍妮', N'111', N'罗桓杰', CAST(0x0000B0E6009EF8E0 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0E600000000 AS DateTime), N'0', N'仓库三', N'RK120113        ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (105, N'进货入库  ', N'0', CAST(0x0000B0DF00000000 AS DateTime), N'JH2023039       ', N'供应商二        ', N'李依依', N'18788393737', N'刘子怡', N'1111', N'罗桓杰', CAST(0x0000B0E600A0260C AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库三', N'RK120115        ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (106, N'进货入库  ', N'2', CAST(0x0000B0E600F61DDC AS DateTime), N'JH2023050       ', N'华为            ', N'李媛媛', N'18974022095', N'刘子怡', N'111', N'罗桓杰', CAST(0x0000B0E600F65BF8 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0E600000000 AS DateTime), N'0', N'仓库二', N'RK120121        ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (107, N'盘点入库  ', N'2', CAST(0x0000B0E600000000 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', NULL, N'罗桓杰', CAST(0x0000B0E600000000 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0E600000000 AS DateTime), N'0', N'仓库四  ', N'PD28066         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (108, N'调拨入库  ', N'2', CAST(0x0000B0E600000000 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', NULL, N'罗桓杰', CAST(0x0000B0E600000000 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0E600000000 AS DateTime), N'0', N'仓库四  ', N'DB28022         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (109, N'进货入库  ', N'0', CAST(0x0000B0E60120942C AS DateTime), N'                ', N'供应商二        ', N'李依依', N'18788393737', N'黄妍妮', N'', N'罗桓杰', CAST(0x0000B0E60120D11C AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库三', N'RK120131        ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (110, N'进货入库  ', N'2', CAST(0x0000B0EB014DBF10 AS DateTime), N'JH2024074       ', N'小米            ', N'小白', N'13232323223', N'刘子怡', N'123', N'罗桓杰', CAST(0x0000B0EB014DD680 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0EB00000000 AS DateTime), N'0', N'蔡锷仓', N'RK10137         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (111, N'退货入库  ', N'0', CAST(0x0000B0EB0152F5D4 AS DateTime), N'                ', NULL, NULL, NULL, N'霍建华', N'123', N'罗桓杰', CAST(0x0000B0EB015309F6 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'蔡锷仓', N'XSTH2058        ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (112, N'进货入库  ', N'2', CAST(0x0000B0EC00EEE120 AS DateTime), N'JH2024076       ', N'iqoo            ', N'李依依', N'13203023738', N'黄妍妮', N'123', N'罗桓杰', CAST(0x0000B0EC00EEF3E0 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0EC00000000 AS DateTime), N'0', N'芙蓉仓', N'RK10142         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (113, N'进货入库  ', N'2', CAST(0x0000B0ED00EF0DA8 AS DateTime), N'JH2024079       ', N'苹果            ', N'李依依', N'13232323222', N'余开学', N'哈哈哈', N'罗桓杰', CAST(0x0000B0ED00EF29C8 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0ED00000000 AS DateTime), N'0', N'蔡锷中路仓', N'RK10158         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (114, N'进货入库  ', N'2', CAST(0x0000B0ED00EF9214 AS DateTime), N'JH2024079       ', N'苹果            ', N'李依依', N'13232323222', N'易蕾', N'11', N'罗桓杰', CAST(0x0000B0ED00EFAAB0 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0ED00000000 AS DateTime), N'0', N'仓库七', N'RK10159         ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (115, N'退货入库  ', N'0', CAST(0x0000B0ED00F254B8 AS DateTime), N'                ', NULL, NULL, NULL, N'刘子怡', N'123', N'罗桓杰', CAST(0x0000B0ED00F269D8 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'仓库二', N'XSTH4059        ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (116, N'盘点入库  ', N'2', CAST(0x0000B0ED00000000 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', NULL, N'罗桓杰', CAST(0x0000B0ED00000000 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0ED00000000 AS DateTime), N'0', N'仓库七  ', N'PD4082          ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (117, N'调拨入库  ', N'2', CAST(0x0000B0ED00000000 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', NULL, N'罗桓杰', CAST(0x0000B0ED00000000 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0ED00000000 AS DateTime), N'0', N'仓库三  ', N'DB4035          ')
INSERT [dbo].[Wh_inbill_h] ([inbill_code], [inbill_type], [inbill_state], [inbll_date], [buy_code], [supply_code], [link_man], [link_way], [inbill_duty_man], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [is_del], [ware_name], [inbill_bh]) VALUES (118, N'调拨入库  ', N'0', CAST(0x0000B0ED00000000 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', NULL, N'罗桓杰', CAST(0x0000B0ED00000000 AS DateTime), NULL, NULL, N'0', NULL, NULL, N'0', N'司马里仓', N'DB4036          ')
SET IDENTITY_INSERT [dbo].[Wh_inbill_h] OFF
SET IDENTITY_INSERT [dbo].[Wh_inventory_d] ON 

INSERT [dbo].[Wh_inventory_d] ([inventory_d_id], [inventory_code], [item_code], [model_code], [unit], [item_type], [account_num], [area_code], [inventory_num], [break_even_num], [inventory_state], [inbill_price], [remark]) VALUES (18, N'PD13037         ', N'2               ', N'blue', N'瓶', N'智能手机', CAST(20.00 AS Decimal(18, 2)), N'库位四', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0', CAST(200.00 AS Decimal(18, 2)), N'1')
INSERT [dbo].[Wh_inventory_d] ([inventory_d_id], [inventory_code], [item_code], [model_code], [unit], [item_type], [account_num], [area_code], [inventory_num], [break_even_num], [inventory_state], [inbill_price], [remark]) VALUES (19, N'PD13037         ', N'4               ', N'blur', N'瓶', N'智能电视', CAST(20.00 AS Decimal(18, 2)), N'库位四', CAST(26.00 AS Decimal(18, 2)), CAST(6.00 AS Decimal(18, 2)), N'2', CAST(300.00 AS Decimal(18, 2)), N'2')
INSERT [dbo].[Wh_inventory_d] ([inventory_d_id], [inventory_code], [item_code], [model_code], [unit], [item_type], [account_num], [area_code], [inventory_num], [break_even_num], [inventory_state], [inbill_price], [remark]) VALUES (20, N'PD13037         ', N'5               ', N'blur ', N'瓶', N'显示器', CAST(60.00 AS Decimal(18, 2)), N'库位四', CAST(20.00 AS Decimal(18, 2)), CAST(-40.00 AS Decimal(18, 2)), N'1', CAST(400.00 AS Decimal(18, 2)), N'3')
INSERT [dbo].[Wh_inventory_d] ([inventory_d_id], [inventory_code], [item_code], [model_code], [unit], [item_type], [account_num], [area_code], [inventory_num], [break_even_num], [inventory_state], [inbill_price], [remark]) VALUES (21, N'PD13041         ', N'4               ', N'blur', N'瓶', N'智能电视', CAST(20.00 AS Decimal(18, 2)), N'库位四', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0', CAST(300.00 AS Decimal(18, 2)), N'斤斤计较')
INSERT [dbo].[Wh_inventory_d] ([inventory_d_id], [inventory_code], [item_code], [model_code], [unit], [item_type], [account_num], [area_code], [inventory_num], [break_even_num], [inventory_state], [inbill_price], [remark]) VALUES (22, N'PD18052         ', N'3               ', N'blur', N'箱', N'手机', CAST(20.00 AS Decimal(18, 2)), N'库位四', CAST(50.00 AS Decimal(18, 2)), CAST(30.00 AS Decimal(18, 2)), N'2', CAST(300.00 AS Decimal(18, 2)), N'111')
INSERT [dbo].[Wh_inventory_d] ([inventory_d_id], [inventory_code], [item_code], [model_code], [unit], [item_type], [account_num], [area_code], [inventory_num], [break_even_num], [inventory_state], [inbill_price], [remark]) VALUES (23, N'PD18052         ', N'4               ', N'blur', N'瓶', N'智能电视', CAST(30.00 AS Decimal(18, 2)), N'库位四', CAST(50.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'2', CAST(300.00 AS Decimal(18, 2)), N'2222')
INSERT [dbo].[Wh_inventory_d] ([inventory_d_id], [inventory_code], [item_code], [model_code], [unit], [item_type], [account_num], [area_code], [inventory_num], [break_even_num], [inventory_state], [inbill_price], [remark]) VALUES (24, N'PD19053         ', N'1               ', N'blue', N'箱', N'电子产品', CAST(61.00 AS Decimal(18, 2)), N'库位四', CAST(20.00 AS Decimal(18, 2)), CAST(-41.00 AS Decimal(18, 2)), N'1', CAST(100.00 AS Decimal(18, 2)), N'盘亏')
INSERT [dbo].[Wh_inventory_d] ([inventory_d_id], [inventory_code], [item_code], [model_code], [unit], [item_type], [account_num], [area_code], [inventory_num], [break_even_num], [inventory_state], [inbill_price], [remark]) VALUES (25, N'PD19053         ', N'2               ', N'blue', N'瓶', N'智能手机', CAST(81.00 AS Decimal(18, 2)), N'库位四', CAST(100.00 AS Decimal(18, 2)), CAST(19.00 AS Decimal(18, 2)), N'2', CAST(200.00 AS Decimal(18, 2)), N'盘盈')
INSERT [dbo].[Wh_inventory_d] ([inventory_d_id], [inventory_code], [item_code], [model_code], [unit], [item_type], [account_num], [area_code], [inventory_num], [break_even_num], [inventory_state], [inbill_price], [remark]) VALUES (26, N'PD28066         ', N'1               ', N'blue', N'箱', N'电子产品', CAST(20.00 AS Decimal(18, 2)), N'库位三', CAST(30.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), N'2', CAST(100.00 AS Decimal(18, 2)), N'1')
INSERT [dbo].[Wh_inventory_d] ([inventory_d_id], [inventory_code], [item_code], [model_code], [unit], [item_type], [account_num], [area_code], [inventory_num], [break_even_num], [inventory_state], [inbill_price], [remark]) VALUES (27, N'PD28066         ', N'2               ', N'blue', N'瓶', N'智能手机', CAST(10.00 AS Decimal(18, 2)), N'库位三', CAST(10.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0', CAST(200.00 AS Decimal(18, 2)), N'2')
INSERT [dbo].[Wh_inventory_d] ([inventory_d_id], [inventory_code], [item_code], [model_code], [unit], [item_type], [account_num], [area_code], [inventory_num], [break_even_num], [inventory_state], [inbill_price], [remark]) VALUES (28, N'PD28066         ', N'3               ', N'blur', N'箱', N'电子产品', CAST(20.00 AS Decimal(18, 2)), N'库位四', CAST(10.00 AS Decimal(18, 2)), CAST(-10.00 AS Decimal(18, 2)), N'1', CAST(300.00 AS Decimal(18, 2)), N'3')
INSERT [dbo].[Wh_inventory_d] ([inventory_d_id], [inventory_code], [item_code], [model_code], [unit], [item_type], [account_num], [area_code], [inventory_num], [break_even_num], [inventory_state], [inbill_price], [remark]) VALUES (29, N'PD4082          ', N'HP10580         ', N'12', N'台', N'智能', CAST(10.00 AS Decimal(18, 2)), N'B2    ', CAST(100.00 AS Decimal(18, 2)), CAST(90.00 AS Decimal(18, 2)), N'2', CAST(2000.00 AS Decimal(18, 2)), N'1')
SET IDENTITY_INSERT [dbo].[Wh_inventory_d] OFF
SET IDENTITY_INSERT [dbo].[Wh_inventory_h] ON 

INSERT [dbo].[Wh_inventory_h] ([inventory_h_id], [inventory_code], [inventory_type], [ware_code], [begin_date], [end_date], [sure_state], [sure_man], [sure_date], [remark], [create_by], [create_time], [is_del], [zt]) VALUES (9, N'PD13037         ', N'期初盘点', N'仓库四  ', CAST(0x0000B0D600000000 AS DateTime), CAST(0x0000B0D701079814 AS DateTime), N'2', N'刘子怡', CAST(0x0000B0D800000000 AS DateTime), N'111', N'罗桓杰', CAST(0x0000B0D700000000 AS DateTime), N'0', N'1')
INSERT [dbo].[Wh_inventory_h] ([inventory_h_id], [inventory_code], [inventory_type], [ware_code], [begin_date], [end_date], [sure_state], [sure_man], [sure_date], [remark], [create_by], [create_time], [is_del], [zt]) VALUES (10, N'PD13041         ', N'期初盘点', N'仓库四  ', CAST(0x0000B0D600000000 AS DateTime), CAST(0x0000B0D70123903C AS DateTime), N'0', N'罗桓杰', NULL, N'4444', N'罗桓杰', CAST(0x0000B0D700000000 AS DateTime), N'0', N'0')
INSERT [dbo].[Wh_inventory_h] ([inventory_h_id], [inventory_code], [inventory_type], [ware_code], [begin_date], [end_date], [sure_state], [sure_man], [sure_date], [remark], [create_by], [create_time], [is_del], [zt]) VALUES (11, N'PD18052         ', N'存货盘点', N'仓库四  ', CAST(0x0000B0DB00000000 AS DateTime), CAST(0x0000B0DD00000000 AS DateTime), N'2', N'刘子怡', CAST(0x0000B0DC00000000 AS DateTime), N'88888', N'罗桓杰', CAST(0x0000B0DC00000000 AS DateTime), N'0', N'1')
INSERT [dbo].[Wh_inventory_h] ([inventory_h_id], [inventory_code], [inventory_type], [ware_code], [begin_date], [end_date], [sure_state], [sure_man], [sure_date], [remark], [create_by], [create_time], [is_del], [zt]) VALUES (12, N'PD19053         ', N'存货盘点', N'仓库四  ', CAST(0x0000B0D600000000 AS DateTime), CAST(0x0000B0DE00000000 AS DateTime), N'2', N'刘子怡', CAST(0x0000B0DD00000000 AS DateTime), N'111', N'罗桓杰', CAST(0x0000B0DD00000000 AS DateTime), N'0', N'1')
INSERT [dbo].[Wh_inventory_h] ([inventory_h_id], [inventory_code], [inventory_type], [ware_code], [begin_date], [end_date], [sure_state], [sure_man], [sure_date], [remark], [create_by], [create_time], [is_del], [zt]) VALUES (13, N'PD28066         ', N'期初盘点', N'仓库四  ', CAST(0x0000B0E600F9C180 AS DateTime), CAST(0x0000B0E600F9DA1C AS DateTime), N'2', N'刘子怡', CAST(0x0000B0E600000000 AS DateTime), N'111', N'罗桓杰', CAST(0x0000B0E600000000 AS DateTime), N'0', N'1')
INSERT [dbo].[Wh_inventory_h] ([inventory_h_id], [inventory_code], [inventory_type], [ware_code], [begin_date], [end_date], [sure_state], [sure_man], [sure_date], [remark], [create_by], [create_time], [is_del], [zt]) VALUES (14, N'PD4082          ', N'期初盘点', N'仓库七  ', CAST(0x0000B0EC00000000 AS DateTime), CAST(0x0000B0ED00F2C40C AS DateTime), N'2', N'刘子怡', CAST(0x0000B0ED00000000 AS DateTime), N'hhh', N'罗桓杰', CAST(0x0000B0ED00000000 AS DateTime), N'0', N'1')
SET IDENTITY_INSERT [dbo].[Wh_inventory_h] OFF
SET IDENTITY_INSERT [dbo].[Wh_now_storage] ON 

INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库一  ', 2, N'库位一', N'2       ', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库一  ', 4, N'库位一', N'4       ', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库二  ', 5, N'库位二', N'2       ', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库二  ', 6, N'库位二', N'4       ', CAST(22.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'1')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库四  ', 20, N'库位四', N'5       ', CAST(60.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库二  ', 21, N'库位二', N'2       ', CAST(38.00 AS Decimal(18, 2)), CAST(22.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库二  ', 22, N'库位二', N'4       ', CAST(62.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库四  ', 23, N'库位四', N'2       ', CAST(101.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库四  ', 24, N'库位四', N'4       ', CAST(30.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库一  ', 25, N'库位一', N'2       ', CAST(31.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库一  ', 26, N'库位一', N'4       ', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库一  ', 27, N'库位一', N'1       ', CAST(82.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库二  ', 28, N'库位二', N'1       ', CAST(70.00 AS Decimal(18, 2)), CAST(21.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库二  ', 29, N'库位二', N'3       ', CAST(70.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库四  ', 30, N'库位四', N'1       ', CAST(81.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库四  ', 31, N'库位四', N'3       ', CAST(20.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库一  ', 32, N'库位一', N'3       ', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库三  ', 33, N'库位三', N'1       ', CAST(40.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库三  ', 34, N'库位三', N'2       ', CAST(30.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库二  ', 35, N'库位二', N'HP120390', CAST(100.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库二  ', 36, N'库位二', N'HP120388', CAST(50.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库二  ', 37, N'库位二', N'HP120389', CAST(50.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库三  ', 38, N'库位一', N'HP120250', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库三  ', 39, N'库位一', N'HP120387', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库三  ', 40, N'库位一', N'HP120253', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库三  ', 41, N'库位一', N'HP120219', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库二  ', 42, N'库位二', N'HP120396', CAST(100.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库四  ', 43, N'库位三', N'1       ', CAST(30.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库三  ', 44, N'库位三', N'4       ', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'蔡锷仓  ', 45, N'B1    ', N'HP10550 ', CAST(100.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'蔡锷仓  ', 46, N'B1    ', N'HP10567 ', CAST(100.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'芙蓉仓  ', 47, N'D1    ', N'HP10570 ', CAST(150.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库三  ', 48, N'库位三', N'5       ', CAST(10.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库七  ', 50, N'B2    ', N'HP10580 ', CAST(10.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_now_storage] ([ware_code], [now_storage_id], [area_code], [item_code], [inbill3_num], [plan_outnum], [is_del]) VALUES (N'仓库三  ', 51, N'库位一', N'HP10580 ', CAST(100.00 AS Decimal(18, 2)), CAST(60.00 AS Decimal(18, 2)), N'0')
SET IDENTITY_INSERT [dbo].[Wh_now_storage] OFF
SET IDENTITY_INSERT [dbo].[Wh_orderbuy_d] ON 

INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (7, N'4               ', N'货品五', N'66', N'白', N'箱', N'饮品', CAST(100.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(70.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', NULL)
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (16, N'666             ', N'货品一', N'1       ', N'blue', N'箱', N'饮品', CAST(10.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'1')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (17, N'666             ', N'货品二', N'2       ', N'blue', N'瓶', N'饮品', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'2')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (18, N'666             ', N'货品三', N'3       ', N'blur', N'箱', N'饮品', CAST(30.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'3')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (19, N'777             ', N'货品四', N'4       ', N'blur', N'瓶', N'饮品', CAST(6.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (20, N'777             ', N'货品三', N'3       ', N'blur', N'箱', N'饮品', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (21, N'888             ', N'货品一', N'1       ', N'blue', N'箱', N'饮品', CAST(10.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)), CAST(7.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'678')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (22, N'999             ', N'货品二', N'2       ', N'blue', N'瓶', N'饮品', CAST(6.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'1')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (23, N'999             ', N'货品四', N'4       ', N'blur', N'瓶', N'饮品', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'2')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (28, N'567             ', N'货品一', N'1       ', N'blue', N'箱', N'饮品', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'7')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (29, N'567             ', N'货品二', N'2       ', N'blue', N'瓶', N'食品', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'7')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (30, N'567             ', N'货品三', N'3       ', N'blur', N'箱', N'饮品', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'7')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (31, N'567             ', N'货品四', N'4       ', N'blur', N'瓶', N'食品', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'7')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (32, N'7899            ', N'货品一', N'1       ', N'blue', N'箱', N'饮品', CAST(9.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'第一次测试')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (39, N'3               ', N'货品一', N'1       ', N'blue', N'箱', N'饮品', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'7')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (40, N'3               ', N'货品二', N'2       ', N'blue', N'瓶', N'食品', CAST(9.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'1111')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (43, N'123456          ', N'货品三', N'3       ', N'blur', N'箱', N'饮品', CAST(10.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(38.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'10')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (44, N'123456          ', N'货品二', N'2       ', N'blue', N'瓶', N'食品', CAST(10.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(38.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'10')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (51, N'987             ', N'货品三', N'3       ', N'blur', N'箱', N'饮品', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (52, N'987             ', N'货品一', N'1       ', N'blue', N'箱', N'饮品', CAST(10.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'456')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (53, N'987             ', N'货品二', N'2       ', N'blue', N'瓶', N'食品', CAST(30.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'789')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (54, N'3042            ', N'货品一', N'1       ', N'blue', N'箱', N'饮品', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'9')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (55, N'3042            ', N'货品二', N'2       ', N'blue', N'瓶', N'食品', CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'9')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (56, N'3042            ', N'货品三', N'3       ', N'blur', N'箱', N'饮品', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'9')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (57, N'3042            ', N'货品四', N'4       ', N'blur', N'瓶', N'食品', CAST(4.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'9')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (58, N'3042            ', N'货品五', N'5       ', N'blur ', N'瓶', N'食品', CAST(5.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), N'0', N'9')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (66, N'6665654         ', N'货品一', N'1       ', N'blue', N'箱', N'电子产品', CAST(6.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(24.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'6')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (67, N'6665654         ', N'货品二', N'2       ', N'blue', N'瓶', N'手机', CAST(6.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(24.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'6')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (68, N'2               ', N'货品二', N'333', N'红', N'箱', N'饮品', CAST(100.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(53.00 AS Decimal(18, 2)), CAST(3000.00 AS Decimal(18, 2)), N'0', N'3')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (69, N'2               ', N'货品四', N'555', N'黄', N'瓶', N'饮品', CAST(50.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(53.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'5')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (70, N'2               ', N'货品五', N'5       ', N'blur ', N'瓶', N'手机', CAST(30.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(53.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), N'0', N'12')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (71, N'5656            ', N'货品一', N'1       ', N'blue', N'箱', N'饮品', CAST(77.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'阿萨德')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (72, N'5656            ', N'货品二', N'2       ', N'blue', N'瓶', N'食品', CAST(10.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'安大师')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (73, N'5656            ', N'货品四', N'4       ', N'blur', N'瓶', N'食品', CAST(10.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'777')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (74, N'5656            ', N'货品五', N'5       ', N'blur ', N'瓶', N'显示器', CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), N'0', N'1')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (78, N'JH123456        ', N'苹果手机', N'HP12042 ', N'blur', N'箱', N'智能手机', CAST(10.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'1')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (79, N'JH123456        ', N'小米手机', N'HP12077 ', N'blue', N'箱', N'智能手机', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'2')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (80, N'JH123456        ', N'等离子', N'HP12087 ', N'blur', N'箱', N'显示器', CAST(30.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'3')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (82, N'jh123           ', N'小米手机', N'HP12077 ', N'blue', N'瓶', N'手机', CAST(70.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (83, N'2131231231      ', N'213123', N'HP120173', N'123', N'箱', N'手机', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(3123.00 AS Decimal(18, 2)), N'0', N'')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (88, N'JH2023010       ', N'CES', N'HP120167', N'12', N'瓶', N'手机', CAST(10.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(312.00 AS Decimal(18, 2)), N'0', N'12')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (89, N'JH2023010       ', N'12313', N'HP120168', N'312', N'箱', N'智能电视', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(312.00 AS Decimal(18, 2)), N'0', N'21')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (90, N'JH2023010       ', N'777', N'HP120169', N'77', N'瓶', N'智能电视', CAST(30.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(77.00 AS Decimal(18, 2)), N'0', N'12')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (91, N'JH2023010       ', N'123', N'HP120170', N'123', N'瓶', N'手机', CAST(40.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(123.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (92, N'JH2023034       ', N'尿不湿', N'HP120388', N'3*6', N'箱', N'裙子', CAST(100.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'2')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (93, N'JH2023034       ', N'洗发水', N'HP120389', N'100*3', N'瓶', N'裙子', CAST(200.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'3')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (94, N'JH2023034       ', N'沐浴', N'HP120390', N'bule', N'瓶', N'裙子', CAST(300.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'1')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (95, N'JH2023035       ', N'口红', N'HP120253', N'4cm', N'瓶', N'电视', CAST(200.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'21')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (96, N'JH2023035       ', N'柜子', N'HP120387', N'120*3', N'瓶', N'男装', CAST(100.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'12')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (97, N'JH2023035       ', N'bb', N'HP120250', N'123', N'瓶', N'手机', CAST(100.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(123.00 AS Decimal(18, 2)), N'0', N'12')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (98, N'JH2023036       ', N'口红', N'HP120253', N'4cm', N'箱', N'电视', CAST(50.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (99, N'JH2023036       ', N'鼠标', N'HP120219', N'2*2', N'箱', N'电子产品', CAST(50.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (100, N'JH2023037       ', N'苹果手机', N'HP12042 ', N'blur', N'瓶', N'智能手机', CAST(50.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (101, N'JH2023037       ', N'小米手机', N'HP12077 ', N'blue', N'箱', N'手机', CAST(50.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (102, N'JH2023038       ', N'鼠标', N'HP120219', N'2*2', N'瓶', N'电子产品', CAST(50.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'2')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (103, N'JH2023038       ', N'bb', N'HP120250', N'123', N'箱', N'手机', CAST(50.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(123.00 AS Decimal(18, 2)), N'0', N'3')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (104, N'JH2023038       ', N'口红', N'HP120253', N'4cm', N'箱', N'电视', CAST(50.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'4')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (105, N'JH2023038       ', N'柜子', N'HP120387', N'120*3', N'瓶', N'男装', CAST(50.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'5')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (106, N'JH2023039       ', N'尿不湿', N'HP120388', N'3*6', N'瓶', N'裙子', CAST(60.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(55.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (107, N'JH2023039       ', N'洗发水', N'HP120389', N'100*3', N'瓶', N'裙子', CAST(60.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(52.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (108, N'JH2023039       ', N'沐浴', N'HP120390', N'bule', N'瓶', N'裙子', CAST(60.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(53.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (110, N'JH2023049       ', N'鼠标', N'HP120219', N'2*2', N'个', N'电子产品', CAST(21.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (113, N'JH2023050       ', N'衣', N'HP120396', N'130', N'件', N'卫衣', CAST(200.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(210.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'1')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (114, N'JH2023050       ', N'沐浴', N'HP120390', N'bule', N'瓶', N'服装', CAST(100.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), CAST(210.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'1')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (116, N'JH2023064       ', N'口红', N'HP120253', N'4cm', N'支', N'电视', CAST(90.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'2')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (119, N'1               ', N'货品一', N'1       ', N'blue', N'箱', N'饮品', CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'其味无穷二1')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (120, N'1               ', N'货品二', N'2       ', N'blue', N'瓶', N'食品', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'轻微去翁1')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (123, N'JH2023067       ', N'波鞋', N'HP120397', N'1', N'12', N'男装', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(21.00 AS Decimal(18, 2)), CAST(321.00 AS Decimal(18, 2)), N'0', N'12')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (124, N'JH2023067       ', N'棉服', N'HP120423', N'12', N'3123', N'服装', CAST(30.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(21.00 AS Decimal(18, 2)), CAST(122.00 AS Decimal(18, 2)), N'0', N'12')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (125, N'JH2023067       ', N'AFS', N'HP120429', N'123', N'312', N'卫衣', CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(21.00 AS Decimal(18, 2)), CAST(213.00 AS Decimal(18, 2)), N'0', N'12')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (128, N'JH2024074       ', N'羽绒服', N'HP10567         ', N'12', N'件', N'女装', CAST(200.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(110.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (129, N'JH2024074       ', N'无糖可乐', N'HP10550         ', N'12', N'瓶', N'百世可乐1', CAST(100.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(110.00 AS Decimal(18, 2)), CAST(123.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (132, N'JH2024075       ', N'羽绒服', N'HP10567         ', N'12', N'件', N'女装', CAST(100.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (134, N'JH2024076       ', N'睡裤', N'HP10570         ', N'12', N'件', N'棉裤1', CAST(150.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(150.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'12')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (135, N'JH2024077       ', N'哔哔机', N'HP10574         ', N'2*3', N'台', N'女装', CAST(200.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'1')
INSERT [dbo].[Wh_orderbuy_d] ([buy_codeId], [buy_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [buy_num], [treat_num], [inbill_num], [return_goods_num], [buy_goods_money], [is_del], [remark]) VALUES (137, N'JH2024079       ', N'华为', N'HP10580         ', N'12', N'台', N'智能', CAST(150.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(120.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), N'0', N'')
SET IDENTITY_INSERT [dbo].[Wh_orderbuy_d] OFF
SET IDENTITY_INSERT [dbo].[Wh_outbill_d] ON 

INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (12, N'CK12030         ', N'2               ', N'销售出库', N'箱', CAST(10.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位二', CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0D500F558FC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D500F558FC AS DateTime), NULL, NULL, N'222', CAST(100.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (20, N'CK12039         ', N'2               ', N'销售出库', N'箱', CAST(10.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位二', CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0D500FB8830 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D500FB8830 AS DateTime), CAST(0x0000B0D600000000 AS DateTime), N'罗桓杰', N'222', CAST(100.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (21, N'CK12046         ', N'2               ', N'销售出库', N'箱', CAST(10.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位二', CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0D600011238 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D600011238 AS DateTime), CAST(0x0000B0D600000000 AS DateTime), N'罗桓杰', N'呃呃呃呃', CAST(100.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (32, N'665             ', N'2               ', N'销售出库', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位二', CAST(200.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0D600A5BE14 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D600A5BE14 AS DateTime), NULL, NULL, N'111', CAST(4000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (33, N'665             ', N'4               ', N'销售出库', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(24.00 AS Decimal(18, 2)), N'库位二', CAST(300.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0D600A5BE14 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D600A5BE14 AS DateTime), NULL, NULL, N'111', CAST(7200.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (34, N'CK12047         ', N'1               ', N'销售出库', N'箱', CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位二', CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0D600B72C94 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D600B72C94 AS DateTime), NULL, NULL, N'2', CAST(100.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (35, N'CK12047         ', N'2               ', N'销售出库', N'瓶', CAST(2.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位二', CAST(200.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0D600B72C94 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D600B72C94 AS DateTime), NULL, NULL, N'2', CAST(200.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (36, N'CK12047         ', N'3               ', N'销售出库', N'箱', CAST(3.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'库位二', CAST(300.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0D600B72C94 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D600B72C94 AS DateTime), NULL, NULL, N'2', CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (37, N'PD13037         ', N'5               ', N'显示器', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位四', CAST(400.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0D8016032E4 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0D8016032E4 AS DateTime), NULL, NULL, NULL, CAST(8000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (42, N'DB16002         ', N'1               ', N'电子产品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位一', CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0DC00C1875C AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DC00C1875C AS DateTime), NULL, NULL, NULL, CAST(2000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (43, N'DB16002         ', N'2               ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0DC00C1875C AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DC00C1875C AS DateTime), NULL, NULL, NULL, CAST(2000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (44, N'PD19053         ', N'1               ', N'电子产品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位四', CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0DD00FD8F54 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0DD00FD8F54 AS DateTime), NULL, NULL, NULL, CAST(2000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (45, N'5555555555      ', N'1               ', N'饮品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), N'库位一', CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E001297A13 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E001297A13 AS DateTime), NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (46, N'JHTH19002       ', N'3               ', N'饮品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(7.00 AS Decimal(18, 2)), N'库位三', CAST(300.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E300A0AF6A AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E300A0AF6A AS DateTime), NULL, NULL, NULL, CAST(2100.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (47, N'JHTH19002       ', N'2               ', N'食品', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(7.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E300A0AF8D AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E300A0AF8D AS DateTime), NULL, NULL, NULL, CAST(1400.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (48, N'9999999999      ', N'66              ', N'饮品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位一', CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E300A13310 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E300A13310 AS DateTime), NULL, NULL, NULL, CAST(2000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (49, N'4444444444      ', N'1               ', N'电子产品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(6.00 AS Decimal(18, 2)), N'库位一', CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E300A1DFC6 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E300A1DFC6 AS DateTime), NULL, NULL, NULL, CAST(600.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (50, N'4444444444      ', N'2               ', N'手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(6.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E300A1DFE6 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E300A1DFE6 AS DateTime), NULL, NULL, NULL, CAST(1200.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (51, N'JHTH25036       ', N'3               ', N'手机', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(9.00 AS Decimal(18, 2)), N'库位一', CAST(300.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E300C069B2 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E300C069B2 AS DateTime), NULL, NULL, NULL, CAST(1800.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (52, N'JHTH25036       ', N'2               ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(9.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E300C069DE AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E300C069DE AS DateTime), NULL, NULL, NULL, CAST(1800.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (53, N'JHTH25035       ', N'2               ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E300C23259 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E300C23259 AS DateTime), NULL, NULL, NULL, CAST(2000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (54, N'JHTH25035       ', N'4               ', N'智能电视', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)), N'库位三', CAST(300.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E300C23271 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E300C23271 AS DateTime), NULL, NULL, NULL, CAST(1500.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (55, N'JHTH25035       ', N'5               ', N'显示器', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'库位三', CAST(400.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E300C23280 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E300C23280 AS DateTime), NULL, NULL, NULL, CAST(800.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (56, N'JHTH25037       ', N'3               ', N'手机', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), N'库位三', CAST(300.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E300C306C0 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E300C306C0 AS DateTime), NULL, NULL, NULL, CAST(3000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (57, N'JHTH25037       ', N'2               ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E300C306D8 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E300C306D8 AS DateTime), NULL, NULL, NULL, CAST(2000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (58, N'JHTH25039       ', N'1               ', N'电子产品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(8.00 AS Decimal(18, 2)), N'库位一', CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E300C3952F AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E300C3952F AS DateTime), NULL, NULL, NULL, CAST(1600.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (59, N'JHTH25039       ', N'2               ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(8.00 AS Decimal(18, 2)), N'库位一', CAST(200.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E300C39540 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E300C39540 AS DateTime), NULL, NULL, NULL, CAST(1600.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (60, N'CK120120        ', N'HP120396        ', N'销售出库', N'件', CAST(60.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'库位二', CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E600F920F4 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E600F920F4 AS DateTime), NULL, NULL, N'1', CAST(5000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (61, N'PD28066         ', N'3               ', N'电子产品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), N'库位四', CAST(300.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E600FAA3AC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E600FAA3AC AS DateTime), NULL, NULL, NULL, CAST(3000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (62, N'DB28022         ', N'1               ', N'电子产品', N'箱', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位二', CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E600FBCAFC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E600FBCAFC AS DateTime), NULL, NULL, NULL, CAST(2000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (63, N'DB28022         ', N'2               ', N'智能手机', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), N'库位二', CAST(200.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E600FBCAFC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E600FBCAFC AS DateTime), NULL, NULL, NULL, CAST(4000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (64, N'JHTH28063       ', N'HP120390        ', N'服装', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'A1    ', CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E6011B2B43 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E6011B2B43 AS DateTime), NULL, NULL, NULL, CAST(5000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (65, N'JHTH28063       ', N'HP120396        ', N'卫衣', N'件', CAST(0.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'A1    ', CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0E6011B2B72 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0E6011B2B72 AS DateTime), NULL, NULL, NULL, CAST(5000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (66, N'JHTH2082        ', N'HP120390        ', N'服装', N'瓶', CAST(0.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'B1    ', CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0EB0151F7BD AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0EB0151F7BD AS DateTime), NULL, NULL, NULL, CAST(5000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (67, N'JHTH2082        ', N'HP120396        ', N'卫衣', N'件', CAST(0.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'B1    ', CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0EB0151F7DB AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0EB0151F7DB AS DateTime), NULL, NULL, NULL, CAST(5000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (68, N'JHTH3086        ', N'HP10567         ', N'女装', N'件', CAST(0.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'B2    ', CAST(200.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0EC00BADF9B AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0EC00BADF9B AS DateTime), NULL, NULL, NULL, CAST(10000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (69, N'JHTH3087        ', N'HP10570         ', N'棉裤1', N'件', CAST(0.00 AS Decimal(18, 2)), CAST(60.00 AS Decimal(18, 2)), N'D1    ', CAST(200.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0EC00EF79E6 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0EC00EF79E6 AS DateTime), NULL, NULL, NULL, CAST(12000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (70, N'CK10153         ', N'HP10580         ', N'销售出库', N'台', CAST(15.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), N'B2    ', CAST(2000.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0ED00F1197C AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0ED00F1197C AS DateTime), NULL, NULL, N'', CAST(20000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (71, N'JHTH4090        ', N'HP10580         ', N'智能', N'台', CAST(0.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), N'库位二', CAST(2000.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0ED00F202E1 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0ED00F202E1 AS DateTime), NULL, NULL, NULL, CAST(100000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (72, N'DB4035          ', N'HP10580         ', N'智能', N'台', CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'B2    ', CAST(2000.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0ED00F40E84 AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0ED00F40E84 AS DateTime), NULL, NULL, NULL, CAST(200000.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_outbill_d] ([outbill_d_id], [outbill_code], [item_code], [item_type], [unit], [sale_num], [outbill_num], [area_code], [sale_price], [batch_no], [product_date], [barcode], [create_by], [create_time], [update_time], [update_by], [remark], [zong], [is_del]) VALUES (73, N'DB4036          ', N'HP10580         ', N'智能', N'台', CAST(0.00 AS Decimal(18, 2)), CAST(60.00 AS Decimal(18, 2)), N'库位一', CAST(2000.00 AS Decimal(18, 2)), NULL, CAST(0x0000B0ED00F4E3CC AS DateTime), NULL, N'罗桓杰', CAST(0x0000B0ED00F4E3CC AS DateTime), NULL, NULL, NULL, CAST(120000.00 AS Decimal(18, 2)), N'0')
SET IDENTITY_INSERT [dbo].[Wh_outbill_d] OFF
SET IDENTITY_INSERT [dbo].[Wh_outbill_h] ON 

INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (1, N'665             ', N'销售出库', CAST(0x0000B0D101051E18 AS DateTime), N'                ', N'客户三  ', N'李依依', N'18788776646', N'罗桓杰', N'仓库二  ', N'罗桓杰', CAST(0x0000B0D1011F14F8 AS DateTime), CAST(0x0000B0D600000000 AS DateTime), N'罗桓杰', N'2', N'罗桓杰', CAST(0x0000B0D600000000 AS DateTime), N'11111', N'2', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (11, N'CK12030         ', N'销售出库', CAST(0x0000B0D500F54C18 AS DateTime), N'XS123456        ', N'客户一  ', N'李依依', N'19099003838', N'罗桓杰', N'仓库二  ', N'罗桓杰', CAST(0x0000B0D500F558FC AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0D600000000 AS DateTime), N'222', N'2', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (19, N'CK12039         ', N'销售出库', CAST(0x0000B0D500FB78F4 AS DateTime), N'XS123456        ', N'客户一  ', N'李依依', N'19099003838', N'罗桓杰', N'仓库二  ', N'罗桓杰', CAST(0x0000B0D500FB8830 AS DateTime), CAST(0x0000B0D600000000 AS DateTime), N'罗桓杰', NULL, NULL, NULL, N'1111', N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (20, N'CK12046         ', N'销售出库', CAST(0x0000B0D60000F03C AS DateTime), N'XS123456        ', N'客户一  ', N'李依依', N'19099003838', N'罗桓杰', N'仓库二  ', N'罗桓杰', CAST(0x0000B0D600011238 AS DateTime), CAST(0x0000B0D600000000 AS DateTime), N'刘子怡', N'2', N'罗桓杰', CAST(0x0000B0EC00000000 AS DateTime), N'呃呃呃呃呃', N'2', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (21, N'CK12047         ', N'销售出库', CAST(0x0000B0D600B72A3C AS DateTime), N'XS789123        ', N'客户二  ', N'李依依', N'17677768656', N'刘子怡', N'仓库二  ', N'罗桓杰', CAST(0x0000B0D600B72C94 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'333', N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (22, N'PD13037         ', N'盘点出库', CAST(0x0000B0D800000000 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', N'仓库四  ', N'罗桓杰', CAST(0x0000B0D800000000 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (25, N'DB16002         ', N'调拨出库', CAST(0x0000B0DC00000000 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', N'仓库一  ', N'罗桓杰', CAST(0x0000B0DC00000000 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (26, N'PD19053         ', N'盘点出库', CAST(0x0000B0DD00000000 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', N'仓库四  ', N'罗桓杰', CAST(0x0000B0DD00000000 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (30, N'5555555555      ', N'退货出库', CAST(0x0000B0E0012969E4 AS DateTime), N'                ', NULL, NULL, NULL, N'黄妍妮', N'仓库二', N'罗桓杰', CAST(0x0000B0E0012979FE AS DateTime), NULL, NULL, NULL, NULL, NULL, N'123', N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (31, N'JHTH19002       ', N'退货出库', CAST(0x0000B0E300A22754 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', N'仓库二', N'罗桓杰', CAST(0x0000B0E300A0AF4F AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0E600000000 AS DateTime), N'123', N'2', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (32, N'9999999999      ', N'退货出库', CAST(0x0000B0E300A12A34 AS DateTime), N'                ', NULL, NULL, NULL, N'黄妍妮', N'仓库二', N'罗桓杰', CAST(0x0000B0E300A132FB AS DateTime), NULL, NULL, NULL, NULL, NULL, N'123', N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (33, N'4444444444      ', N'退货出库', CAST(0x0000B0E300A1D09C AS DateTime), N'                ', NULL, NULL, NULL, N'黄妍妮', N'仓库二', N'罗桓杰', CAST(0x0000B0E300A1DF9F AS DateTime), NULL, NULL, NULL, NULL, NULL, N'12312', N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (34, N'JHTH25036       ', N'退货出库', CAST(0x0000B0E300C0B0E8 AS DateTime), N'                ', NULL, NULL, NULL, N'黄妍妮', N'仓库二', N'罗桓杰', CAST(0x0000B0E300C06981 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'213', N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (35, N'JHTH25035       ', N'退货出库', CAST(0x0000B0E300C20844 AS DateTime), N'                ', NULL, NULL, NULL, N'黄妍妮', N'仓库二', N'罗桓杰', CAST(0x0000B0E300C23247 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'123', N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (36, N'JHTH25037       ', N'退货出库', CAST(0x0000B0E300C2ECC8 AS DateTime), N'                ', NULL, NULL, NULL, N'刘子怡', N'仓库二', N'罗桓杰', CAST(0x0000B0E300C306A3 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'123', N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (37, N'JHTH25039       ', N'退货出库', CAST(0x0000B0E300C3BFB8 AS DateTime), N'                ', NULL, NULL, NULL, N'黄妍妮', N'仓库二', N'罗桓杰', CAST(0x0000B0E300C39508 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'1', N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (38, N'CK120120        ', N'销售出库', CAST(0x0000B0E600F8F46C AS DateTime), N'XS28028         ', N'方俊豪  ', N'方俊豪', N'18974022095', N'刘子怡', N'仓库二  ', N'罗桓杰', CAST(0x0000B0E600F920F4 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'111', N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (39, N'PD28066         ', N'盘点出库', CAST(0x0000B0E600000000 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', N'仓库四  ', N'罗桓杰', CAST(0x0000B0E600000000 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (40, N'DB28022         ', N'调拨出库', CAST(0x0000B0E600000000 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', N'仓库二  ', N'罗桓杰', CAST(0x0000B0E600000000 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (41, N'JHTH28063       ', N'退货出库', CAST(0x0000B0E6011B15EC AS DateTime), N'                ', NULL, NULL, NULL, N'刘子怡', N'司马里仓', N'罗桓杰', CAST(0x0000B0E6011B2B19 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'1123', N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (42, N'JHTH2082        ', N'退货出库', CAST(0x0000B0EB0151D208 AS DateTime), N'                ', NULL, NULL, NULL, N'黄妍妮', N'蔡锷仓', N'罗桓杰', CAST(0x0000B0EB0151F7A2 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'12qw', N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (43, N'JHTH3086        ', N'退货出库', CAST(0x0000B0EC00BAC480 AS DateTime), N'                ', NULL, NULL, NULL, N'余开学', N'仓库七', N'罗桓杰', CAST(0x0000B0EC00BADF7C AS DateTime), NULL, NULL, NULL, NULL, NULL, N'78', N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (44, N'JHTH3087        ', N'退货出库', CAST(0x0000B0EC00EF67E4 AS DateTime), N'                ', NULL, NULL, NULL, N'余开学', N'芙蓉仓', N'罗桓杰', CAST(0x0000B0EC00EF79C8 AS DateTime), NULL, NULL, NULL, NULL, NULL, N'234', N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (45, N'CK10153         ', N'销售出库', CAST(0x0000B0ED00F0F528 AS DateTime), N'XS4048          ', N'客户五  ', N'牛逼', N'19918026397', N'刘子怡', N'仓库七  ', N'罗桓杰', CAST(0x0000B0ED00F1197C AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0ED00000000 AS DateTime), N'1', N'2', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (46, N'JHTH4090        ', N'退货出库', CAST(0x0000B0ED00F1F11C AS DateTime), N'                ', NULL, NULL, NULL, N'易蕾', N'仓库二', N'罗桓杰', CAST(0x0000B0ED00F202BF AS DateTime), NULL, NULL, NULL, NULL, NULL, N'123', N'0', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (47, N'DB4035          ', N'调拨出库', CAST(0x0000B0ED00000000 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', N'仓库七  ', N'罗桓杰', CAST(0x0000B0ED00000000 AS DateTime), NULL, NULL, N'2', N'罗桓杰', CAST(0x0000B0ED00000000 AS DateTime), NULL, N'2', N'0')
INSERT [dbo].[Wh_outbill_h] ([outbill_h_id], [outbill_code], [outbill_type], [outbill_date], [sale_code], [cust_code], [link_man], [link_way], [duty_man], [ware_code], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [sure_date], [remark], [outbill_state], [is_del]) VALUES (48, N'DB4036          ', N'调拨出库', CAST(0x0000B0ED00000000 AS DateTime), N'                ', NULL, NULL, NULL, N'罗桓杰', N'仓库三  ', N'罗桓杰', CAST(0x0000B0ED00000000 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'0', N'0')
SET IDENTITY_INSERT [dbo].[Wh_outbill_h] OFF
SET IDENTITY_INSERT [dbo].[Wh_return_supply_d] ON 

INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (33, N'4444444444      ', N'1               ', N'货品一', NULL, CAST(5.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), N'0', N'blue', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (34, N'4444444444      ', N'2               ', N'货品二', NULL, CAST(5.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), N'0', N'blue', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (41, N'1111111111      ', N'333             ', N'货品二', NULL, CAST(6.00 AS Decimal(18, 2)), CAST(3000.00 AS Decimal(18, 2)), CAST(18000.00 AS Decimal(18, 2)), N'0', N'红', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (42, N'1111111111      ', N'555             ', N'货品四', NULL, CAST(6.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), N'0', N'黄', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (43, N'1111111111      ', N'5               ', N'货品五', NULL, CAST(6.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), CAST(2400.00 AS Decimal(18, 2)), N'0', N'blur ', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (46, N'3333333333      ', N'3               ', N'货品三', NULL, CAST(3.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(900.00 AS Decimal(18, 2)), N'0', N'blur', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (47, N'3333333333      ', N'2               ', N'货品二', NULL, CAST(7.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(1400.00 AS Decimal(18, 2)), N'0', N'blue', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (48, N'9999999999      ', N'66              ', N'货品五', NULL, CAST(20.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), N'0', N'白', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (49, N'JHTH19002       ', N'3               ', N'货品三', NULL, CAST(7.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(2100.00 AS Decimal(18, 2)), N'0', N'blur', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (50, N'JHTH19002       ', N'2               ', N'货品二', NULL, CAST(7.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(1400.00 AS Decimal(18, 2)), N'0', N'blue', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (51, N'2222222222      ', N'3               ', N'货品三', NULL, CAST(3.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(900.00 AS Decimal(18, 2)), N'0', N'blur', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (52, N'2222222222      ', N'2               ', N'货品二', NULL, CAST(4.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(800.00 AS Decimal(18, 2)), N'0', N'blue', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (53, N'JHTH25029       ', N'333             ', N'货品二', CAST(0.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), CAST(3000.00 AS Decimal(18, 2)), CAST(30000.00 AS Decimal(18, 2)), N'0', N'红', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (54, N'JHTH25029       ', N'555             ', N'货品四', CAST(0.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), N'0', N'黄', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (55, N'JHTH25029       ', N'5               ', N'货品五', CAST(0.00 AS Decimal(18, 2)), CAST(30.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), CAST(12000.00 AS Decimal(18, 2)), N'0', N'blur ', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (56, N'JHTH25035       ', N'333             ', N'货品二', CAST(100.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), CAST(3000.00 AS Decimal(18, 2)), CAST(60000.00 AS Decimal(18, 2)), N'0', N'红', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (57, N'JHTH25035       ', N'555             ', N'货品四', CAST(50.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), N'0', N'黄', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (58, N'JHTH25035       ', N'5               ', N'货品五', CAST(30.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), N'0', N'blur ', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (59, N'JHTH25036       ', N'3               ', N'货品三', CAST(-2.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), N'0', N'blur', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (60, N'JHTH25036       ', N'2               ', N'货品二', CAST(7.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), N'0', N'blue', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (61, N'JHTH25037       ', N'3               ', N'货品三', CAST(10.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(3000.00 AS Decimal(18, 2)), N'0', N'blur', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (62, N'JHTH25037       ', N'2               ', N'货品二', CAST(10.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), N'0', N'blue', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (63, N'JHTH25039       ', N'1               ', N'货品一', CAST(3.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'blue', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (64, N'JHTH25039       ', N'2               ', N'货品二', CAST(3.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), N'0', N'blue', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (78, N'5555555555      ', N'1               ', N'货品一', NULL, CAST(6.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), N'0', N'blue', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (79, N'JHTH28063       ', N'HP120396        ', N'衣', CAST(150.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)), N'0', N'130', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (80, N'JHTH28063       ', N'HP120390        ', N'沐浴', CAST(50.00 AS Decimal(18, 2)), CAST(60.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(6000.00 AS Decimal(18, 2)), N'0', N'bule', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (81, N'JHTH29069       ', N'HP120397        ', N'波鞋', CAST(20.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), CAST(321.00 AS Decimal(18, 2)), CAST(3210.00 AS Decimal(18, 2)), N'0', N'1', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (82, N'JHTH29069       ', N'HP120423        ', N'棉服', CAST(30.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), CAST(122.00 AS Decimal(18, 2)), CAST(1220.00 AS Decimal(18, 2)), N'0', N'12', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (83, N'JHTH29069       ', N'HP120429        ', N'AFS', CAST(2.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(213.00 AS Decimal(18, 2)), CAST(213.00 AS Decimal(18, 2)), N'0', N'123', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (84, N'JHTH2074        ', N'HP120396        ', N'衣', CAST(200.00 AS Decimal(18, 2)), CAST(6.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), N'0', N'130', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (85, N'JHTH2074        ', N'HP120390        ', N'沐浴', CAST(100.00 AS Decimal(18, 2)), CAST(6.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), N'0', N'bule', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (88, N'JHTH2075        ', N'HP10567         ', N'羽绒服', NULL, CAST(60.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(12000.00 AS Decimal(18, 2)), N'0', N'12', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (89, N'JHTH2075        ', N'HP10550         ', N'无糖可乐', NULL, CAST(50.00 AS Decimal(18, 2)), CAST(123.00 AS Decimal(18, 2)), CAST(6150.00 AS Decimal(18, 2)), N'0', N'12', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (90, N'JHTH2082        ', N'HP120396        ', N'衣', CAST(150.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)), N'0', N'130', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (91, N'JHTH2082        ', N'HP120390        ', N'沐浴', CAST(50.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)), N'0', N'bule', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (92, N'JHTH2084        ', N'HP10567         ', N'羽绒服', CAST(200.00 AS Decimal(18, 2)), CAST(55.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(11000.00 AS Decimal(18, 2)), N'0', N'12', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (93, N'JHTH2084        ', N'HP10550         ', N'无糖可乐', CAST(100.00 AS Decimal(18, 2)), CAST(55.00 AS Decimal(18, 2)), CAST(123.00 AS Decimal(18, 2)), CAST(6765.00 AS Decimal(18, 2)), N'0', N'12', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (94, N'JHTH2085        ', N'HP120397        ', N'波鞋', CAST(20.00 AS Decimal(18, 2)), CAST(11.00 AS Decimal(18, 2)), CAST(321.00 AS Decimal(18, 2)), CAST(3531.00 AS Decimal(18, 2)), N'0', N'1', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (95, N'JHTH2085        ', N'HP120423        ', N'棉服', CAST(30.00 AS Decimal(18, 2)), CAST(11.00 AS Decimal(18, 2)), CAST(122.00 AS Decimal(18, 2)), CAST(1342.00 AS Decimal(18, 2)), N'0', N'12', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (96, N'JHTH2085        ', N'HP120429        ', N'AFS', CAST(2.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(213.00 AS Decimal(18, 2)), CAST(213.00 AS Decimal(18, 2)), N'0', N'123', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (97, N'JHTH3086        ', N'HP10567         ', N'羽绒服', CAST(50.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(10000.00 AS Decimal(18, 2)), N'0', N'12', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (98, N'JHTH3087        ', N'HP10570         ', N'睡裤', CAST(90.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(10000.00 AS Decimal(18, 2)), N'0', N'12', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (99, N'JHTH4088        ', N'HP10574         ', N'哔哔机', CAST(200.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(10000.00 AS Decimal(18, 2)), N'0', N'2*3', N'0')
INSERT [dbo].[Wh_return_supply_d] ([item_codeId], [returns_code], [item_code], [item_name], [inbill3_num], [return_goods_num], [buy_price], [return_money], [batch_no], [model_code], [is_del]) VALUES (100, N'JHTH4090        ', N'HP10580         ', N'华为', CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), CAST(200000.00 AS Decimal(18, 2)), N'0', N'12', N'0')
SET IDENTITY_INSERT [dbo].[Wh_return_supply_d] OFF
SET IDENTITY_INSERT [dbo].[Wh_return_supply_h] ON 

INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (2, N'2222222222      ', N'123456          ', N'0', CAST(0x0000B0D000950D6C AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'刘子怡', CAST(7.00 AS Decimal(18, 2)), CAST(1700.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), N'阿斯达的', N'罗桓杰', CAST(0x0000B0D00095209C AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'啊实打实的123', N'123', CAST(0x0000B0D701454F7C AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (4, N'4444444444      ', N'6665654         ', N'4', CAST(0x0000B0D600BD9084 AS DateTime), N'供应商三 ', N'李依依', N'16689849373', N'黄妍妮', CAST(10.00 AS Decimal(18, 2)), CAST(1500.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'777777', N'罗桓杰', CAST(0x0000B0D600BDA95E AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'777777', N'阿斯顿撒旦123', CAST(0x0000B0D7014E0178 AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (5, N'5555555555      ', N'888             ', N'2', CAST(0x0000B0D7009A47B4 AS DateTime), N'供应商一 ', N'李依依', N'18918918998', N'刘子怡', CAST(6.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0D7009A4DB1 AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'123', N'123123123', CAST(0x0000B0D7014B79D1 AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (6, N'1111111111      ', N'2               ', N'2', CAST(0x0000B0D70118AEB0 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'小看', CAST(18.00 AS Decimal(18, 2)), CAST(21000.00 AS Decimal(18, 2)), CAST(3500.00 AS Decimal(18, 2)), N'轻微去翁', N'罗桓杰', CAST(0x0000B0D70118C189 AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'灌灌灌灌灌过', N'123', CAST(0x0000B0E300C35853 AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (7, N'3333333333      ', N'123456          ', N'1', CAST(0x0000B0D7014E59C0 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'刘子怡', CAST(10.00 AS Decimal(18, 2)), CAST(2300.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), N'777', N'罗桓杰', CAST(0x0000B0D7014E625B AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'777', N'·12', CAST(0x0000B0DF00EBFA1B AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (8, N'9999999999      ', N'4               ', N'3', CAST(0x0000B0D80097F6BC AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'小看', CAST(20.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0D80097FE52 AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'123', N'123', CAST(0x0000B0E000FBE50C AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (9, N'JHTH19002       ', N'123456          ', N'3', CAST(0x0000B0DD00FB92BC AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'刘子怡', CAST(14.00 AS Decimal(18, 2)), CAST(3500.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), N'12312', N'罗桓杰', CAST(0x0000B0DD00FB9A82 AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'123', N'123', CAST(0x0000B0E000FD486D AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (10, N'JHTH25029       ', N'2               ', N'0', CAST(0x0000B0E300BC9238 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'小看', CAST(60.00 AS Decimal(18, 2)), CAST(44000.00 AS Decimal(18, 2)), CAST(3500.00 AS Decimal(18, 2)), N'2', N'罗桓杰', CAST(0x0000B0E300BCA08A AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (11, N'JHTH25035       ', N'2               ', N'3', CAST(0x0000B0E300BD85F8 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'小看', CAST(35.00 AS Decimal(18, 2)), CAST(63000.00 AS Decimal(18, 2)), CAST(3500.00 AS Decimal(18, 2)), N'2', N'罗桓杰', CAST(0x0000B0E300BD94B8 AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'2', N'123', CAST(0x0000B0E300BDB8F0 AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (12, N'JHTH25036       ', N'123456          ', N'3', CAST(0x0000B0E300BF8F74 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'刘子怡', CAST(4.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), N'222', N'罗桓杰', CAST(0x0000B0E300BFABF7 AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'222', N'123', CAST(0x0000B0E300C014F4 AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (13, N'JHTH25037       ', N'123456          ', N'4', CAST(0x0000B0E300C2AEAC AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'刘子怡', CAST(20.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), N'2', N'罗桓杰', CAST(0x0000B0E300C2BADD AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'2', N'123', CAST(0x0000B0E300C2E582 AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (14, N'JHTH25039       ', N'6665654         ', N'3', CAST(0x0000B0E300C345D8 AS DateTime), N'供应商三 ', N'李依依', N'16689849373', N'黄妍妮', CAST(4.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'3', N'罗桓杰', CAST(0x0000B0E300C34EB4 AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'3', N'123', CAST(0x0000B0E300C379A7 AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (15, N'JHTH28046       ', N'JH2023050       ', N'0', CAST(0x0000B0E600F7E5B8 AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'刘子怡', CAST(100.00 AS Decimal(18, 2)), CAST(10000.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E600F7F6DA AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (16, N'JHTH28046       ', N'JH2023050       ', N'0', CAST(0x0000B0E600F7E5B8 AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'刘子怡', CAST(100.00 AS Decimal(18, 2)), CAST(10000.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E600F7FD07 AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (17, N'JHTH28046       ', N'JH2023050       ', N'0', CAST(0x0000B0E600F7E5B8 AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'刘子怡', CAST(90.00 AS Decimal(18, 2)), CAST(9000.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E600F8055D AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (18, N'JHTH28046       ', N'JH2023050       ', N'0', CAST(0x0000B0E600F7E5B8 AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'刘子怡', CAST(84.00 AS Decimal(18, 2)), CAST(8400.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E600F80E70 AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (19, N'JHTH28046       ', N'JH2023050       ', N'0', CAST(0x0000B0E600F7E5B8 AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'刘子怡', CAST(84.00 AS Decimal(18, 2)), CAST(8400.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E600F80F53 AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (20, N'JHTH28046       ', N'JH2023050       ', N'0', CAST(0x0000B0E600F7E5B8 AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'刘子怡', CAST(84.00 AS Decimal(18, 2)), CAST(8400.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E600F80F8B AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (21, N'JHTH28046       ', N'JH2023050       ', N'0', CAST(0x0000B0E600F7E5B8 AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'刘子怡', CAST(84.00 AS Decimal(18, 2)), CAST(8400.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E600F8187A AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (22, N'JHTH28046       ', N'JH2023050       ', N'0', CAST(0x0000B0E600F7E5B8 AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'刘子怡', CAST(84.00 AS Decimal(18, 2)), CAST(8400.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E600F81EAE AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (23, N'JHTH28047       ', N'JH2023039       ', N'0', CAST(0x0000B0E601022460 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'罗桓杰', CAST(150.00 AS Decimal(18, 2)), CAST(25000.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E6010243F1 AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (24, N'JHTH28047       ', N'JH2023039       ', N'0', CAST(0x0000B0E601022460 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'罗桓杰', CAST(150.00 AS Decimal(18, 2)), CAST(25000.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E601024AC7 AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (25, N'JHTH28047       ', N'2131231231      ', N'0', CAST(0x0000B0E601022460 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'罗桓杰', CAST(1.00 AS Decimal(18, 2)), CAST(3123.00 AS Decimal(18, 2)), CAST(3123.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E60102D3AC AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (26, N'JHTH28047       ', N'2131231231      ', N'0', CAST(0x0000B0E601022460 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'罗桓杰', CAST(1.00 AS Decimal(18, 2)), CAST(3123.00 AS Decimal(18, 2)), CAST(3123.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E60102D454 AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (27, N'JHTH28047       ', N'JH2023039       ', N'0', CAST(0x0000B0E601022460 AS DateTime), N'供应商二 ', N'李依依', N'18788393737', N'罗桓杰', CAST(150.00 AS Decimal(18, 2)), CAST(25000.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E60102DD42 AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (28, N'JHTH28062       ', N'JH2023050       ', N'0', CAST(0x0000B0E601158BF4 AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'刘子怡', CAST(110.00 AS Decimal(18, 2)), CAST(11000.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E60115B893 AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (29, N'JHTH28062       ', N'JH2023050       ', N'0', CAST(0x0000B0E601158BF4 AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'刘子怡', CAST(110.00 AS Decimal(18, 2)), CAST(11000.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E6011629B9 AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (30, N'JHTH28062       ', N'JH2023050       ', N'0', CAST(0x0000B0E601158BF4 AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'刘子怡', CAST(110.00 AS Decimal(18, 2)), CAST(11000.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E6011629F3 AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (31, N'JHTH28062       ', N'JH2023050       ', N'0', CAST(0x0000B0E601158BF4 AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'刘子怡', CAST(110.00 AS Decimal(18, 2)), CAST(11000.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E601162DDD AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (32, N'JHTH28063       ', N'JH2023050       ', N'3', CAST(0x0000B0E60116E350 AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'刘子怡', CAST(110.00 AS Decimal(18, 2)), CAST(11000.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'12', N'罗桓杰', CAST(0x0000B0E60116EAC2 AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'123', N'123', CAST(0x0000B0E60117192B AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (33, N'JHTH29069       ', N'JH2023067       ', N'2', CAST(0x0000B0E700B7F3CC AS DateTime), N'供应商三 ', N'李依依', N'16689849373', N'刘子怡', CAST(21.00 AS Decimal(18, 2)), CAST(4643.00 AS Decimal(18, 2)), CAST(656.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0E700B80645 AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'123', N'通过', CAST(0x0000B0E700B87D15 AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (34, N'JHTH2074        ', N'JH2023050       ', N'0', CAST(0x0000B0EB01250868 AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'刘子怡', CAST(12.00 AS Decimal(18, 2)), CAST(1200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0EB01250EC8 AS DateTime), NULL, NULL, NULL, NULL, N'123', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (35, N'JHTH2075        ', N'JH2024074       ', N'2', CAST(0x0000B0EB014EB2D0 AS DateTime), N'小米     ', N'小白', N'13232323223', N'余开学', CAST(110.00 AS Decimal(18, 2)), CAST(18150.00 AS Decimal(18, 2)), CAST(323.00 AS Decimal(18, 2)), N'1', N'罗桓杰', CAST(0x0000B0EB014EBE45 AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'123', N'通过', CAST(0x0000B0EB014EDC91 AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (36, N'JHTH2082        ', N'JH2023050       ', N'3', CAST(0x0000B0EB01510620 AS DateTime), N'华为     ', N'李媛媛', N'18974022095', N'刘子怡', CAST(100.00 AS Decimal(18, 2)), CAST(10000.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0EB01511BBD AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'123', N'通过', CAST(0x0000B0EB0151750C AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (37, N'JHTH2084        ', N'JH2024074       ', N'0', CAST(0x0000B0EB01518384 AS DateTime), N'小米     ', N'小白', N'13232323223', N'余开学', CAST(110.00 AS Decimal(18, 2)), CAST(17765.00 AS Decimal(18, 2)), CAST(323.00 AS Decimal(18, 2)), N'2', N'罗桓杰', CAST(0x0000B0EB01518AFC AS DateTime), NULL, NULL, NULL, NULL, N'2', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (38, N'JHTH2085        ', N'JH2023067       ', N'0', CAST(0x0000B0EB0151A328 AS DateTime), N'供应商三 ', N'李依依', N'16689849373', N'刘子怡', CAST(23.00 AS Decimal(18, 2)), CAST(5086.00 AS Decimal(18, 2)), CAST(656.00 AS Decimal(18, 2)), N'12', N'罗桓杰', CAST(0x0000B0EB0151B5BD AS DateTime), NULL, NULL, NULL, NULL, N'21', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (39, N'JHTH3086        ', N'JH2024075       ', N'3', CAST(0x0000B0EC00BA8FC4 AS DateTime), N'小米     ', N'小白', N'13232323223', N'刘子怡', CAST(50.00 AS Decimal(18, 2)), CAST(10000.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0EC00BAA933 AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'132', N'通过', CAST(0x0000B0EC00BABD9D AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (40, N'JHTH3087        ', N'JH2024076       ', N'3', CAST(0x0000B0EC00EF496C AS DateTime), N'iqoo     ', N'李依依', N'13203023738', N'刘子怡', CAST(50.00 AS Decimal(18, 2)), CAST(10000.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0EC00EF51A9 AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'23', N'通过', CAST(0x0000B0EC00EF586D AS DateTime), N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (41, N'JHTH4088        ', N'JH2024077       ', N'0', CAST(0x0000B0ED00CFF06C AS DateTime), N'iqoo     ', N'李依依', N'13203023738', N'易蕾', CAST(100.00 AS Decimal(18, 2)), CAST(10000.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'567', N'罗桓杰', CAST(0x0000B0ED00CFFC19 AS DateTime), NULL, NULL, NULL, NULL, N'456', NULL, NULL, N'0')
INSERT [dbo].[Wh_return_supply_h] ([buy_codeId], [returns_code], [buy_code], [sale_state], [sr_date], [supply_code], [link_man], [link_way], [buy_man], [returns_num], [returns_money], [buy_price], [remark], [create_by], [create_time], [update_time], [update_by], [sure_state], [sure_man], [remarks], [sure_yj], [sure_date], [is_del]) VALUES (42, N'JHTH4090        ', N'JH2024079       ', N'3', CAST(0x0000B0ED00F1DC04 AS DateTime), N'苹果     ', N'李依依', N'13232323222', N'刘子怡', CAST(100.00 AS Decimal(18, 2)), CAST(200000.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), N'123', N'罗桓杰', CAST(0x0000B0ED00F1E749 AS DateTime), NULL, NULL, NULL, N'罗桓杰', N'123', N'通过', CAST(0x0000B0ED00F1ED50 AS DateTime), N'0')
SET IDENTITY_INSERT [dbo].[Wh_return_supply_h] OFF
SET IDENTITY_INSERT [dbo].[Wh_sale_d] ON 

INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (3, N'XS456123        ', N'货品二', N'2               ', N'blue', N'瓶', N'手机', CAST(9.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'一次')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (4, N'XS456123        ', N'货品一', N'1               ', N'blue', N'箱', N'电子产品', CAST(9.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'二次')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (8, N'XS987654        ', N'货品一', N'1               ', N'blue', N'箱', N'电子产品', CAST(9.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'阿萨德1')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (9, N'XS987654        ', N'货品二', N'2               ', N'blue', N'瓶', N'手机', CAST(9.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'阿萨德3')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (10, N'XS987654        ', N'货品三', N'3               ', N'blur', N'箱', N'智能手机', CAST(9.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'阿萨德22')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (11, N'XS987654        ', N'货品四', N'4               ', N'blur', N'瓶', N'手机', CAST(9.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'阿萨德2')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (16, N'XS123123        ', N'货品三', N'3               ', N'blur', N'箱', N'智能手机', CAST(6.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'测试1')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (17, N'XS123123        ', N'货品四', N'4               ', N'blur', N'瓶', N'手机', CAST(10.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'测试2')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (18, N'XS123123        ', N'货品一', N'1               ', N'blue', N'箱', N'电子产品', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (19, N'XS123456        ', N'货品二', N'2               ', N'blue', N'箱', N'饮品', CAST(10.00 AS Decimal(18, 2)), CAST(8.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'777')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (20, N'XS789123        ', N'货品一', N'1               ', N'blue', N'箱', N'电子产品', CAST(1.00 AS Decimal(18, 2)), CAST(25.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'666')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (21, N'XS789123        ', N'货品二', N'2               ', N'blue', N'瓶', N'手机', CAST(2.00 AS Decimal(18, 2)), CAST(25.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'666')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (22, N'XS789123        ', N'货品三', N'3               ', N'blur', N'箱', N'智能手机', CAST(3.00 AS Decimal(18, 2)), CAST(25.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'666')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (24, N'XS777888        ', N'货品二', N'2               ', N'blue', N'瓶', N'智能手机', CAST(10.00 AS Decimal(18, 2)), CAST(36.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'小内资')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (25, N'XS777888        ', N'货品三', N'3               ', N'blur', N'箱', N'手机', CAST(2.00 AS Decimal(18, 2)), CAST(36.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'2')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (26, N'XS777888        ', N'货品四', N'4               ', N'blur', N'瓶', N'智能电视', CAST(3.00 AS Decimal(18, 2)), CAST(36.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'2')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (29, N'XS19004         ', N'货品五', N'5               ', N'blur ', N'瓶', N'显示器', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), N'0', N'77123')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (30, N'XS22013         ', N'货品五', N'5               ', N'blur ', N'瓶', N'显示器', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), N'0', N'3')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (31, N'XS22013         ', N'货品一', N'1               ', N'blue', N'箱', N'电子产品', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'3')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (32, N'XS22013         ', N'货品二', N'2               ', N'blue', N'瓶', N'智能手机', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'2')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (33, N'XS22013         ', N'货品四', N'4               ', N'blur', N'瓶', N'智能电视', CAST(7.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'1')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (34, N'XS28021         ', N'鼠标', N'HP120219        ', N'2*2', N'瓶', N'电子产品', CAST(15.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'12')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (35, N'XS28021         ', N'bb', N'HP120250        ', N'123', N'瓶', N'手机', CAST(15.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(123.00 AS Decimal(18, 2)), N'0', N'12')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (36, N'XS28021         ', N'口红', N'HP120253        ', N'4cm', N'箱', N'电视', CAST(5.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'12')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (37, N'XS28022         ', N'柜子', N'HP120387        ', N'120*3', N'瓶', N'男装', CAST(10.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (38, N'XS28022         ', N'尿不湿', N'HP120388        ', N'3*6', N'箱', N'裙子', CAST(30.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (39, N'XS28022         ', N'洗发水', N'HP120389        ', N'100*3', N'瓶', N'裙子', CAST(30.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (40, N'XS28022         ', N'沐浴', N'HP120390        ', N'bule', N'瓶', N'裙子', CAST(30.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (42, N'XS28028         ', N'衣', N'HP120396        ', N'130', N'件', N'卫衣', CAST(60.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'7')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (46, N'XS29035         ', N'衣', N'HP120396        ', N'130', N'件', N'卫衣', CAST(10.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'2')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (47, N'XS28031         ', N'洗发水', N'HP120389        ', N'100*3', N'瓶', N'裙子', CAST(31.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0', N'1')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (48, N'XS28031         ', N'沐浴', N'HP120390        ', N'bule', N'瓶', N'服装', CAST(50.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0', N'2')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (49, N'XS2040          ', N'无糖可乐', N'HP10550         ', N'12', N'瓶', N'百世可乐1', CAST(50.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(123.00 AS Decimal(18, 2)), N'0', N'13')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (50, N'XS2040          ', N'羽绒服', N'HP10567         ', N'12', N'件', N'女装', CAST(50.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (51, N'XS2041          ', N'羽绒服', N'HP10567         ', N'12', N'件', N'女装', CAST(50.00 AS Decimal(18, 2)), CAST(80.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (52, N'XS2041          ', N'无糖可乐', N'HP10550         ', N'12', N'瓶', N'百世可乐1', CAST(50.00 AS Decimal(18, 2)), CAST(80.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(123.00 AS Decimal(18, 2)), N'0', N'123')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (53, N'XS4045          ', N'睡裤', N'HP10570         ', N'12', N'件', N'棉裤1', CAST(100.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0', N'')
INSERT [dbo].[Wh_sale_d] ([sale_codeId], [sale_code], [item_name], [item_code], [model_code], [unit], [item_type_name], [inbill3_num], [return_num], [outbill_num], [sale_price], [is_del], [remark]) VALUES (54, N'XS4048          ', N'华为', N'HP10580         ', N'12', N'台', N'智能', CAST(15.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), N'0', N'')
SET IDENTITY_INSERT [dbo].[Wh_sale_d] OFF
SET IDENTITY_INSERT [dbo].[Wh_sale_h] ON 

INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (2, N'XS123456        ', N'3', CAST(0x0000B0D500000000 AS DateTime), N'客户一  ', N'李依依', N'19099003838', N'罗桓杰', N'罗桓杰', CAST(0x0000B0CB00000000 AS DateTime), N'罗桓杰', CAST(0x0000B0CB00000000 AS DateTime), N'0', N'123采购采购', NULL)
INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (3, N'XS456123        ', N'0', CAST(0x0000B0D500E746A4 AS DateTime), N'客户三  ', N'李依依', N'18788776646', N'黄妍妮', N'罗桓杰', CAST(0x0000B0D500E76C64 AS DateTime), NULL, NULL, N'0', N'第一次', NULL)
INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (4, N'XS789123        ', N'3', CAST(0x0000B0D500EFFCB8 AS DateTime), N'客户二  ', N'李依依', N'17677768656', N'刘子怡', N'罗桓杰', CAST(0x0000B0D500F0141E AS DateTime), N'罗桓杰', CAST(0x0000B0D600B67CE1 AS DateTime), N'0', N'good', N'付一次次次次')
INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (5, N'XS987654        ', N'0', CAST(0x0000B0D700000000 AS DateTime), N'客户一  ', N'李依依', N'19099003838', N'易蕾', N'罗桓杰', CAST(0x0000B0D501210FCB AS DateTime), N'罗桓杰', CAST(0x0000B0D600B76089 AS DateTime), N'0', N'第三次', N'123')
INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (6, N'XS123123        ', N'1', CAST(0x0000B0D600000000 AS DateTime), N'客户二  ', N'李依依', N'17677768656', N'罗桓杰', N'罗桓杰', CAST(0x0000B0D501231EBD AS DateTime), N'罗桓杰', CAST(0x0000B0D600B7AB8B AS DateTime), N'0', N'测试修改1', N'不行不行不不想')
INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (8, N'XS777888        ', N'2', CAST(0x0000B0D600B7E5BC AS DateTime), N'客户三  ', N'李依依', N'18788776646', N'黄妍妮', N'罗桓杰', CAST(0x0000B0D600B800FE AS DateTime), N'罗桓杰', CAST(0x0000B0D6011CB015 AS DateTime), N'0', N'啊实打实的', N'1231')
INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (9, N'XS19004         ', N'0', CAST(0x0000B0DD00FC2088 AS DateTime), N'客户一  ', N'李依依', N'19099003838', N'黄妍妮', N'罗桓杰', CAST(0x0000B0DD00FC32EC AS DateTime), NULL, NULL, N'0', N'123123123123', NULL)
INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (10, N'XS22013         ', N'0', CAST(0x0000B0E000FCB7B4 AS DateTime), N'客户三  ', N'李依依', N'18788776646', N'', N'罗桓杰', CAST(0x0000B0E000FCD977 AS DateTime), NULL, NULL, N'0', N'1123', NULL)
INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (11, N'XS28021         ', N'0', CAST(0x0000B0E600A21944 AS DateTime), N'客户五  ', N'牛逼', N'19918026397', N'罗桓杰', N'罗桓杰', CAST(0x0000B0E600A2360D AS DateTime), NULL, NULL, N'0', N'123', NULL)
INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (12, N'XS28022         ', N'0', CAST(0x0000B0E600A26ED0 AS DateTime), N'客户四  ', N'李欢欢', N'19918026397', N'刘子怡', N'罗桓杰', CAST(0x0000B0E600A28F87 AS DateTime), NULL, NULL, N'0', N'123', NULL)
INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (13, N'XS28028         ', N'3', CAST(0x0000B0E600F846FC AS DateTime), N'方俊豪  ', N'方俊豪', N'18974022095', N'刘子怡', N'罗桓杰', CAST(0x0000B0E600F87708 AS DateTime), N'罗桓杰', CAST(0x0000B0E600F88BC0 AS DateTime), N'0', N'123123', N'234')
INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (14, N'XS28031         ', N'0', CAST(0x0000B0E601150E90 AS DateTime), N'客户五  ', N'牛逼', N'19918026397', N'易蕾', N'罗桓杰', CAST(0x0000B0E601152527 AS DateTime), NULL, NULL, N'0', N'12', NULL)
INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (15, N'XS29035         ', N'2', CAST(0x0000B0E700B89EE4 AS DateTime), N'客户三  ', N'李依依', N'18788776646', N'刘子怡', N'罗桓杰', CAST(0x0000B0E700B8AB2B AS DateTime), N'罗桓杰', CAST(0x0000B0E700B8C510 AS DateTime), N'0', N'123', N'通过')
INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (16, N'XS2040          ', N'2', CAST(0x0000B0EB014E437C AS DateTime), N'李淳风  ', N'小白', N'13203023738', N'刘子怡', N'罗桓杰', CAST(0x0000B0EB014E64F8 AS DateTime), N'罗桓杰', CAST(0x0000B0EB014E9CC8 AS DateTime), N'0', N'123', N'通过')
INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (17, N'XS2041          ', N'2', CAST(0x0000B0EB0152A624 AS DateTime), N'李星云  ', N'天暗星', N'13203023637', N'余开学', N'罗桓杰', CAST(0x0000B0EB0152BAF7 AS DateTime), N'罗桓杰', CAST(0x0000B0EB0152C2CD AS DateTime), N'0', N'123', N'通过')
INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (18, N'XS4045          ', N'0', CAST(0x0000B0ED00E35A58 AS DateTime), N'刘子怡  ', N'罗桓杰', N'13203023738', N'黄妍妮', N'罗桓杰', CAST(0x0000B0ED00E36218 AS DateTime), NULL, NULL, N'0', N'', NULL)
INSERT [dbo].[Wh_sale_h] ([sale_codeId], [sale_code], [sale_state], [sale_date], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [is_del], [remark], [sure_yj]) VALUES (19, N'XS4048          ', N'3', CAST(0x0000B0ED00F03C00 AS DateTime), N'客户五  ', N'牛逼', N'19918026397', N'刘子怡', N'罗桓杰', CAST(0x0000B0ED00F0BE42 AS DateTime), N'罗桓杰', CAST(0x0000B0ED00F0D028 AS DateTime), N'0', N'21', N'通过')
SET IDENTITY_INSERT [dbo].[Wh_sale_h] OFF
SET IDENTITY_INSERT [dbo].[Wh_sale_return_d] ON 

INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (22, N'TH456123        ', N'货品二', N'2               ', CAST(20.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)), NULL, NULL, NULL, CAST(500.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (25, N'TH987654        ', N'货品二', N'2               ', CAST(20.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), N'仓库二  ', N'库位三', NULL, CAST(300.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (53, N'TH123456        ', N'货品二', N'2               ', CAST(20.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(400.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (54, N'TH123456        ', N'货品三', N'3               ', CAST(20.00 AS Decimal(18, 2)), CAST(-1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位三', NULL, CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (55, N'TH123456        ', N'货品四', N'4               ', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (59, N'XSTH19005       ', N'货品二', N'2               ', CAST(10.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(600.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (60, N'XSTH19005       ', N'货品三', N'3               ', CAST(20.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'仓库二  ', N'库位三', NULL, CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (61, N'XSTH19005       ', N'货品四', N'4               ', CAST(30.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(600.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (65, N'XSTH21018       ', N'货品二', N'2               ', CAST(20.00 AS Decimal(18, 2)), CAST(-14.00 AS Decimal(18, 2)), N'仓库二  ', N'库位三', NULL, CAST(1000.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (66, N'XSTH21018       ', N'货品三', N'3               ', CAST(20.00 AS Decimal(18, 2)), CAST(-18.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (67, N'XSTH21018       ', N'货品四', N'4               ', CAST(20.00 AS Decimal(18, 2)), CAST(-17.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(600.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (68, N'XSTH21026       ', N'货品二', N'2               ', CAST(10.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(400.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (69, N'XSTH21026       ', N'货品三', N'3               ', CAST(2.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (70, N'XSTH21026       ', N'货品四', N'4               ', CAST(3.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位三', NULL, CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (72, N'XSTH21028       ', N'货品二', N'2               ', CAST(20.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(200.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (73, N'XSTH21029       ', N'货品一', N'1               ', CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (74, N'XSTH21029       ', N'货品二', N'2               ', CAST(2.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (75, N'XSTH21029       ', N'货品三', N'3               ', CAST(3.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (76, N'XSTH21032       ', N'货品一', N'1               ', CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (77, N'XSTH21032       ', N'货品二', N'2               ', CAST(2.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (78, N'XSTH21032       ', N'货品三', N'3               ', CAST(3.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位三', NULL, CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (79, N'XSTH21033       ', N'货品二', N'2               ', CAST(10.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'仓库一  ', N'库位一', NULL, CAST(400.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (80, N'XSTH21033       ', N'货品三', N'3               ', CAST(2.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库一  ', N'库位三', NULL, CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (81, N'XSTH21033       ', N'货品四', N'4               ', CAST(3.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库一  ', N'库位一', NULL, CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (82, N'XSTH21036       ', N'货品一', N'1               ', CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (83, N'XSTH21036       ', N'货品二', N'2               ', CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (84, N'XSTH21036       ', N'货品三', N'3               ', CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'仓库二  ', N'库位三', NULL, CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (85, N'XSTH21037       ', N'货品一', N'1               ', CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位三', NULL, CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (86, N'XSTH21037       ', N'货品二', N'2               ', CAST(2.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (87, N'XSTH21037       ', N'货品三', N'3               ', CAST(3.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (88, N'XSTH21040       ', N'货品二', N'2               ', CAST(10.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(400.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (89, N'XSTH21040       ', N'货品三', N'3               ', CAST(2.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'仓库二  ', N'库位三', NULL, CAST(600.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (90, N'XSTH21040       ', N'货品四', N'4               ', CAST(3.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(900.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (91, N'XSTH21041       ', N'货品一', N'1               ', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库三  ', N'库位三', NULL, CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (92, N'XSTH21041       ', N'货品二', N'2               ', CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库三  ', N'库位一', NULL, CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (93, N'XSTH21041       ', N'货品三', N'3               ', CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), N'仓库三  ', N'库位三', NULL, CAST(600.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (94, N'XSTH21042       ', N'货品一', N'1               ', CAST(1.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位三', NULL, CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (95, N'XSTH21042       ', N'货品二', N'2               ', CAST(2.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (96, N'XSTH21042       ', N'货品三', N'3               ', CAST(3.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), N'仓库二  ', N'库位一', NULL, CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (97, N'XSTH28047       ', N'衣', N'HP120396        ', CAST(60.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), NULL, NULL, NULL, CAST(1000.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (98, N'XSTH29055       ', N'衣', N'HP120396        ', CAST(10.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)), NULL, NULL, NULL, CAST(500.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (99, N'XSTH2058        ', N'羽绒服', N'HP10567         ', CAST(50.00 AS Decimal(18, 2)), CAST(40.00 AS Decimal(18, 2)), N'蔡锷仓  ', N'B1    ', NULL, CAST(8000.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (100, N'XSTH2058        ', N'无糖可乐', N'HP10550         ', CAST(50.00 AS Decimal(18, 2)), CAST(40.00 AS Decimal(18, 2)), N'蔡锷仓  ', N'B1    ', NULL, CAST(4920.00 AS Decimal(18, 2)), CAST(123.00 AS Decimal(18, 2)), N'0')
INSERT [dbo].[Wh_sale_return_d] ([sr_codeId], [sr_code], [item_name], [item_code], [inbill3_num], [return_num], [ware_code], [area_code], [batch_no], [return_money], [sale_price], [is_del]) VALUES (101, N'XSTH4059        ', N'华为', N'HP10580         ', CAST(15.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), N'仓库二  ', N'A2    ', NULL, CAST(20000.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), N'0')
SET IDENTITY_INSERT [dbo].[Wh_sale_return_d] OFF
SET IDENTITY_INSERT [dbo].[Wh_sale_return_h] ON 

INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (2, N'TH456123        ', CAST(0x0000B0D6014A31B0 AS DateTime), N'XS123456        ', N'客户一  ', N'李依依', N'19099003838', N'罗桓杰', N'罗桓杰', CAST(0x0000B0D6014A3DAD AS DateTime), N'罗桓杰', CAST(0x0000B0D70169F91B AS DateTime), NULL, CAST(100.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), N'1', N'22222222', N'第二次次次123123123', N'123', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (3, N'TH987654        ', CAST(0x0000B0D7009EE4F4 AS DateTime), N'XS123456        ', N'客户一  ', N'李依依', N'19099003838', N'罗桓杰', N'罗桓杰', CAST(0x0000B0D7009EF2A8 AS DateTime), N'罗桓杰', CAST(0x0000B0D7017B94D9 AS DateTime), NULL, CAST(100.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), N'4', N'2第一次不要', N'修改第一次', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (7, N'TH123456        ', CAST(0x0000B0D700F0EE20 AS DateTime), N'XS777888        ', N'客户三  ', N'李依依', N'18788776646', N'黄妍妮', N'罗桓杰', CAST(0x0000B0D700F0F46F AS DateTime), N'罗桓杰', CAST(0x0000B0DF009D07C1 AS DateTime), NULL, CAST(800.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), N'4', N'123123123', N'123123', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (8, N'XSTH19005       ', CAST(0x0000B0DD00FCA4F4 AS DateTime), N'XS777888        ', N'客户三  ', N'李依依', N'18788776646', N'黄妍妮', N'罗桓杰', CAST(0x0000B0DD00FCAE5F AS DateTime), N'罗桓杰', CAST(0x0000B0DF00ECEDAF AS DateTime), NULL, CAST(800.00 AS Decimal(18, 2)), CAST(6.00 AS Decimal(18, 2)), CAST(1500.00 AS Decimal(18, 2)), N'3', N'123', N'123', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (9, N'XSTH21018       ', CAST(0x0000B0DF009E40E4 AS DateTime), N'XS777888        ', N'客户三  ', N'李依依', N'18788776646', N'黄妍妮', N'罗桓杰', CAST(0x0000B0DF009E4FB2 AS DateTime), N'罗桓杰', CAST(0x0000B0DF009E8000 AS DateTime), NULL, CAST(800.00 AS Decimal(18, 2)), CAST(8.00 AS Decimal(18, 2)), CAST(1900.00 AS Decimal(18, 2)), N'3', N'121', N'21', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (10, N'XSTH21026       ', CAST(0x0000B0DF00A16274 AS DateTime), N'XS777888        ', N'客户三  ', N'李依依', N'18788776646', N'黄妍妮', N'罗桓杰', CAST(0x0000B0DF00A16B54 AS DateTime), N'罗桓杰', CAST(0x0000B0DF00A20F12 AS DateTime), NULL, CAST(800.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), N'3', N'123', N'123', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (11, N'XSTH21028       ', CAST(0x0000B0DF00EA5ED4 AS DateTime), N'XS123456        ', N'客户一  ', N'李依依', N'19099003838', N'罗桓杰', N'罗桓杰', CAST(0x0000B0DF00EA6B12 AS DateTime), N'罗桓杰', CAST(0x0000B0DF00EAC170 AS DateTime), NULL, CAST(100.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), N'3', N'123', N'123', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (12, N'XSTH21029       ', CAST(0x0000B0DF00EB6428 AS DateTime), N'XS789123        ', N'客户二  ', N'李依依', N'17677768656', N'刘子怡', N'罗桓杰', CAST(0x0000B0DF00EB6B4E AS DateTime), N'罗桓杰', CAST(0x0000B0E60126B581 AS DateTime), NULL, CAST(600.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), N'2', N'2', N'2', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (13, N'XSTH21032       ', CAST(0x0000B0DF00EE2348 AS DateTime), N'XS789123        ', N'客户二  ', N'李依依', N'17677768656', N'刘子怡', N'罗桓杰', CAST(0x0000B0DF00EE2A1A AS DateTime), N'罗桓杰', CAST(0x0000B0DF013E13D9 AS DateTime), NULL, CAST(600.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), N'4', N'123', N'123', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (14, N'XSTH21033       ', CAST(0x0000B0DF00EFE674 AS DateTime), N'XS777888        ', N'客户三  ', N'李依依', N'18788776646', N'黄妍妮', N'罗桓杰', CAST(0x0000B0DF00EFEC10 AS DateTime), N'罗桓杰', CAST(0x0000B0DF0124809A AS DateTime), NULL, CAST(800.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), N'3', N'123', N'123', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (15, N'XSTH21036       ', CAST(0x0000B0DF011F5698 AS DateTime), N'XS789123        ', N'客户二  ', N'李依依', N'17677768656', N'刘子怡', N'罗桓杰', CAST(0x0000B0DF011F5D88 AS DateTime), N'罗桓杰', CAST(0x0000B0DF011F6C0E AS DateTime), NULL, CAST(600.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), N'4', N'123', N'123', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (16, N'XSTH21037       ', CAST(0x0000B0DF0123A428 AS DateTime), N'XS789123        ', N'客户二  ', N'李依依', N'17677768656', N'刘子怡', N'罗桓杰', CAST(0x0000B0DF0123B348 AS DateTime), N'罗桓杰', CAST(0x0000B0DF0123BAED AS DateTime), NULL, CAST(600.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), N'4', N'123123', N'123312', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (17, N'XSTH21040       ', CAST(0x0000B0DF013EC258 AS DateTime), N'XS777888        ', N'客户三  ', N'李依依', N'18788776646', N'黄妍妮', N'罗桓杰', CAST(0x0000B0DF013ED20E AS DateTime), N'罗桓杰', CAST(0x0000B0DF013ED851 AS DateTime), NULL, CAST(800.00 AS Decimal(18, 2)), CAST(7.00 AS Decimal(18, 2)), CAST(1900.00 AS Decimal(18, 2)), N'3', N'123', N'123', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (18, N'XSTH21041       ', CAST(0x0000B0DF014499A8 AS DateTime), N'XS789123        ', N'客户二  ', N'李依依', N'17677768656', N'刘子怡', N'罗桓杰', CAST(0x0000B0DF0144B33D AS DateTime), N'罗桓杰', CAST(0x0000B0DF0144BF32 AS DateTime), NULL, CAST(600.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(18, 2)), CAST(900.00 AS Decimal(18, 2)), N'4', N'22', N'2', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (19, N'XSTH21042       ', CAST(0x0000B0DF01493238 AS DateTime), N'XS789123        ', N'客户二  ', N'李依依', N'17677768656', N'刘子怡', N'罗桓杰', CAST(0x0000B0DF01493836 AS DateTime), N'罗桓杰', CAST(0x0000B0DF01493D3C AS DateTime), NULL, CAST(600.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), N'4', N'123', N'123', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (20, N'XSTH28047       ', CAST(0x0000B0E601031118 AS DateTime), N'XS28028         ', N'方俊豪  ', N'方俊豪', N'18974022095', N'刘子怡', N'罗桓杰', CAST(0x0000B0E601031704 AS DateTime), N'罗桓杰', CAST(0x0000B0E601181381 AS DateTime), NULL, CAST(100.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), N'2', N'123', N'213', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (21, N'XSTH29055       ', CAST(0x0000B0E700B8DAA8 AS DateTime), N'XS29035         ', N'客户三  ', N'李依依', N'18788776646', N'刘子怡', N'罗桓杰', CAST(0x0000B0E700B8E6EA AS DateTime), N'罗桓杰', CAST(0x0000B0E700B8FB24 AS DateTime), NULL, CAST(100.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), N'2', N'123', N'123', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (22, N'XSTH2058        ', CAST(0x0000B0EB0152D054 AS DateTime), N'XS2041          ', N'李星云  ', N'天暗星', N'13203023637', N'余开学', N'罗桓杰', CAST(0x0000B0EB0152DAF9 AS DateTime), N'罗桓杰', CAST(0x0000B0EB0152EB21 AS DateTime), NULL, CAST(323.00 AS Decimal(18, 2)), CAST(80.00 AS Decimal(18, 2)), CAST(12920.00 AS Decimal(18, 2)), N'3', N'123', N'123', N'', N'0')
INSERT [dbo].[Wh_sale_return_h] ([sr_codeId], [sr_code], [sr_date], [sale_code], [cust_code], [link_man], [link_way], [sale_duty_man], [create_by], [create_time], [sure_man], [sure_date], [sure_state], [buy_price], [return_num], [return_money], [sale_state], [remark], [remarks], [sale_yj], [is_del]) VALUES (23, N'XSTH4059        ', CAST(0x0000B0ED00F23E74 AS DateTime), N'XS4048          ', N'客户五  ', N'牛逼', N'19918026397', N'刘子怡', N'罗桓杰', CAST(0x0000B0ED00F24627 AS DateTime), N'罗桓杰', CAST(0x0000B0ED00F24F88 AS DateTime), NULL, CAST(2000.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), CAST(20000.00 AS Decimal(18, 2)), N'3', N'3', N'', N'', N'0')
SET IDENTITY_INSERT [dbo].[Wh_sale_return_h] OFF
SET IDENTITY_INSERT [dbo].[Wh_transfer_d] ON 

INSERT [dbo].[Wh_transfer_d] ([transfer_d_id], [transfer_code], [wh__transfer_code], [item_code], [model_code], [unit], [outarea_code], [inarea_code], [out_num], [in_num], [inbill_price], [remark]) VALUES (3, N'DB16002         ', NULL, N'1               ', N'blue', N'箱', N'库位一', N'库位三', 20, 20, CAST(100.00 AS Decimal(18, 2)), N'调拨')
INSERT [dbo].[Wh_transfer_d] ([transfer_d_id], [transfer_code], [wh__transfer_code], [item_code], [model_code], [unit], [outarea_code], [inarea_code], [out_num], [in_num], [inbill_price], [remark]) VALUES (4, N'DB16002         ', NULL, N'2               ', N'blue', N'瓶', N'库位一', N'库位三', 10, 10, CAST(200.00 AS Decimal(18, 2)), N'调拨')
INSERT [dbo].[Wh_transfer_d] ([transfer_d_id], [transfer_code], [wh__transfer_code], [item_code], [model_code], [unit], [outarea_code], [inarea_code], [out_num], [in_num], [inbill_price], [remark]) VALUES (26, N'DB18003         ', NULL, N'1               ', N'blue', N'箱', N'库位四', N'库位三', 10, 10, CAST(100.00 AS Decimal(18, 2)), N'十个')
INSERT [dbo].[Wh_transfer_d] ([transfer_d_id], [transfer_code], [wh__transfer_code], [item_code], [model_code], [unit], [outarea_code], [inarea_code], [out_num], [in_num], [inbill_price], [remark]) VALUES (27, N'DB18003         ', NULL, N'2               ', N'blue', N'瓶', N'库位四', N'库位三', 10, 10, CAST(200.00 AS Decimal(18, 2)), N'十个')
INSERT [dbo].[Wh_transfer_d] ([transfer_d_id], [transfer_code], [wh__transfer_code], [item_code], [model_code], [unit], [outarea_code], [inarea_code], [out_num], [in_num], [inbill_price], [remark]) VALUES (28, N'DB18003         ', NULL, N'4               ', N'blur', N'瓶', N'库位四', N'库位三', 5, 5, CAST(300.00 AS Decimal(18, 2)), N'五个')
INSERT [dbo].[Wh_transfer_d] ([transfer_d_id], [transfer_code], [wh__transfer_code], [item_code], [model_code], [unit], [outarea_code], [inarea_code], [out_num], [in_num], [inbill_price], [remark]) VALUES (29, N'DB28022         ', NULL, N'1               ', N'blue', N'箱', N'库位二', N'库位四', 20, 20, CAST(100.00 AS Decimal(18, 2)), N'1')
INSERT [dbo].[Wh_transfer_d] ([transfer_d_id], [transfer_code], [wh__transfer_code], [item_code], [model_code], [unit], [outarea_code], [inarea_code], [out_num], [in_num], [inbill_price], [remark]) VALUES (30, N'DB28022         ', NULL, N'2               ', N'blue', N'瓶', N'库位二', N'库位四', 20, 20, CAST(200.00 AS Decimal(18, 2)), N'2')
INSERT [dbo].[Wh_transfer_d] ([transfer_d_id], [transfer_code], [wh__transfer_code], [item_code], [model_code], [unit], [outarea_code], [inarea_code], [out_num], [in_num], [inbill_price], [remark]) VALUES (31, N'DB4035          ', NULL, N'HP10580         ', N'12', N'台', N'B2    ', N'库位一', 100, 100, CAST(2000.00 AS Decimal(18, 2)), N'1')
INSERT [dbo].[Wh_transfer_d] ([transfer_d_id], [transfer_code], [wh__transfer_code], [item_code], [model_code], [unit], [outarea_code], [inarea_code], [out_num], [in_num], [inbill_price], [remark]) VALUES (32, N'DB4036          ', NULL, N'HP10580         ', N'12', N'台', N'库位一', N'A1    ', 60, 60, CAST(2000.00 AS Decimal(18, 2)), N'1')
SET IDENTITY_INSERT [dbo].[Wh_transfer_d] OFF
SET IDENTITY_INSERT [dbo].[Wh_transfer_h] ON 

INSERT [dbo].[Wh_transfer_h] ([transfer_h_id], [transfer_code], [transfer_date], [out_warecode], [in_warecode], [sure_state], [transfer_type], [outware_state], [inware_state], [create_by], [create_time], [sure_man], [sure_date], [remark], [is_del]) VALUES (3, N'DB16002         ', CAST(0x0000B0D900000000 AS DateTime), N'仓库一  ', N'仓库三  ', N'2', N'库存预警', N'2', N'1', N'罗桓杰', CAST(0x0000B0DA00000000 AS DateTime), N'刘子怡', CAST(0x0000B0DC00000000 AS DateTime), N'1111', N'0')
INSERT [dbo].[Wh_transfer_h] ([transfer_h_id], [transfer_code], [transfer_date], [out_warecode], [in_warecode], [sure_state], [transfer_type], [outware_state], [inware_state], [create_by], [create_time], [sure_man], [sure_date], [remark], [is_del]) VALUES (4, N'DB18003         ', CAST(0x0000B0D000000000 AS DateTime), N'仓库四  ', N'仓库三  ', N'0', N'库存预警', N'2', N'0', N'罗桓杰', CAST(0x0000B0DC00000000 AS DateTime), N'刘子怡', NULL, N'1111', N'0')
INSERT [dbo].[Wh_transfer_h] ([transfer_h_id], [transfer_code], [transfer_date], [out_warecode], [in_warecode], [sure_state], [transfer_type], [outware_state], [inware_state], [create_by], [create_time], [sure_man], [sure_date], [remark], [is_del]) VALUES (5, N'DB28022         ', CAST(0x0000B0E600FB430C AS DateTime), N'仓库二  ', N'仓库四  ', N'2', N'满仓调离', N'2', N'1', N'罗桓杰', CAST(0x0000B0E600000000 AS DateTime), N'刘子怡', CAST(0x0000B0E600000000 AS DateTime), N'111', N'0')
INSERT [dbo].[Wh_transfer_h] ([transfer_h_id], [transfer_code], [transfer_date], [out_warecode], [in_warecode], [sure_state], [transfer_type], [outware_state], [inware_state], [create_by], [create_time], [sure_man], [sure_date], [remark], [is_del]) VALUES (6, N'DB4035          ', CAST(0x0000B0ED00F34D28 AS DateTime), N'仓库七  ', N'仓库三  ', N'2', N'库存预警', N'3', N'1', N'罗桓杰', CAST(0x0000B0ED00000000 AS DateTime), N'刘子怡', CAST(0x0000B0ED00000000 AS DateTime), N'hhh', N'0')
INSERT [dbo].[Wh_transfer_h] ([transfer_h_id], [transfer_code], [transfer_date], [out_warecode], [in_warecode], [sure_state], [transfer_type], [outware_state], [inware_state], [create_by], [create_time], [sure_man], [sure_date], [remark], [is_del]) VALUES (7, N'DB4036          ', CAST(0x0000B0ED00F4A5B0 AS DateTime), N'仓库三  ', N'司马里仓', N'2', N'库存预警', N'2', N'0', N'罗桓杰', CAST(0x0000B0ED00000000 AS DateTime), N'刘子怡', CAST(0x0000B0ED00000000 AS DateTime), N'hh', N'0')
SET IDENTITY_INSERT [dbo].[Wh_transfer_h] OFF
ALTER TABLE [dbo].[Audit] ADD  CONSTRAINT [DF_Audit_Time]  DEFAULT (getdate()) FOR [AuditTime]
GO
ALTER TABLE [dbo].[Bs_customer] ADD  CONSTRAINT [DF_Bs_customer_opetime]  DEFAULT (getdate()) FOR [opetime]
GO
ALTER TABLE [dbo].[Bs_supply] ADD  CONSTRAINT [DF_Bs_supply_opetime]  DEFAULT (getdate()) FOR [opetime]
GO
ALTER TABLE [dbo].[Bs_ware_area] ADD  CONSTRAINT [DF_Bs_ware_area_create_time]  DEFAULT (getdate()) FOR [create_time]
GO
ALTER TABLE [dbo].[Bs_ware_area] ADD  CONSTRAINT [DF_Bs_ware_area_update_time]  DEFAULT (getdate()) FOR [update_time]
GO
ALTER TABLE [dbo].[Bs_warehouse] ADD  CONSTRAINT [DF_Bs_warehouse_create_time]  DEFAULT (getdate()) FOR [create_time]
GO
ALTER TABLE [dbo].[Bs_warehouse] ADD  CONSTRAINT [DF_Bs_warehouse_update_time]  DEFAULT (getdate()) FOR [update_time]
GO
ALTER TABLE [dbo].[Sys_dict_type] ADD  CONSTRAINT [DF_Sys_dict_type_status]  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[Sys_encode] ADD  CONSTRAINT [DF_Sys_encode_create_time]  DEFAULT (getdate()) FOR [create_time]
GO
ALTER TABLE [dbo].[Wh_buy_order_h] ADD  CONSTRAINT [DF_Wh_buy_order_h_create_time]  DEFAULT (getdate()) FOR [create_time]
GO
ALTER TABLE [dbo].[Wh_buy_order_h] ADD  CONSTRAINT [DF_Wh_buy_order_h_is_del]  DEFAULT ((0)) FOR [is_del]
GO
ALTER TABLE [dbo].[Wh_buy_order_h] ADD  CONSTRAINT [DF_Wh_buy_order_h_sale_state]  DEFAULT ((0)) FOR [sale_state]
GO
ALTER TABLE [dbo].[Wh_inbill_h] ADD  CONSTRAINT [DF_Wh_inbill_h_sure_state]  DEFAULT ((0)) FOR [sure_state]
GO
ALTER TABLE [dbo].[Wh_inbill_h] ADD  CONSTRAINT [DF_Wh_inbill_h_is_del]  DEFAULT ((0)) FOR [is_del]
GO
ALTER TABLE [dbo].[Wh_inventory_h] ADD  CONSTRAINT [DF_Wh_inventory_h_sure_state]  DEFAULT ((0)) FOR [sure_state]
GO
ALTER TABLE [dbo].[Wh_inventory_h] ADD  CONSTRAINT [DF_Wh_inventory_h_is_del]  DEFAULT ((0)) FOR [is_del]
GO
ALTER TABLE [dbo].[Wh_now_storage] ADD  CONSTRAINT [DF_Wh_now_storage_is_del]  DEFAULT ((0)) FOR [is_del]
GO
ALTER TABLE [dbo].[Wh_orderbuy_d] ADD  CONSTRAINT [DF_Wh_orderbuy_d_treat_num]  DEFAULT ((0)) FOR [treat_num]
GO
ALTER TABLE [dbo].[Wh_orderbuy_d] ADD  CONSTRAINT [DF_Wh_orderbuy_d_inbill_num]  DEFAULT ((0)) FOR [inbill_num]
GO
ALTER TABLE [dbo].[Wh_orderbuy_d] ADD  CONSTRAINT [DF_Wh_orderbuy_d_return_goods_num]  DEFAULT ((0)) FOR [return_goods_num]
GO
ALTER TABLE [dbo].[Wh_orderbuy_d] ADD  CONSTRAINT [DF_Wh_orderbuy_d_is_del]  DEFAULT ((0)) FOR [is_del]
GO
ALTER TABLE [dbo].[Wh_outbill_d] ADD  CONSTRAINT [DF_Wh_outbill_d_is_del]  DEFAULT ((0)) FOR [is_del]
GO
ALTER TABLE [dbo].[Wh_outbill_h] ADD  CONSTRAINT [DF_Wh_outbill_h_outbill_state]  DEFAULT ((0)) FOR [outbill_state]
GO
ALTER TABLE [dbo].[Wh_outbill_h] ADD  CONSTRAINT [DF_Wh_outbill_h_is_del]  DEFAULT ((0)) FOR [is_del]
GO
ALTER TABLE [dbo].[Wh_return_supply_d] ADD  CONSTRAINT [DF_Wh_return_supply_d_batch_no]  DEFAULT ((0)) FOR [batch_no]
GO
ALTER TABLE [dbo].[Wh_return_supply_d] ADD  CONSTRAINT [DF_Wh_return_supply_d_is_del]  DEFAULT ((0)) FOR [is_del]
GO
ALTER TABLE [dbo].[Wh_return_supply_h] ADD  CONSTRAINT [DF_Wh_return_supply_h_sale_state]  DEFAULT ((0)) FOR [sale_state]
GO
ALTER TABLE [dbo].[Wh_return_supply_h] ADD  CONSTRAINT [DF_Wh_return_supply_h_create_time]  DEFAULT (getdate()) FOR [create_time]
GO
ALTER TABLE [dbo].[Wh_return_supply_h] ADD  CONSTRAINT [DF_Wh_return_supply_h_is_del]  DEFAULT ((0)) FOR [is_del]
GO
ALTER TABLE [dbo].[Wh_sale_d] ADD  CONSTRAINT [DF_Wh_sale_d_return_num]  DEFAULT ((0)) FOR [return_num]
GO
ALTER TABLE [dbo].[Wh_sale_d] ADD  CONSTRAINT [DF_Wh_sale_d_outbill_num]  DEFAULT ((0)) FOR [outbill_num]
GO
ALTER TABLE [dbo].[Wh_sale_d] ADD  CONSTRAINT [DF_Wh_sale_d_is_del]  DEFAULT ((0)) FOR [is_del]
GO
ALTER TABLE [dbo].[Wh_sale_h] ADD  CONSTRAINT [DF_Wh_sale_h_sale_state]  DEFAULT ((0)) FOR [sale_state]
GO
ALTER TABLE [dbo].[Wh_sale_h] ADD  CONSTRAINT [DF_Wh_sale_h_create_time]  DEFAULT (getdate()) FOR [create_time]
GO
ALTER TABLE [dbo].[Wh_sale_h] ADD  CONSTRAINT [DF_Wh_sale_h_is_del]  DEFAULT ((0)) FOR [is_del]
GO
ALTER TABLE [dbo].[Wh_sale_return_d] ADD  CONSTRAINT [DF_Wh_sale_return_d_is_del]  DEFAULT ((0)) FOR [is_del]
GO
ALTER TABLE [dbo].[Wh_sale_return_h] ADD  CONSTRAINT [DF_Wh_sale_return_h_create_time]  DEFAULT (getdate()) FOR [create_time]
GO
ALTER TABLE [dbo].[Wh_sale_return_h] ADD  CONSTRAINT [DF_Wh_sale_return_h_sale_state]  DEFAULT ((0)) FOR [sale_state]
GO
ALTER TABLE [dbo].[Wh_sale_return_h] ADD  CONSTRAINT [DF_Wh_sale_return_h_is_del]  DEFAULT ((0)) FOR [is_del]
GO
ALTER TABLE [dbo].[Wh_transfer_h] ADD  CONSTRAINT [DF_Wh_transfer_h_outware_state]  DEFAULT ((2)) FOR [outware_state]
GO
ALTER TABLE [dbo].[Wh_transfer_h] ADD  CONSTRAINT [DF_Wh_transfer_h_inware_state]  DEFAULT ((0)) FOR [inware_state]
GO
ALTER TABLE [dbo].[Wh_transfer_h] ADD  CONSTRAINT [DF_Wh_transfer_h_is_del]  DEFAULT ((0)) FOR [is_del]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "h"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 211
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 11
         End
         Begin Table = "w"
            Begin Extent = 
               Top = 6
               Left = 269
               Bottom = 146
               Right = 460
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'CKView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'CKView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "bc"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 146
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 12
         End
         Begin Table = "bf"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 146
               Right = 413
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'CustomerView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'CustomerView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "h"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 146
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 268
               Bottom = 146
               Right = 450
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'gysRK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'gysRK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[14] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 16
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ST'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ST'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ST2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ST2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ST3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ST3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "bs"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 146
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 12
         End
         Begin Table = "bf"
            Begin Extent = 
               Top = 6
               Left = 267
               Bottom = 146
               Right = 434
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SupplyView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SupplyView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Order'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Order'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Return_supply'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Return_supply'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sale'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sale'
GO
USE [master]
GO
ALTER DATABASE [WMS_modern] SET  READ_WRITE 
GO
