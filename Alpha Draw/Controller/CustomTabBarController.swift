//
//  CustomTabBarController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/26/22.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    var middleButton: UIButton! = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        self.selectedIndex = 1
        setupMiddleButton()
    }


    func setupMiddleButton() {
        // make the button in the middle of the tab bar at the bottom, delcare a filled button
        middleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        middleButton.backgroundColor = UIColor(named: "red")
        middleButton.layer.cornerRadius = 32
        middleButton.layer.masksToBounds = true
        middleButton.setImage(UIImage(named: "lightbulb3"), for: .normal)
        middleButton.addTarget(self, action: #selector(middleButtonAction), for: .touchUpInside)
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        // 
        view.addSubview(middleButton)
        // position the button in the middle of the tab bar
        middleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        middleButton.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 48).isActive = true
        middleButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        middleButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
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
