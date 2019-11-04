//
//  ViewController.swift
//  context-translater
//
//  Created by Иван Кнапп on 03/11/2019.
//  Copyright © 2019 Иван Кнапп. All rights reserved.
//

import Cocoa

class TargetViewController: NSViewController {

    @IBOutlet weak var targetText: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func translate(_ sender: Any) {
        var rawText = ""
        let text = sender as? String
        if  text != nil {
            rawText = text!
        }
        
        var url = "https://translate.googleapis.com/translate_a/single"
        
        var components = URLComponents(string: url)!

        components.queryItems = [
            URLQueryItem(name: "q", value: rawText),
            URLQueryItem(name: "client", value: "gtx"),
            URLQueryItem(name: "sl", value: "en"),
            URLQueryItem(name: "tl", value: "ru"),
            URLQueryItem(name: "dt", value: "t")
        ]
        
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    var arr:Array = json as! Array<Any>;
                    var get0 = arr[0] as! Array<Any>
                    var get0_0 = get0[0] as! Array<Any>
                    var get0_0_0 = get0_0[0] as! String
                    DispatchQueue.main.async { // Correct
                       self.targetText.stringValue = get0_0_0
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}

