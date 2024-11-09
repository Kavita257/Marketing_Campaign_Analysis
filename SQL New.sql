use marketing_campaign;
select * from marketing_campaigns;
show index from marketing_campaigns where key_name = 'primary'; 
alter table marketing_campaigns drop constraint ID;

# Task 6
select Channel, sum(Conversions) as total_conversions from marketing_campaigns group by Channel;

#Task 7
select Campaign_ID, Budget, New_User_Revenue,((New_User_Revenue - Budget) /Budget) * 100 as roi_percentage from marketing_campaigns;

select Campaign_ID, Budget, Returning_User_Revenue,((Returning_User_Revenue - Budget) /Budget) * 100 as roi_percentage from marketing_campaigns;

SELECT 
    Campaign_ID, Start_Date, End_Date, Budget, New_User_Revenue,Returning_User_Revenue,
    (New_User_Revenue + Returning_User_Revenue) AS Total_Revenue,
    (New_User_Revenue + Returning_User_Revenue) / Budget AS Return_On_Investment
FROM marketing_campaigns ORDER BY Return_On_Investment DESC LIMIT 10;

# Task 8
SELECT 
    Campaign_ID, Impressions, Clicks, Sign_Ups, Conversions,
    (Clicks * 1.0 / Impressions) * 100 AS Click_Through_Rate,
    (Sign_Ups * 1.0 / Clicks) * 100 AS Sign_Up_Rate,
    (Conversions * 1.0 / Sign_Ups) * 100 AS Conversion_Rate,
    (Conversions * 1.0 / Impressions) * 100 AS Overall_Conversion_Rate
FROM marketing_campaigns ORDER BY Campaign_ID;

# Task 10

SELECT 
    Campaign_ID, Start_Date, End_Date, Budget,
    (New_User_Revenue + Returning_User_Revenue) AS Total_Revenue,
    (New_User_Revenue + Returning_User_Revenue) / Budget AS Return_On_Investment
FROM marketing_campaigns WHERE (New_User_Revenue + Returning_User_Revenue) / Budget > (SELECT 
            AVG((New_User_Revenue + Returning_User_Revenue) / NULLIF(Budget, 0))
        FROM 
            marketing_campaigns)
ORDER BY Return_On_Investment DESC;

# Task 11

SELECT 
    Campaign_ID, Channel, Start_Date,
    (New_User_Revenue + Returning_User_Revenue) AS Total_Revenue,
    SUM(New_User_Revenue + Returning_User_Revenue) 
        OVER (PARTITION BY Channel ORDER BY Start_Date ROWS UNBOUNDED PRECEDING) AS Cumulative_Revenue
FROM 
    marketing_campaigns
ORDER BY 
    Channel,
    Start_Date;
    
    # Task 9
    
    SELECT 
    c.Campaign_ID,
    c.Channel,
    c.Start_Date,
    c.End_Date,
    c.Budget,
    e.Impressions,
    e.Clicks,
    e.Sign_Ups,
    e.Conversions,
    r.New_User_Revenue,
    r.Returning_User_Revenue,
    (r.New_User_Revenue + r.Returning_User_Revenue) AS Total_Revenue,
    (r.New_User_Revenue + r.Returning_User_Revenue) / NULLIF(c.Budget, 0) AS Return_On_Investment,
    (e.Clicks * 1.0 / NULLIF(e.Impressions, 0)) * 100 AS Click_Through_Rate,
    (e.Sign_Ups * 1.0 / NULLIF(e.Clicks, 0)) * 100 AS Sign_Up_Rate,
    (e.Conversions * 1.0 / NULLIF(e.Sign_Ups, 0)) * 100 AS Conversion_Rate,
    (e.Conversions * 1.0 / NULLIF(e.Impressions, 0)) * 100 AS Overall_Conversion_Rate
FROM 
    marketing_campaigns AS c
JOIN 
    updated_user_engagement AS e ON c.Campaign_ID = e.Campaign_ID
JOIN 
    updated_revenue_generated AS r ON c.Campaign_ID = r.Campaign_ID
ORDER BY 
    c.Campaign_ID;