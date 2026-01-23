-- 코드를 작성해주세yo
select count(ID) as COUNT
from ECOLI_DATA
where (GENOTYPE & 2) = 0
    AND ((GENOTYPE & 1) > 0 or (GENOTYPE & 4) > 0);

-- GENOTYPE이 '비트마스크'..?
-- 0001(1) / 0010(2) / 0100(4) / 1000(8)