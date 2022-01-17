//
//  File.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 03.12.2021.
//

import Foundation
import UIKit
import Fakery
import LoremSwiftum
import RealmSwift

let fakeGroups = Faker()
 
class Group: Object, Decodable {
    @Persisted var name: String
    @Persisted var groupImage: String
    @Persisted var id: Int
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case groupImage = "photo_100"
        case id
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.groupImage = try container.decode(String.self, forKey: .groupImage)
        self.id = try container.decode(Int.self, forKey: .id)
    }
//    static var randomGroups = randomMany()
//    
//    
//    static func randomOne() -> Group {
//        Group(name: Lorem.title, groupImage: String(Int.random(in: 1...10)))
//    }
//    
//    static func randomMany() -> [Group] {
//        (1...20).map { _ in  randomOne()}
//    }
}
