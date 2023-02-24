//
//  myLoverViewController.swift
//  TinderClone
//
//  Created by Kaan Yıldız on 11.02.2023.
//

import UIKit
import Firebase

class myLoverViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var myLoverTableView: UITableView!
    var loverNBR = 0
    var loverArr = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLoverTableView.delegate = self
        myLoverTableView.dataSource = self
        
        let curUserEmail = (Auth.auth().currentUser?.email)!

        let firestoreDB = Firestore.firestore()
        firestoreDB.collection("Users").document(curUserEmail).collection("my lovers").getDocuments { QuerySnap, error in
            guard let lovers = QuerySnap?.documents else{
                print("loverları çekemedim firestore dan.")
                return
            }
            
            for lover in lovers{
                self.loverNBR += 1
                self.loverArr.append(lover.documentID)
            }
            // lover ları elimde tutuyorum artık
            
            self.myLoverTableView.reloadData()
            
            
        }
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loverArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = UITableViewCell()
        var context = Cell.defaultContentConfiguration()
        context.text = loverArr[indexPath.row]
        Cell.contentConfiguration = context
        return Cell
    }

}
