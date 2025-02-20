
/* 함수 : 컬럼값 | 지정된 값을 읽어 연산한 결과를 반환하는 것
 * 
 * 1. 단일행 함수 (N -> N)
 * -N개의 행의 컬럼값을 전달하여 N개의 결과를 반환
 * 
 * 2. 그룹 함수 	(N -> 1)
 * -N개의 행의 컬럼값을 전달하여 1개의 결과를 반환
 * 
 * * 함수는
 * SELECT절, WHERE절, ORDER BY절, GROUP BY절, HAVING절에서 사용 가능(FROM 빼고 다)
 */
-----------------------------------------------------------------------------
/*********** 단일행 함수 ***********/

/* <문자 관련 함수> */

/* LENGTH(컬럼명 | 문자열) : 문자열의 길이 반환 */
SELECT 'HELLO WORLD', LENGTH('HELLO WORLD')
FROM DUAL; --임시(가짜) 테이블 -- 11글자

--EMPLOYEE 테이블에서
--사원명, 이메일, 이메일 길이 조회
--단, 이메일 길이가 12 이하인 사원만 조회
--이메일 길이 오름차순 정렬
SELECT EMP_NAME, EMAIL, LENGTH(EMAIL) AS "이메일 길이"
FROM EMPLOYEE 
WHERE LENGTH(EMAIL) <= 12
ORDER BY LENGTH(EMAIL) ASC; --16행
-----------------------------------------------------------------------------
/* INSTR(문자열 | 컬럼명, '찾을 문자열' [, 시작위치 [, 순번]])
 * -시작 위치부터 지정된 순번까지
 *  문자열 | 컬럼값에서 '찾을 문자열'의 위치를 반환
 */
-- 처음 B를 찾은 위치 조회
SELECT 'AABBCCABC', INSTR('AABBCCABC', 'B')
FROM DUAL; --3

-- 5번째 문자부터 검색 시작, 처음 B를 찾은 위치 조회
SELECT 'AABBCCABC', INSTR('AABBCCABC', 'B', 5)
FROM DUAL; --8

-- 5번째 문자부터 검색 시작, 3번째로 찾은 C를 위치 조회
SELECT 'AABBCCABC', INSTR('AABBCCABC', 'C', 5, 3)
FROM DUAL; --9
-----------------------------------------------------------------------------
/* SUBSTR(문자열, 시작위치 [, 길이])
 * -문자열을 시작위치부터 지정된 길이 만큼 잘라서 반환
 * -길이 미작성 시 시작위치 ~ 끝까지 잘라서 반환
 */

--EMPLOYEE 테이블에서
--사원들의 이메일 아이디 조회하기(뒤의 주소 필요없음)
SELECT SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') - 1)
FROM EMPLOYEE;
-----------------------------------------------------------------------------
/* TRIM(옵션 문자열 FROM 대상문자열)
 * -대상 문자열의 앞|뒤|양쪽에 존재하는 지정된 문자열 제거
 * -옵션 : LEADING(앞), TRAILING(뒤), BOTH(양쪽, 기본값)
 */
SELECT '###기###준###',
	TRIM(LEADING '#' FROM '###기###준###'),
	TRIM(TRAILING '#' FROM '###기###준###'),
	TRIM(BOTH '#' FROM '###기###준###')
FROM DUAL;
-----------------------------------------------------------------------------
/* REPLACE(문자열, 찾을 문자열, 대체 문자열)
 * -문자열에서 원하는 부분을 바꾸는 함수
 * 
 */
SELECT NATIONAL_NAME, REPLACE(NATIONAL_NAME, '한국', '대한민국') AS 변경
FROM "NATIONAL";

-- 모든 사원의 이메일 주소를
-- or.kr -> gmail.com
SELECT EMAIL || ' -> ' || REPLACE(EMAIL,'or.kr', 'gmail.com') AS "이메일 변경"
FROM EMPLOYEE;

-- # 모두 제거하기
SELECT '###기###준###', REPLACE('###기###준###', '#', '') AS 변경
FROM EMPLOYEE;
-----------------------------------------------------------------------------
/* <숫자 관련 함수>
 * -MOD(숫자, 나눌 값) : 결과로 나머지를 반환
 * -ABS(숫자) : 절대값 반환
 * -CEIL(실수)  : 올림 -> 정수 형태로 반환
 * -FLOOR(실수) : 내림 -> 정수 형태로 반환
 * 
 * -ROUND(실수 [, 소수점 위치]) : 반올림
 * 1) 소수점 위치 X : 소수점 첫째자리에서 반올림 -> 정수
 * 2) 소수점 위치 O : 지정된 위치가 표현되도록 반올림
 * 
 * -TRUNC(실수 [, 소수점 위치]) : 버림(잘라내기)
 */

--MOD()
SELECT MOD(7,4) FROM DUAL; --3

--ABS()
SELECT ABS(-333) FROM DUAL; --333

--CEIL(), FLOOR()
SELECT CEIL(1.1), FLOOR(1.9) FROM DUAL; --2, 1

--ROUND()
SELECT 
	ROUND(123.456), --123
	ROUND(123.456, 1), --123.5
	ROUND(123.456, 2), --123.46
	ROUND(123.456, 0), --123
	ROUND(123.456, -1) --120
FROM DUAL; 

--TRUNC() : 버림
SELECT 
	TRUNC(123.456), --123 (소수점 버림)
	TRUNC(123.456, 1), --123.4 (56 버림)
	TRUNC(123.456, 2), --123.45 (6 버림)
FROM DUAL;

--TRUNC()와 FLOOR()의 차이
-- 버림      내림
SELECT 
	TRUNC(-123.5), FLOOR(-123.5) -- -123, -124
FROM DUAL;
-----------------------------------------------------------------------------
/* 날짜 관련 함수 */

/* MONTH_BETWEEN(날짜, 날짜)
 * -두 날짜 사이의 개월 수를 반환
 */
SELECT 
	CEIL(MONTHS_BETWEEN(TO_DATE('2025-07-17', 'YYYY-MM-DD') , CURRENT_DATE))
FROM DUAL; --5개월

/* 나이 구하기 */
--2001.03.20 생의 나이 구하기
SELECT 
	CEIL(
		(SYSDATE - TO_DATE('2001.03.20', 'YYYY.MM.DD')) / 365 + 1
	) AS "한국식 나이", --25

	FLOOR(MONTHS_BETWEEN(
		SYSDATE, TO_DATE('2001.03.20', 'YYYY.MM.DD') 
	) / 12) AS "만 나이" --23
FROM DUAL;

/************************************************************/
-- 정확한 날짜 계산에는 MONTH_BETWEEN이 좋다!!!
--> 내부적으로 윤달 계산이 포함되어 있어서
/************************************************************/
-----------------------------------------------------------------------------
/* ADD_MONTH(날짜, 숫자) :
 * -날짜에 숫자 만큼의 개월 수 추가
 * -달마다 일 수가 다르기 때문에 계산이 쉽지 않음 -> 쉽게 계산할 수 있는 함수 제공
 */
SELECT 
	SYSDATE + 28, --3/20
	ADD_MONTHS(SYSDATE, 1), --3/20
	SYSDATE + 28 + 31, --4/20
	ADD_MONTHS(SYSDATE, 2) --4/20
FROM DUAL;
-----------------------------------------------------------------------------
/* LAST_DAT(날짜)
 * -해당 월의 마지막 날짜 반환
 * -월 말, 월 초 구하는 용도로 많이 사용
 */
SELECT 
	LAST_DAY(SYSDATE),
	LAST_DAY(SYSDATE) + 1 AS "다음달 1일",
	ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1)	AS "이번달 1일"
FROM DUAL;
-----------------------------------------------------------------------------
/* EXTRACT(YEAR | MONTH | DAY FROM 날짜)
 * -EXTRACT 뜻 : 뽑아내다, 추출하다
 * -지정된 년|월|일을 추출하여 '정수' 형태로 반환
 */
-- EMPLOYEE 테이블에서
-- 2010년대에 입사한 사원의
-- 사번, 이름, 입사일을
-- 입사일 내림차순으로 조회
SELECT EMP_ID , EMP_NAME , HIRE_DATE 입사일
FROM EMPLOYEE 
WHERE HIRE_DATE 
	BETWEEN TO_DATE('2010-01-01', 'YYYY-MM-DD') 
			AND TO_DATE('2019-12-31', 'YYYY-MM-DD')
ORDER BY 입사일 DESC;







