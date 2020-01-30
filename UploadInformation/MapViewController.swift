//
//  MapViewController.swift
//  UploadInformation
//
//  Created by Furkan Yiğit Akyildiz on 11/8/19.
//  Copyright © 2019 AlohaLabs. All rights reserved.
//

import UIKit
import MapKit
import Firebase


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneButtonClicked))
         
             navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
               recognizer.minimumPressDuration = 1
               mapView.addGestureRecognizer(recognizer)
        
    }
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.restaurantName
           
            
            self.mapView.addAnnotation(annotation)
            
            
            PlaceModel.sharedInstance.placeLatitude = coordinates.latitude
            PlaceModel.sharedInstance.placeLongitude = coordinates.longitude
          
            
            let coordinate1 = CLLocation(latitude: 21.397477, longitude: -157.730317)
                      let coordinate2 = CLLocation(latitude: 21.399634, longitude: -157.736149)

                      let distanceInMeters = coordinate2.distance(from: coordinate1)
            
                   print("XOXOXOXOXOXOXOXOXOXO----\(distanceInMeters)---XOXOXOXOXOXOXOXOXOXOXOXOX")
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }

    func makeAlert (titleInput : String, messageInput : String) {
           let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert )
           let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
           self.present(alert, animated: true, completion: nil)
       }
    
    @objc func doneButtonClicked(){
        
        let placeModel = PlaceModel.sharedInstance
        let storage = Storage.storage()
            let storageReference = storage.reference()
            let mediaFolder = storageReference.child("media")
            let uuidImage = UUID().uuidString
            
        if let data = placeModel.placeImage.jpegData(compressionQuality: 0.5){
            
            let imageReference = mediaFolder.child("\(uuidImage).jpg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                          
                            
                            //DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            let uuidDocument = UUID().uuidString

                            firestoreDatabase.collection("Locations").document("\(Auth.auth().currentUser!.email!)").setData([
                            "GeoPoint": GeoPoint(latitude: placeModel.placeLatitude, longitude: placeModel.placeLongitude)
                            ])
                            firestoreDatabase.collection( "Restaurants").document("\(Auth.auth().currentUser!.email!)").setData([
                                
                                "RestaurantOwner": Auth.auth().currentUser!.email!,
                                "RestaurantName": placeModel.restaurantName,
                                "FlashSales": placeModel.flashSale,
                                "TimeLine": placeModel.timeLine,
                                "İmageUrl": imageUrl!,
                                "date" : FieldValue.serverTimestamp()
                                ])
                            { err in
                                if err != nil {
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                } else {
                                    print("Document successfully written!")
                                    
                                    self.performSegue(withIdentifier: "fromMapVctoProfileVc", sender: nil)
                                   
                                    
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        }
        @objc func backButtonClicked() {
               //navigationController?.popViewController(animated: true)
               self.dismiss(animated: true, completion: nil)
           }

    }

