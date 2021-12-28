//
//  ViewController.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 25.10.2021.
//

import UIKit



class LoginViewController: UIViewController {
    
    // MARK: - IB Outlets

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loadingBar: LoadingBar!
    
    //MARK: - Life Cycles Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardDidHideNotification,
                                                  object: nil)
        
    }
    
    // MARK: - IB Actions
    
    @IBAction func scrollViewTapped(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func actionTapped(_ sender: Any?) {
        loadingBar.animate()
    }
    
    
    // MARK: - Keyboard Methods
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let kbSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
    }
    
    @objc func keyboardWillHide() {
        scrollView.contentInset = .zero
    }

}



