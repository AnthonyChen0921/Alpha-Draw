//
//  T2Img-Pixray.swift
//  Uses pixray to generate an image from text prompt
//  url: https://replicate.com/pixray/text2image
//  Alpha Draw
//
//  Created by Anthony C on 10/21/22.
//

import Foundation

/**
 *  @brief: This function is used to generate a Pixray AI image from a text prompt
 *  @param: completion: The completion handler
 *  @param: bodyRequest: The body request of the API, written in Swift Struct, see PixrayData.swift for more details
 *  @return: Void
 */
func fetchPixrayInitialRequest(completion: @escaping (PixrayData) -> Void, bodyRequest: PixrayBodyReuqest, token: String) {
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
            let pixray = try JSONDecoder().decode(PixrayData.self, from: data)
            completion(pixray)
        } catch {
            print("Error decoding response: \(error)")
        }
    }.resume()
}

/**
 *  @brief: This function is used to request an update of the Pixray AI image
 *  @param: completion: The completion handler
 *  @param: predictionId: The prediction id of the API, will be returned by the initial request (InitalRequest also contains a get request url)
 *  @return: Void
 */
func fetchPixrayByPredictionId(completion: @escaping (PixrayData) -> Void, predictionId: String, token: String) {
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
            let pixray = try JSONDecoder().decode(PixrayData.self, from: data)
            completion(pixray)
        } catch {
            print("Error decoding response: \(error)")
        }
    }.resume()
}

/**
 *  @brief: This function is used to convert the body request of the Pixray API into a string array
 *  @param: bodyRequest: The body request of the API, written in Swift Struct, see PixrayData.swift for more details
 *  @return: [String: Any]
 */
func convertBodyRequestToStringArray(bodyRequest: PixrayBodyReuqest) -> [String: Any] {
    let body = [
        "version": bodyRequest.version!,
        "input": [
            "prompts": bodyRequest.input?.prompts!,
            "drawer": bodyRequest.input?.drawer!
        ]
    ] as [String : Any]
    return body
}


// MARK: - PixrayData

// Data INPUT see more: https://dazhizhong.gitbook.io/pixray-docs/docs/primary-settings
