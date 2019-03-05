//
//  DishesBrain.swift
//  DishesPocket
//
//  Created by 이운형 on 05/03/2019.
//  Copyright © 2019 201302458. All rights reserved.
//

import Foundation

class DishesBrain {
    var dishList = [String]()
    
    func addDish(_ dish:String) {
        if dishList.contains(dish) {
            NotificationCenter.default.post(name: Notification.Name("loadOverlapView"), object: self, userInfo: ["dish":dish])
        } else {
            dishList.append(dish)
        }
    }
}
