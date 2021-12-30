//
//  User.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 03.12.2021.
//

import Foundation
import UIKit
import Fakery
import LoremSwiftum

let faker = Faker()

struct User:Decodable {
    var firstName: String
    var lastName: String
    var avatar: String
    var id: Int
    var photos: [String]
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "photo_100"
        case id = "id"
    }
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar) ?? ""
        self.id = try container.decode(Int.self, forKey: .id)
        self.photos = []
    }

    //MARK: - Fake
    
//
    //    static var randomOne: User{
//        User(firstName: faker.name.firstName(), lastName: faker.name.lastName(), avatar: String(Int.random(in: 1...10)), photos: (1...10).map { _ in String(Int.random(in: 1...10))} )
//    }
//
//    static var randomMany: [User]{
//        (1...20).map { _ in User.randomOne }
//    }
}
