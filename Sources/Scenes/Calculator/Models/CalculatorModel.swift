import Foundation

enum CalculatorModelError: LocalizedError {
    case operationIsInvalid
    case notEnoughElement
    case divideByZero

    var errorDescription: String? {
        switch self {
        case .operationIsInvalid:
            return "Operation is invalid"
        case .notEnoughElement:
            return "Not enough elements to perform calculation"
        case .divideByZero:
            return "Division by zero is forbidden"
        }
    }
}

final class CalculatorModel {

    var rawElements = ""

    var elements: [String] {
        return rawElements.split(separator: " ").map { "\($0)" }
    }

    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "*" && elements.last != "/"
    }

    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "*" && elements.last != "/"
    }

    var expressionHaveResult: Bool {
        return elements.firstIndex(of: "=") != nil
    }

    func performMultiplicationAndDivision(_ operationsToReduce: [String]) -> Result<[String], CalculatorModelError> {
        var reducedOperations = operationsToReduce

        while reducedOperations.contains("*") || reducedOperations.contains("/") {
            if let multiplicationIndex = reducedOperations.firstIndex(of: "*") {
                guard let left = Double(reducedOperations[multiplicationIndex - 1]), let right = Double(reducedOperations[multiplicationIndex + 1]) else {
                    return .failure(.operationIsInvalid)
                }

                let result = left * right

                reducedOperations.replaceSubrange((multiplicationIndex - 1)...(multiplicationIndex + 1), with: ["\(result)"])
            } else if let divisionIndex = reducedOperations.firstIndex(of: "/") {
                guard let left = Double(reducedOperations[divisionIndex - 1]), let right = Double(reducedOperations[divisionIndex + 1]) else {
                    return .failure(.operationIsInvalid)
                }
                guard right != 0 else { return .failure(.divideByZero) }
                let result = left / right
                reducedOperations.replaceSubrange((divisionIndex - 1)...(divisionIndex + 1), with: ["\(result)"])
            }
        }

        return .success(reducedOperations)
    }

    func performAdditionAndSubtraction(_ operationsToReduce: [String]) -> Result<String, CalculatorModelError> {
        var reducedOperations = operationsToReduce

        while reducedOperations.count > 1 {
            guard let left = Double(reducedOperations[0]) else {
                return .failure(.operationIsInvalid)
            }

            let operand = reducedOperations[1]

            guard let right = Double(reducedOperations[2]) else {
                return .failure(.operationIsInvalid)
            }

            let result: Double
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: fatalError("Unknown operator !")
            }

            reducedOperations = Array(reducedOperations.dropFirst(3))
            reducedOperations.insert("\(result)", at: 0)
        }

        guard let result = reducedOperations.first else {
            return .failure(.operationIsInvalid)
        }

        return .success(result)
    }

    func evaluateExpression() -> Result<String, CalculatorModelError> {
        guard elements.last != "+" && elements.last != "-" && elements.last != "*" && elements.last != "/" else {
            return .failure(.operationIsInvalid)
        }

        guard elements.count >= 3 else {
            return .failure(.notEnoughElement)
        }

        let multiplicationAndDivisionResult = performMultiplicationAndDivision(elements)
        switch multiplicationAndDivisionResult {
        case .success(let operationsToReduce):
            return performAdditionAndSubtraction(operationsToReduce)
        case .failure(let error):
            return .failure(error)
        }
    }
}
