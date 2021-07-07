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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    private func findtenth() -> String {
        let htmlString = fetchHtml()
        let webContentProcessor = WebContentProcessor(htmlString: htmlString)
        do {
            return try webContentProcessor.findTenthCharacter()
        } catch let error {
            print(error)
            return ""
        }
    }
    
    private func findEveryTenth() -> String {
        let htmlString = fetchHtml()
        let webContentProcessor = WebContentProcessor(htmlString: htmlString)
        do {
            return try webContentProcessor.findEveryTenthCharacter()
        } catch let error {
            print(error)
            return ""
        }
    }
    
    private func wordCount() -> Dictionary<String, Int> {
        let htmlString = fetchHtml()
        let webContentProcessor = WebContentProcessor(htmlString: htmlString)
        return webContentProcessor.wordCount()
    }
    
    private func fetchHtml() -> String {
        
        let myURLString = "https://truecaller.blog/2018/03/15/how-to-become-an-ios-developer/"

        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return ""
        }

        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
//            print("HTML : \(myHTMLString)")
            return myHTMLString
        } catch let error {
            print("Error: \(error)")
            return ""
        }
    }

    @IBAction func startRequestsButtonePressed(_ sender: Any) {
        DispatchQueue.global().async { [weak self] in
            let tenthChar = self?.findtenth()
            DispatchQueue.main.async { [weak self] in
                self?.firstTenthTextView.text = tenthChar
            }
        }
        
        DispatchQueue.global().async { [weak self] in
            let everyTenthChar = self?.findEveryTenth()
            DispatchQueue.main.async { [weak self] in
                self?.everyTenthTextView.text = everyTenthChar
            }
        }
        
        DispatchQueue.global().async { [weak self] in
            let wordCount = self?.wordCount()
            DispatchQueue.main.async { [weak self] in
                self?.wordCountTextView.text = wordCount?.description
            }
        }
    }
    
}

