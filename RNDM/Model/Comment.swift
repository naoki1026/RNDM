//
//  Comment.swift
//  RNDM
//
//  Created by Naoki Arakawa on 2019/04/28.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//


import Foundation
import Firebase

class Comment {
  
  private(set) var username : String!
  private(set) var timeStamp : Timestamp!
  private(set) var commentTxt : String!
  private(set) var documentId : String!
  private(set) var userId: String!
  
  init(username : String,  timeStamp: Timestamp,  commentTxt : String, documentId: String, userId: String) {
    
    self.username = username
    self.timeStamp = timeStamp
    self.commentTxt = commentTxt
    self.documentId = documentId
    self.userId = userId
    
  }
  
  
  class func parseData(snapshot: QuerySnapshot?) -> [Comment]{
    
    var comments = [Comment]()

    guard let snap = snapshot else { return comments }

    for document in snap.documents {

      let data = document.data()
      let username = data[USERNAME] as? String ?? "Anonymous"
      let timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
      let commentTxt = data[COMMENT_TXT] as? String ?? ""
      let documentId = document.documentID
      let userId = data[USER_ID] as? String ?? ""

    
      let newComment = Comment(username: username, timeStamp: timeStamp, commentTxt: commentTxt, documentId:documentId, userId : userId)
      comments.append(newComment)

    }

    return comments


  }

}
