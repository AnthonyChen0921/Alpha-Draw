//
//  WelcomeViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/24/22.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var animateBar: UIView!
    @IBOutlet weak var regBottomLine: UIView!
    @IBOutlet weak var logBottomLine: UIView!
    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var welcomeText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set button font style to Times Bold 18.0
        addAnimatation()
        setRegButtonColor()
        setLogButtonColor()
        
        // call addGlowEffectToTitle() per 4 seconds
        Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(addGlowEffectToTitle), userInfo: nil, repeats: true)

        // call addLinearlyFlashEffectToBottomLine per 2 seconds
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(addLinearlyFlashEffectToAnimateBar), userInfo: nil, repeats: true)

        // call animateBackGroundImage per 4 seconds
        Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(animateBackGroundImage), userInfo: nil, repeats: true)

        // add button action on hover
        regButton.addTarget(self, action: #selector(regButtonHover), for: .touchDown)
        logButton.addTarget(self, action: #selector(logButtonHover), for: .touchDown)

        // add button action on hover out
        regButton.addTarget(self, action: #selector(regButtonHoverOut), for: .touchDragExit)
        logButton.addTarget(self, action: #selector(logButtonHoverOut), for: .touchDragExit)
    }

    // view did appear
    override func viewDidAppear(_ animated: Bool) {  
        // addAnimatation()
        regBottomLine.alpha = 0
        logBottomLine.alpha = 0
        animateBar.alpha = 0
    }



    @objc func regButtonHover(sender: UIButton!) {
        animateView(viewToAnimate: sender, type: 0)

    }

    @objc func logButtonHover(sender: UIButton!) {
        animateView(viewToAnimate: sender, type: 2)
    }

    @objc func regButtonHoverOut(sender: UIButton!) {
        animateView(viewToAnimate: sender, type: 1)
    }

    @objc func logButtonHoverOut(sender: UIButton!) {
        animateView(viewToAnimate: sender, type: 3)
    }

    func animateView(viewToAnimate: UIView, type: Int) {
        if type == 0 {
            // make regBottomLine appear from left to right with alpha 1
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.regBottomLine.alpha = 1
            }, completion: nil)

        } else if(type == 1) {
            // make regBottomLine disappear from left to right with alpha 0
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.regBottomLine.alpha = 0
            }, completion: nil)
        } else if(type == 2){
            // make logBottomLine appear from left to right with alpha 1
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.logBottomLine.alpha = 1
            }, completion: nil)
        } else if(type == 3){
            // make logBottomLine disappear from right to left with alpha 0
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.logBottomLine.alpha = 0
            }, completion: nil)
        }
    }

    @objc func addGlowEffectToTitle() {
        // add glow effect to welcomeText within 0.5 seconds
        UIView.animate(withDuration: 2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.welcomeText.layer.shadowColor = UIColor.white.cgColor
            self.welcomeText.layer.shadowRadius = 10.0
            self.welcomeText.layer.shadowOpacity = 1.0
            self.welcomeText.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.welcomeText.layer.masksToBounds = false

        }, completion: nil)
        // delay 0.5 seconds and remove glow effect from welcomeText
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            UIView.animate(withDuration: 2, delay: 0.0, options: .curveEaseInOut, animations: {
                self.welcomeText.layer.shadowColor = UIColor.clear.cgColor
                self.welcomeText.layer.shadowRadius = 0.0
                self.welcomeText.layer.shadowOpacity = 0.0
                self.welcomeText.layer.shadowOffset = CGSize(width: 0, height: 0)
                self.welcomeText.layer.masksToBounds = false
            }, completion: nil)
        } 
    }

    @objc func addLinearlyFlashEffectToAnimateBar(){
        // make animateBar appear with alpha 1, then move to the right of the screen make it disappear with alpha 0, reset its position to the left of the screen
       
        UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.animateBar.alpha = 1
        }, completion: nil)
        // after 1.5 seconds, move animateBar to the right of the screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.animateBar.frame.origin.x = self.view.frame.width - self.animateBar.frame.width - 29
            }, completion: nil)
        }
        // after 4 seconds, move animateBar to the left of the screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.animateBar.frame.origin.x = 29
            }, completion: nil)
        }
        // after 5 seconds, make animateBar disappear with alpha 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.animateBar.alpha = 0
            }, completion: nil)
        }
    }

    func addAnimatation(){
        // print out the welcome text with animation
        welcomeText.text = ""
        var charIndex = 0.0
        let titleText = "PixelBot"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.05 * charIndex, repeats: false) { (timer) in
                self.welcomeText.text?.append(letter)
            }
            charIndex += 1
        }

    }

    @objc func animateBackGroundImage(){
        // animate background image
        UIView.animate(withDuration: 2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.backgroundImage.alpha = 0.5
        }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 2, delay: 0.0, options: .curveEaseInOut, animations: {
                self.backgroundImage.alpha = 1
            }, completion: nil)
        }
    }
    

    func setRegButtonColor(){
        // set animation for the register button within 0.5 seconds to fade in
        regButton.alpha = 0
        UIView.animate(withDuration: 0.8, animations: {
            self.regButton.alpha = 1
        })
        // set regbutton background color to clear
        regButton.backgroundColor = UIColor.clear
    }

    func setLogButtonColor(){
        // set animation for the login button within 0.5 seconds to fade in
        logButton.alpha = 0
        UIView.animate(withDuration: 0.8, animations: {
            self.logButton.alpha = 1
        })
        // set logbutton background color to clear
        logButton.backgroundColor = .clear
    }

    

    @IBAction func registerButtonClicked(_ sender: Any) {
        // set the regBottomLine to alpha 0
        regBottomLine.alpha = 0
    }
    @IBAction func loginButtonClicked(_ sender: Any) {
        // set the logBottomLine to alpha 0
        logBottomLine.alpha = 0
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
