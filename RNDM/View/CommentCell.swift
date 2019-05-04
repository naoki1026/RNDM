//
//  UITableViewCell.swift
//  RNDM
//
//  Created by Naoki Arakawa on 2019/04/28.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

protocol CommentDelegate {
  func commentActionsTapped(comment: Comment)
}

class CommentCell: UITableViewCell {
  
  
  @IBOutlet weak var usernameTxt: UILabel!
  @IBOutlet weak var timestampTxt: UILabel!
  @IBOutlet weak var commentTxt: UILabel!
  @IBOutlet weak var optionsMenu: UIImageView!
  
  private var comment : Comment!
  private var delegate : CommentDelegate?
  
  func configureCell(comment: Comment, delegate : CommentDelegate?){
    
    usernameTxt.text = comment.username
    commentTxt.text = comment.commentTxt
    
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, hh:mm"
    optionsMenu.isHidden = true
    self.comment = comment
    self.delegate = delegate
    
    //dateValueでtimestamo型をdate型に変換することができる
    let timestamp = formatter.string(from: comment.timeStamp.dateValue())
    timestampTxt.text = timestamp
    
    if comment.userId == Auth.auth().currentUser?.uid {
      
      optionsMenu.isHidden = false
      let tap = UITapGestureRecognizer(target: self, action: #selector(commentOptionsTapped))
     optionsMenu.addGestureRecognizer(tap)
      
    }
  }
  
  @objc func commentOptionsTapped(){
    
    print("tap")
    delegate?.commentActionsTapped(comment: comment)
    
  }
}
