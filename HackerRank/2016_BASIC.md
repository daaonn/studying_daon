### Basic Select
https://www.hackerrank.com/challenges/revising-the-select-query-2/problem?isFullScreen=true


```SQL
SELECT NAME
FROM CITY
WHERE POPULATION >= 120000 AND COUNTRYCODE = 'USA';
```


---
### Advanced Join
https://www.hackerrank.com/challenges/placements/problem?isFullScreen=true


* TABLES : STUDENTS, FRIENDS, PACKAGES
* NAMES - BF가 본인보다 더 높은 SALARY
* SALART AMOUNT로 정렬


```SQL
SELECT S.NAME
FROM STUDENTS S
JOIN FRIENDS F ON S.ID = F.ID
-- PACKAGE는 두 번 조인
JOIN PACKAGES P1 ON S.ID = P1.ID
JOIN PACKAGES P2 ON F.FRIEND_ID = P2.ID
WHERE P1.SALARY < P2.SALARY
ORDER BY P2.SALARY;
```
