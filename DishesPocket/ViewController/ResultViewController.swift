//
//  resultViewController.swift
//  DishesPocket
//
//  Created by 이운형 on 06/03/2019.
//  Copyright © 2019 201302458. All rights reserved.
//

import UIKit

class ResultViewController : UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var memoLabel: UIButton!
    @IBOutlet weak var memoImage: UIImageView?
    @IBOutlet weak var cancelButton: UIButton?
    
    // MARK: - Variables
    var resultText: String?
    
    // MARK: - Custom Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addResultImage()
        addResultText()
        addCancelButton()
        
        if let text = resultText {
            memoLabel.setAttributedTitle(NSAttributedString(string: text), for: UIControl.State.normal)
        }
    }
    
    func addResultImage() {
        let image: UIImageView = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(image)
        if let memoImage = UIImage(named: "sticker") {
            image.image = memoImage
        }
        
        image.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1).isActive = true
        
        memoImage = image
    }
    
    func addResultText() {
        let label: UIButton = UIButton(type: UIButton.ButtonType.custom)
        label.translatesAutoresizingMaskIntoConstraints = false
    
        guard let image = memoImage else {
            return
        }
        
        self.view.addSubview(label)
        label.addTarget(self, action: #selector(loadMapViewController(_:)), for: UIControl.Event.touchUpInside)
        label.titleLabel?.numberOfLines = 3
        label.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        label.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: image.widthAnchor, multiplier: 0.7).isActive = true
        label.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 0.1).isActive = true
        
        memoLabel = label
    }
    
    func addCancelButton() {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        guard let image = memoImage else {
            return
        }
        
        self.view.addSubview(button)
        button.setImage(UIImage(named: "cancel"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(dismissResultViewController(_:)), for: UIControl.Event.touchUpInside)
        
        button.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -self.view.frame.width*0.5*0.2).isActive = true
        button.topAnchor.constraint(equalTo: image.topAnchor, constant: self.view.frame.width*0.5*0.05).isActive = true
        button.widthAnchor.constraint(equalTo: image.widthAnchor, multiplier: 0.1).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1).isActive = true
        
        cancelButton = button
    }
    
    
    @objc func dismissResultViewController(_ sender:UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func loadMapViewController(_ sender:UIButton) {
        print("Button Touched!")
    }
}
