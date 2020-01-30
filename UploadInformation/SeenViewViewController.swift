//
//  SeenViewViewController.swift
//  UploadInformation
//
//  Created by Furkan Yiğit Akyildiz on 11/4/19.
//  Copyright © 2019 AlohaLabs. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import MapKit


class SeenViewViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!

    var restaurantNameArray = [String]()
    var restaurantOwnerArray = [String]()
    var flashSalesArray = [String]()
    var userImageArray = [String]()
    var timeLineArray = [String]()
    var documentIdArray = [String]()
    var locationArray = [Double]()
    var membersArray = [String]()
    var noMembersArray = [String]()
    
    let searchController = UISearchController(searchResultsController : nil)
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["Distance", "Newest"]
        searchController.searchBar.delegate = self
        
        
        locationManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        //getDataFromFirestore()
        
        tableView.dataSource = self
        tableView.delegate = self

           self.navigationController?.navigationBar.barStyle = .black
        

        getDocumentNearBy(latitude: 21.288443, longitude: -157.834524, distance: 0.1)
    }
    func getDocumentNearBy(latitude: Double, longitude: Double, distance: Double) {

        // ~1 mile of lat and lon in degrees
        let lat = 0.0144927536231884
        let lon = 0.0181818181818182

        let lowerLat = latitude - (lat * distance)
        let lowerLon = longitude - (lon * distance)

        let greaterLat = latitude + (lat * distance)
        let greaterLon = longitude + (lon * distance)

        let lesserGeopoint = GeoPoint(latitude: lowerLat, longitude: lowerLon)
        let greaterGeopoint = GeoPoint(latitude: greaterLat, longitude: greaterLon)
        var x = lesserGeopoint.latitude
        var y = lesserGeopoint.longitude
        print("Latitude: ------>>>>>   \(x) \n Longitude -------->>>>> \(y)")
        
        let locationsRef = Firestore.firestore().collection("Locations")
        let ref = Firestore.firestore()
        
        let query = locationsRef.whereField("GeoPoint", isGreaterThan: lesserGeopoint).whereField("GeoPoint", isLessThan: greaterGeopoint)
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                var member =  ""
                
                for document in snapshot!.documents {
                    
                    print("\(document.documentID) => \(document.data())")
                    self.membersArray.append(document.documentID)
                    member = document.documentID
                    print("MEMBER: \(member)")
                    
                      self.flashSalesArray.removeAll(keepingCapacity: false)
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.restaurantNameArray.removeAll(keepingCapacity: false)
                    self.timeLineArray.removeAll(keepingCapacity: false)
                    
                    let docRef = ref.collection("Restaurants").document("\(member)")
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                          
                                               
                             if let flashSales = document.get("FlashSales")as? String{
                                                       self.flashSalesArray.append(flashSales)
                                                   }
                            if let restaurantOwner = document.get("RestaurantOwner")as? String{
                                                                              self.restaurantOwnerArray.append(restaurantOwner)
                                                                   }
                                                  if let restaurantName = document.get("RestaurantName")as? String{
                                                                             self.restaurantNameArray.append(restaurantName)
                                                                         }
                                                   if let imageUrl = document.get("İmageUrl")as? String{
                                                                              self.userImageArray.append(imageUrl)
                                                                          }
                                                   if let timeLine = document.get("TimeLine")as? String{
                                                                                                     self.timeLineArray.append(timeLine)
                                                                                                 }
                        
                            self.tableView.reloadData()
                        }
                        else {
                            print("Document does not exist")
                        }
                        
                    }
                 

                }
                 print("members: \(self.membersArray)")
                print("MembersCount: \(self.restaurantNameArray.count)")
            }
        }
    }
    
    func getDataFromFirestore(){
           
           let firestoreDataBase = Firestore.firestore()
        
        firestoreDataBase.collection("Restaurants").whereField("InZone", isEqualTo: true).addSnapshotListener { (snapshot, error) in
               if error != nil{
                   print(error?.localizedDescription)
               }else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.restaurantNameArray.removeAll(keepingCapacity: false)
                    self.restaurantOwnerArray.removeAll(keepingCapacity: false)
                    self.flashSalesArray.removeAll(keepingCapacity: false)
                    self.timeLineArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    self.locationArray.removeAll(keepingCapacity: false)
                    
                    
                       for document in snapshot!.documents {
                           let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        //firestoreDataBase.document("\(documentID)").setData(["InZone" : false])
                        
                        if let geoLocation = document.get("GeoPoint")as? Double{
                            self.locationArray.append(geoLocation)
                        }
                        if let flashSales = document.get("FlashSales")as? String{
                            self.flashSalesArray.append(flashSales)
                        }
                        if let restaurantOwner = document.get("RestaurantOwner")as? String{
                                                   self.restaurantOwnerArray.append(restaurantOwner)
                                        }
                       if let restaurantName = document.get("RestaurantName")as? String{
                                                  self.restaurantNameArray.append(restaurantName)
                                              }
                        if let imageUrl = document.get("İmageUrl")as? String{
                                                   self.userImageArray.append(imageUrl)
                                               }
                        if let timeLine = document.get("TimeLine")as? String{
                                                                          self.timeLineArray.append(timeLine)
                                                                      }
                       }
                    self.tableView.reloadData()
                    
               }
           }
            print("GeoPoints: \(self.locationArray)")
       }
   
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.restaurantNameLabel.text = restaurantNameArray[indexPath.row]
        cell.flashSalesLabel.text = flashSalesArray[indexPath.row]
        cell.timeLineLabel.text = timeLineArray[indexPath.row]
        
        return cell
    }
}
