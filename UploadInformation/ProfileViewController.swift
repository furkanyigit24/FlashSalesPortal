//
//  ProfileViewController.swift
//  UploadInformation
//
//  Created by Furkan Yiğit Akyildiz on 11/4/19.
//  Copyright © 2019 AlohaLabs. All rights reserved.
//
// Hello
import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var restaurantNameText: UITextField!
    
    @IBOutlet weak var currentUserLabel: UILabel!
    
    @IBOutlet weak var flashSaleText: UITextField!
    
    @IBOutlet weak var timeLineText: UITextField!


    override func viewDidLoad() {
        
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        self.currentUserLabel.text = "\(Auth.auth().currentUser!.email!)"
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: self, action: #selector(nextButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutClicked))
        
        
    }
    
    @objc func nextButtonClicked() {
        
        if restaurantNameText.text != "" && flashSaleText.text != "" && flashSaleText.text != "" && timeLineText.text != "" {
            if let choosenImage = imageView.image{
            let placeModel = PlaceModel.sharedInstance
            placeModel.restaurantName = restaurantNameText.text!
            placeModel.flashSale = flashSaleText.text!
            placeModel.timeLine = timeLineText.text!
            placeModel.placeImage = choosenImage
            }
                  self.performSegue(withIdentifier: "toMapVC", sender: nil)
        }else {
            let alert = UIAlertController(title: "Error", message: "Restaurant Name/ Flash Sale / TimeLine ?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }
        restaurantNameText.text = ""
        flashSaleText.text = ""
        timeLineText.text = ""
    }
    
    @objc func chooseImage(){
        
        let pickerController = UIImagePickerController()
               pickerController.delegate = self
               pickerController.sourceType = .photoLibrary
               present(pickerController, animated: true, completion: nil)
            
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
       
    }
    

    func makeAlert (titleInput : String, messageInput : String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert )
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func logoutClicked(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil )
        } catch{
            print("error")
        } 
    }
    
}
