//
//  LoadingBar.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 20.12.2021.
//

import UIKit

class LoadingBar: UIView {
    
    @IBOutlet weak var image1: UIView!
    @IBOutlet weak var image2: UIView!
    @IBOutlet weak var image3: UIView!
    
    func animate() {
        UIView.animate(withDuration: 0.9, delay: 0, options: [.autoreverse, .repeat]) {
            self.image1.alpha = 0.2
        }
        UIView.animate(withDuration: 0.9, delay: 0.3, options: [.autoreverse, .repeat]) {
            self.image2.alpha = 0.2
        }
        UIView.animate(withDuration: 0.9, delay: 0.6, options: [.autoreverse, .repeat]) {
            self.image3.alpha = 0.2
        }
    }

}
