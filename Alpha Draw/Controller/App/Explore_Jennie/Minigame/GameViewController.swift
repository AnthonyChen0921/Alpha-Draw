//
//  GameViewController.swift
//  Alpha Draw
//
//  Created by Jennie Lu on 11/29/22.
//
// Dino game is from google chrome
// Followed a tutorial+github on how to make it https://www.youtube.com/watch?v=1H9EG15mycI + https://github.com/johnlk/DinoRunner + https://www.youtube.com/watch?v=0gOi_2Jwt28

import UIKit
import SpriteKit


class GameViewController: UIViewController {
    
    @IBOutlet weak var skView: SKView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
        skView.ignoresSiblingOrder = true
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask.all
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
