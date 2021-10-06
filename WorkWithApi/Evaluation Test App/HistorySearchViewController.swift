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
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = createButton()
        button.addTarget(self, action: #selector(reload), for: .touchUpInside)
        self.view.addSubview(button)
        navigationItem.titleView = button
        
        setupTableView()
    }
    
    //MARK: - Private methods
    private func createButton() -> UIButton {   //create a button to reload Table View
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: view.frame.width / 4, height: 50))
        button.backgroundColor = .black
        button.setTitle("Reload", for: .normal)
        return button
    }
    
    private func setupTableView() {  //setup TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc private func reload() { //reload Data if in search something new in search string was entered
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
        navigationController?.pushViewController(albumsViewController, animated: true)
    }
}
