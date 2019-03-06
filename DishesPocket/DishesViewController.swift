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
    @IBOutlet weak var mixButton: UIButton!
    
    let dishesBrain = DishesBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadOverlapView), name: Notification.Name("loadOverlapView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addDishEnd), name:Notification.Name("addDishEnd") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadEmptyListView), name: Notification.Name("emptyList"), object: nil)
    }

    // MARK: - IBAction methods
    @IBAction func dishesAddButtonTouched(_ sender: UIButton) {
        guard let text = textField.text, text != "" else {
            return
        }
        dishesBrain.addDish(text)
    }
    
    @IBAction func mixButtonTouched(_ sender: UIButton) {
        let output = dishesBrain.mixDish()
    }
    
    // MARK: - Custom methods
    @objc func loadOverlapView() {
        // 중복된 음식을 알리는 view를 사용자에게 띄운다,
    }
    
    @objc func addDishEnd() {
        textField.text = nil
        // list 개수를 로드한다.
    }
    
    @objc func loadEmptyListView() {
        // 원소가 없는 view를 load 한다.
    }
}

