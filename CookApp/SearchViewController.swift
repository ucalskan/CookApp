//
//  SearchViewController.swift
//  CookApp
//
//  Created by Utku Çalışkan on 20.12.2022.
//

import UIKit
import Firebase
import FirebaseStorage


class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    

    
    
    var filteredList = [String]()
    var recipe = ""
    var cookName = ""
    var selectedImage = ""
    var cookNameArray = [String]()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
       //getDataBase()
        
        
        
       
        
       
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cookName = cookNameArray[0]
        performSegue(withIdentifier: "searchToDetails", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToDetails" {
            let destinationVC = segue.destination as? DetailsViewController
            destinationVC?.name = cookName
        }
    }
    
    /*func getDataBase(){
        let db = Firestore.firestore()
        db.collection("Cook").addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlertI(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
            }
            else{
                if snapshot?.isEmpty != true{
                    for doc in snapshot!.documents {
                        if let cookName = doc.get("CookName") as? String{
                            self.cookNameArray.append(cookName)
                        }
                    }
                }
            }
        }
    }
    */
    
   

    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let db = Firestore.firestore()
        db.collection("Cook").whereField("CookName", isGreaterThanOrEqualTo: searchText) .addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlertI(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
            }
            else{
                if snapshot?.isEmpty != true{
                    self.filteredList.removeAll(keepingCapacity: false)
                    for doc in snapshot!.documents {
                        if let cookName = doc.get("CookName") as? String{
                            self.filteredList.append(cookName)
                            self.cookNameArray.append(cookName)
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.cookNameLabel.text = filteredList[0]
        return cell
    }
    
   
    
    
    
    func makeAlertI(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
    
}







