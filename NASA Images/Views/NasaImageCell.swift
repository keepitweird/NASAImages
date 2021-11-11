//
//  ImageCell.swift
//  NASA Images
//
//  Created by Tina Ho on 10/31/21.
//

import UIKit

class NasaImageCell: UITableViewCell {

    @IBOutlet weak var nasaImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var reloadImageButton: UIButton!
    
    private var dataTask: URLSessionDataTask?
    private var photoURLString: String?
    private var session: URLSession?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reloadImageButton.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dataTask?.cancel() //Cancel data task
        dataTask = nil //Discard data task
        nasaImageView.image = nil //Reset NASA image view
    }
    
    func fetchPhoto(with photoURLString: String, session: URLSession) {
        //To call this func when reloadImageButton is pressed
        self.photoURLString = photoURLString
        self.session = session
        
        if let url = URL(string: photoURLString) {
            activityIndicatorView.startAnimating() // Start Activity Indicator View
            let dataTask = session.dataTask(with: url) { data, _, error in
                if let safeData = data, error == nil {
                    if let image = UIImage(data: safeData) {
                        DispatchQueue.main.async {
                            self.nasaImageView.image = image
                            self.reloadImageButton.isHidden = true
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.nasaImageView.image = UIImage(systemName: K.networkErrorIcon)
                        self.reloadImageButton.isHidden = false
                    }
                    print(error!)
                }
            }
            dataTask.resume()
            self.dataTask = dataTask
        }
    }
    
    @IBAction func reloadImageButton(_ sender: UIButton) {
        if photoURLString != nil, session != nil {
            fetchPhoto(with: photoURLString!, session: session!)
        }
        sender.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1.0
        }
    }
    
    
}

