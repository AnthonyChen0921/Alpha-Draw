//
//  Text2Img-nightmare-ai.swift
//  Generate images using a variety of techniques - Powered by Discoart
//  url: https://replicate.com/nightmareai/disco-diffusion
//  github: https://github.com/jina-ai/discoart
//  Alpha Draw
//
//  Created by Anthony C on 10/21/22.
//

import Foundation

/**
 *  @brief: This function is used to generate a Nightmare AI image from a text prompt
 *  @param: completion: The completion handler
 *  @param: bodyRequest: The body request of the API, written in Swift Struct, see NightmareData.swift for more details
 *  @return: Void
 */
func fetchNightmareInitialRequest(completion: @escaping (NightmareData) -> Void, bodyRequest: NightmareBodyReuqest, token: String) {
    let url = URL(string: "https://api.replicate.com/v1/predictions")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body = convertBodyRequestToStringArray(bodyRequest: bodyRequest)
    request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
            return
        }
        do {
            let nightmare = try JSONDecoder().decode(NightmareData.self, from: data)
            completion(nightmare)
        } catch {
            print("Error decoding response: \(error)")
        }
    }.resume()
}

/**
 *  @brief: This function is used to request an update of the Nightmare AI image
 *  @param: completion: The completion handler
 *  @param: predictionId: The prediction id of the API, will be returned by the initial request (InitalRequest also contains a get request url)
 *  @return: Void
 */
func fetchNightmareByPredictionId(completion: @escaping (NightmareData) -> Void, predictionId: String, token: String) {
    let url = URL(string: "https://api.replicate.com/v1/predictions/\(predictionId)")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
            return
        }
        do {
            let nightmare = try JSONDecoder().decode(NightmareData.self, from: data)
            completion(nightmare)
        } catch {
            print("Error decoding response: \(error)")
        }
    }.resume()
}


/**
 *  @brief: This function is used to convert the body request of the Nightmare AI API into a string array
 *  @param: bodyRequest: The body request of the API, written in Swift Struct, see NightmareData.swift for more details
 *  @return: The body request of the API, written in string array
 */
func convertBodyRequestToStringArray(bodyRequest: NightmareBodyReuqest) -> [String: Any] {
    let body = [
        "version": bodyRequest.version!,
        "input": [
            "prompt": bodyRequest.input?.prompt! as Any,
            "step": bodyRequest.input?.step! as Any,
            "width": bodyRequest.input?.width! as Any,
            "height": bodyRequest.input?.height! as Any,
            "diffusion_model": bodyRequest.input?.diffusion_model! as Any,
            "diffusion_sampling_mode": bodyRequest.input?.diffusion_sampling_mode! as Any,
            "ViTB32": bodyRequest.input?.ViTB32! as Any,
            "ViTB16": bodyRequest.input?.ViTB16! as Any,
            "RN50": bodyRequest.input?.RN50! as Any,
            "use_secondary_model": bodyRequest.input?.use_secondary_model! as Any,
            "clip_guidance_scale": bodyRequest.input?.clip_guidance_scale! as Any,
            "range_scale": bodyRequest.input?.range_scale! as Any,
            "cutn_batches": bodyRequest.input?.cutn_batches! as Any,
            "init_scale": bodyRequest.input?.init_scale! as Any,
            "target_scale": bodyRequest.input?.target_scale! as Any,
            "skip_steps": bodyRequest.input?.skip_steps! as Any,
            "display_rate": bodyRequest.input?.display_rate! as Any,
            "guidance_scale": bodyRequest.input?.guidance_scale! as Any,
            "num_inference_steps": bodyRequest.input?.num_inference_steps! as Any,
        ]
    ] as [String : Any]
    return body
}


// MARK: - NightmareData

/**
    Example of bodyRequest Object:
    const nightmare = {
        body: JSON.stringify({
          version:
            "3c128f652e9f24e72896ac0b019e47facfd6bccf93104d50f09f1f2196325507",
          input: {
            prompt: req.body.prompt,
            step: req.body.step,
            width: "1280",
            height: "768",
            diffusion_model: "512x512_diffusion_uncond_finetune_008100",
            diffusion_sampling_mode: "ddpm",
            ViTB32: true,
            ViTB16: true,
            RN50: true,
            use_secondary_model: true,
            clip_guidance_scale: "5000",
            range_scale: "150",
            cutn_batches: "4",
            init_scale: "1000",
            target_scale: "20000",
            skip_steps: "10",
            display_rate: "20",
            guidance_scale: "7.5",
            num_inference_steps: "80",
          },
        }),
      };
*/


