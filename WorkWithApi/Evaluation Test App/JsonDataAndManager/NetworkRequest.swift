//
//  NetworkRequest.swift
//  Evaluation Test App
//
//  Created by Владимир on 04.10.2021.
//

import Foundation


class NetworkRequest {
    
    func request(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {  //Make request
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }.resume()
    }
}
