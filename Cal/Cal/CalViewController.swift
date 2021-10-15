//
//  CalViewController.swift
//  Cal
//
//  Created by wangxuan on 2021/10/07.
//  Copyright © 2021 wangxuan. All rights reserved.
//

import UIKit

class CalViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var clear: UIButton!
    
    @IBOutlet weak var e_y: UIButton!
    @IBOutlet weak var ten_2: UIButton!
    @IBOutlet weak var ln2log: UIButton!
    @IBOutlet weak var logten_2: UIButton!
    @IBOutlet weak var arcsin: UIButton!
    @IBOutlet weak var arccos: UIButton!
    @IBOutlet weak var arctan: UIButton!
    @IBOutlet weak var asinh: UIButton!
    @IBOutlet weak var acosh: UIButton!
    @IBOutlet weak var atanh: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.display.text! = "0"
        // Do any additional setup after loading the view.
    }
    
    var digitOnDisplay: String{
        get {
            return self.display.text!
        }
        
        set {
            self.display.text! = newValue
        }
    }
    
    var inTypingMode = false
    
    @IBAction func twoPressed(_ sender: UIButton) {
        clear.setTitle("C", for: .normal)
        if inTypingMode{
            digitOnDisplay = digitOnDisplay + sender.currentTitle!
        }
        else{
            digitOnDisplay = sender.currentTitle!
            inTypingMode = true
        }
    }
    
    let calculator = Calculator()
    var is_change:Bool = true
    
    @IBAction func operatorTouched(_ sender: UIButton) {
        if let op = sender.currentTitle{
            inTypingMode = false
            if op == "2nd"{
                if is_change{
                    e_y.setTitle("yˣ", for: .normal)
                    ten_2.setTitle("2ˣ", for: .normal)
                    ln2log.setTitle("logy", for: .normal)
                    logten_2.setTitle("log2", for: .normal)
                    arcsin.setTitle("sin⁻¹", for: .normal)
                    arccos.setTitle("cos⁻¹", for: .normal)
                    arctan.setTitle("tan⁻¹", for: .normal)
                    asinh.setTitle("asinh", for: .normal)
                    acosh.setTitle("acosh", for: .normal)
                    atanh.setTitle("atanh", for: .normal)
                    is_change = false
                }
                else{
                    e_y.setTitle("eˣ", for: .normal)
                    ten_2.setTitle("10ˣ", for: .normal)
                    ln2log.setTitle("ln", for: .normal)
                    logten_2.setTitle("log₁₀", for: .normal)
                    arcsin.setTitle("sin", for: .normal)
                    arccos.setTitle("cos", for: .normal)
                    arctan.setTitle("tan", for: .normal)
                    asinh.setTitle("sinh", for: .normal)
                    acosh.setTitle("cosh", for: .normal)
                    atanh.setTitle("tanh", for: .normal)
                    is_change = true
                }
                inTypingMode = true
            }
            else if let result = calculator.performOperation(operation: op, operand: Double(digitOnDisplay)!){
                if result != Double.nan{
                    digitOnDisplay = String(result)
                }
                /*else{
                    digitOnDisplay = "不是数字"
                }*/
            }
            if op == "Deg"{
                sender.setTitle("Rad", for: .normal)
            }
            else if op == "Rad"{
                sender.setTitle("Deg", for: .normal)
            }
            else if op == "C"{
                sender.setTitle("AC", for: .normal)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
