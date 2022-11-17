//
//  StableDiffusionConfig.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/31/22.
//

import UIKit

class StableDiffusionConfig: Config{
    var num_outputs: Int
    var prompt: String

    override init(width: Int, height: Int, prompt_strength: Float, num_inference_steps: Int, guidance_scale: Float) {
        self.num_outputs = 1
        self.prompt = ""
        super.init(width: width, height: height, prompt_strength: prompt_strength, num_inference_steps: num_inference_steps, guidance_scale: guidance_scale)
    }

    override func getDict() -> [String: Any] {
        return [
            "width": self.width,
            "height": self.height,
            "prompt_strength": self.prompt_strength,
            "num_inference_steps": self.num_inference_steps,
            "guidance_scale": self.guidance_scale,
            "num_outputs": self.num_outputs,
            "prompt": self.prompt
        ]
    }

    func toStableDiffusionInput(prompt: String) -> StableDiffusionInput {
        return StableDiffusionInput(
            prompt: prompt,
            width: String(self.width),
            height: String(self.height),
            guidance_scale: String(self.guidance_scale),
            num_inference_steps: String(self.num_inference_steps),
            prompt_strength: String(self.prompt_strength),
            num_outputs: String(self.num_outputs)
        )
    }

}
