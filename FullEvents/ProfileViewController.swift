//
//  ProfileViewController.swift
//  FullEvents
//
//  Created by user on 11/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var emailId: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AccountHelperFile.userInfo() { result in
            
            let userData = result["data"]
            
            guard let firstName = userData["user"]["firstName"].string else {
                return
            }
            
            guard let lastName = userData["user"]["lastName"].string else {
                return
            }
            
            let fullName = "\(firstName + " " + lastName)"
            
            self.userName.text = fullName
            
            guard let emailId = userData["user"]["login"].string else {
                return
            }
            
            self.emailId.text = emailId
            
            guard let imageString = userData["user"]["photoId"].string else {
                return
            }
            
            guard let imageURL = URL(string: imageString) else {
                return
            }
            
            if  let data = try? Data(contentsOf: imageURL) {
                
                let picture = UIImage(data: data)
                
                self.image.image = picture
                self.image.layer.cornerRadius = self.image.frame.size.width / 2
                self.image.clipsToBounds = true
                self.image.layer.borderColor = UIColor.white.cgColor
                self.image.layer.borderWidth = 3
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Profile"
    }
}





