//
//  DetailVC.swift
//  TechticDemo
//
//  Created by avinash on 23/11/23.
//


import UIKit

class DetailVC: UIViewController {
    var userLogin: String?

    @IBOutlet weak var companyProfile: UILabel!
    @IBOutlet weak var blogProfile: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let userLogin = userLogin {
            showLoader()
            fetchUserProfile(login: userLogin)
        }
        navigationItem.hidesBackButton = true
    }

    func showLoader() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    func hideLoader() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    func fetchUserProfile(login: String) {
        GitHubAPIProfileManager.shared.getUserProfile(login: login) { [weak self] userProfile, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching user profile: \(error)")
                // Handle the error, show an alert, etc.
            } else if let userProfile = userProfile {
                // Update UI with the fetched user profile
                DispatchQueue.main.async {
                    self.profileName.text = userProfile.name ?? "N/A"
                    self.companyProfile.text = userProfile.company ?? "N/A"
                    self.blogProfile.text = userProfile.blog ?? "N/A"

                    // Assuming you have the user avatar URL, you can load it into the UIImageView
                    if let avatarURL = URL(string: userProfile.avatarUrl) {
                        do {
                            let imageData = try Data(contentsOf: avatarURL)
                            self.imgProfile.image = UIImage(data: imageData)
                        } catch {
                            print("Error loading image: \(error)")
                        }
                    }

                    self.hideLoader()  // Move hideLoader here after updating the UI
                }
            }
        }
    }

}
