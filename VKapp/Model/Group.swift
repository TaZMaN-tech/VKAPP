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

let fakeGroups = Faker()
 
struct Group {
    var name: String
    var groupImage: String
    static var randomGroups = randomMany()
    
    
    static func randomOne() -> Group {
        Group(name: Lorem.title, groupImage: String(Int.random(in: 1...10)))
    }
    
    static func randomMany() -> [Group] {
        (1...20).map { _ in  randomOne()}
    }
}
