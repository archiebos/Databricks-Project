select
  ride_date,
  bike_id,
  count(distinct ride_id)                   as total_rides,
  cast(sum(ride_revenue) as decimal(19,4))  as total_revenue,
  min_by(start_station_id, start_time)      as first_start_station_id,
  max_by(end_station_id, end_time)          as last_end_station_id
from {{ ref('silver_bike_events') }}
group by all