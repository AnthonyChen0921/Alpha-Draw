//
//  T2Img-Stable-diffusion.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/31/22.
//

import Foundation

/**
    *  @brief: This function is used to generate a Pokemon from a text description
    *  @param: completion: The completion handler
    *  @param: bodyRequest: The body request of the API, written in Swift Struct, see PokemonData.swift for more details
    *  @return: Void
    */
func fetchStableDiffusionInitialRequest(completion: @escaping (StableDiffusionData) -> Void, bodyRequest: StableDiffusionBodyReuqest, token: String) {
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
            let stableDiffusion = try JSONDecoder().decode(StableDiffusionData.self, from: data)
            completion(stableDiffusion)
        } catch {
            print("Error decoding response: \(error)")
        }
    }.resume()
}

/**
    *  @brief: This function is used to request an update of the Pokemon image
    *  @param: completion: The completion handler
    *  @param: predictionId: The prediction id of the API, will be returned by the initial request (InitalRequest also contains a get request url)
    *  @return: Void
    */
func fetchStableDiffusionByPredictionId(completion: @escaping (StableDiffusionData) -> Void, predictionId: String, token: String) {
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
            let stableDiffusion = try JSONDecoder().decode(StableDiffusionData.self, from: data)
            completion(stableDiffusion)
        } catch {
            print("Error decoding response: \(error)")
        }
    }.resume()
}

/**
    *  @brief: This function is used to convert the body request from Swift Struct to a String Array
    *  @param: bodyRequest: The body request of the API, written in Swift Struct, see PokemonData.swift for more details
    *  @return: [String: Any]
    */
func convertBodyRequestToStringArray(bodyRequest: StableDiffusionBodyReuqest) -> [String: Any] {
    let body = [
        "version": bodyRequest.version!,
        "input": [
            "prompt": bodyRequest.input?.prompt!,
            "width": bodyRequest.input?.width!,
            "height": bodyRequest.input?.height!,
            "num_inference_steps": bodyRequest.input?.num_inference_steps!,
            "guidance_scale": bodyRequest.input?.guidance_scale!,
            "prompt_strength": bodyRequest.input?.prompt_strength!,
            "num_outputs": bodyRequest.input?.num_outputs!
        ]
    ] as [String : Any]
    return body
}

// MARK: - StableDiffusionData
