//
//  HomeCell.swift
//  CookApp
//
//  Created by Utku Çalışkan on 7.12.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth


class HomeCell: UITableViewCell{
    
    @IBOutlet weak var whoLikedLabel: UILabel!
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var documentID: UILabel!
    @IBOutlet weak var likePoint: UILabel!
    @IBOutlet weak var cookNameLabel: UILabel!
    @IBOutlet weak var cookImage: UIImageView!
    var wholikedArray = [String]()
    var user = Auth.auth().currentUser?.email
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        //print(whoLikedLabel.text)
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
    
    @IBAction func likeClicked(_ sender: UIButton?) {
        
    }
    
}
