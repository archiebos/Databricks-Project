select
  to_date(start_time)               as ride_date,
  cast(ride_id as string)           as ride_id,
  cast(start_time as timestamp)     as start_time,
  cast(end_time as timestamp)       as end_time,
  cast(start_station_id as string)  as start_station_id,
  cast(end_station_id as string)    as end_station_id,
  cast(bike_id as string)           as bike_id,
  cast(user_type as string)         as user_type

 from {{ source('bronze', 'bronze_bike_events') }}