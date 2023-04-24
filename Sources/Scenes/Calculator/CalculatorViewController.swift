import UIKit

class CalculatorViewController: UIViewController {

    private let calculatorModel = CalculatorModel()

    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculatorModel.rawElements = "1 + 1"
    }

    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }

        if calculatorModel.expressionHaveResult {
            textView.text = ""
            calculatorModel.rawElements = textView.text
        }

        textView.text.append(numberText)
        calculatorModel.rawElements = textView.text
    }

    @IBAction func tappedClearCalculationButton(_ sender: UIButton) {
        textView.text = "0"
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
        } else {
            displayError(message: "Un opérateur est déjà ajouté !")
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        let result = calculatorModel.evaluateExpression()

        switch result {
        case .success(let value):
            textView.text.append(" = \(value)")

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
