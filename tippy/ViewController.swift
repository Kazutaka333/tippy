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
    
    @IBOutlet weak var billFieldBackgroundViewHeightConstraint: NSLayoutConstraint!
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
    var viewJustLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tipLabels = [tipLabel1, tipLabel2, tipLabel3, tipLabel4]
        totalLabels = [totalLabel1, totalLabel2, totalLabel3, totalLabel4]
        viewJustLoaded = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let customTipPercentage = UserDefaults.standard.double(forKey: "customTipPercentage")
        let ratio = (customTipPercentage/100.0)
        if tipPercentages[tipPercentages.count-1] != ratio {
            if ratio > 0 {
                tipPercentages[tipPercentages.count-1] = ratio
                tipControl.setTitle(String(format: "%.0f%%", customTipPercentage), forSegmentAt: tipPercentages.count-1)
                self.calculateTip(self)
            } else {
                tipControl.setTitle("Custom", forSegmentAt: tipPercentages.count-1)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewJustLoaded {
            tipControl.isHidden = true
            self.billFieldBackgroundViewHeightConstraint.constant = 400
            UIView.animate(withDuration: 1) {
                self.tipControl.alpha = 0
                self.billField.becomeFirstResponder()
                self.view.layoutIfNeeded()
            }
            viewJustLoaded = false
        }
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        
        // Get the bill amount
        let bill = Double(billField.text!) ?? 0
        
        if billFieldBackgroundViewHeightConstraint.constant == 400 {
            self.billFieldBackgroundViewHeightConstraint.constant = 170
            self.tipControl.isHidden = false
            UIView.animate(withDuration: 1) {
                self.tipControl.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
        
        
        // Calculate tip and total
        var tip = 0.0
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
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

