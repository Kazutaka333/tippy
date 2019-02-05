//
//  SettingViewController.swift
//  tippy
//
//  Created by Kazutaka Homma on 2/4/19.
//  Copyright © 2019 Kazutaka. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var tipPercentageField: UITextField!
    let customTipPercentageKey = "customTipPercentage"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let customTipPercentage = UserDefaults.standard.double(forKey: customTipPercentageKey)
        tipPercentageField.text = String(format: "%.0f", customTipPercentage)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let value = Double(tipPercentageField.text!) ?? 0.0
        if  0 < value && value <= 100 {
            UserDefaults.standard.set(value, forKey: customTipPercentageKey)
        } else {
            let alert = UIAlertController(title: "Tip Percentage has to be more than 0 and less or equal to 100",
                                          message: "",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
    }

}
