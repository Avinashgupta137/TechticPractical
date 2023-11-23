//
//  GitHubUser.swift
//  TechticDemo
//
//  Created by avinash on 23/11/23.
//

import Foundation

struct GitHubUser: Codable {
    let id: Int
    let login: String
    let avatarUrl: String
    let url: String
    let type: String
    let siteAdmin: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case url
        case type
        case siteAdmin = "site_admin"
    }
}
