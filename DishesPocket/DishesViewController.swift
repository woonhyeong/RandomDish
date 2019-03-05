//
//  ViewController.swift
//  DishesPocket
//
//  Created by 이운형 on 05/03/2019.
//  Copyright © 2019 201302458. All rights reserved.
//

import UIKit

class DishesViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dishesAddButton: UIButton!
    
    let dishesBrain = DishesBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadOverlapView), name: Notification.Name("loadOverlapView"), object: nil)
    }

    @IBAction func dishesAddButtonTouched(_ sender: UIButton) {
        guard let text = textField.text, text != "" else {
            return
        }
        dishesBrain.addDish(text)
        
    }
    
    @objc func loadOverlapView() {
        
    }
}

