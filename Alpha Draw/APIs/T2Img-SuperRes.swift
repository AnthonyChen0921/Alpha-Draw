//
//  T2Img-SuperRes.swift
//  Alpha Draw
//
//  Created by Yuanhao Chai Misaki.999 on 12/2/22.
//

import Foundation

func fetchSuperResImage(completion: @escaping (SuperResolutionData) -> Void, bodyRequest: SuperResolutionReuqest, token: String) {
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
            let superRes = try JSONDecoder().decode(SuperResolutionData.self, from: data)
            completion(superRes)
        } catch {
            print("Error decoding response: \(error)")
        }
    }.resume()
}

func fetchsuperResByPredictionId(completion: @escaping (SuperResolutionData) -> Void, predictionId: String, token: String) {
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
            let superRes = try JSONDecoder().decode(SuperResolutionData.self, from: data)
            completion(superRes)
        } catch {
            print("Error decoding response: \(error)")
        }
    }.resume()
}

func cancelsuperResRequest(cancelUrl: String, token: String) {
    let url = URL(string: cancelUrl)!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
            return
        }
        do {
            let superRes = try JSONDecoder().decode(SuperResolutionData.self, from: data)
            print(superRes)
        } catch {
            print("Error decoding response: \(error)")
        }
    }.resume()
}

func convertBodyRequestToStringArray(bodyRequest: SuperResolutionReuqest) -> [String: Any] {
    let body = [
        "version": bodyRequest.version!,
        "input": [
            "image": bodyRequest.input?.img_url!,
            "task_type": bodyRequest.input?.task_type!,
            "noise": bodyRequest.input?.noise!,
            "jpeg" : bodyRequest.input?.jpeg!,
            "version" : bodyRequest.input?.version!,
            "sacle" : bodyRequest.input?.scale!,
        ]
    ] as [String : Any]
    return body
}
