//
//  LoginVC.swift
//  RNDM
//
//  Created by Naoki Arakawa on 2019/04/28.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController {
  
  @IBOutlet weak var emailTxt: UITextField!
  @IBOutlet weak var passwordTxt: UITextField!
  @IBOutlet weak var loginBtn: UIButton!
  @IBOutlet weak var createUserBtn: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      loginBtn.layer.cornerRadius = 10
      createUserBtn.layer.cornerRadius = 10

       
    }
  
  
  @IBAction func loginBtnTapped(_ sender: Any) {
    
    guard let email = emailTxt.text,
      let password = passwordTxt.text else {return}

    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
      if error != nil {
        
        self.simpleAlert(title: "Error", msg: "An error occurred in this system.")
        
      } else {
        
        self.dismiss(animated: true, completion: nil)
        
      }
    }
  }
  
  
  @IBAction func createUserTappedBtn(_ sender: Any) {
  }
  

  
}
