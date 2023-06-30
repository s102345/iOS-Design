//
//  ViewController.swift
//  HW2
//
//  Created by  陳奕軒 on 2023/3/16.
//

import UIKit

class ViewController: UIViewController {
    
    var nameReceived: String? = nil
    var imageReceived: String? = nil
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let name = nameReceived, let img = imageReceived{
            nameLabel!.text = "名稱：\(name)"
            imageView!.image = UIImage(named: img)
        }
        else{
            nameLabel!.text = "發生錯誤！"
        }
    }


}

