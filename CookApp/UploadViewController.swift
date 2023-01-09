//
//  UploadViewController.swift
//  CookApp
//
//  Created by Utku Çalışkan on 7.12.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var recipeText: UITextView!
    @IBOutlet weak var cookNameText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    
    @IBAction func backClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "goHomeVC", sender: nil)
    }
    
    @objc func chooseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func uploadClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        let uuid = UUID().uuidString
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(titleInput: "ERROR!", messageInput: error?.localizedDescription ?? "Error")
                }
                else{
                    imageReference.downloadURL { url, error in
                        if error == nil{
                            let imageURL = url?.absoluteString
                            // MARK: - DATABASE
                            let dataBase = Firestore.firestore()
                            var fireStoreReference : DocumentReference? = nil
                            if self.cookNameText.text == "" && self.recipeText.text == "" {
                                self.makeAlert(titleInput: "ERROR!", messageInput: error?.localizedDescription ?? "Error")
                            }
                            else{
                                let fireStorePost = ["imageURL" : imageURL! , "postedBy" : Auth.auth().currentUser!.email!, "CookName" : self.cookNameText.text!,"Recipe": self.recipeText.text!, "date" : FieldValue.serverTimestamp(),"likes" : 0] as [String : Any]
                                
                                fireStoreReference = dataBase.collection("Cook").addDocument(data: fireStorePost, completion: { error in
                                    if error != nil {
                                        self.makeAlert(titleInput: "ERROR", messageInput: "Please write cook name or recipe.")
                                    }
                                    else{
                                        self.imageView.image = UIImage(named: "cook3")
                                        self.cookNameText.text! = ""
                                        self.recipeText.text! = ""
                                        self.tabBarController?.selectedIndex = 1
                                    }
                                })
                                
                                                
                                
                            }
                            }
                    }
                }
            }
        }
        
        //MARK: - SECOND DATA
        let secondMediaFolder = mediaFolder.child("media2")
        let uuid2 = UUID().uuidString
        if let data2 = imageView.image?.jpegData(compressionQuality: 0.5){
            let imageReference2 = secondMediaFolder.child("\(uuid).jpeg")
            imageReference2.putData(data2, metadata: nil) { metadata2, error in
                if error != nil{
                    self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
                }
                else{
                    imageReference2.downloadURL { url2, error2 in
                        if error2 == nil {
                            let imageURL2 = url2?.absoluteString
                            let db = Firestore.firestore()
                            var frReference : DocumentReference? = nil
                            if self.cookNameText.text == "" && self.recipeText.text == "" {
                                self.makeAlert(titleInput: "ERROR", messageInput: "Please write cook name or recipe.")
                            }
                            else{
                                let fireStorePost = ["imageURL":imageURL2!, "postedBy": Auth.auth().currentUser!.email!,"CookName": self.cookNameText.text!, "Recipe": self.recipeText.text!, "likes":0, "date":FieldValue.serverTimestamp()] as [String: Any]
                                frReference = db.collection("Cook2").addDocument(data: fireStorePost, completion: { error in
                                    if error != nil {
                                        self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
                                    }
                                    else{
                                        self.imageView.image = UIImage(named: "cook3")
                                        self.cookNameText.text! = ""
                                        self.recipeText.text! = ""
                                        self.tabBarController?.selectedIndex = 1
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func makeAlert(titleInput: String, messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
}
