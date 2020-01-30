//
//  FeedCell.swift
//  UploadInformation
//
//  Created by Furkan Yiğit Akyildiz on 11/5/19.
//  Copyright © 2019 AlohaLabs. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    

    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    @IBOutlet weak var timeLineLabel: UILabel!
    
    @IBOutlet weak var flashSalesLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        //userImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        //userImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 6).isActive = true
        //userImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        
        userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        restaurantNameLabel.translatesAutoresizingMaskIntoConstraints = false
         
        restaurantNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 5).isActive = true
        restaurantNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        restaurantNameLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        restaurantNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        restaurantNameLabel.textAlignment = .left
        
        flashSalesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        flashSalesLabel.topAnchor.constraint(equalTo: restaurantNameLabel.bottomAnchor, constant: 5).isActive = true
        flashSalesLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        flashSalesLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        flashSalesLabel.textColor = .red
        flashSalesLabel.textAlignment = .left
        
        timeLineLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLineLabel.topAnchor.constraint(equalTo: flashSalesLabel.bottomAnchor, constant: 5).isActive = true
        timeLineLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        timeLineLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        timeLineLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        flashSalesLabel.textColor = .darkGray
        flashSalesLabel.textAlignment = .left
        

    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
