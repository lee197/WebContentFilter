//
//  ViewController.swift
//  TrueCalleriOS
//
//  Created by Jason Lee on 05/07/2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var firstTenthTextView: UITextView!
    @IBOutlet weak var everyTenthTextView: UITextView!
    @IBOutlet weak var wordCountTextView: UITextView!
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindResultViewModel()
        bindErrorViewModel()
    }
    
    private func bindResultViewModel() {
        viewModel.updateHtmlString = { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result.type {
            case .tenth:
                self.firstTenthTextView.text = result.result
            case .everyTenth:
                self.everyTenthTextView.text = result.result
            case .wordCount:
                self.wordCountTextView.text = result.result
            case .none:
                self.firstTenthTextView.text = result.result
                self.wordCountTextView.text = result.result
                self.everyTenthTextView.text = result.result
            }
        }
    }
    
    private func bindErrorViewModel() {
        viewModel.updateError = { [weak self] userError in
            guard let self = self else {
                return
            }
            self.showAlert(title: "Error", message: userError)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func startRequestsButtonePressed(_ sender: Any) {
        viewModel.startFindTenthRequest()
        viewModel.startWordCount()
        viewModel.startFindEveryTenthRequest()
    }
}

