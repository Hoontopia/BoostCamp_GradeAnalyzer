# BoostCamp_GradeAnalyzer
성적 결과분석 프로그램
사용언어 및 프레임워크
Swift 3.1
Foundation Framework
프로그램 실행환경
macOS 또는 Ubuntu 16.04
입력
사용자 홈 디렉터리 의 students.json 이라는 파일을 읽습니다 (파일다운로드)
예)
macOS : /Users/yagom/students.json
Ubuntu : /home/yagom/students.json


students.json 파일내용  
[
   {
     "name": "jack",
     "grade": {
       "data_structure": 85,
       "algorithm": 76,
       "database": 42,
       "operating_system": 83
     }
   },
   {
     "name": "jain",
     "grade": {
       "data_structure": 56,
       "algorithm": 65,
       "networking": 68,
       "database": 46,
       "operating_system": 83
     }
   },
   {
     "name": "hana",
     "grade": {
       "data_structure": 86,
       "algorithm": 64,
       "database": 87,
       "operating_system": 96
     }
   },
   {
     "name": "john",
     "grade": {
       "data_structure": 35,
       "networking": 45,
       "database": 78
     }
   },
   {
     "name": "steve",
     "grade": {
       "algorithm": 56,
       "networking": 89,
       "operating_system": 100
     }
   },
   {
     "name": "bill",
     "grade": {
       "data_structure": 87,
       "algorithm": 45,
       "database": 65,
       "operating_system": 78
     }
   }
 ]


출력결과
사용자의 홈 디렉터리 에 result.txt 라는 텍스트파일을 생성하여 출력합니다
예)
macOS : /Users/yagom/result.txt
Ubuntu : /home/yagom/result.txt


출력 결과
출력결과에는 전체 학생의 평균, 개인별 학점, 수료생이 표시됩니다.
전체 평균은 소수점 둘째자리까지만 표시합니다
학점
90점 이상 100점 이하 - A
80점 이상 90점 미만 - B
70점 이상 80점 미만 - C
60점 이상 70점 미만 - D
그 외 - F
수료기준
평균 70점 이상의 학생
개인별 학점 및 수료생 명단은 abc 내림차순으로 정렬합니다
프로그램을 통해 채점이 자동화 되어있기 때문에 아래 첨부파일의 출력과 완전히 동일한 출력결과를 출력해야 합니다.
결과 텍스트 파일 다운로드
 
텍스트 인코딩
모든 텍스트는 UTF-8 인코딩을 사용합니다
제출항목
자신의 github 저장소에 소스를 포함한 Xcode 프로젝트 또는 Swift 패키지 프로젝트를 업로드하여 해당 저장소 주소를 제출합니다.
macOS 또는 Ubuntu 16.04에서 실행가능한 실행파일을 제출합니다.
실행파일 이름 : Grade_{영문이름} [대소문자 유의] 예) Grade_kim_ki_dong
지원서 페이지(http://apply.connect.or.kr/connect/boostcamp/)내에 다음과 같은 항목에 기입 혹은 업로드  .
    
 
