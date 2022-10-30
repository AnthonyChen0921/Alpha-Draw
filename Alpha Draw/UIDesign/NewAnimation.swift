//
//  NewAnimation.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/30/22.
//

import UIKit
import RAMAnimatedTabBarController

class NewAnimation: RAMItemAnimation {
    // method call when Tab Bar Item is selected
    override func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        // add animation
        playBounceAnimation(icon)
    }
    // method call when Tab Bar Item is deselected
    override func deselectAnimation(_ icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor) {
      // add animation
    }
    // method call when TabBarController did load
    override func selectedState(_ icon: UIImageView, textLabel: UILabel) {
      // set selected state
    }
    func playBounceAnimation(_ icon : UIImageView) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic

        icon.layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
    
}
