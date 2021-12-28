//
//  SegueAfterLogin.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 28.12.2021.
//

import Foundation
import UIKit

class SegueAfterLogin: UIStoryboardSegue {
    override func perform() {
        let isValid = UserSession.shared.accessToken
        if  isValid == "" {
            showLoginErrorAlert()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.source.present(self.destination, animated: false, completion: nil)
            }
        }
    }
    
    func showLoginErrorAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Неправильный логин или пароль", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        self.source.present(alert, animated: true, completion: nil)
    }
}
