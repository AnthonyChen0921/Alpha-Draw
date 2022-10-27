//
//  CustomTabBarController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/26/22.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    var middleButton: UIButton! = UIButton()
    var buttonBackground: UIView! = UIView()
    var colorArray: [CGColor] = [UIColor.white.cgColor, UIColor.systemMint.cgColor, UIColor.systemCyan.cgColor, UIColor.systemOrange.cgColor, UIColor.systemPurple.cgColor]
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // set up delegate and initialize tarbar first item
        self.delegate = self
        self.selectedIndex = 0

        // set up middle button
        setupMiddleButton()
        
        // add animation to middle button
        addGloomyShadowEffectAnimation()

        // setup a timer for addGloomyShadowEffectAnimation every 4.5 seconds
        Timer.scheduledTimer(timeInterval: 4.5, target: self, selector: #selector(self.addGloomyShadowEffectAnimation), userInfo: nil, repeats: true)
    }

    /**
        *  This function is used to setup the middle button in the tab bar
        */
    func setupMiddleButton() {
        // add a buttonBackground view to hold the button, using round corners
        buttonBackground.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        buttonBackground.center = CGPoint(x: self.tabBar.center.x, y: self.tabBar.frame.height - 34)
        buttonBackground.backgroundColor = UIColor.black
        buttonBackground.layer.cornerRadius = 30
        buttonBackground.layer.shadowColor = UIColor.white.cgColor
        buttonBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
        buttonBackground.layer.shadowRadius = 10
        buttonBackground.layer.shadowOpacity = 0.8
        buttonBackground.layer.masksToBounds = false


        // make the button in the middle of the tab bar at the bottom, delcare a filled button
        middleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        middleButton.backgroundColor = UIColor(named: "red")
        middleButton.layer.cornerRadius = 32
        middleButton.clipsToBounds = true
        // add a shadow to the button
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        middleButton.layer.shadowRadius = 10
        middleButton.layer.shadowOpacity = 0.5
        middleButton.setImage(UIImage(named: "lightbulb3"), for: .normal)
        middleButton.addTarget(self, action: #selector(middleButtonAction), for: .touchUpInside)
        middleButton.translatesAutoresizingMaskIntoConstraints = false

        // add the button to the buttonBackground view
        buttonBackground.addSubview(middleButton)
        // add the buttonBackground view to the tab bar
        self.tabBar.addSubview(buttonBackground)
        // position the button in the middle of the tab bar
        middleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        middleButton.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 48).isActive = true
        middleButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        middleButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        
    }

    /**
        *  @brief This function is to add gloomy shadow effect animation to the buttonBackground view, 
        *  the whole execution of this function is 4.5 seconds
        */
    @objc func addGloomyShadowEffectAnimation(){
        // add a gloomy shadow effect animation to the button
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {            
            self.buttonBackground.layer.shadowColor = UIColor.clear.cgColor
            self.buttonBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.buttonBackground.layer.shadowRadius = 0
            self.buttonBackground.layer.shadowOpacity = 0
        }, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
                // pick color by sequence
                self.buttonBackground.layer.shadowColor = self.colorArray[self.selectedIndex]
                self.buttonBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
                self.buttonBackground.layer.shadowRadius = 10
                self.buttonBackground.layer.shadowOpacity = 0.8
            }, completion: nil)
        }
    }

    
    /**
        *  @brief Don't change this function, it links the button to the tab bar
        */
    @objc func middleButtonAction() {
        self.selectedIndex = 2
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
