//
//  GitHubAPIManager.swift
//  TechticDemo
//
//  Created by avinash on 23/11/23.
//

import Foundation

class GitHubAPIManager {
    static let shared = GitHubAPIManager()

    private init() {}

    func getUsers(since userId: Int, perPage: Int, completion: @escaping ([GitHubUser]?, Error?) -> Void) {
        let urlString = "https://api.github.com/users?since=\(userId)&per_page=\(perPage)"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NSError(domain: "Invalid response", code: 0, userInfo: nil))
                return
            }

            if let data = data {
                do {
                    let users = try JSONDecoder().decode([GitHubUser].self, from: data)
                    completion(users, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }

        task.resume()
    }
}
