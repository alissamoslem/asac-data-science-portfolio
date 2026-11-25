let
    Source = Csv.Document(File.Contents("C:\Users\Muslim\OneDrive\Desktop\Luminus\Datasets\Taxi\yellow_trips_2019_2020_sample.csv"),[Delimiter=",", Columns=18, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"VendorID", Int64.Type}, {"tpep_pickup_datetime", type datetime}, {"tpep_dropoff_datetime", type datetime}, {"passenger_count", Int64.Type}, {"trip_distance", type number}, {"RatecodeID", Int64.Type}, {"store_and_fwd_flag", type text}, {"PULocationID", Int64.Type}, {"DOLocationID", Int64.Type}, {"payment_type", Int64.Type}, {"fare_amount", type number}, {"extra", type number}, {"mta_tax", type number}, {"tip_amount", type number}, {"tolls_amount", type number}, {"improvement_surcharge", type number}, {"total_amount", type number}, {"congestion_surcharge", type number}}),
    #"pickup is on or after 1/1/2019 00:00 and before 1/1/2021 00:00" = Table.SelectRows(#"Changed Type", each [tpep_pickup_datetime] >= #datetime(2019, 1, 1, 0, 0, 0) and [tpep_pickup_datetime] < #datetime(2021, 1, 1, 0, 0, 0)),
    #"add the datetime check column" = Table.AddColumn(#"pickup is on or after 1/1/2019 00:00 and before 1/1/2021 00:00", "Custom", each [tpep_dropoff_datetime]>=[tpep_pickup_datetime]),
    #"The dropoff_datetime must be at or after the pickup_datetime" = Table.SelectRows(#"add the datetime check column", each ([Custom] = true)),
    #"remove the datetime check column" = Table.RemoveColumns(#"The dropoff_datetime must be at or after the pickup_datetime",{"Custom"}),
    #"remove the total_amounts less than 0" = Table.SelectRows(#"remove the datetime check column", each [total_amount] >= 0),
    #"Replace the null values with 5 which equal to Unknown in the payment_types file" = Table.ReplaceValue(#"remove the total_amounts less than 0",null,5,Replacer.ReplaceValue,{"payment_type"}),
    #"Replace the null values with 99 which is equal to Unknown in the rate_codes file" = Table.ReplaceValue(#"Replace the null values with 5 which equal to Unknown in the payment_types file",null,99,Replacer.ReplaceValue,{"RatecodeID"}),
    #"Inserted Date" = Table.AddColumn(#"Replace the null values with 99 which is equal to Unknown in the rate_codes file", "Date", each DateTime.Date([tpep_pickup_datetime]), type date),
    #"Renamed Columns" = Table.RenameColumns(#"Inserted Date",{{"Date", "pickup_date"}}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Renamed Columns",{{"pickup_date", type date}}),
    #"Remove VendorID, store_and_fwd_flag, extra, mta_tax and improvement_surcharge" = Table.RemoveColumns(#"Changed Type1",{"VendorID", "store_and_fwd_flag", "extra", "mta_tax", "improvement_surcharge"}),
    #"Reordered Columns" = Table.ReorderColumns(#"Remove VendorID, store_and_fwd_flag, extra, mta_tax and improvement_surcharge",{"tpep_pickup_datetime", "pickup_date", "tpep_dropoff_datetime", "passenger_count", "trip_distance", "RatecodeID", "PULocationID", "DOLocationID", "payment_type", "fare_amount", "tip_amount", "tolls_amount", "total_amount", "congestion_surcharge"})
in
    #"Reordered Columns"
