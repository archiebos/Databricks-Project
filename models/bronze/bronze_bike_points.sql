select
    *
 from {{ source('bronze', 'bronze_bike_events') }}