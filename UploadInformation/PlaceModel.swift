//
//  PlaceModel.swift
//  UploadInformation
//
//  Created by Furkan Yiğit Akyildiz on 11/9/19.
//  Copyright © 2019 AlohaLabs. All rights reserved.
//

import Foundation
import UIKit

class PlaceModel{
    static let sharedInstance = PlaceModel()
    
    var restaurantName = ""
    var flashSale = ""
    var timeLine = ""
    var placeImage = UIImage()
    var placeLatitude = 0.000000
    var placeLongitude = 0.000000
       
    
    
 
    
    private init (){} 
}
