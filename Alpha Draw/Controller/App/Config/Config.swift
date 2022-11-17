//
//  Config.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/31/22.
//

import UIKit


class Config {
    var width: Int
    var height: Int
    var prompt_strength: Float
    var num_inference_steps: Int
    var guidance_scale: Float

    init(width: Int, height: Int, prompt_strength: Float, num_inference_steps: Int, guidance_scale: Float) {
        self.width = width
        self.height = height
        self.prompt_strength = prompt_strength
        self.num_inference_steps = num_inference_steps
        self.guidance_scale = guidance_scale
    }

    func getDict() -> [String: Any] {
        return [
            "width": self.width,
            "height": self.height,
            "prompt_strength": self.prompt_strength,
            "num_inference_steps": self.num_inference_steps,
            "guidance_scale": self.guidance_scale
        ]
    }


}
