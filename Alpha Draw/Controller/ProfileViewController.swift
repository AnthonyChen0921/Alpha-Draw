//
//  ProfileViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/25/22.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getName()
    }


    @IBAction func logoutButtonClicked(_ sender: Any) {
        // logout user
        do {
            try Auth.auth().signOut()
            // clear user defaults
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "user_id")
            // go to welcome screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let welcomeViewController = storyboard.instantiateViewController(identifier: "WelcomeViewController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(welcomeViewController)
        } catch {
            // show alert
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.overrideUserInterfaceStyle = .dark
            self.present(alert, animated: true)
        }
    }

    func getName() -> String {
        // get user data by user_id from UserDefaults
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        print(user_id!)

        // get user data from firebase
        let db = Firestore.firestore()
        var name = ""
        db.collection("users").document(user_id!).getDocument { (document, error) in
            if error != nil {
                // show alert
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.overrideUserInterfaceStyle = .dark
                self.present(alert, animated: true)
            } else {
                if document != nil && document!.exists {
                    // get name from user data
                    name = document!.get("name") as! String
                    self.username.text = name
                }
            }
        }
        return name
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
