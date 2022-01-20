//
//  VKLoginViewController.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 28.12.2021.
//

import UIKit
import WebKit

class VKLoginViewController: UIViewController, WKNavigationDelegate {
    
    let service = VKAPI()

    @IBOutlet weak var webview: WKWebView! {
        didSet{
            webview.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        var token = userDefaults.string(forKey: "accessToken") ?? ""
        token = ""
        if token != "" {
            doLogin(token)
        } else {
            getLogin()
        }
    }
    
    func getLogin() {
        var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "oauth.vk.com"
            urlComponents.path = "/authorize"
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: "8037941"),
                URLQueryItem(name: "display", value: "mobile"),
                URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                URLQueryItem(name: "scope", value: "262150"),
                URLQueryItem(name: "response_type", value: "token"),
                URLQueryItem(name: "v", value: "5.131")
            ]
            
            let request = URLRequest(url: urlComponents.url!)
            
            webview.load(request)
    }
        
    func doLogin(_ token: String) {
        print(token)
        UserSession.shared.accessToken = token
        performSegue(withIdentifier: "SegueAfterLogin", sender: self)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html",
              let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        let token = params["access_token"] ?? ""
        let userDefaults = UserDefaults.standard
        userDefaults.set(token, forKey: "accessToken")
        
        doLogin(token)
        
        decisionHandler(.cancel)
    }
}
