//
//  ViewController.swift
//  CookApp
//
//  Created by Utku Çalışkan on 3.12.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth


class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signinClicked(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){authdata, error in
                if error != nil {
                    self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Error")
                }
                else {
                    self.performSegue(withIdentifier: "goTabVC", sender: nil)
                }
            }
        }
        else{
            self.makeAlert(titleInput: "ERROR!!", messageInput: "USERNAME/PASSWORD?")
        }
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){authdata, error in
                if error != nil {
                    self.makeAlert(titleInput:"ERROR", messageInput: error?.localizedDescription ?? "Error")
                 
                }
                else{
                    
                    self.performSegue(withIdentifier: "goTabVC", sender: nil)
                }
            }
        }
        
    }
        
        
        
        func makeAlert(titleInput: String, messageInput: String){
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    

