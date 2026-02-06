### 문제. The PADS
https://www.hackerrank.com/challenges/the-pads/problem?isFullScreen=true


```SQL
-- Occupation의 NAME ASC
  -- NAME (N)
-- OCCUPATION의 첫 글자순

-- 직업별 인원수 >> ASC
-- 출력 문장 포맷 : There are a total of [occupation_count] [occupation]s.
-- occupation은 소문자 + 맨 뒤에 s 붙여서 복수형으로
-- 각 직업은 최소 2명 이상임

SELECT NAME + "(" + LEFT(OCCUPATION, 1) + ")",
  "There are a total of [" + count(occupation) as occupation_count + "] [" + occupation + "]s."
FROM OCCUPATIONS
GROUP BY OCCUPATION
ORDER BY NAME ASC;

-- 두 개의 서로 다른 결과를 한 쿼리로 만들려 함
  -- >> 두 개의 독립된 결과를 출력하라는 문제
-- 문자열 연결 방식 오류
  -- >> 문자열 연결은 +가 아님
-- 첫 번째 출력 : GROUP BY가 필요 없음
-- 두 번째 출력 : OCCUPATIO별 COUNT만 있어야 함
  -- >> NAME을 SELECT에 포함하면 안 됨
```

> 두 개의 별도 쿼리여야 함
```SQL
SELECT CONCAT(NAME, '(', LEFT(OCCUPATION, 1), ')') AS NAME_O
FROM OCCUPATIONS
ORDER BY NAME ASC, LEFT(OCCUPATION, 1) ASC;

SELECT CONCAT('There are a total of ', count(*), ' ', LOWER(occupation), 's.')
FROM OCCUPATIONS
GROUP BY OCCUPATION
ORDER BY COUNT(*), LOWER(OCCUPATION) ASC;
```
  
