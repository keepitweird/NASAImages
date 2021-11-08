//
//  ImageCell.swift
//  NASA Images
//
//  Created by Tina Ho on 10/31/21.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var nasaImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nasaImageView.image = nil
    }
    
    func fetchPhoto(with photoURLString: String) {
        if let url = URL(string: photoURLString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, _, error in
                if let safeData = data, error == nil {
                    if let image = UIImage(data: safeData) {
                        DispatchQueue.main.async {
                            self.nasaImageView.image = image
                        }
                    }
                } else {
                    print(error!)
                }
            }
            task.resume()
        }
    }
    
    
}

