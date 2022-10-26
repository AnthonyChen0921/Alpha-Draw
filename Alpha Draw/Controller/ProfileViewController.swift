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
        // get user data
        let db = Firestore.firestore()
        db.collection("users").whereField("email", isEqualTo: Auth.auth().currentUser?.email! as Any).getDocuments { (snapshot, error) in
            if error != nil {
                // show alert
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.overrideUserInterfaceStyle = .dark
                self.present(alert, animated: true)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        if let name = document.get("name") as? String {
                            self.username.text = name
                        }
                    }
                }
            }
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
