//
//  ViewController.swift
//  TinderClone
//
//  Created by Kaan Yıldız on 9.02.2023.
//

import UIKit
import Firebase

class EntranceOfApp: UIViewController {

    @IBOutlet var emailTextF: UITextField!
    @IBOutlet var paswordTextF: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    @IBAction func signinTapped(_ sender: Any) {
        let email = emailTextF.text
        let pasword = paswordTextF.text
        
        if email != nil && pasword != nil {
            
            Auth.auth().signIn(withEmail: email!, password: pasword!) { AuthDataResult , error in
                if error != nil {
                    // error verdir
                    self.makeAlert(Error: error!)
                }else{
                    // sign in oldu
                    self.performSegue(withIdentifier: "ToTabVC", sender: nil)
                }
            }
            
        }
    
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        let email = emailTextF.text
        let pasword = paswordTextF.text
        
        if email != nil && pasword != nil {
            
            Auth.auth().createUser(withEmail: email!, password: pasword!) { AuthDataResult, error in
                if error != nil {
                    // error verdir
                    self.makeAlert(Error: error!)
                }else{
                    // devam...
                    self.performSegue(withIdentifier: "ToPersonalInfoAddPage", sender: nil)
                }
            }
            
        }
    }
    
    func makeAlert(Error: Error){
        let Alert = UIAlertController(title: "Error", message: Error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "ok", style: UIAlertAction.Style.default)
        Alert.addAction(ok)
        present(Alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPersonalInfoAddPage" {
            if let desVC = segue.destination as? PersonalinfoAddVC{
                desVC.userPasword = paswordTextF.text!
            }
        }
    }
}

