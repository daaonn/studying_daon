select id,
    case
        when pct <= 0.25 then 'CRITICAL'
        when pct <= 0.50 then 'HIGH'
        when pct <= 0.75 then 'MEDIUM'
        else 'LOW'
    end as COLONY_NAME
from (select
         id, size_of_colony,
         percent_rank () over (order by size_of_colony desc) as pct
      from ecoli_data) t
order by id asc;