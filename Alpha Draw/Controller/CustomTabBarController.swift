//
//  CustomTabBarController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/26/22.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    var middleButton: UIButton! = UIButton()
    var neonBackground: UIView! = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        self.tabBar.tintColor = UIColor(named: "AccentColor")
        self.tabBar.unselectedItemTintColor = UIColor(named: "red")
        self.selectedIndex = 1
        //addNeonBackgroundBehindButton()
        //addBreathEffectToView()
        setupMiddleButton()
    }

    func setupMiddleButton() {
        // make the button in the middle of the tab bar at the bottom, delcare a filled button
        middleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        middleButton.backgroundColor = UIColor(named: "red")
        // button style to be a filled circle
        middleButton.layer.cornerRadius = 32
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        middleButton.layer.shadowRadius = 5
        middleButton.layer.shadowOpacity = 0.5
        // add border to the button and fill it with black
        // middleButton.layer.borderWidth = 2
        // middleButton.layer.borderColor = UIColor.white.cgColor
        middleButton.layer.masksToBounds = true
        //set to plus image
        middleButton.setImage(UIImage(named: "lightbulb"), for: .normal)
        // middleButton.setImage(UIImage(systemName: "scribble.variable"), for: .normal)
        middleButton.tintColor = UIColor.white
        middleButton.addTarget(self, action: #selector(middleButtonAction), for: .touchUpInside)
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        //set z position to be on top of the tab bar
        middleButton.layer.zPosition = 1
        view.addSubview(middleButton)
        middleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        middleButton.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 48).isActive = true
        middleButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        middleButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }

    // func addNeonBackgroundBehindButton(){
    //     // add a neon background behind the button
    //     neonBackground = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
    //     neonBackground.backgroundColor = UIColor(named: "red")
    //     neonBackground.layer.cornerRadius = 35
    //     neonBackground.layer.shadowColor = UIColor.red.cgColor
    //     neonBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
    //     neonBackground.layer.shadowRadius = 5
    //     neonBackground.layer.shadowOpacity = 0.5
    //     // add border to the button and fill it with black
    //     neonBackground.layer.borderWidth = 2
    //     neonBackground.layer.borderColor = UIColor.white.cgColor
    //     neonBackground.layer.masksToBounds = true
    //     // add a no-image image to the view, add subview
    //     neonBackground.addSubview(UIImageView(image: UIImage(named: "no-image")))
    //     neonBackground.translatesAutoresizingMaskIntoConstraints = false
    //     //set z position to be on bottom of the tab bar
    //     neonBackground.layer.zPosition = 0
    //     view.addSubview(neonBackground)
    //     neonBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    //     neonBackground.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 51).isActive = true
    //     neonBackground.widthAnchor.constraint(equalToConstant: 70).isActive = true
    //     neonBackground.heightAnchor.constraint(equalToConstant: 70).isActive = true
    // }

    func addBreathEffectToView(){
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            self.neonBackground.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
    }
    
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
