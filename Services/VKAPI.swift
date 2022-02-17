//
//  VKAPI.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 28.12.2021.
//

import Foundation
import Alamofire
import RealmSwift

let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
let realm = try! Realm(configuration: config)

struct FriendsResponseOk: Decodable {
    var items: [User]
}

struct FriendsResponse: Decodable {
    var response: FriendsResponseOk
}

class PhotoSizeItem: Object, Codable {
    @Persisted var url: String
}

class PhotoItem: Object, Codable {
    @Persisted var id: Int = 0
    @Persisted var sizes: List<PhotoSizeItem>
    
    override class func primaryKey() -> String? {
        "id"
    }
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

struct NewsResponseOk: Decodable {
    var count: Int
    var items: [News]
}

struct NewsResponse: Decodable {
    var response: NewsResponseOk
}

class VKAPI {
    
    let baseUrl = "https://api.vk.com/method/"
    let vApi = "5.131"
    
    func callAPI(method: String, params: [String: String], completion: @escaping (AFDataResponse<Data>) -> Void) {
        var defParams = [
            "access_token": UserSession.shared.accessToken,
            "scope": "wall",
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
                self.saveUsersData(friendsResponse.response.items)
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
                self.savePhotoData(friendsResponse.response.items)
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
                self.saveGroupsData(groupsResponse.response.items)
                completionHnadler(groupsResponse.response.items)
            } catch let error {
                print(error)
                completionHnadler([])
            }
        }
    }
    
    func getNews (comletionHandler: @escaping ([News]) -> Void) {
        callAPI(method: "newsfeed.get", params: ["filter" : "post"], completion: { response in
            guard let data = response.data else { return }
            do {
                let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                self.saveNewsData(newsResponse.response.items)
                comletionHandler(newsResponse.response.items)
            } catch let error {
                print(error)
                comletionHandler([])
            }
            
        })
    }
    
    func searchGroups (q:String) {
        //        callAPI(method: "groups.search", params: ["q": q])
    }
    
    func saveUsersData(_ users: [User]) {
        do {
            try realm.write {
                realm.add(users, update: .modified)
            }
            print(realm.configuration.fileURL ?? "")
        } catch {
            print(error)
        }
    }
    
    func savePhotoData(_ photos: [PhotoItem]) {
        do {
            try realm.write {
                realm.add(photos, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func saveGroupsData(_ groups: [Group]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(groups, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func saveNewsData(_ news: [News]) {
        
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

