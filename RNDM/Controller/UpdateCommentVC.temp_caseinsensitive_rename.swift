//
//  updateCommentVC.swift
//  RNDM
//
//  Created by Naoki Arakawa on 2019/04/30.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit

class UpdateCommentVC: UIViewController {
  
  
  @IBOutlet weak var commentTxt: UITextView!
  @IBOutlet weak var updateBtn: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      commentTxt.layer.cornerRadius = 5
      updateBtn.layer.cornerRadius = 5
    }
    

  @IBAction func updateTapped(_ sender: Any) {
  }
  
}
