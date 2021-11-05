//
//  NetworkManager.swift
//  NASA Images
//
//  Created by Tina Ho on 10/29/21.
//

import UIKit

protocol NetworkManagerDelegate {
    func didUpdateNASA(_ networkManager: NetworkManager, imageData: ImageData)
    //func didUpdateImage(_ networkManager: NetworkManager, image: UIImage)
    func didFailWithError(_ networkManager: NetworkManager, error: Error)
}


struct NetworkManager {
    
    var delegate: NetworkManagerDelegate?
    let baseURL = "https://images-api.nasa.gov/search?media_type=image"
    
    func performRequest(with searchTerm: String) {
        let urlString = baseURL + "&q=\(searchTerm)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, _, error in
                if error == nil {
                    if let safeData = data {
                        //let dataString = String(data: safeData, encoding: .utf8)
                        //print(dataString!)
                        if let result = self.parseJSON(with: safeData) {
                            delegate?.didUpdateNASA(self, imageData: result)
                        }
                    }
                } else {
                    print(error!)
                    delegate?.didFailWithError(self, error: error!)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(with imageData: Data) -> ImageData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ImageData.self, from: imageData)
            //print(decodedData.collection.items[2].data[0].title)
            return decodedData
        } catch {
            print(error)
            delegate?.didFailWithError(self, error: error)
            return nil
        }
    }


    
}
