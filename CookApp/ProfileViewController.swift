//
//  ProfileViewController.swift
//  CookApp
//
//  Created by Utku Çalışkan on 7.12.2022.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth
import SDWebImage

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var cookNameArray = [String]()
    var user = Auth.auth().currentUser?.email
    var cookName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        DispatchQueue.global().async {
            self.getDataBase()
        }
        usernameLabel.text = user
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cookName = cookNameArray[indexPath.row]
        performSegue(withIdentifier: "profileToDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToDetails"{
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.name = cookName
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cookNameArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.cookNameLabel.text = cookNameArray[indexPath.row]
        return cell
        
    }
    
    
    
    func getDataBase(){
        
        let db = Firestore.firestore()
        db.collection("Profile").addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
            }
            else{
                if snapshot?.isEmpty != true{
                    self.cookNameArray.removeAll(keepingCapacity: false)
                    for doc in snapshot!.documents{
                        if let postedBy = doc.get("postedBy") as? String{
                            if self.user == postedBy{
                                if let biographyName = doc.get("biography") as? String{
                                    self.biographyLabel.text = biographyName
                                    if let imageURL = doc.get("imageURL") as? String{
                                        self.profileImage.sd_setImage(with: URL(string: imageURL))
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        db.collection("Cook").addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
            }
            else{
                if snapshot?.isEmpty != true{
                    for doc in snapshot!.documents{
                        if let postedBy = doc.get("postedBy") as? String{
                            if self.user == postedBy {
                                if let cookName = doc.get("CookName") as? String{
                                    self.cookNameArray.append(cookName)
                                }
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }

    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }

    
}

