//
//  RegisterViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/24/22.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var confirmPasswordInputField: UITextField!
    @IBOutlet weak var nameInputField: UITextField!
    @IBOutlet weak var emailInputField: UITextField!
    @IBOutlet weak var passwordInputField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addStyleToInputField(inputField: nameInputField)
        addStyleToInputField(inputField: emailInputField)
        addStyleToInputField(inputField: passwordInputField)
        addStyleToInputField(inputField: confirmPasswordInputField)
    }
    @IBAction func registerButtonClicked(_ sender: Any) {
        // check if all input fields are filled
        if nameInputField.text == "" || emailInputField.text == "" || passwordInputField.text == "" || confirmPasswordInputField.text == "" {
            // show alert
            let alert = UIAlertController(title: "Error", message: "Please fill in all input fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.overrideUserInterfaceStyle = .dark
            self.present(alert, animated: true)
        } else {
            // check if password and confirm password are the same
            if passwordInputField.text != confirmPasswordInputField.text {
                // show alert
                let alert = UIAlertController(title: "Error", message: "Password and Confirm Password are not the same", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.overrideUserInterfaceStyle = .dark
                self.present(alert, animated: true)
            } else {
                // register user
                Auth.auth().createUser(withEmail: emailInputField.text!, password: passwordInputField.text!) { authResult, error in
                    if error != nil {
                        // show alert
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        alert.overrideUserInterfaceStyle = .dark
                        self.present(alert, animated: true)
                    } else {
                        // add user to database
                        let db = Firestore.firestore()
                        db.collection("users").addDocument(data: ["name": self.nameInputField.text!, "email": self.emailInputField.text!]) { (error) in
                            if error != nil {
                                // show alert
                                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Login Now!", style: .default, handler: nil))
                                alert.overrideUserInterfaceStyle = .dark
                                self.present(alert, animated: true)
                            }
                        }
                        // show alert
                        let alert = UIAlertController(title: "Success", message: "You have successfully registered", preferredStyle: .alert)
                        // when click on OK button, go to login page
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            self.performSegue(withIdentifier: "goToLogin", sender: self)
                        }))
                        alert.overrideUserInterfaceStyle = .dark
                        self.present(alert, animated: true)

                    }
                }
            }
        }

    }

    // when click other place on screen, dismiss keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // when click return on keyboard, dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }




    
    func addStyleToInputField(inputField: UITextField) {
        //set the height of the input field to be 50
        inputField.frame.size.height = 50
        inputField.layer.cornerRadius = 25
        // setup a white gloomy shadow for the input field
        inputField.layer.shadowColor = UIColor.white.cgColor
        inputField.layer.shadowOffset = CGSize(width: 0, height: 0)
        inputField.layer.shadowRadius = 10
        inputField.layer.shadowOpacity = 0.5
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
