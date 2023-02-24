//
//  PersonalinfoAddVC.swift
//  TinderClone
//
//  Created by Kaan Yıldız on 9.02.2023.
//

import UIKit
import Firebase

class PersonalinfoAddVC: UIViewController {

    
    @IBOutlet var typedName: UITextField!
    @IBOutlet var typedSurname: UITextField!
    @IBOutlet var typedPersonalinfo: UITextField!
    var userEmail = String()
    var userPasword = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func saveTapped(_ sender: Any) {
        
        if typedName.text == "" || typedSurname.text == "" || typedPersonalinfo.text == "" {
            makeAlert()
        }else{
            // info ları cloud firestore a kaydet..
            let firestoredatabase = Firestore.firestore()
            
            let newData = ["name": typedName.text! ,
                           "surname": typedSurname.text! ,
                           "personal info": typedPersonalinfo.text! ,
                           "pasword": userPasword ] as [String:Any]
            
            userEmail = (Auth.auth().currentUser?.email)!
            
            // oluşturduğum datayı cloud firestore a ekliyorum.
            firestoredatabase.collection("Users").document(userEmail).setData(newData, merge: true) { error in
                if error != nil{
                    
                }else{
                    self.performSegue(withIdentifier: "ToTabVC", sender: nil)
                }
            }
            
            
        }
    }
    
    
    
    
    func makeAlert(){
        let Alert = UIAlertController(title: "Error", message: "Please type info bloks! ", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "ok", style: UIAlertAction.Style.default)
        Alert.addAction(ok)
        present(Alert, animated: true)
    }

}
