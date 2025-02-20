/* SELECT
 * 
 * -지정된 테이블에서 원하는 데이터가 존재하는
 *  행, 열을 선택해서 조회하는 SQL(구조적 질의 언어)
 * 
 * -선택된 데이터 == 조회 결과 묶음 == RESULT SET
 * 
 * -조회 결과는 0행 이상
 *  (조건에 맞는 행이 없을 수 있다!)
 **/

/* [SELECT 작성법 - 1]
 * 
 * 2) SELECT * || 컬럼명, ...
 * 1) FROM 테이블명;
 * 
 * -지정된 테이블의 모든 행에서
 *  특정 열(컬럼)만 조회하기
 */

-- EMPLOYEE 테이블에서
-- 모든 행의 이름(EMP_NAME), 급여(SALARY) 컬럼 조회
SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY EMP_NAME ASC;

-- EMPLOYEE 테이블에서
-- 모든 행(==모든 사원)의 사번, 이름, 급여, 입사일 조회
SELECT EMP_ID,EMP_NAME,SALARY,HIRE_DATE FROM EMPLOYEE;

-- EMPLOYEE 테이블의
-- 모든 행, 모든 열(컬럼) 조회
--> *(asterisk) : "모든", "포함"을 나타내는 기호
SELECT * FROM EMPLOYEE;

-- DEPARTMENT 테이블에서
-- 부서코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;

-- EMPLOYEE 테이블의
-- 이름, 이메일, 전화번호 조회
SELECT EMP_NAME, EMAIL, PHONE FROM EMPLOYEE;
-------------------------------------------------------------

/* 컬럼 값 산술 연산 */

/* 컬럼 값 : 행과 열이 교차되는 한 칸에 작성된 값
 * 
 * -SELECT문 작성 시
 *  SELECT절 컬럼명에 산술 연산을 작성하면
 *  조회 결과(RESULT SET)에서
 *  모든 행에 산술 연산이 적용된 컬럼 값이 조회된다.
 */
-- EMPLOYEE 테이블에서
-- 모든 사원의 이름, 급여, 급여 + 100만 조회
SELECT EMP_NAME, SALARY, SALARY+1000000 AS "급여+100만원" FROM EMPLOYEE;
-- 모든 사원의 이름, 급여(1개월), 연봉(급여 * 12) 조회
SELECT EMP_NAME, SALARY, SALARY*12 AS "연봉" FROM EMPLOYEE;

-------------------------------------------------------

/* -SYSDATE / CURRENT_DATE
 * -SYSTIMESTAMP / CURRENT_TIMESTAMP * */

/* DB는 날짜/시간 관련 데이터를 다룰 수 있도록하는 자료형 제공
 * 
 * -DATE 타입 : 년, 월, 일, 시 , 분, 초, 요일 저장
 * -TIMESTAMP 타입 : 년, 월, 일, 시 , 분, 초, 요일 저장  MS, 지역 저장
 * 
 * -SYS (시스템) " 시스템에 설정된 시간
 * -CURRENT : 현재 접속한 세선(사용자)의 시간 기반
 * 
 * -SYSDATE : 현재 시스템 기반 시간 얻어오기
 * -CURRENT_DATE : 현재 사용자 계정 기반 시간 얻어오기
 * 
 * -->DATA  --> TIMESTAMP 바꾸면 ms단위 + 지역 정보를 추가로 얻어옴
 */
SELECT SYSDATE, CURREMT_DATE FROM DUAL;
SELECT SYSTIMESTAMP, CURRENT_TIMESTAMP FROM DUAL;

/* DUAL(DUmmy tAble) 테이블
 * -가짜 테이블(임시 테이블)
 * -조회하려는 데이터가 실제 테이블에 저장된 데이터가 아닌 경우
 *  사용하는 임시 테이블
 */
/* 날짜 데이터 연산하기 (+, -만 가능!!) */

-- 날짜 + 정수 : 정수 만큼 "일" 수 증가
-- 날짜 - 정수 : 정수 만큼 "일" 수 감소
-- 어제, 오늘, 내일, 모레 조회
SELECT CURRENT_DATE-1, CURRENT_DATE, CURRENT_DATE+1, CURRENT_DATE+2 FROM DUAL;

/* 시간 연산 응용 (알아두면 도움 많이 됨!!) */
SELECT
	CURRENT_DATE,
	CURRENT_DATE + 1/24, -- + 1시간
	CURRENT_DATE + 1/24/60, -- + 1분
	CURRENT_DATE + 1/24/60/60, -- + 1초
	CURRENT_DATE + 1/24/60/60 * 30 -- + 30초
FROM DUAL;

/* 날짜끼리 -연산
 * 날짜 - 날짜 = 두 날짜 사이의 차이나는 일 수
 * 
 * TO_DATE('날짜모양문자열', '인식패턴')
 * -> '날짜모양문자열'을 '인식패턴'을 이용해 해석하여
 * 		DATE 타입으로 변환
 * */
SELECT 
	TO_DATE('2025-02-19','YYYY-MM-DD'), -- 시간으로 인식
	'2025-02-19' -- 문자열로 인식
FROM DUAL;

-- 오늘(2/19)부터 2/28까지 남은 일 수 == 9일
SELECT 
	TO_DATE('2025-02-28', 'YYYY-MM-DD')
	- TO_DATE('2025-2-19', 'YYYY-MM-DD')
FROM DUAL;

-- 종강일(7/17)까지 남은 일 수 == 148일
SELECT 
	TO_DATE('2025-07-17', 'YYYY-MM-DD')
	- TO_DATE('2025-2-19', 'YYYY-MM-DD')
FROM DUAL;

-- 퇴근시간까지 남은 시간 == 146분 
SELECT 
	(TO_DATE('2025-02-19 	17:50:00', 
					'YYYY-MM-DD HH24:MI:SS')
	- CURRENT_DATE) * 24 * 60
FROM DUAL;

-- EMPLOYEE 테이블에서
-- 모든 사원의 사번, 이름, 입사일, 현재까지 근무일수, 연차 조회
SELECT 
	EMP_ID, 
	EMP_NAME, 
	HIRE_DATE,
	FLOOR(CURRENT_DATE - HIRE_DATE), -- 내림 처리(소수점)
	CEIL((CURRENT_DATE - HIRE_DATE) / 365) -- 올림 처리(소수점)
FROM EMPLOYEE;
--------------------------------------------------

/* 컬럼명 별칭(Alias) 지정하기
 * 
 * [지정 방법]
 * 1) 컬럼명 AS 별칭    : 문자O, 띄어쓰기X, 특수문자X
 * 
 * 2) 컬럼명 AS "별칭"  : 문자O, 띄어쓰기O, 특수문자O
 * 
 * * AS 구문 생략 가능!!
 * 
 * * ORACLE에서 ""의 의미
 * 	 -"" 내부에 작성된 글자 모양 그대로를 인식해라!!
 * 
 * EX) 문자열    오라클 인식
 * 			 abc  ->  ABC, abc	(대소문자 구분 X)
 * 			"abc" ->    abc			("" 내부 작성된 모양으로만 인식)
 * 
 * */
-- EMPLOYEE 테이블에서 모든 사원의
-- 사번, 이름, 입사일, 현재까지 근무일수, 연차 조회
-- 단, 별칭 꼭 지정!!
SELECT 
	EMP_ID AS 사번, -- AS 별칭
	EMP_NAME 이름,  -- AS 생략
	HIRE_DATE AS "입사한 날짜", -- AS "별칭"
	FLOOR(CURRENT_DATE - HIRE_DATE) "근무일수", -- AS 생략
	CEIL((CURRENT_DATE - HIRE_DATE) / 365) AS "연차"
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서
-- 모든 사원의 사번, 이름, 급여(원), 연봉(급여*12) 조회
-- 단, 컬럼명은 모두 별칭 적용
SELECT 
	EMP_ID 사번,
	EMP_NAME 이름,
	SALARY "급여(원)",
	SALARY * 12 "연봉"
FROM EMPLOYEE;
------------------------------------------------
/* 연결 연산자(||) 
 * -두 컬럼값 또는 리터럴을 하나의 문자열로 연결할 때 사용
 * */
SELECT 
	EMP_ID, 
	EMP_NAME,
	EMP_ID || EMP_NAME
FROM EMPLOYEE;
------------------------------------------------
/* 리터럴 : 값(DATA)를 표기하는 방식(문법)
 * 
 * -NUMBER 타입 : 20, 1.12, -44 (정수, 실수 표기)
 * -CHAR, VARCHAR2 타입(문자열) : 'AB', '가나다' ('' 홑따옴표)
 * 
 * * SELECT절에 리터럴을 작성하면
 *   조회 결과(RESULT SET) 모든 행에 리터럴이 추가된다!
 * */
SELECT
	SALARY, '원',
	SALARY || '원' AS "급여"		
FROM EMPLOYEE;
------------------------------------------------
/* DISTINCT(별개의, 전혀 다른)
 * 
 * -조회 결과 집합(RESULT SET)에서
 *  DISTINCT가 지정된 컬럼에 중복된 값이 존재할 경우
 *  중복을 제거하고 한 번만 표시할 때 사용
 * 
 * (중복된 데이터를 가진 행을 제거)
 * */

-- EMPLOYEE 테이블에서
-- 모든 사원읠 부서 코드(DEPT_CODE) 조회
SELECT 
	DEPT_CODE
FROM 
	EMPLOYEE; -- 23행 조회

-- 사원들이 속한 부서 코드 조회
	 --> 사원이 있는 부서만 조회
SELECT 
	DISTINCT DEPT_CODE
FROM 
	EMPLOYEE; -- 7행 조회(중복X인 경우만)
------------------------------------------------

/* [SELECT 작성법 - 2]
 * 
 * 3) SELECT 컬럼명 || 리터럴, ... -- 열 선택
 * 1) FROM 테이블명 -- 테이블 선택
 * 2) WHERE 조건식; -- 행 선택
 */

/* *** WHERE 절 ***
 * -테이블에서 조건을 충족하는 행을 조회할 때 사용
 * -WHERE 절에는 조건식(결과가 T/F)만 작성 가능
 * -비교 연산자 : >, <, >=, <=, =(같다), !=, <>(같지 않다)
 * -논리 연산자 : AND, OR, NOT
 */
-- EMPLOYEE 테이블에서
-- 급여가 400만원을 초과하는 사원의
-- 사번, 이름, 급여를 조회
SELECT 
	EMP_ID 사번, EMP_NAME 이름, SALARY 급여
FROM 
	EMPLOYEE
WHERE
	SALARY > 4000000; -- 8행

-- EMPLOYEE 테이블에서
-- 급여가 500만원 이하인 사원의
-- 사번, 이름, 급여, 부서코드, 직급코드를 조회
SELECT 
	EMP_ID 사번, EMP_NAME 이름, SALARY 급여, DEPT_CODE 부서코드, JOB_CODE 직급코드
FROM
	EMPLOYEE 
WHERE 
	SALARY <= 5000000; -- 19행

-- EMPLOYEE 테이블에서
-- 연봉이 5000만원 이하인 사원의
-- 이름, 연봉 조회
SELECT EMP_NAME, SALARY * 12 AS 연봉
FROM EMPLOYEE 
WHERE	(SALARY * 12) <= 50000000; -- 15행

-- 이름이 '노옹철'인 사원의
-- 사번, 이름, 전화번호 조회
SELECT EMP_ID, EMP_NAME, PHONE 
FROM EMPLOYEE 
WHERE EMP_NAME = '노옹철';

-- 부서코드(DEPT_CODE)가 'D9'이 아닌 사원의
-- 이름, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE <> 'D9'; -- 18행
--WHERE DEPT_CODE != 'D9';

-- 부서코드(DEPT_CODE)가 'D9'이 아닌 사원의
-- 이름, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D9'; -- 3행
	
-- 전체 : 23행, DP : 3행, DP 아님 : 18행
--> 2행은 어디로?
------------------------------------------------
/* *** NULL ***
 * 
 * -DB에서 NULL : 빈칸 (저장된 값 없음)
 * 
 * -NULL은 비교 대상이 없기 때문에
 *  =, != 등의 비교 연산 결과가 무조건 FALSE
 */

/* *** NULL 비교 연산 ***
 * 
 * 1) 컬럼명 IS NULL : 해당 컬럼 값이 NULL이면 TRUE 반환
 * 2) 컬럼명 IS NOT NULL : 해당 컬럼 값이 NULL이 아니면 TRUE 반환
 * 												== 컬럼에 값이 존재하면 TRUE
 * (컬럼 값의 존재 유무를 비교하는 연산)
 */

-- EMPLOYEE 테이블에서
-- 부서코드(DEPT_CODE)가 없는 사원의
-- 사번, 이름, 부서코드 조회
SELECT EMP_ID , EMP_NAME , DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE IS NULL; -- 2행
-- DEPT_CODE = NULL <= 안됨

-- BONUS가 존재하는 사원의
-- 이름, 보너스 조회
SELECT EMP_NAME , BONUS 
FROM EMPLOYEE 
WHERE BONUS IS NOT NULL; -- 9행
------------------------------------------------
/* *** 논리 연산자(AND/OR) ***
 * 
 * -두 조건식의 결과에 따라 새로운 결과를 만드는 연산
 * 
 * -AND(그리고) : 두 연산자의 결과가 TRUE일 때만 최종 결과 TRUE
 * 	-> 두 조건을 모두 만족하는 행만 결과 집합(RESULT SET)에 포함
 * 
 * -OR(또는) : 두 연산자의 결과가 FALSE일 때만 최종 결과 FALSE
 * 	-> 두 조건 중 하나라도 만족하는 행을 결과 집합(RESULT SET)에 포함
 * 
 * -우선 순위 : AND > OR
 */
-- EMPLOYEE 테이블에서
-- 부서코드가 'D6'인 사원 중
-- 급여가 400만원을 초과하는 사원의
-- 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D6' AND SALARY > 4000000; -- 2명

-- EMPLOYEE 테이블에서
-- 급여가 300만원 이상, 500만 미만인 사원의
-- 사번, 이름, 급여 조회
SELECT EMP_ID , EMP_NAME , SALARY 
FROM EMPLOYEE 
WHERE SALARY >= 3000000 AND SALARY < 5000000; -- 16행

-- EMPLOYEE 테이블에서
-- 급여가 300만원 미만 또는 500만원 이상인 사원의
-- 사번, 이름, 급여 조회
SELECT EMP_ID , EMP_NAME , SALARY 
FROM EMPLOYEE 
WHERE SALARY < 3000000 OR SALARY >= 5000000; -- 7행















