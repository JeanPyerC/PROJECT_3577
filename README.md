# SALES DASHBOARD

The objective was to generate an SQL report incorporating real-time data and present a summarized visualization. In this instance, Power BI served as the chosen tool for crafting the visual model.


![](https://github.com/JeanPyerC/PROJECT_3577/blob/main/3577/Images/Dashboard%20Image.png)


# Steps I took to Achieve This:

### Step 1 - TSQL - Identifying Tables & Properly Join Them 

Analyzing the database tables, I successfully identified the Master Table housing comprehensive sales information. Subsequently, I meticulously discerned key tables essential for data integration, including Regions, Products, and Customers. In the course of this analysis, I formulated a customized SQL formula to calculate pivotal metrics such as 'Total Selling Value' and 'Total Product Cost,' both integral components for the forthcoming report.

```
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
```

### Step 2 - DAX - Power Bi Set-Up

Upon formulating the requisite formula, the subsequent step involves establishing a connection and executing the query to retrieve the necessary data. Leveraging Power BI, the creation of a Measuring Table (Measure Table) to gauge specific details and a date table (DateTable) is imperative. This strategic setup lays the foundation for generating a comprehensive visual report.

- <b>Date Table</b> will encompass all dates ranging from the minimum to the maximum date within our dataset. This is a critical step, as it enables the inclusion of missing dates in-between, enhancing the visual representation for a more comprehensive and informative display.
```
DateTable = 
ADDCOLUMNS (
    //CALENDAR(DATE(2020,1,1), DATE(2024,12,31)),
    CALENDARAUTO(),
    "Year", YEAR([Date]),
    "Quarter", "Q" & FORMAT(CEILING(MONTH([Date])/3, 1), "#"),
    "Quarter No", CEILING(MONTH([Date])/3, 1),
    "Month No", MONTH([Date]),
    "Month Name", FORMAT([Date], "MMMM"),
    "Month Short Name", FORMAT([Date], "MMM"),
    "Month Short Name Plus Year", FORMAT([Date], "MMM,yy"),
    "DateSort", FORMAT([Date], "yyyyMMdd"),
    "Day Name", FORMAT([Date], "dddd"),
    "Details", FORMAT([Date], "dd-MMM-yyyy"),
    "Day Number", DAY ( [Date] )
```
- <b>Measuring Table</b> will house specific measurements integral to enhancing the visual representation. Within this context, DAX calculations will be employed to compute metrics such as Current Sales (Sales) and Last Year Sales (Sales PY). This approach facilitates a visual comparison, allowing for a clear and insightful understanding of the differences between the two metrics.
```
Profits = SUM(Sales_Transaction[Profits])
Profits PY = CALCULATE([Profits], SAMEPERIODLASTYEAR(DateTable[Date]))
Profits vs PY = [Profits] - [Profits PY]
Profits vs PY % = [Profits vs PY] / [Profits]
Sales = SUM(Sales_Transaction[Total Selling Value])
Sales PY = CALCULATE([Sales], SAMEPERIODLASTYEAR(DateTable[Date]))
Sales vs PY = [Sales] - [Sales PY]
Sales vs PY % = [Sales vs PY] / [Sales]
```

