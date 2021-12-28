//
//  SearchView.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 20.12.2021.
//

import UIKit

class SearchView: UIView, UITextFieldDelegate {

    var text: String? {
        return textField.text
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var textFiealdLeading: NSLayoutConstraint!
    @IBOutlet weak var searchIconCenterX: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonTrailing: NSLayoutConstraint!
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let iconWidth = searchIcon.frame.width
        searchIconCenterX.constant = -(bounds.width / 2 - iconWidth)
        textFiealdLeading.constant = iconWidth * 2
        cancelButtonTrailing.constant = 10
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        return true
    }
    
    //MARK: - Actions
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        textField.resignFirstResponder()
        
        searchIconCenterX.constant = 0
        textFiealdLeading.constant = 0
        cancelButtonTrailing.constant = -77
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    
}
