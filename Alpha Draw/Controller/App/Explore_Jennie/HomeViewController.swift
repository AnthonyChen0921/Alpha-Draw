//
//  DrawViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/25/22.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBackButton(view: self)
        // DO NOT DELETE: This is the code that hides the back button on the home screen, since Home is the first screen in the app after login, other controllers does not have hidesBackButton function called for resouces purposes
        
    }
    
}
