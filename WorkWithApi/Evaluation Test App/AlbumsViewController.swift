//
//  AlbumsViewController.swift
//  Evaluation Test App
//
//  Created by Владимир on 03.10.2021.
//

import Kingfisher
import UIKit

class AlbumsViewController: UIViewController {
    //MARK: - Properties
    private let networkManager = NetworkManager()
    private var resultsData: ResultsData? = nil
    private var resultCount = 0
    private var arrayOfDataStruct = [Results]()
    private var arrayOfDataStructSaved = [Results]()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    var searchByHistoryString: String = ""  //search by string from table view history (this property get data from historyVC)
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        makeRequest(request: searchByHistoryString)
    }
    
    //MARK: - Private methods
    private func setupCollectionView() {  //setup Collection view
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func sortAlbumsByName(array: [Results]) -> [Results]{ //sort Albums by name
        let sortedArrayScore = array.sorted { (s1: Results, s2: Results) -> Bool in
            return s1.collectionName! < s2.collectionName!
        }
        return sortedArrayScore
    }
    
    private func makeRequest(request: String) {   //request to get data
        let text = request
        let editedSearchText = text.replacingOccurrences(of: " ", with: "+")
        
        let urlString = "https://itunes.apple.com/search?term=\(editedSearchText)&media=music&entity=album"
        
        networkManager.getAlbums(urlString: urlString) { [unowned self] (resultsData) in
            guard let resultsData = resultsData else { return }
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

    //MARK: - Extensions
extension AlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfDataStructSaved.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellAlbum", for: indexPath) as! HistoryCollectionViewCell
        let album = arrayOfDataStructSaved[indexPath.item]
        let url = URL(string: album.artworkUrl100 ?? "")
        cell.historyImageView.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumInfoViewController = AlbumInfoViewController.instantiateAlbumsVC()
        let album = arrayOfDataStructSaved[indexPath.item]
        albumInfoViewController.results = album       //send data to AlbumInfoVC
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
