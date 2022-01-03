//
//  VKAPI.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 28.12.2021.
//

import Foundation
import Alamofire

struct FriendsResponseOk: Decodable {
    var items: [User]
}

struct FriendsResponse: Decodable {
    var response: FriendsResponseOk
}

struct PhotoSizeItem: Decodable {
    var url: String
}

struct PhotoItem: Decodable {
    var id: Int
    var sizes: [PhotoSizeItem]
}

struct PhotosResponseOk: Decodable {
    var items: [PhotoItem]
}

struct PhotosResponse:Decodable {
    var response: PhotosResponseOk
}

struct GroupsResponseOk: Decodable {
    var count: Int
    var items: [Group]
}

struct GroupsResponse: Decodable {
    var response: GroupsResponseOk
}

class VKAPI {
    
    let baseUrl = "https://api.vk.com/method/"
    let vApi = "5.131"
    
    func callAPI(method: String, params: [String: String], completion: @escaping (AFDataResponse<Data>) -> Void) {
        var defParams = [
            "access_token": UserSession.shared.accessToken,
            "v": vApi
        ]
        params.forEach { (key, value) in defParams[key] = value }
        let parametres: Parameters = defParams
        
        let url = baseUrl + method
        
        AF.request(url, parameters: parametres).responseData(completionHandler: completion)
    }
    
    
    func getFriends (completionHandler:  @escaping ([User]) -> Void)  {
        callAPI(method: "friends.get", params: ["fields": "photo_100"]) { response in
            guard let data = response.data else {return}
            do {
                let friendsResponse = try JSONDecoder().decode(FriendsResponse.self, from: data)
                completionHandler(friendsResponse.response.items)
            } catch {
                print(error)
                completionHandler([])
            }
        }
    }
        
    func getAllPhotos (ownerId: Int, completionHandler:  @escaping ([String])->Void) {
        callAPI(method: "photos.getAll", params: ["owner_id": String(ownerId)]){ response in
            guard let data = response.data else {return}
            do {
                let friendsResponse = try JSONDecoder().decode(PhotosResponse.self, from: data)
                var aaa: [String] = []
                for photo in friendsResponse.response.items {
                    aaa.append(photo.sizes[0].url)
                }
                completionHandler(aaa)
            } catch {
                print(error)
                completionHandler([])
            }
        }
    }
    
    func getGroups (completionHnadler: @escaping ([Group]) -> Void) {
        callAPI(method: "groups.get", params: ["access_token": String(UserSession.shared.accessToken), "extended": "1"]) { response in
            guard let data = response.data else {return}
            do {
                let groupsResponse = try JSONDecoder().decode(GroupsResponse.self, from: data)
                completionHnadler(groupsResponse.response.items)
            } catch let error {
                print(error)
                completionHnadler([])
            }
        }
    }
    
    func searchGroups (q:String) {
        //        callAPI(method: "groups.search", params: ["q": q])
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

