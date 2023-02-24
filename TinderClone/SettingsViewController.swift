//
//  SettingsViewController.swift
//  TinderClone
//
//  Created by Kaan Yıldız on 9.02.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var paswordLabel: UILabel!
    var currUserEmail = String()
    var currUserPasword = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(editMode))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // şifresini bu ekranda görecek olan kullanıcı için önce bi uyarı..
        alertUserAbout(M: "Your personal info will be showed")
        
        currUserEmail = (Auth.auth().currentUser?.email)!
        
        let firestoredb = Firestore.firestore()
        
        firestoredb.collection("Users").document(currUserEmail).getDocument { DocSnap, error in
            guard let tempdata = DocSnap else{
                self.alertUserAbout(M: "data could not fatched")
                return
            }
            
            if let data = tempdata.data() {
                self.emailLabel.text = self.currUserEmail
                self.paswordLabel.text = (data["pasword"] as! String)
            }
        }
    }
   
    
    @objc func editMode(){
        // app theme ini tam zıttına dönüştürmek istemiştim... to be continue
        
    }
    
    func alertUserAbout(M : String){
        let Alert = UIAlertController(title: "Attention" , message: M , preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "ok", style: UIAlertAction.Style.default)
        Alert.addAction(ok)
        present(Alert, animated: true)
    }
    

    @IBAction func deleteAcountTapped(_ sender: Any) {
        let firestoredb = Firestore.firestore()
        
        firestoredb.collection("Users").document(currUserEmail).delete { error in
            if error != nil {
                self.alertUserAbout(M: "Acount are not deleted")
            }else{
                Auth.auth().currentUser?.delete(completion: { error in
                    if error != nil{
                        
                    }else{
                        
                    }
                })
                
                self.performSegue(withIdentifier: "Restart", sender: nil)
            }
        }
    }
    
    @IBAction func deleteLoverTapped(_ sender: Any) {
        let firestoreDB = Firestore.firestore()
        
        firestoreDB.collection("Users").document(currUserEmail).collection("my lovers").getDocuments { quersnap, error in
            guard let lovers = quersnap?.documents else{
                print("lovers didnot deleted.")
                return
            }
            
            for lover in lovers {
                let loverString = lover.documentID
                firestoreDB.collection("Users").document(self.currUserEmail).collection("my lovers").document(loverString).delete { error in
                    if error != nil {
                        print("lover did not deleted.")
                    }else{
                        
                    }
                }
            }
        }
    }
    
    
}
