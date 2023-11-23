//
//  ViewController.swift
//  TechticDemo
//
//  Created by avinash on 23/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var users: [GitHubUser] = []
    var lastUserId: Int?
    let pageSize = 20
    var isLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSpinner()
        loadUsers()
    }
    func setupSpinner() {
        spinner.hidesWhenStopped = true
        tableView.tableFooterView = spinner
    }
    
    func loadUsers() {
        guard !isLoading else { return }
        
        isLoading = true
        spinner.startAnimating()
        
        GitHubAPIManager.shared.getUsers(since: lastUserId ?? 0, perPage: pageSize) { [weak self] newUsers, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error)")
            }
            
            if let newUsers = newUsers {
                self.users.append(contentsOf: newUsers)
                self.lastUserId = newUsers.last?.id
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            self.isLoading = false
            self.spinner.stopAnimating()
        }
    }
}
extension ViewController :UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! usercell
        let user = users[indexPath.row]
        cell.userName.text = user.login
        cell.userDetails.text = user.login
        cell.userImage.loadImage(from: user.avatarUrl)
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            // User is scrolling to the last cell, load more users
            loadUsers()
        }
    }
    
    // MARK: - UITableViewDelegate
    
    
    // Handle cell selection, navigate to user profile, etc.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        vc.userLogin = user.login
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



class usercell: UITableViewCell {
    
    @IBOutlet weak var userDetails: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var indicator: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
