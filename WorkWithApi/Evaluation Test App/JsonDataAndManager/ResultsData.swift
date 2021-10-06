//
//  ResultsData.swift
//  Evaluation Test App
//
//  Created by Владимир on 02.10.2021.
//

import Foundation

struct Results: Codable {   //struct to parse Data
    enum CodingKeys: String, CodingKey {
        case artistName = "artistName"
        case collectionId = "collectionId"
        case collectionName = "collectionName"
        case artworkUrl100 = "artworkUrl60"
        case releaseDate = "releaseDate"
        case trackName = "trackName"
    }
    let artistName: String
    let collectionId: Int
    let collectionName: String?
    let artworkUrl100: String?
    let releaseDate: String
    let trackName: String?
}

struct ResultsData: Codable {
    let results: [Results]?
}
