//
//  MyAccountViewController.swift
//  TinderClone
//
//  Created by Kaan Yıldız on 9.02.2023.
//

import UIKit
import Firebase

class MyAccountViewController: UIViewController {

    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var surnameLabel: UILabel!
    @IBOutlet var myinfoLabel: UILabel!
    var name = String()
    var surname = String()
    var personalinfo = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        specifyLabels()
        
        
    }
    
    func specifyLabels(){
        let currUserEmail = (Auth.auth().currentUser?.email)!
        
        let fdb = Firestore.firestore()
        fdb.collection("Users").document(currUserEmail).getDocument { DocSnap, error in
            if error != nil {
                
            }else{
                guard let data = DocSnap?.data() else{
                    self.makeAlert()
                    return
                }
                
                if let n = data["name"] as? String{
                    self.name = n
                }

                if let s = data["surname"] as? String{
                    self.surname = s
                }
                
                if let p = data["personal info"] as? String{
                    self.personalinfo = p
                }
            }
            
            self.nameLabel.text = self.name
            self.surnameLabel.text = self.surname
            self.myinfoLabel.text = self.personalinfo
        }
    }
    
    

    @IBAction func showWhoLikedMe(_ sender: Any) {
        performSegue(withIdentifier: "ToWhoLikedMe", sender: nil)
    }
    
    
    @IBAction func logout(_ sender: Any) {
        performSegue(withIdentifier: "Restart", sender: nil)
    }
    
    func makeAlert(){
        let Alert = UIAlertController(title: "Error", message: "problem", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "ok", style: UIAlertAction.Style.default)
        Alert.addAction(ok)
        present(Alert, animated: true)
    }
    
}
