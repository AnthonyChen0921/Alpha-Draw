//
//  WelcomeViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/24/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    var currentBackgroundImageIndex = 1;
    var flag = false;

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var animateBar: UIView!
    @IBOutlet weak var regBottomLine: UIView!
    @IBOutlet weak var logBottomLine: UIView!
    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var detailText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set button font style to Times Bold 18.0
        addAnimatation()
        setRegButtonColor()
        setLogButtonColor()
        

        // schedule deleteAndAddDetailText() to be called every 24 seconds, but first call after 12 seconds
        Timer.scheduledTimer(timeInterval: 24, target: self, selector: #selector(deleteAndAddDetailText), userInfo: nil, repeats: true)

        // call addGlowEffectToTitle() per 4 seconds
        Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(addGlowEffectToTitle), userInfo: nil, repeats: true)

        // call addLinearlyFlashEffectToBottomLine per 2 seconds
        Timer.scheduledTimer(timeInterval: 14, target: self, selector: #selector(self.addLinearlyFlashEffectToAnimateBar), userInfo: nil, repeats: true)

        // call animateBackGroundImage per 4 seconds
        Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(animateBackGroundImage), userInfo: nil, repeats: true)

        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.switchBackgroundimage), userInfo: nil, repeats: true)

        // call setAnimateBarFadeIn() per 2 seconds
        Timer.scheduledTimer(timeInterval: 14, target: self, selector: #selector(setAnimateBarFadeIn), userInfo: nil, repeats: true)
        
        
        deleteAndAddDetailText()
        
        // add button action on hover
        regButton.addTarget(self, action: #selector(regButtonHover), for: .touchDown)
        logButton.addTarget(self, action: #selector(logButtonHover), for: .touchDown)

        // add button action on hover out
        regButton.addTarget(self, action: #selector(regButtonHoverOut), for: .touchDragExit)
        logButton.addTarget(self, action: #selector(logButtonHoverOut), for: .touchDragExit)

        
        animateBar.alpha = 0

        // set background image
        backgroundImage.image = UIImage(named: "WelcomeBackground")
        backgroundImage.contentMode = .topLeft
        backgroundImage.clipsToBounds = true

        
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

    // @objc func addLinearlyFlashEffectToAnimateBar(){
    //     // move animateBar from left of the screen to right of the screen
    //     UIView.animate(withDuration: 1, delay: 0.0, options: .curveLinear, animations: {
    //         self.animateBar.alpha = 1
    //         self.animateBar.frame.origin.x = self.view.frame.width - self.animateBar.frame.width-29
    //     }, completion: nil)
    //     // delay 1 second and move animateBar from right of the screen to left of the screen
    //     DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    //         UIView.animate(withDuration: 1, delay: 0.0, options: .curveLinear, animations: {
    //             self.animateBar.alpha = 0
    //             self.animateBar.frame.origin.x = 29
    //         }, completion: nil)
    //     }
    // }

    @objc func addLinearlyFlashEffectToAnimateBar(){
        // add linearly flash effect to animateBar within 0.5 seconds
        UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseInOut, animations: {
            //self.animateBar.alpha = 1
        }, completion: nil)
        // after 1.5 seconds, move animateBar to the right of the screen
        UIView.animate(withDuration: 1.5, delay: 2.0, options: .curveEaseInOut, animations: {
            self.animateBar.frame.origin.x = self.view.frame.width - self.animateBar.frame.width - 29
        }, completion: nil)
        
        // after 4 seconds, move animateBar to the left of the screen
        UIView.animate(withDuration: 1.5, delay: 4.0, options: .curveEaseInOut, animations: {
            self.animateBar.frame.origin.x = 29
        }, completion: nil)
        // // after 5 seconds, make animateBar disappear with alpha 0
        // UIView.animate(withDuration: 1.5, delay: 6.0, options: .curveEaseInOut, animations: {
        //     self.animateBar.alpha = 0
        // }, completion: nil)
    }

    @objc func setAnimateBarFadeIn(){
        // make animateBar appear with alpha 1
        UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.animateBar.alpha = 1
        }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            // make animateBar disappear with alpha 0
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
            Timer.scheduledTimer(withTimeInterval: 0.08 * charIndex, repeats: false) { (timer) in
                self.welcomeText.text?.append(letter)
            }
            charIndex += 1
        }
    }
    @objc func addAnimatedDetailToWelcomeText() {
        // add another labeltext to display: "A painting of a castle standing in a tumultuous storm, the crowd at the bottom. Magnificant clouds and lightning. Light towers glimmer with red light, Trending on ArtStation."
        detailText.text = ""
        // set the color to silver
        detailText.textColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
        var titleText = "";
        if (currentBackgroundImageIndex == 1){
            var charIndex = 0.0
            titleText = "A painting of a castle standing in a tumultuous storm, the crowd at the bottom. Magnificent clouds and lightning. Light towers glimmer with red light, Trending on ArtStation."
            for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.042241 * charIndex, repeats: false) { (timer) in
                self.detailText.text?.append(letter)
            }
            charIndex += 1
            }
        }
        else{
            var charIndex = 0.0
            titleText = "A beautiful painting of sea cliffs in a tumultuous storm. A light house on the other side, shining glimmer with gold light. Trending on ArtStation."
            for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.05 * charIndex, repeats: false) { (timer) in
                self.detailText.text?.append(letter)
            }
            charIndex += 1
            }
        }
    }

    @objc func animateToDeleteDetailText() {
        // delete the detail text one by one
        
        var titleText = "";
        if (currentBackgroundImageIndex == 1){
            var charIndex = 0.0
            titleText = "A painting of a castle standing in a tumultuous storm, the crowd at the bottom. Magnificent clouds and lightning. Light towers glimmer with red light, Trending on ArtStation."
            for _ in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.042241 * charIndex, repeats: false) { (timer) in
                self.detailText.text?.removeLast()
            }
            charIndex += 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                self.currentBackgroundImageIndex = 2
                self.flag = true
            }
        }
        else{
            var charIndex = 0.0
            titleText = "A beautiful painting of sea cliffs in a tumultuous storm. A light house on the other side, shining glimmer with gold light. Trending on ArtStation."
            for _ in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.05 * charIndex, repeats: false) { (timer) in
                self.detailText.text?.removeLast()
            }
            charIndex += 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                self.currentBackgroundImageIndex = 1
                self.flag = true
            }
        }
    }

    @objc func switchBackgroundimage(){
        // change currentBackgroundImageIndex to 1 or 2
        if(currentBackgroundImageIndex == 1 && flag){
            UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.backgroundImage.alpha = 0
            }, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.backgroundImage.image = UIImage(named: "WelcomeBackground")
                }, completion: nil)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.backgroundImage.alpha = 1
                }, completion: nil)
            }
            flag = false
        }else if(currentBackgroundImageIndex == 2 && flag){
            UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.backgroundImage.alpha = 0
            }, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.backgroundImage.image = UIImage(named: "WelcomeBackground3")
                }, completion: nil)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.backgroundImage.alpha = 1
                }, completion: nil)
            }
            flag = false
        }
    }

    @objc func deleteAndAddDetailText(){
        // delete the detail text and add another one
        addAnimatedDetailToWelcomeText()
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.animateToDeleteDetailText()
        }
    }

    @objc func animateBackGroundImage(){
        // animate background image
        UIView.animate(withDuration: 2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.backgroundImage.alpha = 0.6
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
