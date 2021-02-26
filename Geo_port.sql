-- Question 1
------------------------------------------

declare SG_port_latitude,SG_port_longitude FLOAT64;
set  SG_port_latitude = (SELECT port_latitude from   `bigquery-public-data.geo_international_ports.world_port_index` where
        country = 'SG'
        and  port_name = 'JURONG ISLAND');

set  SG_port_longitude= (SELECT port_longitude from  `bigquery-public-data.geo_international_ports.world_port_index` where
        country = 'SG'
        and  port_name = 'JURONG ISLAND');
with distance_to_SG as (
SELECT
  index_number,
  port_name,
  region_number,
  ST_DISTANCE(
    ST_GEOGPOINT(port_longitude,port_latitude),
    ST_GEOGPOINT(SG_port_longitude,SG_port_latitude )) distance
FROM
`bigquery-public-data.geo_international_ports.world_port_index`
)
select
    port_name,
    distance
from
(select
    port_name,
    distance,
    row_number()  over  ( order by distance asc) rank_
 from
    distance_to_SG ) t
where
  rank_ <=6 and
  distance >0

------------------------------------------
-- Question 2
select
   country,
   count(*) port_count
from
(select * from
`bigquery-public-data.geo_international_ports.world_port_index`
where cargo_wharf = true ) t
group by
  country
order by port_count desc
limit 1 ;

------------------------------------------

-- Question 3
select
  country,
  port_name,
  port_latitude ,
  port_longitude
from
  `bigquery-public-data.geo_international_ports.world_port_index`
where
  provisions = true
  and water= true
  and fuel_oil  = true
  and diesel= true
order by  ST_DISTANCE(
    ST_GEOGPOINT(-38.706256,32.610982),
    ST_GEOGPOINT(port_longitude,port_latitude )) asc
limit 1 ;