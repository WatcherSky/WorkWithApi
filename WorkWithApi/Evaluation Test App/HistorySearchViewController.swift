//
//  HistorySearchViewController.swift
//  Evaluation Test App
//
//  Created by Владимир on 02.10.2021.
//

import UIKit

class HistorySearchViewController: UIViewController {
    //MARK: - Properties
    private var array = UserDefaults.standard.stringArray(forKey: "array")
    private var labelText: String?
    @IBOutlet private var tableView: UITableView!
    private var timer: Timer?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reload()
        setupTableView()
    }
    
    //MARK: - Private methods
    private func setupTableView() {  //setup TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    

    private func reload() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(reloadTableView), userInfo: nil, repeats: true)
    }
    
    @objc func reloadTableView() {
        array = UserDefaults.standard.stringArray(forKey: "array")
        tableView.reloadData()
    }
}

//MARK: - Extensions
extension HistorySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let array = array else { return 0 }
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = array?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumsViewController = AlbumsViewController.instantiateAlbumsVC()
        if let labelText = array?[indexPath.row] {
            albumsViewController.searchByHistoryString = labelText
        }
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(albumsViewController, animated: true)
    }
}
