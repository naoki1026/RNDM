//
//  CreateUserVC.swift
//  RNDM
//
//  Created by Naoki Arakawa on 2019/04/28.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateUserVC: UIViewController {
  
  @IBOutlet weak var emailTxt: UITextField!
  @IBOutlet weak var passwordTxt: UITextField!
  @IBOutlet weak var usernameTxt: UITextField!
  @IBOutlet weak var createBtn: UIButton!
  @IBOutlet weak var cancelBtn: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      createBtn.layer.cornerRadius = 10
      cancelBtn.layer.cornerRadius = 10
  
      
    }
    
  @IBAction func createTapped(_ sender: Any) {
    
    guard let email = emailTxt.text,
      let password = passwordTxt.text,
      let username = usernameTxt.text else {return}
  
    Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
      
      if  error != nil {
        
        self.simpleAlert(title: "Error", msg: "An error occurred in this system.")

        return
        
      }
      
     let changeRequest = authResult?.user.createProfileChangeRequest()
      changeRequest?.displayName = username
      changeRequest?.commitChanges(completion: { (error) in
        if error != nil {
          
        self.simpleAlert(title: "Error", msg: "An error occurred in this system.")
          
        }
      })
      
      guard let userId = authResult?.user.uid else {return}
      Firestore.firestore().collection(USERS_REF).document(userId).setData([
        USERNAME : username,
        DATE_CREATED : FieldValue.serverTimestamp()
        ], completion: { (error) in
        
          if error != nil {
            
            self.simpleAlert(title: "Error", msg: "An error occurred in this system.")
            
          } else {
            
           self.dismiss(animated: true, completion: nil)
            
          }
      })
    }
  }
  
  
  @IBAction func cancelTapped(_ sender: Any) {
    
    self.dismiss(animated: true, completion: nil)
    
  }
}

//アラートに関するエクステンション
extension UIViewController {
  
  //自分でエラーを追加することができる
  func simpleAlert(title: String, msg: String) {
    
    //エラーの変数を定義
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    
    //その変数に対して動作をつける
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    //定義した変数を表示
    present(alert, animated: true, completion: nil)
    
  }
}

