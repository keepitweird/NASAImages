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
    
    private var networkManager = NetworkManager()
    private var nasaImageItems: [NasaImageItem] = []
    private lazy var session: URLSession = {
        URLCache.shared.memoryCapacity = 512 * 1024 * 1024 //Set in-memory cache to 512 MB
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }()
    private var randomSearchTerms = ["Milky Way","Black Hole","Earth","Sun","Mars","Rocket","Ship","Andromeda","Space","Alien","Ablation","Accretion","Achondrite","Albedo","Altitude","Antimatter","Apastron","Aperture","Aphelion","Apogee","Asteroid","Astrochemistry","Atmosphere","Aurora","Axis","Azimuth","Blueshift","Bolide","Caldera","Catena","Cavus","Chaos","Chasma","Chondrite","Chondrule","Chromosphere","Coma","Comet","Conjunction","Constellation","Corona","Cosmogony","Cosmology","Crater","Declination","Density","Disk","Eccentricity","Eclipse","Ecliptic","Ejecta","Ellipse","Elongation","Ephemeris","Equinox","Extinction","Extragalactic","Extraterrestrial","Eyepiece","Faculae","Filament","Finder","Fireball","Galaxy","Granulation","Gravity","Heliopause","Heliosphere","Hydrogen","Hypergalaxy","Ice","Inclination","Ionosphere","Jansky","Jet","Kelvin","Kiloparsec","Libration","Limb","Lunation","Mare","Mass","Matter","Meridian","Metal","Meteor","Meteorite","Meteoroid","Millibar","Nadir","Nebula","Neutrino","Nova","Obliquity","Oblateness","Occultation","Opposition","Orbit","Parallax","Parsec","Patera","Penumbra","Perigee","Perihelion","Perturb","Phase","Photon","Planemo","Planet","Planitia","Planum","Plasma","Precession","Prominence","Protostar","Pulsar","Quadrature","Quasar","Radiant","Radiation","Redshift","Resonance","Rotation","Satellite","Scarp","Sidereal","Singularity","Solstice","Spectrometer","Spectroscopy","Spectrum","Spicules","Star","Sunspot","Supergiant","Supermoon","Supernova","Tektite","Telescope","Terminator","Terrestrial","Transit","Trojan","Ultraviolet","Umbra","Wavelength","X-ray","Zenith","Zodiac"]
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        
        //Fix the black bar tint color bug in Navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: K.darkGrayColor)
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
        
        //Pull to refresh
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(fetchRandomSearchTerm), for: .valueChanged)
        
        fetchRandomSearchTerm()
    }
    
    //Fetch data from a random astronomy search term
    @objc func fetchRandomSearchTerm() {
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
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }

}


//MARK: - Table View
extension ImageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let imageItemsCount = nasaImageItems.count
        if imageItemsCount == 0 {
            return 1
        } else {
            return imageItemsCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! NasaImageCell

        if nasaImageItems.count == 0 {
            cell.title.text = "No result"
            cell.title.textAlignment = .center
            cell.date.text = ""
            tableView.separatorColor = .black
        } else {
            cell.fetchPhoto(with: nasaImageItems[indexPath.row].links[0].href, session: session)
            cell.title.text = nasaImageItems[indexPath.row].data[0].title
            cell.title.textAlignment = .left
            cell.date.text = String(nasaImageItems[indexPath.row].data[0].date_created.prefix(10))
            tableView.separatorColor = .lightGray
        }
        
        //Change selected cell color to dark gray
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: K.darkGrayColor)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if nasaImageItems.count != 0 {
            performSegue(withIdentifier: K.segueIdentifier, sender: self)
        } else {
            tableView.deselectRow(at: indexPath, animated: true) //"No result" cell will get deselected (change cell color back)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueIdentifier {
            let destinationVC = segue.destination as! DetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let imageItem = self.nasaImageItems[indexPath.row]
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

    func didUpdateNASA(_ networkManager: NetworkManager, imageData: NasaImageData) {
        DispatchQueue.main.async {
            self.nasaImageItems = imageData.collection.items ?? []
            self.tableView.refreshControl?.endRefreshing() //We're done updating; it can stop spinning
            self.tableView.reloadData()
            print("Image Count: \(self.nasaImageItems.count)")
        }
    }
    
    func didFailWithError(_ networkManager: NetworkManager, error: Error) {
        print(error)
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Network Error", message: "Please try again later.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default) { (action) in
                self.nasaImageItems = []
                self.tableView.reloadData()
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}



