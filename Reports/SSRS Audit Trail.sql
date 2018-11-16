-- SSRS Audit Trail

--select * from catalog
--order by CreationDate desc

--select * from ExecutionLog2
--order by TimeStart desc

--select * from UpgradeInfo
--order by DateTime desc

--select * from Subscriptions

select temp.ReportPath,
	   temp.UserName,
	   isnull(temp.Format, '---') as [Format],
	   isnull(temp.Parameters, '---') as [Parameters],
	   temp.TimeStart,
	   temp.TimeEnd,
	   right('0' + cast(temp.minute as varchar),2) + ':' + right('0' + cast(temp.second as varchar),2) as 'turn_around_time(m:ss)'
from
(
select a.ReportPath,
	   a.UserName,
	   a.[Format],
	   a.[Parameters],
	   a.TimeStart,
	   a.TimeEnd,
	   cast(datediff(ss,a.TimeStart,a.TimeEnd) /60 as numeric(4,0)) as [minute],
	   cast(datediff(ss,a.TimeStart,a.TimeEnd) %60 as numeric(4,0)) as [second]
	   --DATEDIFF(minute,a.TimeStart,a.TimeEnd) as [minute],
	   --DATEDIFF(ss,a.TimeStart,a.TimeEnd) /60  as [minute],
	   --DATEDIFF(millisecond,a.TimeStart,a.TimeEnd) /1000 as [seconds]
from ReportServer.dbo.ExecutionLog2 a 
--order by TimeStart desc
) as temp
where 
year(temp.TimeStart) = 2018 and
month(temp.TimeEnd) = 11
order by temp.TimeStart desc