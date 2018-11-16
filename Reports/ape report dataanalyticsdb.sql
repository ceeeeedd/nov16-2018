--ape report dataanalyticsdb
select * from AHMC_DataAnalyticsDB.dbo.ape_reports
where 
year(transaction_date) = 2018 and
month(transaction_date) = 9