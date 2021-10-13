//
//  SearchViewController.swift
//  Evaluation Test App
//
//  Created by Владимир on 02.10.2021.
//
import Kingfisher 
import UIKit

class SearchViewController: UIViewController {
    //MARK: - Properties
    private let networkManager = NetworkManager()
    private var resultsData: ResultsData? = nil
    private let defaults = UserDefaults.standard  //use UserDefaults to save data to history tab
    private var editedSearchText = ""  //Use edit search text to escape nil when making request with space
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchArray: [String] = [] //array to save to UserDefaults for history tab
    private var alternativeArray = [""] //alternative to get rid of force unwrap, dont know just add this word^ not empty string, looks good)
    private var resultCount = 0
    private var arrayOfDataStruct = [Results]()
    private var arrayOfDataStructSaved = [Results]()
    @IBOutlet private weak var collectionView: UICollectionView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearch()
        setupCollectionView()
        isAppAlreadyLaunchedOnce()
    }
    
    //MARK: - Private methods
    private func setupSearch() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func sortAlbumsByName(array: [Results]) -> [Results]{ //sort Albums by name
        let sortedArrayScore = array.sorted { (s1: Results, s2: Results) -> Bool in
            return s1.collectionName! < s2.collectionName!
        }
        return sortedArrayScore
    }
    
    private func isAppAlreadyLaunchedOnce() {
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            searchArray = defaults.stringArray(forKey: "array") ?? alternativeArray
            // not first Launch
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            //first Launch
        }
    }
}
//MARK: - Extensions
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {        
        guard let text = searchBar.text else { return  }
        editedSearchText = text.replacingOccurrences(of: " ", with: "+")
        
        searchArray.append(text)  //append in string array
        if searchArray.count > 10 {   //limit for history. Can be set as you wish (15, 20, no limit)
            searchArray.removeFirst()
        }
        defaults.removeObject(forKey: "array") // remove old array
        defaults.set(searchArray, forKey: "array") // add new array
        
        let urlString = "https://itunes.apple.com/search?term=\(editedSearchText)&media=music&entity=album" //make request  and sort albums
        
        networkManager.getAlbums(urlString: urlString) { (resultsData) in  //get Data, parse it, then pass it to custom array and sort
            guard let resultsData = resultsData else { return }                                                         //alphabetically
            self.resultsData = resultsData
            self.resultCount = resultsData.results?.count ?? 0
            for results in 0..<self.resultCount  {
                self.arrayOfDataStruct.append(resultsData.results![results])
            }
            self.arrayOfDataStruct = self.sortAlbumsByName(array: self.arrayOfDataStruct)
            self.arrayOfDataStructSaved = self.arrayOfDataStruct
            self.arrayOfDataStruct = []
            
            self.collectionView.reloadData()
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfDataStructSaved.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)  as! SearchCollectionViewCell
        let album = arrayOfDataStructSaved[indexPath.item]
        let url = URL(string: album.artworkUrl100 ?? "")
        cell.searchImageView.kf.setImage(with: url)  //Kingfisher for caching and setting image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumInfoViewController = AlbumInfoViewController.instantiateAlbumsVC()
        let album = arrayOfDataStructSaved[indexPath.item]
        albumInfoViewController.results = album
        albumInfoViewController.collectionId = album.collectionId
        self.navigationController?.pushViewController(albumInfoViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 1, height: view.frame.width / 2 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

//MARK: - Note from Author
//Описание при переходе экрана можно понять двумя способами: Первый, как я сделал, и второй, при нажатии на альбом в SearchVC будет переход на результат в двух местах: Здесь, и в History
// Но логичнее сделать так, как я и сделал, что ваш HR и подтвердил
//Надеюсь что все в порядке, спасибо.
