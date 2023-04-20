import Foundation

struct CalculatorModel {
    static func evaluateExpression(_ expression: String) -> String? {
        let elements = expression.split(separator: " ").map { "\($0)" }

        guard elements.last != "+" && elements.last != "-" && elements.last != "*" && elements.last != "/" else {
            return nil
        }

        guard elements.count >= 3 else {
            return nil
        }

        var operationsToReduce = elements

        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!

            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "*": result = left * right
            case "/":
                guard right != 0 else { return nil }
                result = left / right
            default: fatalError("Unknown operator !")
            }

            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }

        return operationsToReduce.first
    }
}
