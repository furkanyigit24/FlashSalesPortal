//
//  ViewController.swift
//  UploadInformation
//
//  Created by Furkan Yiğit Akyildiz on 11/1/19.
//  Copyright © 2019 AlohaLabs. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
  
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func signInClicked(_ sender: Any) {
        
                if emailTextField.text != "" && passwordTextField.text != ""{
        
                    Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authdata, error) in
                        
                        if error != nil {
                            self.makeAlert(titleInput: "Error", messageInput: "Username/Pasword is invalid")
                        } else {
                            self.performSegue(withIdentifier: "toRetailerInformation", sender: nil)
                        }
                
                    }
                } else{
                    makeAlert(titleInput: "Error", messageInput: "Username/Pasword is invalid")
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != ""{
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authdata, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error ")
                }
                else {
                    self.performSegue(withIdentifier: "toRetailerInformation", sender: nil)
                }
            }
        }
        else {
            makeAlert(titleInput: "Error", messageInput: "Username/Pasword is invalid")
        }
        
    }
    func makeAlert (titleInput: String, messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil )
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

