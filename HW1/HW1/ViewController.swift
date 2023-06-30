//
//  ViewController.swift
//  HW1
//
//  Created by  陳奕軒 on 2023/3/3.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0){
            return 100
        }
        else if(component == 1){
            return 100
        }
        else{
            return 100
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0){
            return col1[row]
        }
        else if(component == 1){
            return col2[row]
        }
        else{
            return col3[row]
        }
    }
    
    let symbol = ["🍎","🍒", "🍉", "🍊", "🔔", "7️⃣", "👑", "BAR"]
    var score = 0
    var col1 = [String]()
    var col2 = [String]()
    var col3 = [String]()
    
    let winDict = [ "🍎": 1,
                    "🍒": 2,
                    "🍉": 4,
                    "🍊": 8,
                    "🔔": 16,
                    "7️⃣": 32,
                    "👑": 64,
                    "BAR": 128]
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var barView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        barView.delegate = self
        barView.dataSource = self
        for _ in 1...100{
            col1.append(symbol[(Int)(arc4random() % 8)])
            col2.append(symbol[(Int)(arc4random() % 8)])
            col3.append(symbol[(Int)(arc4random() % 8)])
        }
        
        for i in 0...2{
            barView.selectRow(Int(arc4random()) % 100, inComponent: i, animated: true)
        }
        userScore.text = "分數: \(score)"
    }
    
    @IBAction func testButtonPressed(_ sender: UIButton) {
        winJudge()
    }
    override func viewDidAppear(_ animated: Bool) {
        func login(){
            let alert = UIAlertController(title: "登入", message: "請輸入帳號密碼", preferredStyle: .alert)
            
            alert.addTextField {
                (textField) in textField.placeholder = "Login"
            }
            alert.addTextField {
                (textField) in textField.placeholder = "Password"
                textField.isSecureTextEntry = true
            }
            
            let cancelAction = UIAlertAction(
                title: "取消",
                style: .cancel){
                    (action) in self.dismiss(animated: true, completion: nil)
                    let userName = "Anonymous"
                    self.userName.text = "您好，\(userName)"
                }
            
            alert.addAction(cancelAction)
            
            let okAction = UIAlertAction(
                title: "登入",
                style: .default){
                    (action) in self.dismiss(animated: true)
                    let userName = (alert.textFields?.first)!.text
                    let userPassword = (alert.textFields?.last)!.text
                    
                    if (userName != "" && userPassword != ""){
                        self.userName.text = "您好，\(userName!)"
                        if (userName == "Test" && userPassword == "123"){
                            self.testButton.isHidden = false
                        }
                    }
                
                    else if (userName == ""){
                        inputEmpty(EmptyInput: "名字")
                    }
                    else if(userPassword == ""){
                        inputEmpty(EmptyInput: "密碼")
                    }

                }
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
        }
        func inputEmpty(EmptyInput lackedInput:String){
            let controller = UIAlertController(
                title: "您還沒輸入\(lackedInput)！",
                message: "請輸入\(lackedInput)",
                preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default){
                (action) in self.dismiss(animated: true, completion: nil)
                login()
            }
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
        login()
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        for i in 0...2{
            barView.selectRow(Int(arc4random()) % 100, inComponent: i, animated: true)
        }
        winJudge()
       
    }
    
    func winJudge(){
        let firstSymbol = col1[barView.selectedRow(inComponent: 0)]
        let secondSymbol = col2[barView.selectedRow(inComponent: 1)]
        let thirdSymbol = col3[barView.selectedRow(inComponent: 2)]
        
        if (firstSymbol == secondSymbol && secondSymbol == thirdSymbol){
            print("\(firstSymbol) 中獎")
            let win = winDict[firstSymbol]!
            
            if win >= 50{
                let controller = UIAlertController(
                    title: "中大獎",
                    message: "恭喜你中大獎！！！",
                    preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default){
                    (action) in self.dismiss(animated: true, completion: nil)
                }
                controller.addAction(okAction)
                present(controller, animated: true, completion: nil)

            }
            
            score += win
            userScore.text = "分數: \(score)"
        }
    }
    
    
}

