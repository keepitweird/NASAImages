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
    var imageItems: [ImageItem] = []
    var randomSearchTerms = ["Earth","Sun","Mars","Rocket","Ship","Andromeda","Space","Alien","Ablation","Accretion","Achondrite","Albedo","Altitude","Antimatter","Apastron","Aperture","Aphelion","Apogee","Asteroid","Astrochemistry","Atmosphere","Aurora","Axis","Azimuth","Blueshift","Bolide","Caldera","Catena","Cavus","Chaos","Chasma","Chondrite","Chondrule","Chromosphere","Coma","Comet","Conjunction","Constellation","Corona","Cosmogony","Cosmology","Crater","Declination","Density","Disk","Eccentricity","Eclipse","Ecliptic","Ejecta","Ellipse","Elongation","Ephemeris","Equinox","Extinction","Extragalactic","Extraterrestrial","Eyepiece","Faculae","Filament","Finder","Fireball","Galaxy","Granulation","Gravity","Heliopause","Heliosphere","Hydrogen","Hypergalaxy","Ice","Inclination","Ionosphere","Jansky","Jet","Kelvin","Kiloparsec","Libration","Limb","Lunation","Mare","Mass","Matter","Meridian","Metal","Meteor","Meteorite","Meteoroid","Millibar","Nadir","Nebula","Neutrino","Nova","Obliquity","Oblateness","Occultation","Opposition","Orbit","Parallax","Parsec","Patera","Penumbra","Perigee","Perihelion","Perturb","Phase","Photon","Planemo","Planet","Planitia","Planum","Plasma","Precession","Prominence","Protostar","Pulsar","Quadrature","Quasar","Radiant","Radiation","Redshift","Resonance","Rotation","Satellite","Scarp","Sidereal","Singularity","Solstice","Spectrometer","Spectroscopy","Spectrum","Spicules","Star","Sunspot","Supergiant","Supermoon","Supernova","Tektite","Telescope","Terminator","Terrestrial","Transit","Trojan","Ultraviolet","Umbra","Wavelength","X-ray","Zenith","Zodiac"]
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        
        //Fix the black bar tint color bug in Navigation bar (available iOS 13 or later)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.16, alpha: 1.00)  //
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.buttonAppearance = buttonAppearance

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance

        UIBarButtonItem.appearance().tintColor = UIColor.white
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        searchBar.delegate = self
        networkManager.delegate = self
        
        //Search for a random search term when the view is loaded
        didPullToRefresh()
        
        //Pull to refresh
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc func didPullToRefresh() {
        //Fetch data from random astronomy search term
        let randomSearchTerm = randomSearchTerms.randomElement()
        self.networkManager.performRequest(with: randomSearchTerm!)
        searchBar.text = randomSearchTerm
        //See the method tableView.refreshControl?.endRefreshing() at where we reload our table data
    }
    
    //Set status bar (time, wifi signal, etc) color to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


//MARK: - Search Bar
extension ImageViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchTerm = searchBar.text {
            self.networkManager.performRequest(with: searchTerm)
        }
    }

}


//MARK: - Table View
extension ImageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let imageItemsCount = imageItems.count
        if imageItemsCount == 0 {
            return 1
        } else {
            return imageItemsCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ImageCell

        if imageItems.count == 0 {
            cell.title.text = "No result"
            cell.title.textAlignment = .center
            cell.date.text = ""
            tableView.separatorColor = .black
        } else {
            cell.fetchPhoto(with: imageItems[indexPath.row].links[0].href)
            cell.title.text = imageItems[indexPath.row].data[0].title
            cell.title.textAlignment = .left
            cell.date.text = String(imageItems[indexPath.row].data[0].date_created.prefix(10))
            tableView.separatorColor = .lightGray
        }
        
        //Change selected cell color to dark gray
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.16, alpha: 1.00)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueIdentifier {
            let destinationVC = segue.destination as! DetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let imageItem = self.imageItems[indexPath.row]
                destinationVC.center = imageItem.data[0].center
                destinationVC.titleImage = imageItem.data[0].title
                destinationVC.nasa_id = imageItem.data[0].nasa_id
                destinationVC.date_created = imageItem.data[0].date_created
                destinationVC.description_508 = imageItem.data[0].description_508
                destinationVC.href = imageItem.links[0].href
            }
        }
    }
    
}


//MARK: - NetworkManagerDelegate
extension ImageViewController: NetworkManagerDelegate {

    func didUpdateNASA(_ networkManager: NetworkManager, imageData: ImageData) {
        DispatchQueue.main.async {
            self.imageItems = imageData.collection.items ?? []
            self.tableView.refreshControl?.endRefreshing() //We're done updating; it can stop spinning
            self.tableView.reloadData()
            print("Image Count: \(self.imageItems.count)")
            //print(self.imageData?.collection.items[0].data[0].title)
            //print(self.imageItems[0].links[0].href)
        }
    }
    
    func didFailWithError(_ networkManager: NetworkManager, error: Error) {
        print(error)
    }
    
}



