//
//  AddThoughtVC.swift
//  RNDM
//
//  Created by Naoki Arakawa on 2019/04/18.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AddThoughtVC: UIViewController, UITextViewDelegate {
  
  //MARK: Outlets
  
  @IBOutlet private weak var categorySegment: UISegmentedControl!
  //@IBOutlet private  weak var usernameTxt: UITextField!
  @IBOutlet private weak var thoughtTxt: UITextView!
  @IBOutlet private weak var postBtn: UIButton!
  
 //MARK: Variables

  
//privateは同一の定義の中でのみ使用可能、仮の目的のために使用するか？
 private var selectedCategory = ThoughtCategory.funny.rawValue
  
    override func viewDidLoad() {
        super.viewDidLoad()

       postBtn.layer.cornerRadius = 4
       thoughtTxt.layer.cornerRadius = 4
       thoughtTxt.text = "My random thought..."
       thoughtTxt.textColor = .lightGray
       thoughtTxt.delegate = self
    
    }
  
  //テキストの入力があるたびに呼び出されるデリゲートメソッド
  func textViewDidBeginEditing(_ textView: UITextView) {
   thoughtTxt.text = ""
   thoughtTxt.textColor = .darkGray
    
  }

  
  @IBAction func postButtonTapped(_ sender: Any) {
    
    //guard let username = usernameTxt.text else {return}
    
    Firestore.firestore().collection(THOUGHTS_REF).addDocument(data: [
      
      CATEGORY : selectedCategory,
      NUM_COMMENTS : 0,
      NUM_LIKES : 0,
      THOGHT_TXT : thoughtTxt.text!,
      TIMESTAMP : FieldValue.serverTimestamp(),
      USERNAME : Auth.auth().currentUser?.displayName ?? "",
      USER_ID: Auth.auth().currentUser?.uid ?? ""
      
    ]) { (err) in
      
      if let err = err {
        
        debugPrint("Error adding document: \(err)")
        
      } else {
        
        self.navigationController?.popViewController(animated: true)
        
      }
    }
  }
  
  @IBAction func categoryChanged(_ sender: Any) {
    
    switch categorySegment.selectedSegmentIndex {
    case 0: selectedCategory = ThoughtCategory.funny.rawValue
    case 1: selectedCategory = ThoughtCategory.serious.rawValue
    default: selectedCategory = ThoughtCategory.crazy.rawValue
    }
    

  
}

}
