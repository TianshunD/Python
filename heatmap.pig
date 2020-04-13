--register the python file.
register '/vol/home/td6/Exam2/average.py' using jython as udfs;

--remove a file in HDFS if the same name file exists.
rmf /user/td6/heatmap_final;

--load data.
raw = LOAD '/home/td6/Exam2/ny_taxi.csv' USING PigStorage(',') AS (medallion, hack_license, vendor_id, rate_code, store_and_fwd_flag, pickup_datetime, dropoff_datetime, passenger_count:int, trip_time_in_secs, trip_distance, pickup_longitude:double, pickup_latitude:double, dropoff_longitude, dropoff_latitude:double, payment_type, fare_amount:double, surcharge, mta_tax, tip_amount, tolls_amount, total_amount);

--filter out pickup_datetime.
step1 = FILTER raw BY pickup_longitude is not null AND pickup_latitude is not null AND passenger_count is not null AND fare_amount is not null;

step2 = FOREACH step1 GENERATE $10, $11, $7, $15; 

--filter out the data based on the bounding box.
step3 = FILTER step2 BY $0 > -74.25 AND $0 < -73.70 AND $1 > 40.49 AND $1 < 40.92; 

--generate new records based on latitude and longitude key.
step4 = FOREACH step3 GENERATE $2,$3,(int)(($0 + 74.25)/0.005) AS logkey,(int)(($1 - 40.49)/0.005) AS latkey;

--collect all records with the same latitude and longitude key.
step4_group = GROUP step4 BY (latkey,logkey);


--calculate the average of radiation levels per each cell.
step4_avg = FOREACH step4_group GENERATE group, udfs.getAverage(step4.passenger_count,step4.fare_amount) ;

--sort data based on the group.
result = ORDER step4_avg BY group;

--dump the results to your screen
--dump result;

--send the output to a folder in HDFS
store result into '/user/td6/heatmap_final';
