//
//  HomeViewController.swift
//  CookApp
//
//  Created by Utku Çalışkan on 7.12.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var whoLikedArray = [String]()
    var userArray = [String]()
    var cookNameArray = [String]()
    var imageArray = [String]()
    var likeArray = [Int]()
    var documentIDArray = [String]()
    var recipeArray = [String]()
    var cookName = ""
    var recipe = ""
    var selectedImage = ""
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tabBarController?.tabBar.backgroundColor = .orange
        DispatchQueue.global().async {
            self.getDataBase()
        }
               
    }
    
        
    func getDataBase(){
        let db = Firestore.firestore()
        db.collection("Cook").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
            }
            else{
                if snapshot?.isEmpty != true {
                    self.userArray.removeAll(keepingCapacity: false)
                    self.imageArray.removeAll(keepingCapacity: false)
                    self.cookNameArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let docID = document.documentID
                        self.documentIDArray.append(docID)
                        if let postedBy = document.get("postedBy") as? String{
                            self.userArray.append(postedBy)
                            if let cookName = document.get("CookName") as? String{
                                self.cookNameArray.append(cookName)
                                if let imageURL = document.get("imageURL") as? String{
                                    self.imageArray.append(imageURL)
                                    if let likes = document.get("likes") as? Int {
                                        self.likeArray.append(likes)
                                        if let recipe = document.get("Recipe") as? String{
                                            self.recipeArray.append(recipe)
                                            if let wholiked = document.get("wholiked") as? String{
                                                self.whoLikedArray.append(wholiked)
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                }
            }
            self.tableView.reloadData()
        }
        
    }
        
    

    
    
    
    
   
    @IBAction func uploadClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "uploadVC", sender: nil)
    }
    
    
    @IBAction func settingsClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "settingsVC", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.cookNameLabel.text! = cookNameArray[indexPath.row]
       // cell.whoLikedLabel.text! = whoLikedArray[indexPath.row]
        //cookName = cookNameArray[3]
        cell.likePoint.text! = String(likeArray[indexPath.row])
        cell.documentID.text = documentIDArray[indexPath.row]
        //print("UTKU-2-\(cell.whoLikedLabel.text)")
        cell.whoLikedLabel.text! = userArray[indexPath.row]
        return cell
    }
    
    func makeAlert(titleInput : String , messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipe = recipeArray[indexPath.row]
        cookName = cookNameArray[indexPath.row]
        selectedImage = imageArray[indexPath.row]
        performSegue(withIdentifier: "goDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetailsVC" {
            let destinationVC = segue.destination as? DetailsViewController
            destinationVC?.name = cookName
            destinationVC?.recipeName = recipe
            destinationVC?.chosenImage = selectedImage
        }
    }

    
}
