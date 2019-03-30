//
//  resultViewController.swift
//  DishesPocket
//
//  Created by 이운형 on 06/03/2019.
//  Copyright © 2019 201302458. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class ResultViewController : UIViewController, AVAudioPlayerDelegate{
    
    // MARK: - Properties
    @IBOutlet weak var memoLabel: UIButton!
    @IBOutlet weak var memoImage: UIImageView?
    @IBOutlet weak var cancelButton: UIButton?
    //@IBOutlet weak var cloudImageView: UIImageView?
    @IBOutlet weak var pocketImageView: UIImageView?
    
    // MARK: - Variables
    var resultText: String?
    var magicSoundPlayer : AVAudioPlayer!
    var shakeSoundPlayer : AVAudioPlayer!
    
    // MARK: - Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addProperties()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIImageView.animate(withDuration: 1.0, animations: {
            self.pocketImageView?.frame.origin.y += (self.memoImage!.center.y - self.pocketImageView!.center.y)
        }) {
            finished in
            self.shakeSoundPlayer.play()
            self.shake(duration: 1)
        }
    }
    
    // MARK: - Custom Methods
    func addProperties() {
        addPocketImage()
        addResultImage()
        addCancelButton()
        addResultText()
        addMagicSound()
        addShakeSound()
        if let text = resultText {
            memoLabel.setAttributedTitle(NSAttributedString(string: text), for: UIControl.State.normal)
        }
        self.view.layoutIfNeeded()
    }
    
    func addPocketImage() {
        let image: UIImageView = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(image)
        if let pocket = UIImage(named: "pocket") {
            image.image = pocket
        }
        
        image.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.height*0.1).isActive = true
        image.widthAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1).isActive = true
        
        pocketImageView = image;
    }
    
    func addResultImage() {
        let image: UIImageView = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.alpha = 0
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
        
        self.memoImage!.addSubview(label)
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
        
        self.memoImage!.addSubview(button)
        button.setImage(UIImage(named: "cancel"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(dismissResultViewController(_:)), for: UIControl.Event.touchUpInside)
        
        button.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -self.view.frame.width*0.5*0.2).isActive = true
        button.topAnchor.constraint(equalTo: image.topAnchor, constant: self.view.frame.width*0.5*0.05).isActive = true
        button.widthAnchor.constraint(equalTo: image.widthAnchor, multiplier: 0.1).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1).isActive = true
        
        cancelButton = button
    }
    
    func addMagicSound() {
        guard let soundAsset:NSDataAsset = NSDataAsset(name: "bbororong-Sound") else {
            print("음원 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            try self.magicSoundPlayer = AVAudioPlayer(data: soundAsset.data)
            self.magicSoundPlayer.delegate = self
        } catch let error as NSError {
            print("플레이어 초기화 실패")
            print("코드 : \(error.code), 메세지 : \(error.localizedDescription)")
        }
    }
    
    func addShakeSound() {
        guard let soundAsset:NSDataAsset = NSDataAsset(name: "shake_sound") else {
            print("음원 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            try self.shakeSoundPlayer = AVAudioPlayer(data: soundAsset.data)
            self.shakeSoundPlayer.delegate = self
        } catch let error as NSError {
            print("플레이어 초기화 실패")
            print("코드 : \(error.code), 메세지 : \(error.localizedDescription)")
        }
    }

    
    // MARK: - IBAction methods
    @IBAction func dismissResultViewController(_ sender:UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Animation
    func shake(duration: CFTimeInterval) {
        CATransaction.begin()
        
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map {
            ( degrees: Double) -> Double in
            let radians: Double = (.pi * degrees) / 180.0
            return radians
        }
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = duration
        
        CATransaction.setCompletionBlock({
            self.pocketImageView?.isHidden = true
            self.magicSoundPlayer.play()
            UIView.animate(withDuration: 2.0, animations: {
                self.memoImage!.alpha = 1.0
            }) {
                _ in
            }
        })
        self.pocketImageView?.layer.add(shakeGroup, forKey: "shakeIt")
        
        CATransaction.commit()
    }
}
