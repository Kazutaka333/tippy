//
//  ViewController.swift
//  tippy
//
//  Created by Kazutaka Homma on 1/31/19.
//  Copyright © 2019 Kazutaka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var tipLabel1: UILabel!
    @IBOutlet weak var tipLabel2: UILabel!
    @IBOutlet weak var tipLabel3: UILabel!
    @IBOutlet weak var tipLabel4: UILabel!
    @IBOutlet weak var totalLabel1: UILabel!
    @IBOutlet weak var totalLabel2: UILabel!
    @IBOutlet weak var totalLabel3: UILabel!
    @IBOutlet weak var totalLabel4: UILabel!
    
    var tipLabels: [UILabel]!
    var totalLabels: [UILabel]!
    var tipPercentages = [0.15, 0.18, 0.2, 0.0]
    var previousSegmentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tipLabels = [tipLabel1, tipLabel2, tipLabel3, tipLabel4]
        totalLabels = [totalLabel1, totalLabel2, totalLabel3, totalLabel4]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let customTipPercentage = UserDefaults.standard.double(forKey: "customTipPercentage")
        let ratio = (customTipPercentage/100.0)
        if ratio > 0 {
            tipPercentages[tipPercentages.count-1] = ratio
            tipControl.setTitle(String(format: "%.0f%%", customTipPercentage), forSegmentAt: tipPercentages.count-1)
            self.calculateTip(self)
        } else {
            tipControl.setTitle("Custom", forSegmentAt: tipPercentages.count-1)
        }
        
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        
        // Get the bill amount
        let bill = Double(billField.text!) ?? 0
        
        // Calculate tip and total
        
        
        var tip = 0.0
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        tip = bill * tipPercentage
        if tipPercentage == 0 {
            let alert = UIAlertController(title: "Tip Percentage is not set",
                                          message: "Tap % on the top right",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            tipControl.selectedSegmentIndex = previousSegmentIndex
        } else {
            previousSegmentIndex = tipControl.selectedSegmentIndex
        }
        let total = bill + tip
        
        // Update tip and total labels
        for i in 0..<tipLabels.count {
            let tipLabel = tipLabels[i]
            let totalLabel = totalLabels[i]
            tipLabel.text = String(format: "$%.2f", tip/Double(i+1))
            totalLabel.text = String(format: "$%.2f", total/Double(i+1))
        }
        
    }
}

