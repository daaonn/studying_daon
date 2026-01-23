# select c.ID, c.GENOTYPE, c.ID as PARENT_GENOTYPE
# -- 부모 형질 구하기 ) 부모 행 찾아서 그 제노타입 읽기
# from ecoli_data c
# join ecoli_data p -- self join
#     on c.parent_id = p.id; -- 부모-자식 연결

-- 부모의 형질 비트가 자식 제노타입 안에 모두 포함이 되는지!!
select c.ID, c.GENOTYPE, p.GENOTYPE as PARENT_GENOTYPE
from ecoli_data c -- 자식
join ecoli_data p -- 부모
    on c.PARENT_ID = p.ID -- 부모행 가져오기 (자식의 부모가 p행이다)
where (c.GENOTYPE & p.GENOTYPE) = p.GENOTYPE
order by c.ID;