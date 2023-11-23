//
//  GitHubAPIProfileManager.swift
//  TechticDemo
//
//  Created by avinash on 23/11/23.
//

import Foundation

class GitHubAPIProfileManager {
    static let shared = GitHubAPIProfileManager()

    private init() {}

    func getUserProfile(login: String, completion: @escaping (GitHubUserProfile?, Error?) -> Void) {
        guard let url = URL(string: "https://api.github.com/users/\(login)") else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(nil, error)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                let error = NSError(domain: "No data received", code: 1, userInfo: nil)
                completion(nil, error)
                return
            }

            do {
                let userProfile = try JSONDecoder().decode(GitHubUserProfile.self, from: data)
                completion(userProfile, nil)
            } catch {
                completion(nil, error)
            }
        }

        task.resume()
    }
}
