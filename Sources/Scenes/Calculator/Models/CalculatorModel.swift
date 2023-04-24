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

    func evaluateExpression() -> Result<String, CalculatorModelError> {
        guard elements.last != "+" && elements.last != "-" && elements.last != "*" && elements.last != "/" else {
            return .failure(.operationIsInvalid)
        }

        guard elements.count >= 3 else {
            return .failure(.notEnoughElement)
        }

        var operationsToReduce = elements

        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!

            let result: Double
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "*": result = left * right
            case "/":
                guard right != 0 else { return .failure(.divideByZero) }
                result = left / right
            default: fatalError("Unknown operator !")
            }

            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }

        guard let result = operationsToReduce.first else {
            return .failure(.operationIsInvalid)

        }

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return .success(result)
    }
}
