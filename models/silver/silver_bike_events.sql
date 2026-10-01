select
  to_date(start_time)               as ride_date,
  cast(ride_id as string)           as ride_id,
  cast(start_time as timestamp)     as start_time,
  cast(end_time as timestamp)       as end_time,
  cast(start_station_id as string)  as start_station_id,
  cast(end_station_id as string)    as end_station_id,
  cast(bike_id as string)           as bike_id,
  cast(user_type as string)         as user_type,
  cast(
    (datediff(minute, cast(start_time as timestamp), cast(end_time as timestamp)) / 60.0)
    * case when user_type = 'member' then 10.0 else 15.0 end
    as decimal(19,4)
  ) as ride_revenue

from {{ source('bronze', 'bronze_bike_events') }}
where datediff(minute, cast(start_time as timestamp), cast(end_time as timestamp)) > 0
