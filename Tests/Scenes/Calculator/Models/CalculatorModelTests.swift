import XCTest
@testable import CountOnMe

final class CalculatorModelTests: XCTestCase {

    static var calculator: CalculatorModel!

        override class func setUp() {
            super.setUp()
            calculator = CalculatorModel()
        }

    func testAddition() {
        // Given
        let firstNumber = 5
        let secondNumber = 2
        let expectedResult = "7.0"

        // When
        let result =
        CalculatorModelTests.calculator.performAdditionAndSubtraction([String(firstNumber), "+", String(secondNumber)])

        // Then
        switch result {
        case .success(let value):
            XCTAssertEqual(value, expectedResult)
        case .failure(let error):
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }

    func testSubtraction() {
        // Given
        let firstNumber = 5
        let secondNumber = 2
        let expectedResult = "3.0"

        // When
        let result =
        CalculatorModelTests.calculator.performAdditionAndSubtraction([String(firstNumber), "-", String(secondNumber)])

        // Then
        switch result {
        case .success(let value):
            XCTAssertEqual(value, expectedResult)
        case .failure(let error):
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }

    func testMultiplication() {
        // Given
        let firstNumber = 5
        let secondNumber = 2
        let expectedResult = "10.0"

        // When
        let result = CalculatorModelTests.calculator.performMultiplicationAndDivision([String(firstNumber), "*", String(secondNumber)])

        // Then
        switch result {
        case .success(let value):
            let joinedResult = value.joined(separator: " ")
            XCTAssertEqual(joinedResult, expectedResult)
        case .failure(let error):
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }

    func testDivision() {
        // Given
        let firstNumber = 5
        let secondNumber = 2
        let expectedResult = "2.5"

        // When
        let result = CalculatorModelTests.calculator.performMultiplicationAndDivision([String(firstNumber), "/", String(secondNumber)])

        // Then
        switch result {
        case .success(let value):
            let joinedResult = value.joined(separator: " ")
            XCTAssertEqual(joinedResult, expectedResult)
        case .failure(let error):
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }

    // test priorité calcul

    // test decimal

    // test pas de zéro si resultat rond
}
