//
//  WelcomeViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/24/22.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var welcomeText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set button font style to Times Bold 18.0
        // regButton.titleLabel?.font = UIFont(name: "Times-Bold", size: 18.0)
        // logButton.titleLabel?.font = UIFont(name: "Times-Bold", size: 18.0)

        // print out the welcome text with animation
        welcomeText.text = ""
        var charIndex = 0.0
        let titleText = "Welcome to PixelBot"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.05 * charIndex, repeats: false) { (timer) in
                self.welcomeText.text?.append(letter)
            }
            charIndex += 1
        }
        
        

        // set animation for the register button within 0.5 seconds to fade in
        regButton.alpha = 0
        UIView.animate(withDuration: 0.8, animations: {
            self.regButton.alpha = 1
        })

        // set animation for the login button within 0.5 seconds to fade in
        logButton.alpha = 0
        UIView.animate(withDuration: 0.8, animations: {
            self.logButton.alpha = 1
        })
    }

    @IBAction func registerButtonClicked(_ sender: Any) {
    }
    @IBAction func loginButtonClicked(_ sender: Any) {
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
