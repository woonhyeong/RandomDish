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
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var mixButton: UIButton!
    
    let dishesBrain = DishesBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadOverlapView(notification:)), name: Notification.Name("loadOverlapView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addDishEnd(notification:)), name:Notification.Name("addDishEnd") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadEmptyListView), name: Notification.Name("emptyList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetDish), name: Notification.Name("resetDish"), object: nil)
    }
    
    // MARK: - IBAction methods
    @IBAction func dishesAddButtonTouched(_ sender: UIButton) {
        guard let text = textField.text, text != "" else {
            return
        }
        dishesBrain.addDish(text)
    }
    
    @IBAction func mixButtonTouched(_ sender: UIButton) {
        if let output = dishesBrain.mixDish() {
            print(output)
        }
    }
    
    @IBAction func resetButtonTouched(_ sender: UIButton) {
        dishesBrain.resetDish()
    }
    
    // MARK: - Custom methods
    func loadResultView() {
        // 결과 view를 띄운다.
        
    }
    
    // MARK: - Notification methods
    @objc func loadOverlapView(notification: Notification) {
        // 중복된 음식을 알리는 alert를 사용자에게 띄운다
        guard let notificationUserInfo = notification.userInfo as? [String: String],
            let overlappedDish = notificationUserInfo["dish"] else { return }
        
        let alert: UIAlertController = UIAlertController(title: overlappedDish, message: "중복된 음식입니다.", preferredStyle: UIAlertController.Style.alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addDishEnd(notification: Notification) {
        textField.text = nil
        // list 개수를 로드한다.
        guard let notificationUserInfo = notification.userInfo as? [String: Int],
            let dishCount = notificationUserInfo["count"] else { return }
        print(dishCount)
    }
    
    @objc func loadEmptyListView() {
        // 원소가 없는 view를 load 한다.
    }
    
    @objc func resetDish() {
        // 음식 개수를 나타내는 label을 0으로 초기화한다.
    }
}

