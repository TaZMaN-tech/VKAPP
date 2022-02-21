//
//  News.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 17.12.2021.
//

import Foundation
import UIKit
import Fakery
import LoremSwiftum

let fakes = Faker()

//struct News: Decodable {
//    var newsTitle: String
//    var authorName: String
//    var authorImage: String
//    //var author: User
//    var postDate: String
//    var text: String
//    var photos: [String]
//
//    static let fake: [News] = (1...10).map { _ in News(newsTitle: Lorem.title, authorName: Lorem.fullName, authorImage: String(Int.random(in: 1...10)), postDate: "1.1.1000", text: fakes.lorem.sentences(amount: 5), photos: Self.generatePhotos(count: Int.random(in: 0...10)))}
//
//    static func generatePhotos(count: Int) -> [String] {
//        guard count > 0 else { return [] }
//        return (1...count).compactMap { _ in String(Int.random(in: 1...10))}
//    }

struct News: Codable {
    let postID: Int
    let text: String?
    let date: Double
    let attachments: [Attachment]?
    let likes: LikeModel?
    let comments: CommentModel?
    let sourceID: Int
    var avatarURL: String?
    var creatorName: String?
    var photosURL: [String]? {
        get {
            let photosURL = attachments?.compactMap{ $0.photo?.sizes?.last?.url }
            return photosURL
        }
    }
    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case text
        case date
        case likes
        case comments
        case attachments
        case sourceID = "source_id"
        case avatarURL
        case creatorName
    }

    func getStringDate() -> String {
        let dateFormatter = DateFormatterVK()
        return dateFormatter.convertDate(timeIntervalSince1970: date)
    }

}

struct Attachment: Codable {
    let type: String?
    let photo: PhotoNews?
}

struct LikeModel: Codable {
    let count: Int
}

struct CommentModel: Codable {
    let count: Int
}

struct PhotoNews: Codable {
    let id: Int?
    let ownerID: Int?
    let sizes: [SizeNews]?

    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case sizes
    }
}

struct SizeNews: Codable {
    let type: String?
    let url: String?
}

class DateFormatterVK {
    let dateFormatter = DateFormatter()

    func convertDate(timeIntervalSince1970: Double) -> String{
        dateFormatter.dateFormat = "MM-dd-yyyy HH.mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        return dateFormatter.string(from: date)
    }
}

struct ResponseNews: Codable {
    let response: ItemsNews
}

struct ItemsNews: Codable {
    let items: [News]
    let profiles: [ProfileNews]
    let groups: [GroupNews]
    let nextFrom: String

    enum CodingKeys: String, CodingKey {
        case items
        case profiles
        case groups
        case nextFrom = "next_from"
    }
}

struct ProfileNews: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarURL = "photo_100"
    }
}

struct GroupNews: Codable {
    let id: Int
    let name: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarURL = "photo_100"
    }
}
