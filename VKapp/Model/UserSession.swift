//
//  File.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 28.12.2021.
//

import Foundation

class UserSession {
    
    static let shared = UserSession()
    private init() {}
    
    var accessToken: String = ""
    var id: Int = 0
}
