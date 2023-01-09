//
//  SettingsViewController.swift
//  CookApp
//
//  Created by Utku Çalışkan on 7.12.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var biographyText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseimage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func chooseimage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
        
    }
    

    @IBAction func logoutClicked(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier:"goLoginVC", sender: nil)
        }
        catch{}
        }
    @IBAction func saveClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        
        let mediaFolder = storageReferance.child("media")
        
        let uuid = UUID().uuidString
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let imageReferance = mediaFolder.child("\(uuid).jpeg")
            imageReferance.putData(data, metadata: nil){metadata, error in
                if error != nil{
                    self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
                }
                else {
                    imageReferance.downloadURL { url, error in
                        if error == nil{
                            let imageURL = url?.absoluteString
                            //MARK: DATABASE
                            let db = Firestore.firestore()
                            var FirestoreReference : DocumentReference? = nil
                            if self.biographyText.text == ""  {
                                self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
                            }
                            else{
                                var fireStorePost = ["postedBy" : Auth.auth().currentUser?.email, "biography": self.biographyText.text, "imageURL" : imageURL] as? [String : Any]
                                db.collection("Profile").addDocument(data: fireStorePost!) { error in
                                    if error != nil {
                                        self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error" )
                                    }
                                    else{
                                        self.imageView.image = UIImage(named: "users")
                                        self.biographyText.text = ""
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                }
                            
                            }
                        }
                    }
                }
                
                
                
            }
        }
        
        
    }
    @IBAction func backClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "goBackVC", sender: nil)
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }

}
