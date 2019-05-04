//
//  Thought.swift
//  RNDM
//
//  Created by Naoki Arakawa on 2019/04/18.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import Foundation
import Firebase

class Thought {
  
  private(set) var username : String!
  private(set) var timeStamp : Timestamp!
  private(set) var numComments : Int!
  private(set) var numLikes : Int!
  private(set) var thoughtTxt : String!
  private(set) var documentId : String!
  private(set) var userId : String!
 
  init(username : String, documentId : String, timeStamp: Timestamp, numComments : Int, numLikes : Int, thoughtText : String, userId : String) {
    
    self.username = username
    self.documentId = documentId
    self.timeStamp = timeStamp
    self.numComments = numComments
    self.numLikes = numLikes
    self.thoughtTxt = thoughtText
    self.userId = userId
    
  }
  
  class func parseData(snapshot: QuerySnapshot?) -> [Thought]{
    
    var thoughts = [Thought]()
    
    guard let snap = snapshot else { return thoughts }
    
    for document in snap.documents {
      
      let data = document.data()
      let username = data[USERNAME] as? String ?? "Anonymous"
      
      //timestamp型に変換
      let timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
      let thoghtTxt = data[THOGHT_TXT] as? String ?? ""
      let numLikes = data[NUM_LIKES] as? Int ?? 0
      let numComments = data[NUM_COMMENTS] as? Int ?? 0
      let documentId = document.documentID
      let userId = data[USER_ID] as? String ?? ""
      
      let newThought = Thought(username: username, documentId: documentId, timeStamp: timeStamp, numComments: numComments, numLikes: numLikes, thoughtText: thoghtTxt, userId: userId)
      thoughts.append(newThought)

  }
  
  return thoughts
  

 }

}
