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
    let viewMode = ViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        viewMode.updateHtmlString = { [weak self] result in
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


    @IBAction func startRequestsButtonePressed(_ sender: Any) {
        viewMode.startRequests()
    }
    
}

