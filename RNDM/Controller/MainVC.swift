//
//  ViewController.swift
//  RNDM
//
//  Created by Naoki Arakawa on 2019/04/17.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

enum ThoughtCategory : String {
  
  case funny = "funny"
  case serious = "serious"
  case crazy = "crazy"
  case popular = "popular"
  
}

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ThoguhtDelegate {
  
  
  //MARK:Outlets
  
  @IBOutlet private weak var segmentControl: UISegmentedControl!
  @IBOutlet private weak var tableView: UITableView!
  
  
  //Properties
  //Thoughtクラスを配列の中に入れている
  private var thoughts = [Thought]()
  private var thoughtsCollectionRef : CollectionReference!
  private var thoughtsListener : ListenerRegistration!
  private var selectedCategory = ThoughtCategory.funny.rawValue
  
  //後で追加
  private var handle : AuthStateDidChangeListenerHandle?
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 80
    
    //ここで高さを動的に変更することができる
    tableView.rowHeight = UITableView.automaticDimension
    
    //Firestoreのデータを読み込んでいる
    thoughtsCollectionRef = Firestore.firestore().collection(THOUGHTS_REF)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
      if user == nil {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
        self.present(loginVC, animated: true, completion: nil)
        
        
      } else {
        
        self.setListener()
        
      }
    })
    
    setListener()
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    
    if thoughtsListener != nil {
      
       thoughtsListener.remove()
      
    }
  }
  
  func thoughtOptionsTapped(thought: Thought) {
    
  let alert = UIAlertController(title: "Delete", message: "Do you want to delete your thought?", preferredStyle: .actionSheet)
    let deleteAction = UIAlertAction(title: "Delete Thought", style: .default) { (action) in
      
      //delete thought
      self.delete(collection: Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId).collection(COMMENTS_REF), completion: { (error) in
        if let error = error {
          
          debugPrint("Could not delete subcollection: \(error.localizedDescription)")
          
        } else {
          
          Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId).delete(completion: { (error) in
            if let error = error {
              
              debugPrint("Could not delete thought: \(error.localizedDescription)")
              
            } else {
              
              alert.dismiss(animated: true, completion: nil)
              
          }
        })
      }
   })
  }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(deleteAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
    
  }
  
  func delete(collection: CollectionReference, batchSize: Int = 100, completion: @escaping (Error?) -> ()) {
    
    //Limit query to avoid out-of-memory errors on large collections.
    
    //When deleting a collection guaranteed to fit in memory, batching can be avoided entirely.
    
    collection.limit(to: batchSize).getDocuments { (docset, error) in
      
      // An error occured.
      
      guard let docset = docset else {
        
        completion(error)
        
        return
        
      }
      
      //There's nothing to delete.
      
      guard docset.count > 0 else {
        
        completion(nil)
        
        return
        
      }
      
      
      
      let batch = collection.firestore.batch()
      
      docset.documents.forEach { batch.deleteDocument($0.reference) }
      
      
      
      batch.commit { (batchError) in
        
        if let batchError = batchError {
          
          // Stop the deletion process and handle the error. Some elements
          
          // may have been deleted.
          
          completion(batchError)
          
        } else {
          
          self.delete(collection: collection, batchSize: batchSize, completion: completion)
          
        }
      }
    }
  }
  
  @IBAction func categoryChanged(_ sender: Any) {
    
    switch segmentControl.selectedSegmentIndex {
      
    case 0: selectedCategory = ThoughtCategory.funny.rawValue
    case 1: selectedCategory = ThoughtCategory.serious.rawValue
    case 2: selectedCategory = ThoughtCategory.crazy.rawValue
    default: selectedCategory = ThoughtCategory.popular.rawValue
      
    }
    
    thoughtsListener.remove()
    setListener()
    
  }
  
  
  @IBAction func logoutTapped(_ sender: Any) {
    
    do {
      //サインアウトを試みる
      try Auth.auth().signOut()
      
      print("Successfully logged user out")
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
      self.present(loginVC, animated: true, completion: nil)
      
    } catch {
      
      //handle error
      print("Falied to sign out")
      
    }
  }

  func setListener(){
    
    if selectedCategory == ThoughtCategory.popular.rawValue {
      
      //カテゴリーの中で、セグメントコントロールで選択されたカテゴリと同じものが抽出されて、日付順表示される。
      //thoghtsListener = thoughtsCollectionRef.addSnapshotListener { (snapshot, error) in
      thoughtsListener = thoughtsCollectionRef.order(by: TIMESTAMP, descending: true).addSnapshotListener { (snapshot, error) in
        
        print(self.selectedCategory)
        
        if let err = error {
          
          debugPrint("Error fetching docs: \(err)")
          
        } else {
          
          //ここで削除することによってダブルで表示されなくなる
          self.thoughts.removeAll()
          self.thoughts = Thought.parseData(snapshot: snapshot)
          self.tableView.reloadData()
          
        }
      }
    } else {
      
      //カテゴリーの中で、セグメントコントロールで選択されたカテゴリと同じものが抽出されて、日付順表示される。
      //thoghtsListener = thoughtsCollectionRef.addSnapshotListener { (snapshot, error) in
      thoughtsListener = thoughtsCollectionRef.whereField(CATEGORY, isEqualTo: selectedCategory).order(by: TIMESTAMP, descending: true).addSnapshotListener { (snapshot, error) in
        
        print(self.selectedCategory)
        
        if let err = error {
          
          debugPrint("Error fetching docs: \(err)")
          
        } else {
          
          //ここで削除することによってダブルで表示されなくなる
          self.thoughts.removeAll()
          guard let snap = snapshot else {return}
          
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
            
            self.thoughts.append(newThought)
            
          }
          
          self.tableView.reloadData()
        }
      }
    }
  }
  

  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   return  thoughts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: "thoughtCell", for: indexPath) as? ThoughtCell {
      
      cell.configureCell(thought: thoughts[indexPath.row], delegate: self)
      return cell
      
    } else {
      
      return UITableViewCell()
      
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      performSegue(withIdentifier: "toComments", sender: thoughts[indexPath.row])
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toComments" {
      
      if let destinationVC = segue.destination as? CommentsVC {
        
        if let thoght = sender as? Thought {
          
          destinationVC.thought = thoght
        }
        
      }
      
    }
  }
  

}
//ここでデータを取得してきている
//    thoughtsCollectionRef.getDocuments { (snapshot, error) in
//
//      if let err = error {
//
//        debugPrint("Error fetching docs: \(err)")
//
//
//      } else {
//
//        //こういうものだと覚える
////        for document in snapshot!.documents {
////          print(document.data())
//
//        guard let snap = snapshot else {return}
//
//        for document in snap.documents {
//
//        let data = document.data()
//        let username = data[USERNAME] as? String ?? "Anonymous"
//        let timeStamp = data[TIMESTAMP] as? Date ?? Date()
//        let thoghtTxt = data[THOGHT_TXT] as? String ?? ""
//        let numLikes = data[NUM_LIKES] as? Int ?? 0
//        let numComments = data[NUM_COMMENTS] as? Int ?? 0
//        let documentId = document.documentID
//
//        let newThought = Thought(username: username, documentId: documentId, timeStamp: timeStamp, numComments: numComments, numLikes: numLikes, thoughtText: thoghtTxt)
//
//          self.thoughts.append(newThought)
//
//        }
//      }
//
//      self.tableView.reloadData()
//
//    }
