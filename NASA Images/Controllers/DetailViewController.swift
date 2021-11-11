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
        titleLabel.attributedText = NSMutableAttributedString().bold("Title: ").normal(titleImage ?? "Not specified")
        centerLabel.attributedText = NSMutableAttributedString().bold("Center: ").normal(center ?? "Not specified")
        nasaIdLabel.attributedText = NSMutableAttributedString().bold("NASA ID: ").normal(nasa_id ?? "Not specified")
        dateCreatedLabel.attributedText = NSMutableAttributedString().bold("Date Created: ").normal(String(date_created?.prefix(10) ?? "Not specified"))
        descriptionLabel.attributedText = NSMutableAttributedString().bold("Description: ").normal(description_508 ?? "Not specified")
        fetchPhoto(with: href!)
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
                } else {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(systemName: K.networkErrorIcon)
                    }
                    print(error!)
                }
            }
            task.resume()
        }
    }
    
    
}

//MARK: - Making Text Bold
extension NSMutableAttributedString {
    
    var fontSize: CGFloat { return 17 }
    var boldFont: UIFont { return UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont: UIFont { return UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [ .font: boldFont]
        self.append( NSAttributedString(string: value, attributes: attributes) )
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [ .font: normalFont, ]
        self.append( NSAttributedString(string: value, attributes: attributes) )
        return self
    }
    
}
