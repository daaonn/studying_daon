### 문제 1. Top Competitors
https://www.hackerrank.com/challenges/full-score/problem?isFullScreen=true


Julia just finished conducting a coding contest, and she needs your help assembling the leaderboard! Write a query to print the **respective hacker_id and name of hackers who achieved full scores for more than one challenge**. Order your output in descending order by the total number of challenges in which the hacker earned a full score. If more than one hacker received full scores in same number of challenges, then sort them by ascending hacker_id.


* Hackers : The hacker_id is the id of the hacker, and name is the name of the hacker.

* difficulty : The difficult_level is the level of difficulty of the challenge, and score is the maximum score that can be achieved for a challenge at that difficulty level.

* Challenges: The challenge_id is the id of the challenge, the hacker_id is the id of the hacker who created the challenge, and difficulty_level is the level of difficulty of the challenge.

* Submissions: The submission_id is the id of the submission, hacker_id is the id of the hacker who made the submission, challenge_id is the id of the challenge that the submission belongs to, and score is the score of the submission.


*<풀이>*
```SQL
-- 2개 이상의 챌린지에서 FULL SCORE(만점)을 받은
  -- FULL SCORE : DIFFICULTY 테이블의 점수와 SUBMISSION 점수가 같아야 함
  -- HACKER_ID가 참여한 CHALLENGE_ID가 2개 이상
-- 해커아이디, 이름
-- 챌린지 개수로 desc, 해커아이디 asc

WITH FULL_SCORES AS (
  SELECT
    H.HACKER_ID, H.NAME, COUNT(S.CHALLENGE_ID) AS COUNTING
  FROM HACKERS H
  LEFT JOIN SUBMISSIONS S ON S.HACKER_ID = H.HACKER_ID
  LEFT JOIN CHALLENGES C ON C.HACKER_ID = H.HACKER_ID
  LEFT JOIN DIFFICULTY D ON D.DIFFICULTY_LEVEL = C.DIFFICULTY_LEVEL
  WHERE S.SCORE = D.SCORE --FULL SCORE HACKERS
  GROUP BY H.HACKER_ID
)

SELECT HACKER_ID, NAME
FROM FULL
WHERE COUNTING >= 2
ORDER BY COUNTING DESC, HACKER_ID ASC;
```
* CHALLENGES 조인 조건 : 해커가 제출한(SUBMISSION) 챌린지를 기준으로 만점 여부 확인해야 함
* 중복 COUNT의 위험 > 한 해커가 같은 챌린지에 여러 번 제출할 수도 있음
* LEFT JOIN + WHERE 조건이면 사실상 INNER JOIN > 차라리 JOIN으로 쓰기


*<정답>*
```SQL
WITH FULL_SCORES AS (
  SELECT
    H.HACKER_ID, H.NAME, COUNT(DISTINCT S.CHALLENGE_ID) AS FULL_COUNT
  FROM HACKERS H
  JOIN SUBMISSIONS S ON S.HACKER_ID = H.HACKER_ID
  JOIN CHALLENGES C ON C.CHALLENGE_ID = S.CHALLENGE_ID
  JOIN DIFFICULTY D ON  D.DIFFICULTY_LEVEL = C.DIFFICULTY_LEVEL
  WHERE D.SCORE = S.SCORE
  GROUP BY H.HACKER_ID, H.NAME
)
SELECT HACKER_ID, NAME
FROM FULL_SCORES
WHERE FULL_COUNT > 1
ORDER BY FULL_COUNT DESC, HACKER_ID ASC;
```
* 서브쿼리
```SQL
SELECT T.HACKER_ID, T.NAME
FROM (
  SELECT
    H.HACKER_ID, H.NAME, COUNT(DISTINCT S.CHALLENGE_ID) AS FULL_COUNT
  FROM HACKERS H
  JOIN SUBMISSIONS S ON S.HACKER_ID = H.HACKER_ID
  JOIN CHALLENGES C ON C.CHALLENGE_ID = S.CHALLENGE_ID
  JOIN DIFFICULTY D ON  D.DIFFICULTY_LEVEL = C.DIFFICULTY_LEVEL
  WHERE D.SCORE = S.SCORE
  GROUP BY H.HACKER_ID, H.NAME
) T
WHERE T.FULL_COUNT > 1
ORDER BY T.FULL_COUNT DESC, T.HACKER_ID ASC;
```

---

### 문제 2. Ollivander's Inventory
https://www.hackerrank.com/challenges/harry-potter-and-wands/problem?isFullScreen=true


Harry Potter and his friends are at Ollivander's with Ron, finally replacing Charlie's old broken wand.
Hermione decides the best way to choose is by determining **the minimum number of** gold galleons needed to buy each **non-evil** wand **of high power and age**. 
Write a query to **print the id, age, coins_needed, and power of the wands that Ron's interested in**, sorted in order of descending power. 
If more than one wand has same power, sort the result in order of descending age.


*<풀이>*
```SQL
-- id, age, coins_needed, power
-- 파워와 나이가 높은 지팡이 중 NON-EVIL >> 최소한의 가격
-- 정렬 : POWER DESC, AGE DESC

SELECT W.ID, P.AGE, W.COINS_NEEDED, W.POWER
FROM WANDS W
JOIN WANDS_PROPERTY P ON W.CODE = P.CODE
WHERE P.IS_EVIL = 0 AND MIN(W.COINS_NEEDED) = W.COINS_NEEDED
GROUP BY W.POWER, P.AGE
ORDER BY W.POWER DESC, P.AGE DESC;
```
* MIN은 WHERE에서 쓸 수 없음
* GROUP BY의 대상이 잘못됨
* 논리가 잘못됨

  
> “같은 (power, age) 조합 안에서 가장 coins_needed가 낮은 ‘그 지팡이 한 개만’ 출력하라”
> POWER + AGE 조합의 최소 COINS_NEEDED를 뽑고, 그 값과 일치하는 행만 SELECT


*<정답>*
```SQL
SELECT W.ID, P.AGE, W.COIN_NEEDED, W.POWER
FROM WANDS W
JOIN WANDS_PROPERTY P ON W.CODE = P.CODE
JOIN (
  SELECT P2.AGE, W2.POWER, MIN(W2.COINS_NEEDED) AS MIN_COINS
  FROM WANDS W2
  JOIN WANDS_PROPERTY P2 ON W2.CODE = P2.CODE
  WHERE P2.IS_EVIL = 0
  GROUP BY W2.POWER, P2.AGE
) T ON T.AGE = P.AGE AND T.POWER = W.POWER AND T.MIN_COINS = W.COIN_NEEDED
WHERE P.IS_EVIL = 0
ORDER BY W.POWER DESC, P.AGE DESC;
```

---

### 문제 3. Challenges
https://www.hackerrank.com/challenges/challenges/problem?isFullScreen=true


Julia asked her students to create some coding challenges. Write a query to **print the hacker_id, name, and the total number of challenges** created by each student. Sort your results by the total number of challenges in descending order. If more than one student created the same number of challenges, then sort the result by hacker_id. If **more than one student created the same number of challenges and the count is less than the maximum number of challenges created, then exclude** those students from the result.


*<풀이>*
```SQL
-- hacker_id, name, the total number of challenges
-- total number of challenges DESC, hacker_id ASC
-- 만약 두 명 이상의 학생이 같은 수의 챌린지, 그 개수가 최고 기록이 아니면 결과에서 제외

<1>
SELECT H.HACKER_ID, H.NAME, COUNT(C.CHALLENGE_ID) AS CHALLENGES_CREATED
FROM HACKERS H
JOIN CHALLENGES C ON H.HACKER_ID = C.HACKER_ID
WHERE CHALLENGES_CREATED = MAX(CHALLENGES_CREATED) -- WHERE에서는 집계함수를 쓸 수 없음
ORDER BY CHALLENGES_CREATED DESC, HACKER_ID ASC;

<2>
SELECT H.HACKER_ID, H.NAME, COUNT(C.CHALLENGE_ID) AS CHALLENGES_CREATED
FROM HACKERS H
JOIN CHALLENGES C ON H.HACKER_ID = C.HACKER_ID
WHERE CHALLENGES_CREATED = ( -- 집계 결과가 만들어지기 전에 WHERE이 실행 >> SELECT에서 만든 별칭은 사용 불
  SELECT MAX(COUNT(C.CHALLENGE_ID)) -- MAX() 안에 COUNT() 바로 넣는 건 불가 >> 한 번 더 감싼 서브쿼리 필요
  FROM HACKERS H2
  JOIN CHALLENGES C2 ON H2.HACKER_ID = C2.HACKER_ID
  GROUP BY H2.HACKER_ID
) M
ORDER BY CHALLENGES_CREATED DESC, HACKER_ID ASC; -- 메인쿼리에 GROUP BY가 없음
```


*<정답>*
```SQL
WITH CNTS AS (
  SELECT HACKER_ID, COUNT(*) AS CNT
  FROM CHALLENGES
  GROUP BY HACKER_ID)
SELECT H.HACKER_ID, H.NAME, C.CNT AS CHALLENGE_CREATED
FROM CNTS C
JOIN HACKERS H ON H.HACKER_ID = C.HACKER_ID
WHERE C.CNT = (SELECT MAX(CNT) FROM CNTS)
  OR C.CNT IN ( -- CNT가 전체 CNT 중 단 1명만 가진 CNT 목록 안에 있으면 포함
    SELECT CNT
    FROM CNTS
    GROUP BY CNT
    HAVING COUNT(*) = 1)
ORDER BY CHALLENGES_CREATED DESC, H.HACKER_ID ASC;
```
* **HAVING :** GROUP BY 이후에 실행 >> GROUP BY로 묶은 집계 결과에 조건을 걸 때만 사용 가능 >> **그룹 단위**로만 볼 수 있음
* **WHERE :** 개별 행에 조건

---

### 문제 4. Contest Leaderboard
https://www.hackerrank.com/challenges/contest-leaderboard/problem?isFullScreen=true


You did such a great job helping Julia with her last coding contest challenge that she wants you to work on this one, too!
The **total score** of a hacker is the sum of their maximum scores for all of the challenges. 
Write a query to **print the hacker_id, name, and total score** of the hackers ordered by the descending score. 
If more than one hacker achieved the same total score, then sort the result by ascending hacker_id. 
**Exclude** all hackers with a total score of 0 from your result.


*<풀이>*
```SQL
-- TOTAL SCORE : 모든 챌린지에 대한 MAX SCORE의 합
-- hacker_id, name, total score
-- TOTAL SCORE DESC, HACKER_ID ASC
-- TOTAL SCORE가 0인 건 모두 제외

SELECT HACKER_ID, NAME,
  SUM(SELECT MAX(SCORE) AS MX FROM SUBMISSIONS GROUP BY HACKER_ID, CHALLENGE_ID) AS TOTAL_SCORE
FROM HACKERS
WHERE TOTAL_SCORE != 1
ORDER BY TOTAL_SCORE DESC, HACKER_ID ASC;

-- 그룹화된 값은 SELECT절에서 직접 쓸 수 없음
-- SUM() 안에는 숫자 컬럼만 가능 & SELECT문을 넣을 수 없음
```

*<정답>*
```SQL
SELECT H.HACKER_ID, H.NAME, SUM(T.MAX_SCORE) AS TOTAL_SCORE
FROM (
  SELECT HACKER_ID, CHALLENGE_ID, MAX(SCORE) AS MAX_SCORE
  FROM SUBMISSIONS
  GROUP BY HACKER_ID, CHALLENGE_ID) T
JOIN HACKERS H ON H.HACKER_ID = T.HACKER_ID
GROUP BY H.HACKER_ID, H.NAME
HAVING TOTAL_SCORE > 1
ORDER BY TOTAL_SCORE DESC, H.HACKER_ID ASC;
```

---

### 문제 5. Weather Observation Station 9
https://www.hackerrank.com/challenges/weather-observation-station-9/problem?isFullScreen=true


Query **the list of CITY names** from STATION that do not start with vowels. 
Your result cannot contain duplicates.


*Input Format*


The STATION table is described as follows:


<div align="center">
<img width="359" height="223" alt="image" src="https://github.com/user-attachments/assets/6e394318-ff0c-433f-95f7-07dfa2fa3fea" />
</div>


*<풀이>*
```SQL
-- 도시 리스트 >> 모음으로 시작하지 않는
-- 중복 X

<1>
SELECT DISTINCT CITY
FROM STATION
WHERE SUBSTR(CITY, 1, 1) NOT IN ('A', 'E', 'I', 'O', 'U', 'a', 'e', 'i', 'o', 'u');

<2>
SELECT DISTINCT CITY
FROM STATON
WHERE CITY NOT LIKE 'A%'
  AND CITY NOT LIKE 'E%'
  AND CITY NOT LIKE 'I%'
  AND CITY NOT LIKE 'O%'
  AND CITY NOT LIKE 'U%';
```
* **SUBSTR :** 문자열 자르기 함수 >> SUBSTR(자를 대상, 몇 번째 글자부터 자를지, 몇 글자 가져올지)
* **LIKE :** 문자열이 특정 패턴과 '일치'하는지 검사
