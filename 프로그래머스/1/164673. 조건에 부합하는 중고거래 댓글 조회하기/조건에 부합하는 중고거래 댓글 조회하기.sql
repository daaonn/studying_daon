-- 코드를 입력하세요
SELECT ub.TITLE, ub.BOARD_ID, 
    ur.REPLY_ID, ur.WRITER_ID, ur.CONTENTS, 
    date_format(ur.CREATED_DATE, '%Y-%m-%d') as CREATED_DATE
From Used_Goods_Board ub
join USED_GOODS_REPLY ur
    on ub.BOARD_ID = ur.BOARD_ID
where substr(ub.created_date, 1, 7) = '2022-10'
order 
    by ur.Created_date asc, ub.title asc;
