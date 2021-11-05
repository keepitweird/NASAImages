//
//  ViewController.swift
//  NASA Images
//
//  Created by Tina Ho on 10/29/21.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var networkManager = NetworkManager()
    var imageItems: [Item] = []
    var nasaImage = UIImage()
    //var imageData: ImageData?
    //let imageTitleString = ["Hello","Goodbye","Thanks"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        networkManager.delegate = self
        //networkManager.performRequest(with: "Earth")
        //networkManager.fetchPhotos(with: "https://images-assets.nasa.gov/image/PIA00342/PIA00342~thumb.jpg")
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 100
        
    }

    //Our table view has a background color of black, so let's make the status bar color white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


//MARK: - Search Bar
extension ImageViewController: UISearchBarDelegate {

//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if let searchTerm = searchBar.text {
//            networkManager.performRequest(with: searchTerm)
//        }
//    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        if let searchTerm = searchBar.text {
            self.networkManager.performRequest(with: searchTerm)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
//    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
//        if searchBar.text == nil {
//            searchBar.placeholder = "Enter a search term"
//            return false
//        } else {
//            return true
//        }
//    }
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        if let searchTerm = searchBar.text {
//            networkManager.performRequest(with: searchTerm)
//        }
//        tableView.reloadData()
//    }
}


//MARK: - Table View
extension ImageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //imageTitleString.count
        let imageItemsCount = imageItems.count
        if imageItemsCount == 0 { //|| imageItemsCount == nil {
            return 1
        } else {
            return imageItemsCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let imageItems = imageData?.collection.items
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ImageCell

        if imageItems.count == 0 { //|| imageItems == nil { // || imageItems?.isEmpty
            cell.title.text = "No result"
            cell.title.textAlignment = .center
            cell.date.text = ""
            tableView.separatorColor = .black
            //cell.layer.borderWidth = 0
            //cell.textLabel?.text = "No result"
        } else {
            //let imageURLString = imageItems[indexPath.row].links[0].href
            //cell.textLabel?.text = imageItems[indexPath.row].data[0].title //?? "No result" //imageTitleString[indexPath.row]
            cell.fetchPhoto(with: imageItems[indexPath.row].links[0].href)
            //cell.setNeedsLayout()
            //cell.nasaImageView.image = nasaImage
            cell.title.text = imageItems[indexPath.row].data[0].title
            cell.title.textAlignment = .left
            cell.date.text = String(imageItems[indexPath.row].data[0].date_created.prefix(10))
            
            tableView.separatorColor = .lightGray
            //cell.layer.borderColor = UIColor.systemGray.cgColor
            //cell.layer.borderWidth = 0.5
        }
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        //let currentImage = nasaImage
//        //let imageCrop = currentImage.getCropRatio()
//        //return tableView.frame.width * imageWidthRatio
//
//        let thisCell = tableView.cellForRow(at: indexPath) as! ImageCell
////        let tableViewWidth = tableView.frame.width
////        if let thisHeight = tableViewWidth * thisCell?.imageWidthRatio {
////            return thisHeight
////        }
//        let thisHeight = thisCell.bounds.height
//        return CGFloat(thisHeight)
//
//        //return 30
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) //as! ImageCell - we don't need to cast it down here bc ImageCell inherits from UITableViewCell
        cell?.selectedBackgroundView?.backgroundColor = .darkGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            cell?.selectedBackgroundView?.backgroundColor = .none
        }
        //tableView.separatorColor = .lightGray
    }
    
}

////MARK: - Calculate Cell Height (based on image height)
//extension UIImage {
//    func getCropRatio() -> CGFloat {
//        let widthRatio = CGFloat(self.size.width / self.size.height)
//        return widthRatio
//    }
//}

//MARK: - NetworkManagerDelegate
extension ImageViewController: NetworkManagerDelegate {

    func didUpdateNASA(_ networkManager: NetworkManager, imageData: ImageData) {
        DispatchQueue.main.async {
            self.imageItems = imageData.collection.items ?? []
            self.tableView.reloadData()
            print("Image Count: \(self.imageItems.count)")
            //print(self.imageData?.collection.items[0].data[0].title)
            //print(self.imageItems[0].links[0].href)
        }
    }
    
//    func didUpdateImage(_ networkManager: NetworkManager, image: UIImage) {
//        DispatchQueue.main.async {
//            self.nasaImage = image
//            //self.tableView.reloadData()
//        }
//    }
    
    func didFailWithError(_ networkManager: NetworkManager, error: Error) {
        print(error)
    }
    
}


