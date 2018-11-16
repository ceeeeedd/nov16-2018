--APE report (w/ invoice number)
select top 10 *
from
(
	   select 
			  d.transaction_date_time as transaction_date,
			  g.visible_patient_id as HN,
			  f.display_name_l as patient_name,
			  j.parent_item_group_code as main_group_code,
			  (select top 1
			  bb.name_l as item_name
			  
	   
	   from charge_detail aa left join item bb on aa.item_id = bb.item_id
							left join ar_invoice_detail cc on cc.charge_detail_id = aa.charge_detail_id
							left join ar_invoice dd on dd.ar_invoice_id = cc.ar_invoice_id
							left join patient_visit ee on aa.patient_visit_id = ee.patient_visit_id
							left join person_formatted_name_iview_nl_view ff on ee.patient_id = ff.person_id
							left join person_formatted_name_iview_nl_view ff1 on aa.caregiver_employee_id = ff1.person_id
							left join person_formatted_name_iview_nl_view ff2 on aa.charged_by_employee_id = ff2.person_id
							left join patient_hospital_usage_nl_view gg on ee.patient_id = gg.patient_id
							left join gl_acct_code hh on aa.gl_acct_code_id = hh.gl_acct_code_id
							left join item_type_ref ii on bb.item_type_rcd = ii.item_type_rcd
							left join olap_dim_item_view jj on bb.item_id = jj.item_id
							left join cashier_receipt_view kk on cc.ar_invoice_id = kk.invoice_id
							left join costcentre ll on aa.service_provider_costcentre_id = ll.costcentre_id
							left join policy mm on dd.policy_id = mm.policy_id
				   where 
	    bb.active_flag =1
	   and year(dd.transaction_date_time) = 2017
	   and month(dd.transaction_date_time) = 1
	   and day(dd.transaction_date_time) = 3
	   and cc.gross_amount >= 0
	   AND dd.transaction_status_rcd <> 'VOI'
	   AND dd.system_transaction_type_rcd <> 'CDMR'
	   and jj.parent_item_group_code in ('AAPE','090','094','095','100','210')
	   and mm.policy_id in ('DECBB52A-FC93-11DC-8164-000E0C7F3FA3','4A6E2252-FEEA-11DC-8164-000E0C7F3FA3')
	   and ii.name_l = 'package'
	   and aa.patient_visit_id = a.patient_visit_id
	   --and g.visible_patient_id = '00322167'
	   order by ff.display_name_l
	   ) as group_name,
			  j.parent_item_group_name_l as item_group_name,
			  l.name_l as service_provider,
			  l.costcentre_code,
			  b.name_l as item_name,
			  b.item_code,
			  i.name_l as item_type,
			  a.quantity,
			  a.unit_price,
			  d.gross_amount,
			  d.discount_amount,
			  d.net_amount,
			  --d.tax_amount,
			  h.name_l as  gl_account_name,
			  h.gl_acct_code_code as gl_account_code,
			  isnull(f2.display_name_l,'---') as charged_by_employee,
			  isnull(f1.display_name_l,'---') as clinician,
			  k.invoice_date_time,
			  k.invoice_number
	   
	   from charge_detail a left join item b on a.item_id = b.item_id
							left join ar_invoice_detail c on c.charge_detail_id = a.charge_detail_id
							left join ar_invoice d on d.ar_invoice_id = c.ar_invoice_id
							left join patient_visit e on a.patient_visit_id = e.patient_visit_id
							left join person_formatted_name_iview_nl_view f on e.patient_id = f.person_id
							left join person_formatted_name_iview_nl_view f1 on a.caregiver_employee_id = f1.person_id
							left join person_formatted_name_iview_nl_view f2 on a.charged_by_employee_id = f2.person_id
							left join patient_hospital_usage_nl_view g on e.patient_id = g.patient_id
							left join gl_acct_code h on a.gl_acct_code_id = h.gl_acct_code_id
							left join item_type_ref i on b.item_type_rcd = i.item_type_rcd
							left join olap_dim_item_view j on b.item_id = j.item_id
							left join cashier_receipt_view k on c.ar_invoice_id = k.invoice_id
							left join costcentre l on a.service_provider_costcentre_id = l.costcentre_id
							left join policy m on d.policy_id = m.policy_id
				   where 
	    b.active_flag =1
	   and year(d.transaction_date_time) = 2017
	   and month(d.transaction_date_time) = 1
	   and day(d.transaction_date_time) = 3
	   and c.gross_amount >= 0
	   AND d.transaction_status_rcd <> 'VOI'
	   AND d.system_transaction_type_rcd <> 'CDMR'
	   and j.parent_item_group_code in ('AAPE','090','094','095','100','210')
	   and m.policy_id in ('DECBB52A-FC93-11DC-8164-000E0C7F3FA3','4A6E2252-FEEA-11DC-8164-000E0C7F3FA3')
	   --and g.visible_patient_id = '00322167'
	   --order by f.display_name_l
	   ) as temp
	   where temp.group_name is not null
	   order by temp.patient_name