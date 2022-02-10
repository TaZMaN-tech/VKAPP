//
//  News.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 17.12.2021.
//

import Foundation
import Fakery
import LoremSwiftum

let fakes = Faker()

struct News {
    var newsTitle: String
    var authorName: String
    var authorImage: String
    var postDate: String
    var text: String
    var photos: [String]
    
    static let fake: [News] = (1...10).map { _ in News(newsTitle: Lorem.title, authorName: Lorem.fullName, authorImage: String(Int.random(in: 1...10)), postDate: "1.1.1000", text: fakes.lorem.sentences(amount: 5), photos: Self.generatePhotos(count: Int.random(in: 0...10)))}
    
    static func generatePhotos(count: Int) -> [String] {
        guard count > 0 else { return [] }
        return (1...count).compactMap { _ in String(Int.random(in: 1...10))}
    }
}
 

