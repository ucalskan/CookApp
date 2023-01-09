//
//  DetailsViewController.swift
//  CookApp
//
//  Created by Utku Çalışkan on 9.12.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class DetailsViewController: UIViewController{
    
    
    
    @IBOutlet weak var cookImage: UIImageView!
    @IBOutlet weak var recipeText: UITextView!
    @IBOutlet weak var CookNameLabel: UILabel!
    
    var name = ""
    var recipeName = ""
    var chosenImage = "" 
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global().async {
            self.getDataBase()
        }
        
        
        
    }
    
    
    func getDataBase(){
        let db = Firestore.firestore()
        db.collection("Cook").addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
            }
            else{
                if snapshot?.isEmpty != true{
                    for doc in snapshot!.documents {
                        if let cookName = doc.get("CookName") as? String{
                            if self.name == cookName{
                                self.CookNameLabel.text = cookName
                                if let recipe = doc.get("Recipe") as? String{
                                    self.recipeText.text = recipe
                                    if let imageURL = doc.get("imageURL") as? String{
                                        self.cookImage.sd_setImage(with: URL(string: imageURL))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
  
    
    

    
    

   
    
    
    func makeAlert(titleInput: String, messageInput: String){
     let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
     let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
     alert.addAction(okButton)
     self.present(alert,animated: true)
        
    }
            

    @IBAction func backClicked(_ sender: Any) {
        performSegue(withIdentifier: "gotoBackScreen", sender: nil)
    }
    
   
    
}
