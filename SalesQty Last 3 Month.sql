--Sales Report (Yestarday)

Select pv.id [PVID],
	   pv.name [Product],
	   Count(*) [Sale Quantity],
	   Sum(t.CostPrice) [CostPrice],
	   Sum(tr.Mrp) [MRPValue],
	   Sum(tr.SalePrice) [SalePrice]

from ProductVariant pv
join ThingRequest tr on tr.ProductVariantId=pv.id
join thing t on t.id=tr.AssignedThingId
join Shipment s on s.id=tr.ShipmentId

where s.ReconciledOn is not null
and s.ReconciledOn >= '2022-08-02 00:00 +06:00'
and s.ReconciledOn < '2022-08-03 00:00 +06:00'
and pv.ShelfType in (5,9)
and s.ShipmentStatus not in (1,9,10)
and IsReturned=0
and IsCancelled=0
and HasFailedBeforeDispatch=0
and IsMissingAfterDispatch=0
and pv.DistributionNetworkId = 1

group by pv.id,
		 pv.name

--order by 3 desc