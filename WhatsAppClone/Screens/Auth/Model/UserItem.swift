//
//  UserItem.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 17.06.24.
//

import Foundation

struct UserItem: Identifiable, Hashable, Decodable {
    let uid: String
    let username: String
    let email: String
    var bio: String? = nil
    var profileImageUrl: String? = nil
    
    var id: String {
        return uid
    }
    
    var bioUnwrapped: String {
        return bio ?? "Hey there! I am using WhatsApp."
    }
    
    static let placeholder = UserItem(uid: "1", username: "x1core", email: "maxmustermann@example.com")
    
    static let placeholders: [UserItem] = [
        UserItem(uid: "1", username: "Osas", email: "osas@yahoo.com", bio: "Avid reader, love to travel and explore new cultures."),
        UserItem(uid: "2", username: "John", email: "john@example.com", bio: "Passionate about technology and coding."),
        UserItem(uid: "3", username: "Jane", email: "jane@example.com", bio: "Fitness enthusiast, love to cook in my free time."),
        UserItem(uid: "4", username: "Alice", email: "alice@example.com", bio: "Nature lover and amateur photographer."),
        UserItem(uid: "5", username: "Bob", email: "bob@example.com", bio: "Musician at heart, love to play guitar."),
        UserItem(uid: "6", username: "Charlie", email: "charlie@example.com", bio: "Coffee connoisseur and bookworm."),
        UserItem(uid: "7", username: "David", email: "david@example.com", bio: "Love to paint and explore the world of art."),
        UserItem(uid: "8", username: "Eve", email: "eve@example.com", bio: "Passionate about astronomy and space exploration."),
        UserItem(uid: "9", username: "Frank", email: "frank@example.com", bio: "Love to write, dream to publish my own book one day."),
        UserItem(uid: "10", username: "Grace", email: "grace@example.com", bio: "A foodie who loves to try new cuisines."),
        UserItem(uid: "11", username: "Heidi", email: "heidi@example.com", bio: "A passionate gardener, love to spend time with nature."),
        UserItem(uid: "12", username: "Ivan", email: "ivan@example.com", bio: "A tech geek, love to build and tinker with gadgets.")
    ]
}


extension UserItem {
    init(dictionary: [String:Any]) {
        self.uid = dictionary[.uid] as? String ?? ""
        self.username = dictionary[.username] as? String ?? ""
        self.email = dictionary[.email] as? String ?? ""
        self.bio = dictionary[.bio] as? String? ?? ""
        self.profileImageUrl = dictionary[.profileImageUrl] as? String? ?? ""
    }
}

extension String {
    static let uid = "uid"
    static let username = "username"
    static let email = "email"
    static let bio = "bio"
    static let profileImageUrl = "profileImageUrl"
}
