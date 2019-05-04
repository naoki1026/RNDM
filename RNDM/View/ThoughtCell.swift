//
//  ThoughtCell.swift
//  RNDM
//
//  Created by Naoki Arakawa on 2019/04/18.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

protocol ThoguhtDelegate  {
  
  func thoughtOptionsTapped(thought: Thought)
  
}

class ThoughtCell: UITableViewCell {
  
  //MARK:Properties
  
  @IBOutlet weak var usernameLbl: UILabel!
  @IBOutlet weak var timeStampLbl: UILabel!
  @IBOutlet weak var thoughtTxtLbl: UILabel!
  @IBOutlet weak var likesImg: UIImageView!
  @IBOutlet weak var likesNumLbl: UILabel!
  
  @IBOutlet weak var optionsMenu: UIImageView!
  @IBOutlet weak var commentsNumLabel: UILabel!
  
  
  
  private var thought : Thought!
  private var delegate : ThoguhtDelegate?
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
      let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
      likesImg.addGestureRecognizer(tap)
      likesImg.isUserInteractionEnabled = true
     
      
    }
  
  @objc func likeTapped(){

    Firestore.firestore().document("thoughts/\(thought.documentId!)").updateData([NUM_LIKES : thought.numLikes + 1])

    
  }
  
  
  func configureCell(thought : Thought, delegate: ThoguhtDelegate?){
    
    optionsMenu.isHidden = true
    self.thought = thought
    self.delegate = delegate
    usernameLbl.text = thought.username
    thoughtTxtLbl.text = thought.thoughtTxt
    likesNumLbl.text = String(thought.numLikes)
    commentsNumLabel.text = String(thought.numComments)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, hh:mm"
    
    //dateValueでtimestamo型をdate型に変換することができる
    let timestamp = formatter.string(from: thought.timeStamp.dateValue())
    timeStampLbl.text = timestamp
    
    if thought.userId == Auth.auth().currentUser?.uid {
      
      //編集ボタンを有効にしている
      optionsMenu.isHidden = false
      optionsMenu.isUserInteractionEnabled = true
      let tap = UITapGestureRecognizer(target: self, action: #selector(thoughtOptionsTapped))
      optionsMenu.addGestureRecognizer(tap)
      
    }
  }
  
  @objc func thoughtOptionsTapped(){
    
    delegate?.thoughtOptionsTapped(thought: thought)
    
  }
  
  
}
