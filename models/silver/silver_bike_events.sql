select
  ride_date,
  ride_id,
  start_time,
  end_time,
  start_station_id,
  end_station_id,
  bike_id,
  user_type,
  cast(
    (datediff(minute, cast(start_time as timestamp), cast(end_time as timestamp)) / 60.0)
    * case when user_type = 'member' then 10.0 else 15.0 end
    as decimal(19,4)
  ) as ride_revenue

from {{ ref('bronze_bike_points') }}
where datediff(minute, cast(start_time as timestamp), cast(end_time as timestamp)) > 0
