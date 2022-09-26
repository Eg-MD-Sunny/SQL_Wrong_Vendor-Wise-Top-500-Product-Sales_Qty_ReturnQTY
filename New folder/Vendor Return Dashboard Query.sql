Declare @EndDate DatetimeOffset = '2022-08-05 00:00 +6:00'


SELECT Date,VendorID,VendorName,SUM(pendingqty) PendingQTY,SUM(PendingAmmount) PendingAmmount,
SUM(returnqty) ReturnQTY, SUM(ReturnAmmount) ReturnAmmount
FROM ((
		SELECT prvrz.Date,prvrz.VendorID,prvrz.VendorName,
		SUM (prvrz.Quantity) PendingQTY,SUM(prvrz.ReturnedPrice) PendingAmmount, 0 AS ReturnQTY, 0 AS ReturnAmmount
		FROM (
				SELECT (CAST(dbo.ToBdt(tt.CreatedOn) AS date)) Date,
				ro.id ReturnOrderID, v.id VendorID,v.Name VendorName,
				COUNT (*) Quantity, SUM(t.returnprice) ReturnedPrice
				FROM Thing t
				JOIN ThingEvent te ON te.ThingID=t.id
				JOIN ThingTransaction tt ON tt.id=te.ThingTransactionID
				JOIN returnorder ro ON ro.id=t.ReturnOrderID
				JOIN Vendor v ON v.id=ro.VendorID
				WHERE ToState=1073741824
				AND tt.CreatedOn >='2022-07-25 00:00 +6:00'
				AND tt.CreatedOn < @EndDate
				GROUP BY ro.id,v.id,v.Name,(CAST(dbo.ToBdt(tt.CreatedOn) AS date)) 
								) prvrz
LEFT JOIN (
		SELECT (CAST(dbo.ToBdt(tt.CreatedOn) AS date)) date, 
		ro.id ReturnOrderID, v.id VendorID,v.Name VendorName,
		COUNT (*) Quantity, SUM(t.returnprice) ReturnedPrice
		FROM Thing t
		JOIN ThingEvent te ON te.ThingID=t.id
		JOIN ThingTransaction tt ON tt.id=te.ThingTransactionID
		JOIN returnorder ro ON ro.id=t.ReturnOrderID
		JOIN Vendor v ON v.id=ro.VendorID
		WHERE ToState=2147483648
		AND tt.CreatedOn >='2022-07-25 00:00 +6:00'
		AND tt.CreatedOn < @EndDate
		GROUP BY ro.id,v.id,v.Name,(CAST(dbo.ToBdt(tt.CreatedOn) AS date))
		) SBV ON sbv.ReturnOrderID=prvrz.ReturnOrderID AND  sbv.VendorID=prvrz.VendorID
GROUP BY prvrz.date,prvrz.VendorID,prvrz.VendorName
		)

union all(

SELECT SBV.date,SBV.VendorID,SBV.VendorName, 0 AS  PendingQTY, 0 AS PendingAmmount,
SUM (sbv.Quantity) ReturnQTY,SUM(sbv.ReturnedPrice) ReturnAmmount

FROM (
		SELECT (CAST(dbo.ToBdt(tt.CreatedOn) AS date)) date, 
		ro.id ReturnOrderID, v.id VendorID,v.Name VendorName,
		COUNT(*) Quantity, SUM(t.returnprice) ReturnedPrice
		FROM Thing t
		JOIN ThingEvent te ON te.ThingID=t.id
		JOIN ThingTransaction tt ON tt.id=te.ThingTransactionID
		JOIN returnorder ro ON ro.id=t.ReturnOrderID
		JOIN Vendor v ON v.id=ro.VendorID
		WHERE ToState=1073741824
		AND tt.CreatedOn >='2022-07-25 00:00 +6:00'
		AND tt.CreatedOn < @EndDate
		GROUP BY ro.id,v.id,v.Name,(CAST(dbo.ToBdt(tt.CreatedOn) AS date))
							) prvrz
RIGHT JOIN (
		SELECT (CAST(dbo.ToBdt(tt.CreatedOn) AS date)) Date,
		ro.id ReturnOrderID, v.id VendorID,v.Name VendorName,
		COUNT(*) Quantity, SUM(t.returnprice) ReturnedPrice
		FROM Thing t
		JOIN ThingEvent te ON te.ThingID=t.id
		JOIN ThingTransaction tt ON tt.id=te.ThingTransactionID
		JOIN returnorder ro ON ro.id=t.ReturnOrderID
		JOIN Vendor v ON v.id=ro.VendorID
		WHERE ToState=2147483648
		AND tt.CreatedOn >='2022-07-25 00:00 +6:00'
		AND tt.CreatedOn < @EndDate
		GROUP BY  ro.id,v.id,v.Name,(CAST(dbo.ToBdt(tt.CreatedOn) AS date))
		) SBV ON sbv.ReturnOrderID=prvrz.ReturnOrderID AND  sbv.VendorID=prvrz.VendorID

GROUP BY SBV.Date,SBV.VendorID,SBV.VendorName
		)) ab
--WHERE VendorID IN (4,10,11,23,24,29,31,36,38,39,40,44,48,52,71,72,75,80,92,131,138,155,165,173,180,186,187,198,202,216,217,220,232,235,238,246,253,259,279,285,324,344,355,356,367,392,395,397,406,407,433,446,457,463,470,476,486,493,524,531,534,541,551,558,562,576,577,578,580,584,598,599,600,606,613,615,621,622,636,640,644,645,652,659,663,664,668,692,693,697,708,717,722,729,732,758,759,765,767,789,794,797,806,809,811,812,822,824,831,833,847,848,862,868,871,881,893,903,911,916,921,937,944,952,957,964,967,972,973,979,980,981,982,983,989,992,1010,1011,1012,1013,1014,1015,1016,1017,1020,1021,1022,1023,1026,1028,1029,1030,1031,1032,1033,1034,1035,1036,1040,1041,1042,1043,1044,1046,1048,1049,1056,1060,1062,1064,1065,1066,1069,1071,1073,1074,1075,1076,1077,1080,1096,1097,1104,1148,1154,1161,1162,5,7,8,13,14,18,19,22,35,37,54,55,58,60,62,63,67,68,77,83,88,96,105,141,163,178,183,205,211,234,249,260,284,287,295,322,340,345,346,370,380,389,393,394,403,409,411,420,422,445,448,481,484,487,489,491,522,527,546,550,552,559,564,571,575,579,583,587,589,590,604,608,611,653,654,658,677,678,679,683,687,691,699,718,731,749,761,764,787,788,793,805,807,808,823,826,836,838,840,841,857,865,866,870,873,874,875,882,883,888,892,894,899,904,905,906,907,912,913,914,915,917,918,920,922,923,924,942,943,953,954,958,960,961,962,965,968,970,971,975,976,977,978,984,985,986,987,988,991,993,994,1019,1024,1025,1037,1039,1045,1047,1050,1052,1053,1054,1058,1063,1067,1068,1072,1081,1099,1100,1101,1103,1105,1106,1110,1112,1113,1137,1138,1144,1145,1146,1163,1164,119,182,188,209,221,363,405,437,494,496,537,563,566,586,593,633,660,661,724,795,796,800,820,845,849,908,925,926,931,935,936,938,939,941,946,947,948,966,969,990,1055,1059,1061,1070,1078,1098,1107,1115,1166)

GROUP BY date,VendorID,VendorName
ORDER BY 1,2,3



--SELECT   * FROM   Vendor WHERE id = 433