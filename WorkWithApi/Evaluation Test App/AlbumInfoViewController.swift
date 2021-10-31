//
//  AlbumInfoViewController.swift
//  Evaluation Test App
//
//  Created by Владимир on 04.10.2021.
//

import UIKit

class AlbumInfoViewController: UIViewController {
    //MARK: - Properties
    private let networkManager = NetworkManager()
    private var resultsData: ResultsData? = nil
    private let headerForTable = "AlbumSongs"
    private let dateFormatter = ISO8601DateFormatter()
    var results: Results?
    var collectionId: Int = 0 //get collection id from previous screen to make request (didnt get from results to make it more simple) We can see id
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var albumNameLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupLabels()
        getSongs(collectionId: collectionId)
        setupReleaseDate()
    }
    
    //MARK: - Private methods
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupLabels() { //setup labels name
        title = "AlbumInformation"
        guard let albumNameText = results?.collectionName else {
            return
        }
        guard let artistNameText = results?.artistName else {
            return
        }
        
        albumNameLabel.text = "AlbumName: \(albumNameText)"
        artistNameLabel.text = "ArtistName: \(artistNameText)"
    }
    
    
    private func setupReleaseDate() { //formatted release date using dateFormatter
        guard let releaseDateText = results?.releaseDate else {
            return
        }
        guard let getDateFromJson = dateFormatter.date(from: releaseDateText) else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let changedDateFromJson = dateFormatter.string(from: getDateFromJson)
        releaseDateLabel.text = "ReleaseDate: \(changedDateFromJson)"
    }
    
    private func setupLabelPosition() {  //setup positions
        albumNameLabel.frame = CGRect(x: 20, y: view.frame.height / 5 - 40, width: view.frame.width - 20, height: 80)
        artistNameLabel.frame = CGRect(x: 20, y: view.frame.height / 5 + 50, width: view.frame.width - 20, height: 40)
        releaseDateLabel.frame = CGRect(x: 20, y: view.frame.height / 5 + 100, width: view.frame.width - 20, height: 40)
        tableView.frame = CGRect(x: 20, y: view.frame.height / 5 + 150, width: view.frame.width, height: view.frame.height - view.frame.height / 5 + 150)
    }
    
    private func getSongs(collectionId: Int) { //make request by collection id from previous screen
        let urlId = "https://itunes.apple.com/lookup?id=\(collectionId)&entity=song"
        networkManager.getSongs(urlString: urlId) { [unowned self] (resultsData) in
            guard let resultsData = resultsData else {
                return
            }
            self.resultsData = resultsData
            let result = ResultsData(results: resultsData.results)
            let encodedUserDetails = try? JSONEncoder().encode(result)
            UserDefaults.standard.set(encodedUserDetails, forKey: "HistoryDetails")   //Last to save
            self.tableView.reloadData()
        }
    }
}

//MARK: - Extension
extension AlbumInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsData?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = resultsData?.results?[indexPath.row]
        cell.textLabel?.text = song?.trackName
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerForTable
    }
}
