SELECT A.[Order_Number]
      ,A.[Order_Date]
      ,A.[Ship_Date]
      ,D.Customer_Names
      ,A.[Channel]
      ,A.[Currency_Code]
      ,A.[Warehouse_Code]
      ,C.[Product_Name]
      ,A.[Order_Quantity]
      ,CAST(A.[Unit_Selling_Price] AS MONEY) AS 'Unit_Price'
	  ,CAST(A.Unit_Selling_Price * A.[Order_Quantity] AS MONEY) AS 'Total Selling Value'
      ,CAST(A.[Unit_Cost] AS MONEY) AS 'Unit_Cost'
	  ,CAST(A.[Unit_Cost] * A.Order_Quantity AS MONEY) AS 'Total Product Cost'
	  ,CAST(A.Unit_Selling_Price * A.[Order_Quantity] - A.[Unit_Cost] * A.Order_Quantity AS MONEY) AS 'Profits'
	  ,B.[City]
	  ,B.[postcode]
	  ,B.[Full_Address]
  FROM [3577].[dbo].[Sales_Order] AS A
  LEFT JOIN  [3577].[dbo].[Regions] AS B ON A.Delivery_Region_Index = B.[Index]
  LEFT JOIN [3577].[dbo].[Products] AS C ON A.Product_Description_Index = C.[Index]
  LEFT JOIN [3577].[dbo].[Customers] AS D ON A.Customer_Name_Index = D.Customer_Index
