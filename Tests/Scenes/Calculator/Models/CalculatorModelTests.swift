import XCTest
@testable import CountOnMe

final class CalculatorModelTests: XCTestCase {

    static var calculator: CalculatorModel!

        override class func setUp() {
            super.setUp()
            calculator = CalculatorModel()
        }

    var firstNumber = 5
    var secondNumber = 2

    func testGivenTwoNumbers_WhenPerformingAddition_ThenResultShouldBeCorrect() {
        // Given
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

    func testGivenTwoNumbers_WhenPerformingSubtraction_ThenResultShouldBeCorrect() {
        // Given
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

    func testGivenTwoNumbers_WhenPerformingMultiplication_ThenResultShouldBeCorrect() {
        // Given
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

    func testGivenTwoNumbers_WhenPerformingDivision_ThenResultShouldBeCorrect() {
        // Given
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

    func testGivenDivisorIsZero_WhenPerformingDivision_ThenErrorShouldBeDivideByZero() {
        // Given
        let numberZero = 0

        // When
        let result = CalculatorModelTests.calculator.performMultiplicationAndDivision([String(firstNumber), "/", String(numberZero)])

        // Then
        switch result {
        case .success(_):
            XCTFail("Expected division by zero error.")
        case .failure(let error):
            XCTAssertEqual(error, CalculatorModelError.divideByZero)
        }
    }

    func testEvaluateExpression() {

        // Test when the expression is valid and has multiple operations
        CalculatorModelTests.calculator.rawElements = "2 * 3 + 4 / 2"
        XCTAssertEqual(CalculatorModelTests.calculator.evaluateExpression(), .success("8.0"))

        // Test when the expression is invalid due to a trailing operator
        CalculatorModelTests.calculator.rawElements = "2 + 3 /"
        XCTAssertEqual(CalculatorModelTests.calculator.evaluateExpression(), .failure(.operationIsInvalid))

        // Test when the expression has less than 3 elements
        CalculatorModelTests.calculator.rawElements = "2"
            XCTAssertEqual(CalculatorModelTests.calculator.evaluateExpression(), .failure(.notEnoughElement))
    }

    func testExpressionIsCorrect() {

        // Test when the last element is an operator
        CalculatorModelTests.calculator.rawElements = "2 + 3 -"
        XCTAssertFalse(CalculatorModelTests.calculator.expressionIsCorrect)

        // Test when the last element is not an operator
        CalculatorModelTests.calculator.rawElements = "2 + 3"
        XCTAssertTrue(CalculatorModelTests.calculator.expressionIsCorrect)
    }

    func testCanAddOperator() {

        // Add elements to the calculator model
        CalculatorModelTests.calculator.rawElements = "2 + 3"

        // Check that an operator can be added to the calculator model
        XCTAssertTrue(CalculatorModelTests.calculator.canAddOperator)

        // Add an operator to the calculator model
        CalculatorModelTests.calculator.rawElements += " +"

        // Check that another operator cannot be added to the calculator model
        XCTAssertFalse(CalculatorModelTests.calculator.canAddOperator)
    }

    func testExpressionHaveResult() {

        // Test when there is an "=" sign
        CalculatorModelTests.calculator.rawElements = "2 + 3 ="
        XCTAssertTrue(CalculatorModelTests.calculator.expressionHaveResult)

        // Test when there is no "=" sign
        CalculatorModelTests.calculator.rawElements = "2 + 3"
        XCTAssertFalse(CalculatorModelTests.calculator.expressionHaveResult)
    }
}
