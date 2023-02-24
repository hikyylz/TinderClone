//
//  FeedViewController.swift
//  TinderClone
//
//  Created by Kaan Yıldız on 9.02.2023.
//


// coreData özelliğini yeni commit lerde kullanacağım.. to be continue

import UIKit
import Firebase

class FeedViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var surnameLabel: UILabel!
    @IBOutlet var personalinfoLabel: UILabel!
    
    var peopleInApp = Int()
    var currCandidateIndex = -1
    var curUserEmail = String()
    var curCandidateID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView.isUserInteractionEnabled = true
        let GestureRecTap = UITapGestureRecognizer(target: self, action: #selector(liked))
        let GestureReclong = UILongPressGestureRecognizer(target: self, action: #selector(dontliked))
        GestureReclong.minimumPressDuration = 1
        imageView.addGestureRecognizer(GestureRecTap)
        imageView.addGestureRecognizer(GestureReclong)
        
        curUserEmail = (Auth.auth().currentUser?.email)!
        
        findPeopleNbrInApp()
        displayNewCandidate()
        
        
        
    }
    
    @objc func dontliked(){
        presentAlert(S: "You DONT like it :/")
    }
    
    @objc func liked(){
        presentAlert(S: "You Liked it :)")
        saveMylove()
    }
    
    func saveMylove(){
        let firestoreDB = Firestore.firestore()
        let newLover = [curUserEmail:curUserEmail] as [String:Any]
        
        firestoreDB.collection("Users").document(curCandidateID).collection("my lovers").document(curUserEmail).setData(newLover, merge: true)
        
    }
    
    func presentAlert(S:String ){
        
        let Alert = UIAlertController(title: S, message: "Would You wanna continue?", preferredStyle: UIAlertController.Style.alert)
        let yes = UIAlertAction(title: "yes" , style: UIAlertAction.Style.default) { UIAlertAction in
            // liked olunca ne olsun istiyorsun...
            self.displayNewCandidate()
        }
        let no = UIAlertAction(title: "no", style: UIAlertAction.Style.default) { UIAlertAction in
            // devam etmek istemiyorum insanları görmeye...
            
        }
        Alert.addAction(yes)
        Alert.addAction(no)
        
        present(Alert, animated: true)
        
    }
    
    func findPeopleNbrInApp(){
        let firestoreDB = Firestore.firestore()
        
        firestoreDB.collection("Users").getDocuments { querySnapshot, error in
            guard let people = querySnapshot?.documents else{
                return
            }
            // app de güncel kaç insan var
            self.peopleInApp = people.count - 1
            // people[nbr].data()    // diyerek yeni bir insana ulaşıyorum.
            
        }
    }
    
    func displayNewCandidate(){
        let firestoreDB = Firestore.firestore()
        
        firestoreDB.collection("Users").getDocuments { Q, error in
            guard let people = Q?.documents else{
                return
            }
            
            if self.currCandidateIndex == self.peopleInApp{
                // insanlar bitti.
                return
            }
            
            self.currCandidateIndex += 1
            
            let newCandidateEmail = people[self.currCandidateIndex].documentID
            if newCandidateEmail == self.curUserEmail {
                self.displayNewCandidate()
                return
            }else{
                self.curCandidateID = newCandidateEmail
            }
            let newCandidate = people[self.currCandidateIndex].data()
            
            
            // display new candidate data
            if let n = newCandidate["name"] as? String{
                
                self.nameLabel.text = n
                
                if let s = newCandidate["surname"] as? String{
                    self.surnameLabel.text = s
                    
                    if let p = newCandidate["personal info"] as? String{
                        self.personalinfoLabel.text = p
                    }
                }
            }
            // new candidate data was displied
            
        }
    }
    
    @IBAction func refreshFeedVC(_ sender: Any) {
        currCandidateIndex = -1
        findPeopleNbrInApp()
        displayNewCandidate()
    }
    
    
    
}
























