//
//  HighResConfig.swift
//  Alpha Draw
//
//  Created by YuanhaoChai (Misaki.999) on 12/2/22.
//

import Foundation

class HighResConfig : Config{
    var task_type : String
    var img_url: String
    var noise: String
    var jpeg: String

    override init(width: Int, height: Int, prompt_strength: Float, num_inference_steps: Int, guidance_scale: Float) {
        self.task_type = "Real-World Image Super-Resolution-Large"
        self.img_url = ""
        self.noise = "15"
        self.jpeg = "40"
        super.init(width: width, height: height, prompt_strength: prompt_strength, num_inference_steps: num_inference_steps, guidance_scale: guidance_scale)
    }

    override func getDict() -> [String: Any] {
        return [
            "width": self.width,
            "height": self.height,
            "task_type": self.task_type
        ]
    }

    func superRes(image_url: String) -> superResInput {
        return superResInput(
            task_type: task_type,
            img_url: image_url,
            noise: noise,
            jpeg: jpeg
        )
    }

}
