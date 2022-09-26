select pv.id [PVID],
		pv.Name [Product],
		v.id [VID],
		v.Name [VendorName]


from ThingRequest tr
join Shipment s on s.Id = tr.ShipmentId 
join ProductVariant pv on pv.Id = tr.ProductVariantId 
join ProductVariantPricing pvp on pv.Id = pvp.ProductVariantId 
join Warehouse w on w.Id = s.WarehouseId 
join ProductVariantVendorMapping pvvm on pv.Id = pvvm.ProductVariantId 
and (w.SourcesPerishablesFromWarehouseId = pvvm.WarehouseId or w.SourcesNonPerishablesFromWarehouseId = pvvm.WarehouseId)
join Vendor v on v.Id = pvvm.VendorId 

where pv.DistributionNetworkId = 1
and v.Id in (4,10,11,23,24,29,31,36,38,39,40,44,48,52,71,72,75,80,92,131,138,155,165,173,180,186,187,198,202,216,217,220,232,235,238,246,253,259,279,285,324,344,355,356,367,392,395,397,406,407,433,446,457,463,470,476,486,493,524,531,534,541,551,558,562,576,577,578,580,584,598,599,600,606,613,615,621,622,636,640,644,645,652,659,663,664,668,692,693,697,708,717,722,729,732,758,759,765,767,789,794,797,806,809,811,812,822,824,831,833,847,848,862,868,871,881,893,903,911,916,921,937,944,952,957,964,967,972,973,979,980,981,982,983,989,992,1010,1011,1012,1013,1014,1015,1016,1017,1020,1021,1022,1023,1026,1028,1029,1030,1031,1032,1033,1034,1035,1036,1040,1041,1042,1043,1044,1046,1048,1049,1056,1060,1062,1064,1065,1066,1069,1071,1073,1074,1075,1076,1077,1080,1096,1097,1104,1148,1154,1161,1162)
and pv.Published = 1
and pv.Deleted = 0

group by pv.id,
		 pv.Name,
		 v.id,
		 v.Name 

--Order by 5 desc
		