//
//  VKAPI.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 28.12.2021.
//

import Foundation
import Alamofire

class VKAPI {
    
    let baseUrl = "https://api.vk.com/method/"
    let vApi = "5.131"
    
    
    
    
    func callAPI(method: String, params: [String: String]) {
        var defParams = [
            "access_token": UserSession.shared.accessToken,
            "v": vApi
        ]
        params.forEach { (key, value) in defParams[key] = value }
        let parametres: Parameters = defParams
        
        let url = baseUrl + method
        
        AF.request(url, parameters: parametres).responseJSON { (response) in
            print(response.value ?? "NO JSON")
        }
    }
    
    func getFriends () {
        callAPI(method: "friends.get", params: ["fields": "photo_id"])
    }
    
    func getAllPhotos (ownerId: String) {
        callAPI(method: "photos.getAll", params: ["owner_id": ownerId])
    }
    
    func getGroups () {
        callAPI(method: "groups.get", params: ["extended": "1"])
    }
    
    func searchGroups (q:String) {
        callAPI(method: "groups.search", params: ["q": q])
    }
}

    
//    func getFriendsList () {
//        var urlComponents = URLComponents()
//            urlComponents.scheme = "https"
//            urlComponents.host = "api.vk.com"
//            urlComponents.path = "/method/users.get"
//            urlComponents.queryItems = [
//                URLQueryItem(name: "fields", value: "photo_id"),
//                URLQueryItem(name: "access_token", value: "\(Session.shared.token)"),
//                URLQueryItem(name: "v", value: "5.126")
//            ]
//    }

