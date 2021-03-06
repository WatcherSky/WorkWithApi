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
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private var resultsData: ResultsData? = nil
    private let defaults = UserDefaults.standard  //use UserDefaults to save data to history tab
    private var editedSearchText = ""  //Use edit search text to escape nil when making request with space
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchArray: [String] = [] //array to save to UserDefaults for history tab
    private var history = UserDefaults.standard.stringArray(forKey: "array")
    private var resultCount = 0
    private var arrayOfDataStruct = [Results]()
    private var arrayOfDataStructSaved = [Results]()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        setupSearch()
        setupCollectionView()
    }
    
    //MARK: - Private methods
    private func setupSearch() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
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
}
//MARK: - Extensions
extension SearchViewController {
    func saveHistory(historyWork: String) {
        history = defaults.stringArray(forKey: "array")
        if let history = history {
            searchArray = history
        }
        searchArray.append(historyWork)
        if searchArray.count > 10 {
            searchArray.removeFirst()
        }
        defaults.set(searchArray, forKey: "array")
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {        
        guard let text = searchBar.text else {
            return
        }
        editedSearchText = text.replacingOccurrences(of: " ", with: "+")
        saveHistory(historyWork: text)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        let urlString = "https://itunes.apple.com/search?term=\(editedSearchText)&media=music&entity=album" //make request  and sort albums
        
        NetworkManager.shared.getAlbums(urlString: urlString) { [unowned self] (resultsData) in  //get Data, parse it, then pass it to custom array and sort
            guard let resultsData = resultsData else {
                return
            }
            self.resultsData = resultsData
            self.resultCount = resultsData.results?.count ?? 0
            for results in 0..<self.resultCount  {
                self.arrayOfDataStruct.append(resultsData.results![results])
            }
            self.arrayOfDataStruct = self.sortAlbumsByName(array: self.arrayOfDataStruct)
            self.arrayOfDataStructSaved = self.arrayOfDataStruct
            self.arrayOfDataStruct = []
            self.collectionView.reloadData()
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }
}
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfDataStructSaved.count
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
        CGSize(width: view.frame.width / 2 - 1, height: view.frame.width / 2 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
