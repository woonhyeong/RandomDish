//
//  resultViewController.swift
//  DishesPocket
//
//  Created by 이운형 on 06/03/2019.
//  Copyright © 2019 201302458. All rights reserved.
//

import UIKit

class ResultViewController : UIViewController {
    
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var memoImage: UIImageView?
    @IBOutlet weak var searchButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addResultImage()
        addResultText()
        addSearchButton()
    }
    
    func addResultImage() {
        let image: UIImageView = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(image)
        if let memoImage = UIImage(named: "sticker") {
            image.image = memoImage
        }
        
        let centerX : NSLayoutConstraint = image.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let centerY : NSLayoutConstraint = image.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        
        let width : NSLayoutConstraint = image.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5)
        let height : NSLayoutConstraint = image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1)
        
        centerX.isActive = true
        centerY.isActive = true
        width.isActive = true
        height.isActive = true
        
        memoImage = image
    }
    
    func addResultText() {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        guard let image = memoImage else {
            return
        }
        image.addSubview(label)
        label.textAlignment = NSTextAlignment.center
        label.text = "짜장면"
        
        let centerX : NSLayoutConstraint = label.centerXAnchor.constraint(equalTo: image.centerXAnchor)
        let centerY : NSLayoutConstraint = label.centerYAnchor.constraint(equalTo: image.centerYAnchor)
        let width : NSLayoutConstraint = label.widthAnchor.constraint(equalTo: image.widthAnchor, multiplier: 0.8)
        let height : NSLayoutConstraint =  label.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 0.1)
        
        centerX.isActive = true
        centerY.isActive = true
        width.isActive = true
        height.isActive = true
        
        memoLabel = label
    }
    
    func addSearchButton() {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        guard let image = memoImage else {
            return
        }
        image.addSubview(button)
        button.setImage(UIImage(named: "magnifier"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(loadMapViewController), for: UIControl.Event.touchUpInside)
        
        let trailing : NSLayoutConstraint = button.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -self.view.frame.width*0.5*0.2)
        let leading : NSLayoutConstraint = button.topAnchor.constraint(equalTo: image.topAnchor, constant: self.view.frame.width*0.5*0.05)
        let width : NSLayoutConstraint = button.widthAnchor.constraint(equalTo: image.widthAnchor, multiplier: 0.1)
        let height : NSLayoutConstraint =  button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1)
        
        trailing.isActive = true
        leading.isActive = true
        width.isActive = true
        height.isActive = true
        
        searchButton = button
    }
    
    @objc
    func loadMapViewController() {
        
    }
}
