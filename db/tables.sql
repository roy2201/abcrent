/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2017                    */
/* Created on:     12/18/2023 8:11:11 PM                        */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CARINOUT') and o.name = 'FK_CARINOUT_INOUTINFO_CAR')
alter table CARINOUT
   drop constraint FK_CARINOUT_INOUTINFO_CAR
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CARPRICING') and o.name = 'FK_CARPRICI_PRICEINFO_CAR')
alter table CARPRICING
   drop constraint FK_CARPRICI_PRICEINFO_CAR
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CARRENTAL') and o.name = 'FK_CARRENTA_CARRENTAL_CUSTOMER')
alter table CARRENTAL
   drop constraint FK_CARRENTA_CARRENTAL_CUSTOMER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CARRENTAL') and o.name = 'FK_CARRENTA_CARRENTAL_CAR')
alter table CARRENTAL
   drop constraint FK_CARRENTA_CARRENTAL_CAR
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CARRENTAL') and o.name = 'FK_CARRENTA_CARRENTAL_REFUNDRE')
alter table CARRENTAL
   drop constraint FK_CARRENTA_CARRENTAL_REFUNDRE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('INSURANCE') and o.name = 'FK_INSURANC_INSURANCE_CAR')
alter table INSURANCE
   drop constraint FK_INSURANC_INSURANCE_CAR
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('LOGINHISTORY') and o.name = 'FK_LOGINHIS_LOGININFO_CUSTOMER')
alter table LOGINHISTORY
   drop constraint FK_LOGINHIS_LOGININFO_CUSTOMER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('SUBSCRIPTION') and o.name = 'FK_SUBSCRIP_SUBSCRIBE_CUSTOMER')
alter table SUBSCRIPTION
   drop constraint FK_SUBSCRIP_SUBSCRIBE_CUSTOMER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('VISACARD') and o.name = 'FK_VISACARD_HAVEVISA_CUSTOMER')
alter table VISACARD
   drop constraint FK_VISACARD_HAVEVISA_CUSTOMER
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CAR')
            and   type = 'U')
   drop table CAR
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CARINOUT')
            and   name  = 'INOUTINFO_FK'
            and   indid > 0
            and   indid < 255)
   drop index CARINOUT.INOUTINFO_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CARINOUT')
            and   type = 'U')
   drop table CARINOUT
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CARPRICING')
            and   name  = 'PRICEINFO_FK'
            and   indid > 0
            and   indid < 255)
   drop index CARPRICING.PRICEINFO_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CARPRICING')
            and   type = 'U')
   drop table CARPRICING
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CARRENTAL')
            and   name  = 'CARRENTAL3_FK'
            and   indid > 0
            and   indid < 255)
   drop index CARRENTAL.CARRENTAL3_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CARRENTAL')
            and   name  = 'CARRENTAL2_FK'
            and   indid > 0
            and   indid < 255)
   drop index CARRENTAL.CARRENTAL2_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CARRENTAL')
            and   name  = 'CARRENTAL_FK'
            and   indid > 0
            and   indid < 255)
   drop index CARRENTAL.CARRENTAL_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CARRENTAL')
            and   type = 'U')
   drop table CARRENTAL
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CUSTOMER')
            and   type = 'U')
   drop table CUSTOMER
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('INSURANCE')
            and   name  = 'INSURANCEINFO_FK'
            and   indid > 0
            and   indid < 255)
   drop index INSURANCE.INSURANCEINFO_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('INSURANCE')
            and   type = 'U')
   drop table INSURANCE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('LOGINHISTORY')
            and   name  = 'LOGININFO_FK'
            and   indid > 0
            and   indid < 255)
   drop index LOGINHISTORY.LOGININFO_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('LOGINHISTORY')
            and   type = 'U')
   drop table LOGINHISTORY
go

if exists (select 1
            from  sysobjects
           where  id = object_id('REFUNDREQUESTS')
            and   type = 'U')
   drop table REFUNDREQUESTS
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('SUBSCRIPTION')
            and   name  = 'SUBSCRIBE_FK'
            and   indid > 0
            and   indid < 255)
   drop index SUBSCRIPTION.SUBSCRIBE_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('SUBSCRIPTION')
            and   type = 'U')
   drop table SUBSCRIPTION
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('VISACARD')
            and   name  = 'HAVEVISA_FK'
            and   indid > 0
            and   indid < 255)
   drop index VISACARD.HAVEVISA_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('VISACARD')
            and   type = 'U')
   drop table VISACARD
go

/*==============================================================*/
/* Table: CAR                                                   */
/*==============================================================*/
create table CAR (
   CARID                int identity(1,1)	 not null,
   LICENSEPLATE         varchar(20)          null,
   COLOR                varchar(256)         null,
   MANUFACTURER         varchar(256)         null,
   MODEL                varchar(256)         null,
   TYPE                 varchar(256)         null,
   MILEAGE              int                  null,
   constraint PK_CAR primary key (CARID)
)
go

/*==============================================================*/
/* Table: CARINOUT                                              */
/*==============================================================*/
create table CARINOUT (
   INOUTID              int identity(1,1)	 not null,
   CARID                int                  not null,
   ENTRYTIME            datetime             null,
   EXITTIME             datetime             null,
   RENTEDSTATUS         bit                  null,
   constraint PK_CARINOUT primary key (INOUTID)
)
go

/*==============================================================*/
/* Index: INOUTINFO_FK                                          */
/*==============================================================*/




create nonclustered index INOUTINFO_FK on CARINOUT (CARID ASC)
go

/*==============================================================*/
/* Table: CARPRICING                                            */
/*==============================================================*/
create table CARPRICING (
   CARPRICINGID         int identity(1,1)    not null,
   CARID                int					 not null,
   EFFECTIVEDATE        datetime             null,
   PRICEPERDAY          float                null,
   constraint PK_CARPRICING primary key (CARPRICINGID)
)
go

/*==============================================================*/
/* Index: PRICEINFO_FK                                          */
/*==============================================================*/




create nonclustered index PRICEINFO_FK on CARPRICING (CARID ASC)
go

/*==============================================================*/
/* Table: CARRENTAL                                             */
/*==============================================================*/
create table CARRENTAL (
   CUSTOMERID           int identity(1,1)	 not null,
   CARID                int                  not null,
   REQUESTID            int                  not null,
   RENTALID             int                  not null,
   RENTSTARTDATE        datetime             null,
   RENTENDDATE          datetime             null,
   ISRETURNED           bit                  null,
   constraint PK_CARRENTAL primary key (RENTALID)
)
go

/*==============================================================*/
/* Index: CARRENTAL_FK                                          */
/*==============================================================*/




create nonclustered index CARRENTAL_FK on CARRENTAL (CUSTOMERID ASC)
go

/*==============================================================*/
/* Index: CARRENTAL2_FK                                         */
/*==============================================================*/




create nonclustered index CARRENTAL2_FK on CARRENTAL (CARID ASC)
go

/*==============================================================*/
/* Index: CARRENTAL3_FK                                         */
/*==============================================================*/




create nonclustered index CARRENTAL3_FK on CARRENTAL (REQUESTID ASC)
go

/*==============================================================*/
/* Table: CUSTOMER                                              */
/*==============================================================*/
create table CUSTOMER (
   CUSTOMERID           int identity(1,1)    not null,
   FIRSTNAME            varchar(256)         null,
   LASTNAME             varchar(256)         null,
   ADDRESS              varchar(256)         null,
   EMAIL                varchar(256)         null,
   PASSWORDHASH         varchar(256)         null,
   AGE                  int                  null,
   ISLOGGED             bit                  null,
   constraint PK_CUSTOMER primary key (CUSTOMERID)
)
go

/*==============================================================*/
/* Table: INSURANCE                                             */
/*==============================================================*/
create table INSURANCE (
   INSURANCEID          int identity(1,1)    not null,
   CARID                int                  not null,
   INSURANCEPROVIDER    varchar(256)         null,
   INSURANCEPOLICYNUMBER varchar(20)         null,
   STARTINGDATE         datetime             null,
   EXPIRYDATE           datetime             null,
   COST                 float                null,
   constraint PK_INSURANCE primary key (INSURANCEID)
)
go

/*==============================================================*/
/* Index: INSURANCEINFO_FK                                      */
/*==============================================================*/




create nonclustered index INSURANCEINFO_FK on INSURANCE (CARID ASC)
go

/*==============================================================*/
/* Table: LOGINHISTORY                                          */
/*==============================================================*/
create table LOGINHISTORY (
   LOGINID              int identity(1,1)    not null,
   CUSTOMERID           int                  not null,
   LOGINTIME            datetime             null,
   LOGOUTTIME           datetime             null,
   SESSIONDURATION      int		             null,
   FAILEDATTEMPTS       int                  null,
   constraint PK_LOGINHISTORY primary key (LOGINID)
)
go

/*==============================================================*/
/* Index: LOGININFO_FK                                          */
/*==============================================================*/




create nonclustered index LOGININFO_FK on LOGINHISTORY (CUSTOMERID ASC)
go

/*==============================================================*/
/* Table: REFUNDREQUESTS                                        */
/*==============================================================*/
create table REFUNDREQUESTS (
   REQUESTID            int identity(1,1)    not null,
   REQUESTDATE          datetime             null,
   REASON               varchar(512)         null,
   STATUS               varchar(50)          null,
   RESOLUTION           varchar(50)          null,
   constraint PK_REFUNDREQUESTS primary key (REQUESTID)
)
go

/*==============================================================*/
/* Table: SUBSCRIPTION                                          */
/*==============================================================*/
create table SUBSCRIPTION (
   SUBSCRIPTIONID       int identity(1,1)    not null,
   CUSTOMERID           int                  not null,
   STATDATE             datetime             null,
   ENDDATE              datetime             null,
   EXPIRED              bit                  null,
   constraint PK_SUBSCRIPTION primary key (SUBSCRIPTIONID)
)
go

/*==============================================================*/
/* Index: SUBSCRIBE_FK                                          */
/*==============================================================*/




create nonclustered index SUBSCRIBE_FK on SUBSCRIPTION (CUSTOMERID ASC)
go

/*==============================================================*/
/* Table: VISACARD                                              */
/*==============================================================*/
create table VISACARD (
   CARDID               int identity(1,1)    not null,
   CUSTOMERID           int                  not null,
   CARDHOLDERNAME       char(256)            null,
   CVV                  char(3)              null,
   EXPIRATIONDATE       datetime             null,
   BALANCE              float                null,
   constraint PK_VISACARD primary key (CARDID)
)
go

/*==============================================================*/
/* Index: HAVEVISA_FK                                           */
/*==============================================================*/




create nonclustered index HAVEVISA_FK on VISACARD (CUSTOMERID ASC)
go

alter table CARINOUT
   add constraint FK_CARINOUT_INOUTINFO_CAR foreign key (CARID)
      references CAR (CARID)
go

alter table CARPRICING
   add constraint FK_CARPRICI_PRICEINFO_CAR foreign key (CARID)
      references CAR (CARID)
go

alter table CARRENTAL
   add constraint FK_CARRENTA_CARRENTAL_CUSTOMER foreign key (CUSTOMERID)
      references CUSTOMER (CUSTOMERID)
go

alter table CARRENTAL
   add constraint FK_CARRENTA_CARRENTAL_CAR foreign key (CARID)
      references CAR (CARID)
go

alter table CARRENTAL
   add constraint FK_CARRENTA_CARRENTAL_REFUNDRE foreign key (REQUESTID)
      references REFUNDREQUESTS (REQUESTID)
go

alter table INSURANCE
   add constraint FK_INSURANC_INSURANCE_CAR foreign key (CARID)
      references CAR (CARID)
go

alter table LOGINHISTORY
   add constraint FK_LOGINHIS_LOGININFO_CUSTOMER foreign key (CUSTOMERID)
      references CUSTOMER (CUSTOMERID)
go

alter table SUBSCRIPTION
   add constraint FK_SUBSCRIP_SUBSCRIBE_CUSTOMER foreign key (CUSTOMERID)
      references CUSTOMER (CUSTOMERID)
go

alter table VISACARD
   add constraint FK_VISACARD_HAVEVISA_CUSTOMER foreign key (CUSTOMERID)
      references CUSTOMER (CUSTOMERID)
go

