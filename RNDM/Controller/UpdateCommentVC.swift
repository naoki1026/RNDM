//
//  updateCommentVC.swift
//  RNDM
//
//  Created by Naoki Arakawa on 2019/04/30.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UpdateCommentVC: UIViewController {
  
  
  @IBOutlet weak var commentTxt: UITextView!
  @IBOutlet weak var updateBtn: UIButton!
  
  var commentData : (comment: Comment, thought: Thought)!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      commentTxt.layer.cornerRadius = 10
      updateBtn.layer.cornerRadius = 10
      commentTxt.text = commentData.comment.commentTxt
      
      
    }
    

  @IBAction func updateTapped(_ sender: Any) {
    
    Firestore.firestore().collection(THOUGHTS_REF).document(commentData.thought.documentId).collection(COMMENTS_REF).document(commentData.comment.documentId).updateData([COMMENT_TXT : commentTxt.text!]){(error) in
      
      if error != nil {
        
      print("Error")
        
      } else {
        
        self.navigationController?.popViewController(animated: true)
      }
    }
    
    
  }
  
}

