### 문제1. Advanced Select


You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.


<div align="center">
<img width="448" height="154" alt="image" src="https://github.com/user-attachments/assets/8bc70189-052c-41e4-83b8-380bf653aa5d" />
</div>


Write a query to **find the node type of Binary Tree ordered by the value of the node**. Output one of the following for each node:

* Root: If node is root node.
* Leaf: If node is leaf node.
* Inner: If node is neither root nor leaf node.
* Sample Input


*<Sample Input>*


<div align="center">
<img width="317" height="347" alt="image" src="https://github.com/user-attachments/assets/a3cd8512-7fb0-4040-983b-e74f5cb36c01" />
</div>


<풀이>


```sql
-- 이진 트리에서 각 노드가 어떤 종류인지 판별
-- root 노드 : 부모가 없는 노드
-- leaf(말단) 노드 : 자식이 없는 노드 = 다른 행의 부모로 등장하지 않음
-- inner 노드 : 부모도 있고, 자식도 있는 노드

SELECT N,
  CASE
    WHEN P IS NULL THEN 'Root'
    -- Leaf >> P 컬럼 : 어떤 노드의 부모 목록 >> 어떤 N이 그 목록에 한 번도 안 나오면, 그 노드는 자식이 없는 Leaf
    WHEN N NOT IN (SELECT P FROM BST WHERE P IS NOT NULL) THEN 'Leaf'
    ELSE 'Inner'
  END AS P
FROM BST
ORDER BY N;
```


---
### 문제2. New Companies
Amber's conglomerate corporation just acquired some new companies. Each of the companies follows this hierarchy:


Founder >> Lead Manager >> Senior Manager >> Manager >> Employee


Given the table schemas below, write a query **to print the company_code, founder name, total number of lead managers, total number of senior managers, total number of managers, and total number of employees.** Order your output by ascending company_code.


**Note:**
* The tables may contain duplicate records.
* The company_code is string, so the sorting should not be numeric. For example, if the company_codes are C_1, C_2, and C_10, then the ascending company_codes will be C_1, C_10, and C_2.


*<풀이>*


```sql
-- company code로 asc
-- 위계에 맞춰 속하는 녀석들을 가져와야 함
-- company_code, founder name, total number of lead managers, total number of senior managers, total number of managers, and total number of employees
SELECT C.COMPANY_CODE, C.FOUNDER,
  SELECT COUNT(*) FROM LEAD_MANAGER L WHERE L.COMPANY_CODE = C.COMPANY_CODE,
  SELECT COUNT(*) FROM SENIOR_MANAGER S WHERE S.LEAD_MANAGER_CODE = L.LEAD_MANAGER_CODE,
  SELECT COUNT(*) FROM MANAGER M WHERE M.SENIOR_MANAGER_CODE = S.SENIOR_MANAGER,
  SELECT COUNT(*) FROM EMPLOYEE E WHERE E.MANAGER_CODE = M.MANAGER_CODE,
FROM COMPANY C
JOIN ON LEAD_MANAGER L
JOIN ON SENIOR_MANAGER S
JOIN ON MANAGER M
JOIN ON EMPLOYEE E
ORDER BY COMPANY_CODE; -- 엉망진창임돌았나
```


* SELECT 안에 또 SELECT 쓰면 안 됨
* JOIN 문법 잘못됨
* 다른 서브쿼리에서 정의된 별칭은 또다른 서브쿼리 안에서 사용 불가
* JOIN으로 다 연결한 뒤 COUNT하면 값 폭증 위험


```SQL
SELECT C.COMPANY_CODE, C.FOUNDER,
  COUNT(DISTINCT L.LEAD_MANAGER_CODE) AS LEAD_MANAGERS, -- CODE를 세면 되네!!
  COUNT(DISTINCT S.SENIOR_MANAGER_CODE) AS SENIOR_MANAGERS,
  COUNT(DISTINCT M.MANAGER_CODE) AS MANAGERS,
  COUNT(DISTINCT E.EMPLOYEE_CODE) AS EMPLOYEES
FROM COMPANY C
LEFT JOIN LEAD_MANAGER L
  ON L.COMPANY_CODE = C.COMPANY_CODE
LEFT JOIN SENIOR_MANAGER S
  ON S.COMPANY_CODE = C.COMPANY_CODE
LEFT JOIN MANAGER M
  ON M.COMPANY_CODE = C.COMPANY_CODE
LEFT JOIN EMPLOYEE E
  ON E.COMPANY_CODE = C.COMPANY_CODE
GROUP BY C.COMPANY_CODE, C.FOUNDER
ORDER BY C.COMPANY_CODE;
```
