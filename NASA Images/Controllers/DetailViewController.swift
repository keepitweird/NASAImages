//
//  DetailViewController.swift
//  NASA Images
//
//  Created by Tina Ho on 11/6/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    var center: String?
    var titleImage: String?
    var nasa_id: String?
    var date_created: String?
    var description_508: String?
    var href: String?
    
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nasaIdLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerLabel.text = "Center: " + (center ?? "Not specified")
        titleLabel.text = "Title: " + (titleImage ?? "Not specified")
        nasaIdLabel.text = "NASA ID: " + (nasa_id ?? "Not specified")
        dateCreatedLabel.text = "Date Created: " + (date_created?.prefix(10) ?? "Not specified")
        descriptionLabel.text = "Description: " + (description_508 ?? "Not specified")
        fetchPhoto(with: href!)
        //print("Photo URL: \(href!)")
    }
    
    //Set status bar color to white
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func fetchPhoto(with photoURLString: String) {
        if let url = URL(string: photoURLString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, _, error in
                if let safeData = data, error == nil {
                    if let image = UIImage(data: safeData) {
                        DispatchQueue.main.async {
                            self.imageView.image = image
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
