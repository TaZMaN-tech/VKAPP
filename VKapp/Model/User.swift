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

struct User {
    var firstName: String
    var lastName: String
    var fullName: String {
        "\(lastName) \(firstName)"
    }
    var avatar: String
    var photos: [String]
    
    static var randomOne: User{
        User(firstName: faker.name.firstName(), lastName: faker.name.lastName(), avatar: String(Int.random(in: 1...10)), photos: (1...10).map { _ in String(Int.random(in: 1...10))} )
    }
    
    static var randomMany: [User]{
        (1...20).map { _ in User.randomOne }
    }
}
