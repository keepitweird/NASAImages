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
    
    var imageWidthRatio: CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //nasaImageView.frame.size.height = nasaImageView.frame.size.width / nasaImageView.getCropRatio()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() { //Does it matter?
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
                            self.imageWidthRatio = image.size.height / image.size.width
                        }
                    }
                    //print("Got image!")
                } else {
                    print(error!)
                }
            }
            task.resume()
        }
    }
    
    
}

