//
//  HistoryDetailsViewController.swift
//  Evaluation Test App
//
//  Created by Владимир on 25.10.2021.
//

import UIKit

class HistoryDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        lol()
    }
    
    
    func lol() {
        

        guard let decoded = UserDefaults.standard.object(forKey: "HistoryDetails") as? Data else {
            return
        }
        
        let userDetails = try? JSONDecoder().decode(ResultsData.self, from: decoded)
        print(userDetails)
        
}
}
