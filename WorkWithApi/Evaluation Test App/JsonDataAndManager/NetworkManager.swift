//
//  NetworkManager.swift
//  Evaluation Test App
//
//  Created by Владимир on 03.10.2021.
//

import Foundation
import UIKit

class NetworkManager {
    
    let networkRequest = NetworkRequest()
    
    func getAlbums(urlString: String, response: @escaping (ResultsData?) -> Void) {    //get Data and decode them
        networkRequest.request(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    let albums = try JSONDecoder().decode(ResultsData?.self, from: data)
                    response(albums)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    response(nil)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
    }
    }
    
    func getSongs(urlString: String, response: @escaping (ResultsData?) -> Void) {
        networkRequest.request(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    let songs = try JSONDecoder().decode(ResultsData.self, from: data)
                    response(songs)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    response(nil)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
    // Same for Songs. We can use 1 method, i used 2 to separate their (functions) name

}
