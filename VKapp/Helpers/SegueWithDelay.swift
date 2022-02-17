//
//  SegueAfterLogin.swift
//  VKClient
//
//  Created by Тадевос Курдоглян on 18.11.2020.
//

import UIKit

class SegueWithDelay: UIStoryboardSegue {
    override func perform() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.source.present(self.destination, animated: false, completion: nil)
        }
    }

}
