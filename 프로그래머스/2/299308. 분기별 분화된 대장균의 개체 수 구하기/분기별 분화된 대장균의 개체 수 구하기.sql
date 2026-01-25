select Concat(quarter(differentiation_date), 'Q') as QUARTER,
    count(ID) as ECOLI_COUNT
from ECOLI_DATA
group by QUARTER -- 집계함수(count, sum ...)를 쓰면 무엇을 기준으로 묶어서 쓸지 반드시 정해야 함!!
order by QUARTER asc;