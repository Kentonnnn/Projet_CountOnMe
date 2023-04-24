import UIKit

class CalculatorViewController: UIViewController {

    private let calculatorModel = CalculatorModel()
    private var currentState: CalculatorState = .resultDisplayed

    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculatorModel.rawElements = "1 + 1 = 2"
        textView.text = calculatorModel.rawElements
    }

    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }

        if currentState == .resultDisplayed {
            textView.text = ""
            currentState = .newInputExpected
        }

        if textView.text == "0" {
            textView.text = ""
        }

        textView.text.append(numberText)
        calculatorModel.rawElements = textView.text
    }

    @IBAction func tappedClearCalculationButton(_ sender: UIButton) {
        textView.text = "0"
        currentState = .resultDisplayed
    }

    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        add(newOperator: "+")
    }

    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        add(newOperator: "-")
    }

    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        add(newOperator: "*")
    }

    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        add(newOperator: "/")
    }

    private func add(newOperator: String) {
        if calculatorModel.canAddOperator {
            textView.text.append(" \(newOperator) ")
            calculatorModel.rawElements = textView.text
            currentState = .newInputExpected
        } else {
            displayError(message: "Un opérateur est déjà ajouté !")
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        let result = calculatorModel.evaluateExpression()

        switch result {
        case .success(let value):
            textView.text = "\(value)"
            currentState = .resultDisplayed

        case .failure(let error):
            displayError(message: error.errorDescription ?? "")
        }
    }

    // Error check computed variables
    private func displayError(tittle: String = "Error", message: String) {
        let alertVC = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        present(alertVC, animated: true, completion: nil)
    }
}

enum CalculatorState {
    case resultDisplayed
    case newInputExpected
}
