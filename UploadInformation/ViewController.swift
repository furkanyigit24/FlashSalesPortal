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
    
    struct datatype : Identifiable {
        
        var id : String
        var name : String
        var image : String
        var rating : String
        var webUrl : String
    }

    struct TypeMain : Decodable {
        
        var nearby_restaurants : [Type1]
    }

    struct Type1 : Decodable{
        
        
        var restaurant : Type2
    }


    struct Type2 : Decodable {
        
        var id : String
        var name : String
        var url : String
        var thumb : String
        var user_rating : Type3
    }
    struct Type3 : Decodable {
        
        var aggregate_rating : String
    }
    var datas = [datatype]()
    
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
        let url1 = "https://developers.zomato.com/api/v2.1/geocode?lat=21.285705415248657&lon=-157.83358329930232"
                  let api = "19ab14dce433eabe16fbcc2661898e34"
                  
                  let url = URL(string: url1)
                  var request = URLRequest(url: url!)
              
                  request.addValue("application/json", forHTTPHeaderField: "Accept")
                  request.addValue(api, forHTTPHeaderField: "user-key")
                  request.httpMethod = "GET"
                  
                  let sess = URLSession(configuration: .default)
                  sess.dataTask(with: request) { (data, _, _) in
                      
                      do{
                          
                          let fetch = try JSONDecoder().decode(Type.self, from: data!)
                          print(fetch)
                          
                          for i in fetch.nearby_restaurants{
                              
                              
                              DispatchQueue.main.async {
                                  
                                  self.datas.append(datatype(id: i.restaurant.id, name: i.restaurant.name, image: i.restaurant.thumb, rating: i.restaurant.user_rating.aggregate_rating, webUrl: i.restaurant.url))
                              }

                          }
                      }
                      catch{
                          
                          print(error.localizedDescription)
                      }
                      
                  }.resume()
              
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

