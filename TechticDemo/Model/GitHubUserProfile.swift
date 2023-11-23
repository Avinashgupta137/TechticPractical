//
//  GitHubUserProfile.swift
//  TechticDemo
//
//  Created by avinash on 23/11/23.
//


import Foundation

struct GitHubUserProfile: Codable {
    let login: String
    let name: String?
    let company: String?
    let blog: String?
    let avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case login, name, company, blog
        case avatarUrl = "avatar_url"
    }
}
