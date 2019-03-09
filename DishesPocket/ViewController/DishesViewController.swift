//
//  ViewController.swift
//  DishesPocket
//
//  Created by 이운형 on 05/03/2019.
//  Copyright © 2019 201302458. All rights reserved.
//

import UIKit

class DishesViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var pocketImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dishesAddButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var mixButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    let dishesBrain = DishesBrain()
    var isKeyBoardShown = false
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addProperties()
        textField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeNotification()
    }
    
    // MARK: - Custom methods
    func addProperties() {
        addImageView()
        addTextField()
        addDishesAddButton()
        addMixButton()
        addResetButton()
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadOverlapView(notification:)), name: .loadOverlapView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addDishEnd(notification:)), name: .addDishEnd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadEmptyListView), name: .emptyList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetDish), name: .resetDish, object: nil)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("loadOverlapView"), object: nil)
        NotificationCenter.default.removeObserver(self, name:Notification.Name("addDishEnd") , object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("emptyList"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("resetDish"), object: nil)
    }
    
    @objc func dismissKeyboard() {
        textField.resignFirstResponder()
        isKeyBoardShown = false
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
        guard let notificationUserInfo = notification.userInfo as? [String: Int],
            let dishCount = notificationUserInfo["count"] else { return }
        
        countLabel.text = String(dishCount)
        
        if !mixButton.isEnabled {
            mixButton.isEnabled = true
        }
    }
    
    @objc func loadEmptyListView() {
        // 원소가 없는 view를 load 한다.
    }
    
    @objc func resetDish() {
        countLabel.text = String(0)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("Notification: keyboard will show")
            
            if keyboardSize.height == 0.0 || isKeyBoardShown == true {
                return
            }
            
            UIView.animate(withDuration: 0.33, animations: { () -> Void in
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }, completion:{ condition in
                if condition { self.isKeyBoardShown = true
                    self.dishesAddButton.isEnabled = false
                    self.mixButton.isEnabled = false
                }
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("Notification keyboard will hide")
            if !isKeyBoardShown {
                return
            }
            
            UIView.animate(withDuration: 0.33, animations: { () -> Void in
                if self.view.frame.origin.y != 0 {
                    self.view.frame.origin.y += keyboardSize.height
                }
            }, completion:{ condition in
                if condition { self.isKeyBoardShown = false
                    self.dishesAddButton.isEnabled = true
                    if self.countLabel.text != "0" {
                        self.mixButton.isEnabled = true
                    }
                }
            })
        }
    }
    
    // MARK: - IBAction methods
    @IBAction func dishesAddButtonTouched(_ sender: UIButton) {
        guard let text = textField.text, text != "" else {
            return
        }
        dishesBrain.addDish(text)
    }
    
    @IBAction func mixButtonTouched(_ sender: UIButton) {
        // animation 효과를 준 뒤 ResultViewController를 띄운다.
        guard let output = dishesBrain.mixDish() else {
            return
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyBoard.instantiateViewController(withIdentifier: "ResultVC") as! ResultViewController
        secondVC.resultText = output
        
        present(secondVC, animated: false, completion: nil)
    }
    
    @IBAction func resetButtonTouched(_ sender: UIButton) {
        dishesBrain.resetDish()
        mixButton.isEnabled = false
    }
    
    // MARK: - Overriding method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - UI
    func addImageView() {
        let image:UIImageView = UIImageView(image: UIImage(named: "pocket"))
        image.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(image)
        
        image.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.height*0.1).isActive = true
        image.widthAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1).isActive = true
        
        pocketImage = image
    }
    
    func addTextField() {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "음식"
        text.textAlignment = NSTextAlignment.center
        text.layer.borderWidth = 1.0
        text.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(text)
        
        text.topAnchor.constraint(equalTo: pocketImage.bottomAnchor, constant: self.view.frame.height*0.1).isActive = true
        text.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.view.frame.width*0.3).isActive = true
        text.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width*0.3).isActive = true
        text.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        
        textField = text
    }
    
    func addDishesAddButton() {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "넣어버리기"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(dishesAddButtonTouched(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button)
        
        button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: self.view.frame.height*0.025).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.view.frame.width*0.3).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width*0.3).isActive = true
        button.heightAnchor.constraint(equalTo: textField.heightAnchor, multiplier: 1).isActive = true
        
        dishesAddButton = button
    }
    
    func addMixButton() {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "섞기"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(mixButtonTouched(_:)), for: UIControl.Event.touchUpInside)
        button.isEnabled = false
        self.view.addSubview(button)
        
        button.topAnchor.constraint(equalTo: dishesAddButton.bottomAnchor, constant: self.view.frame.height*0.025).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.view.frame.width*0.3).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width*0.3).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.view.frame.height*0.1).isActive = true
        button.heightAnchor.constraint(equalTo: dishesAddButton.heightAnchor, multiplier: 1).isActive = true
        
        mixButton = button
    }
    
    func addResetButton() {
        let button = UIButton(type: UIButton.ButtonType.custom)
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textAlignment = NSTextAlignment.right
        button.setImage(UIImage(named: "refresh"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(resetButtonTouched(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button)
        self.view.addSubview(label)
        
        button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height*0.075).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        button.bottomAnchor.constraint(equalTo: pocketImage.topAnchor, constant: -self.view.frame.height*0.075).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1).isActive = true
        
        label.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -5).isActive = true
        label.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        
        resetButton = button
        countLabel = label
    }
}

extension Notification.Name {
    static let loadOverlapView = Notification.Name("loadOverlapView")
    static let addDishEnd = Notification.Name("addDishEnd")
    static let emptyList = Notification.Name("emptyList")
    static let resetDish = Notification.Name("resetDish")
}
