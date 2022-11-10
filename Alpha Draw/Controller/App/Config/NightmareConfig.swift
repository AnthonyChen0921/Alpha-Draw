//
//  NightmareConfig.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/31/22.
//

import UIKit


class NightmareConfig: Config{
    var prompt: String
    var step: String
    var diffusion_model: String
    var diffusion_sampling_mode: String
    var ViTB32: Bool
    var ViTB16: Bool
    var RN50: Bool
    var use_secondary_model: Bool
    var clip_guidance_scale: String
    var range_scale: String
    var cutn_batches: String
    var init_scale: String
    var target_scale: String
    var skip_steps: String
    var display_rate: String
    
    init(width: Int, height: Int, prompt_strength: Float, num_inference_steps: Int, guidance_scale: Float, prompt: String, step: String, diffusion_model: String, diffusion_sampling_mode: String, ViTB32: Bool, ViTB16: Bool, RN50: Bool, use_secondary_model: Bool, clip_guidance_scale: String, range_scale: String, cutn_batches: String, init_scale: String, target_scale: String, skip_steps: String, display_rate: String) {
        self.prompt = prompt
        self.step = step
        self.diffusion_model = diffusion_model
        self.diffusion_sampling_mode = diffusion_sampling_mode
        self.ViTB32 = ViTB32
        self.ViTB16 = ViTB16
        self.RN50 = RN50
        self.use_secondary_model = use_secondary_model
        self.clip_guidance_scale = clip_guidance_scale
        self.range_scale = range_scale
        self.cutn_batches = cutn_batches
        self.init_scale = init_scale
        self.target_scale = target_scale
        self.skip_steps = skip_steps
        self.display_rate = display_rate
        super.init(width: width, height: height, prompt_strength: prompt_strength, num_inference_steps: num_inference_steps, guidance_scale: guidance_scale)
    }

    override func getDict() -> [String: Any] {
        return [
            "prompt": self.prompt,
            "step": self.step,
            "width": self.width,
            "height": self.height,
            "diffusion_model": self.diffusion_model,
            "diffusion_sampling_mode": self.diffusion_sampling_mode,
            "ViTB32": self.ViTB32,
            "ViTB16": self.ViTB16,
            "RN50": self.RN50,
            "use_secondary_model": self.use_secondary_model,
            "clip_guidance_scale": self.clip_guidance_scale,
            "range_scale": self.range_scale,
            "cutn_batches": self.cutn_batches,
            "init_scale": self.init_scale,
            "target_scale": self.target_scale,
            "skip_steps": self.skip_steps,
            "display_rate": self.display_rate,
            "guidance_scale": self.guidance_scale,
            "num_inference_steps": self.num_inference_steps
        ]
    }
}
