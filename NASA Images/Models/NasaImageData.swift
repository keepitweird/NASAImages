//
//  ImageData.swift
//  NASA Images
//
//  Created by Tina Ho on 10/29/21.
//

import Foundation

//API call example: https://images-api.nasa.gov/search?media_type=image&q=earth

//First Level
struct NasaImageData: Decodable {
    let collection: ImageCollection
}

//Second Level
struct ImageCollection: Decodable {
    let items: [NasaImageItem]? //The items array could be empty (ex. Search for the term: "eart")
}

//Third Level
struct NasaImageItem: Decodable {
    let data: [BasicInfoData]
    let links: [ImageLink]
}

//Forth Level
struct BasicInfoData: Decodable {
    let center: String?
    let title: String
    let nasa_id: String
    let date_created: String
    let description_508: String?
}

struct ImageLink: Decodable {
    let href: String
}



