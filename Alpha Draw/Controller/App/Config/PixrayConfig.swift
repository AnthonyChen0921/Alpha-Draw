//
//  PixrayConfig.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/31/22.
//

import UIKit

class PixrayConfig: Config{
    var prompts: String
    var drawer: String

    override init(width: Int, height: Int, prompt_strength: Float, num_inference_steps: Int, guidance_scale: Float) {
        self.prompts = ""
        self.drawer = ""
        super.init(width: width, height: height, prompt_strength: prompt_strength, num_inference_steps: num_inference_steps, guidance_scale: guidance_scale)
    }

    override func getDict() -> [String: Any] {
        return [
            "width": self.width,
            "height": self.height,
            "prompt_strength": self.prompt_strength,
            "num_inference_steps": self.num_inference_steps,
            "guidance_scale": self.guidance_scale,
            "prompts": self.prompts,
            "drawer": self.drawer
        ]
    }

    func toPixrayInput(prompts: String, drawer: String) -> PixrayInput {
        return PixrayInput(
            prompts: prompts,
            drawer: drawer
        )
    }

}