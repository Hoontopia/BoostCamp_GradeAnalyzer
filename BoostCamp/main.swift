//
// 2017.06.06
// 성적 결과분석 프로그램
// Swift 3.1
// Made by 임성훈
//

import Foundation

/* 전체 과목들의 이름을 열거형으로 정의 */
/* 각 과목을 인덱스로 접근하기위해 Int 형으로 정의*/
enum Subject: Int {
    case data_structure
    case algorithm
    case networking
    case database
    case operating_system
    static var count: Int { return Subject.operating_system.hashValue + 1} // 전체 과목 수를 반환
}

/* 학점(A~F)을 열거형으로 정의 */
enum Grade: String {
    case A, B, C, D, F
}

/* 파일 이름들을 열거형으로 정의 */
enum FileName: String {
    case jsonFileName = "students.json"
    case resultFileName = "result.txt"
}

/* Json 파싱, 파일 출력 간 발생할 수 있는 에러들을 열거형으로 정의 */
enum GradeAnalysisError: Error{
    case invalidName                    // Json 파싱시 이름 포맷 불일치
    case invalidGrade                   // Json 파싱시 과목,성적 포맷 불일치
    case invalidJsonFormat              // Json 형식이 아님
    case invalidData                    // 파싱할 Data가 유효하지 않음
    case writingError                   // 파일 출력 에러
}

/* Json 형식에서 파싱할 요소들 열거형으로 정의 */
enum JsonElement: String {
    case name
    case grade
}

/* extension을 통해 Double에 값을 성적으로 변환하는 기능 부여*/
extension Double {
    func toGrade() -> String {
        var grade: String
        
        switch self {
        case 90...100:
            grade = Grade.A.rawValue
        case 80..<90:
            grade = Grade.B.rawValue
        case 70..<80:
            grade = Grade.C.rawValue
        case 60..<70:
            grade = Grade.D.rawValue
        default:
            grade = Grade.F.rawValue
        }
        
        return grade
    }
}

/* extension을 통해 Double에 소수점 N번째 자리에서 반올림 하여 반환하는 기능 부여 */
extension Double {
    func roundToPlace(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))         // N번째 자리의 수를 정수부 끝 값에 맞추기 위해 10^N
        return (self * divisor).rounded() / divisor     // N번째 자리의 수를 정수부 끝 값에 맞춘 후 반올림, 다시 원래 자리수로 맞춰준다.
    }
}

/* 각 학생의 이름, 과목별 성적을 담는 Student 클래스 정의 */
class Student {
    let name: String
    var subject: [String: Int] = [:]                    // 수강한 과목이 Key, 과목별 성적이 Value가 되는 Dictionary
    
    init(name: String) {
        self.name = name
    }
    
    func addSubject(name: String, score: Int) {         // 수강한 과목과 점수를 추가하는 함수
        subject[name] = score
    }
    
    func averageScore() -> Double {                     // 모든 과목 성적의 평균 값을 반환하는 함수
        var totalScore: Double = 0
        for (_, score) in subject {                     // 수강한 과목을 순회하며 성적을 누적 시킨다.
            totalScore += Double(score)
        }
        return totalScore / Double(subject.count)
    }
}

/* 학생들의 성적 분석을 위한 GradeAnalyzer 클래스 정의 */
class GradeAnalyzer {
    let homeDirectory = NSHomeDirectory()               // 사용자 홈 디렉토리 경로
    let jsonPath: String                                // Json 파일 경로
    let jsonURL: URL                                    // Json 파일 URL
    let resultFilePath: String                          // 성적 분석 결과 값 출력 파일 경로
    var result: String = ""                             // 성적 분석 결과
    var students: [Student] = []
    
    init() {
        jsonPath = "\(homeDirectory)/\(FileName.jsonFileName.rawValue)"         // Json 파일 경로 설정
        resultFilePath = "\(homeDirectory)/\(FileName.resultFileName.rawValue)" // 성적 분석 결과 값 출력 파일 경로
        jsonURL = URL.init(fileURLWithPath: jsonPath)                           // Json 파일 경로를 URL로 변환
    }
    
    func analyze() {                                                            // 성적 분석 함수
        do {
            try self.jsonParse(jsonURL: self.jsonURL)                           // Json 파싱
            
            let totalAverage = String.init(getTotalAverage())                   // 학생들의 총 평균 계산
            let totalStudentGrade = getTotalStudentGrade()                      // 개별 학생들의 학점 추출
            let passStudents = getPassStudents()                                // 평균 70점 이상이되어 수료한 학생 추출
            
            result = "성적결과표\n\n"+"전체 평균 : "+totalAverage+"\n\n개인별 학점\n"+totalStudentGrade+"\n수료생\n"+passStudents
            
            try writeToFile(stringURL: resultFilePath)                          // 파일 출력
            
            print("The analysis of students ' grades has been completed.")
            
        /* 익셉션 처리 */
        } catch GradeAnalysisError.invalidJsonFormat {
            print("Invalid JsonFormat Error during the Json parsing")
        } catch GradeAnalysisError.invalidData {
            print("Invalid Data during the Json parsing")
        } catch GradeAnalysisError.invalidGrade {
            print("Invalid Grade during the Json parsing")
        } catch GradeAnalysisError.invalidName {
            print("Invalid Name during the Json parsing")
        } catch GradeAnalysisError.writingError {
            print("Writing Failed")
        } catch let otherErr{
            print(otherErr.localizedDescription)
        }
    }
    
    func writeToFile(stringURL: String) throws {                                // 파일 출력 함수
        do {
           try result.write(toFile: stringURL, atomically: false, encoding: String.Encoding.utf8)
        } catch {
            throw GradeAnalysisError.writingError                               // 실패시 Error throw
        }
    }
    
    func getTotalAverage() -> Double {                                          // 학생들의 총 평균 계산 함수
        var totalScore: Double = 0
        let count: Double = Double(students.count)
        
        for student in students {                                               // 학생들을 순회하며 평균값 누적
            totalScore += student.averageScore()
        }
        return (totalScore / count).roundToPlace(places: 2)                     // 누적된 평균 값을 학생수로 나눈 총 평균 값 반환
    }
    
    func getTotalStudentGrade() -> String {                                     // 개별 학생들의 학점 추출 함수
        var totalStudentGrade: String = ""
        for student in students {
            totalStudentGrade.append(student.name)
            for _ in 0 ..< 11 - student.name.characters.count{                  // 공백을 맞추기 위해 칸 수(11)-이름의 문자 수
                totalStudentGrade += " "
            }
            totalStudentGrade.append(": "+student.averageScore().toGrade()+"\n")
        }
        return totalStudentGrade
    }
    
    func getPassStudents() -> String{                                           // 수료한 학생들 추출 함수
        var passStudents: String = ""
        for student in students {
            if student.averageScore() > 70 {                                    // 학생들을 순회하며 평균이 70이상인 학생 추출
                passStudents.append(student.name)
                if students.last! !== student {                                 // 마지막 학생일 경우 ", " 붙이지 않음
                    passStudents.append(", ")
                }
            }
        }
        return passStudents
    }

    func jsonParse(jsonURL: URL) throws {                                       // Json 파싱 함수
        guard let data = try? Data(contentsOf: jsonURL) else {
            throw GradeAnalysisError.invalidData                                // Data가 nil일 경우 에러 throw
        }
        if let jsons = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
            for json in jsons {                                                 // Dictionary 배열 순회
                guard let name = json[JsonElement.name.rawValue] as? String else {
                    throw GradeAnalysisError.invalidName                        // 이름이 String 형태가 아닐 경우 에러 throw
                }
                let student = Student(name: name)                               // 학생 클래스 인스턴스 생성
                guard let grade = json[JsonElement.grade.rawValue] as? [String: Int] else {
                    throw GradeAnalysisError.invalidGrade                       // 과목이 [String: Int]가 아닐 경우 에러 throw
                }
                for index in 0..<Subject.count {                                // 전체 과목들을 순회
                    let subject: String = String.init(describing: Subject(rawValue: index)!) // 과목 명
                    if let score = grade[subject] {
                        student.addSubject(name: subject, score: score)         // Json 포맷 내 학생이 수강한 과목이 있는 경우
                    } else {
                        print("\(name) didn't take the \(subject)")             // 수강하지 않은 과목의 경우 출력
                    }
                }
                students.append(student)                                        // 학생 명단에 추가
            }
            students.sort(by: { $0.name < $1.name })                            // 학생 명단을 학생 이름의 알파벳 순으로 정렬
        } else {
            throw GradeAnalysisError.invalidJsonFormat              // Json 형태가 [[String: Any가]] 아닐 경우 에러 throw
        }
    }
}

GradeAnalyzer().analyze()

