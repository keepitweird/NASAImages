//
//  ImageData.swift
//  NASA Images
//
//  Created by Tina Ho on 10/29/21.
//

import Foundation

//API call: https://images-api.nasa.gov/search?media_type=image&q=earth

//First Level
struct ImageData: Decodable {
    let collection: ImageCollection
}

//Second Level
struct ImageCollection: Decodable {
    let items: [Item]? //The items array could be empty (ex. Search for the term: "eart")
}

//Third Level
struct Item: Decodable {
    let data: [BasicInfoData]
    let links: [ImageLink]
}

//Forth Level
struct BasicInfoData: Decodable {
    let center: String //Detail
    let title: String //Detail
    let nasa_id: String //Detail
    let date_created: String //Detail
    let keywords: [String] //Detail
    let description_508: String? //Detail
}

struct ImageLink: Decodable {
    let href: String //Detail
}



