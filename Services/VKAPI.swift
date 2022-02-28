//
//  VKAPI.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 28.12.2021.
//

import Foundation
import Alamofire
import RealmSwift
import PromiseKit

enum AppError: Error {
    case noDataProvided
    case failedToDecode
    case errorTask
    case notCorrectUrl
}


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

//struct NewsResponseOk: Decodable {
////    var count: Int
//    var items: [News]
//}
//
//struct NewsResponse: Decodable {
//    var response: NewsResponseOk
//}

class VKAPI {
    
    let baseUrl = "https://api.vk.com/method/"
    let vApi = "5.131"
    
    private var urlConstructor = URLComponents()
    private let configuration: URLSessionConfiguration
    private let session: URLSession!
    
    init() {
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
    
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


    
    //MARK: - News service
    
    func getNews (comletionHandler: @escaping ([News]) -> Void) {
        callAPI(method: "newsfeed.get", params: ["filter" : "post", "start_from" : "next_from", "count" : "20"], completion: { response in
            switch (response.result) {
            case .success:
                guard let data = response.data else { return }
                //print(String(decoding: data, as: UTF8.self))
                do {
                    let newsResponse = try JSONDecoder().decode(ResponseNews.self, from: data)
                    self.saveNewsData(newsResponse.response.items)
                    comletionHandler(newsResponse.response.items)
                } catch let error {
                    print(error)
                    comletionHandler([])
                }
            case .failure:
                return
            }
        })
    }
    
    
    // Result use
    
    
    
    func getNewsRes (completion: @escaping ([News]) -> Void, onError: @escaping (Error) -> Void) {

        // 1. Создаем URL для запроса
        urlConstructor.path = "/method/newsfeed.get"

        urlConstructor.queryItems = [
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "start_from", value: "next_from"),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "access_token", value: UserSession.shared.accessToken),
            URLQueryItem(name: "v", value: vApi),
        ]

        // 2. Создаем запрос
        let task = session.dataTask(with: urlConstructor.url!) {  (data, response, error) in

            // 3. Ловим ошибку
            if error != nil {
                onError(AppError.errorTask)
            }
            // 4 Проверяем есть ли data
            guard let data = data else {
                onError(AppError.noDataProvided)
                return
            }
            // 5 Парсим data
            guard var news = try? JSONDecoder().decode(ResponseNews.self, from: data).response.items else {
                onError(AppError.failedToDecode)
                return
            }
            guard let profiles = try? JSONDecoder().decode(ResponseNews.self, from: data).response.profiles else {
                onError(AppError.failedToDecode)
                print("Error profiles")
                return
            }
            guard let groups = try? JSONDecoder().decode(ResponseNews.self, from: data).response.groups else {
                onError(AppError.failedToDecode)
                print("Error groups")
                return
            }

            // 6 Объединяю массивы
            for i in 0..<news.count {
                if news[i].sourceID < 0 {
                    let group = groups.first(where: { $0.id == -news[i].sourceID })
                    news[i].avatarURL = group?.avatarURL
                    news[i].creatorName = group?.name
                } else {
                    let profile = profiles.first(where: { $0.id == news[i].sourceID })
                    news[i].avatarURL = profile?.avatarURL
                    news[i].creatorName = (profile?.firstName ?? "") + (profile?.lastName ?? "")
                }
            }

            DispatchQueue.main.async {
                completion(news)
            }
        }
        task.resume()
    }
    
// MARK: - Promices

// 1. Создаем URL для запроса
func getUrl() -> Promise<URL> {
    urlConstructor.path = "/method/newsfeed.get"

    urlConstructor.queryItems = [
        URLQueryItem(name: "filters", value: "post"),
        URLQueryItem(name: "start_from", value: "next_from"),
        URLQueryItem(name: "count", value: "20"),
        URLQueryItem(name: "access_token", value: UserSession.shared.accessToken),
        URLQueryItem(name: "v", value: vApi),
    ]

    return Promise  { resolver in
        guard let url = urlConstructor.url else {
            resolver.reject(AppError.notCorrectUrl)
            return
        }
        resolver.fulfill(url)
    }
}

// 2. Создаем запрос получили данные
func getData(_ url: URL) -> Promise<Data> {
    return Promise { resolver in
        session.dataTask(with: url) {  (data, response, error) in
            guard let data = data else {
                resolver.reject(AppError.errorTask)
                return
            }
            resolver.fulfill(data)
        }.resume()
    }
}

// Парсим Данные
func getParsedData(_ data: Data) -> Promise<ItemsNews> {
    return Promise  { resolver in
        do {
            let response = try JSONDecoder().decode(ResponseNews.self, from: data).response
            resolver.fulfill(response)
        } catch {
            resolver.reject(AppError.failedToDecode)
        }
    }
}

func getNews(_ items: ItemsNews) -> Promise<[News]> {
    return Promise<[News]> { resolver in
        var news = items.items
        let groups = items.groups
        let profiles = items.profiles

        for i in 0..<news.count {
            if news[i].sourceID < 0 {
                let group = groups.first(where: { $0.id == -news[i].sourceID })
                news[i].avatarURL = group?.avatarURL
                news[i].creatorName = group?.name
            } else {
                let profile = profiles.first(where: { $0.id == news[i].sourceID })
                news[i].avatarURL = profile?.avatarURL
                news[i].creatorName = (profile?.firstName ?? "") + (profile?.lastName ?? "")
            }
        }
        resolver.fulfill(news)
    }
}
}

