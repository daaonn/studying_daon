select * 
from CAR_RENTAL_COMPANY_CAR
-- 문자열 안에 특정 글자 찾기!
where OPTIONS like '%네비게이션%'
order by CAR_ID desc;