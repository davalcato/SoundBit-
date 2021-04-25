//
//  SearchResultsViewController.swift
//  SoundBit
//
//  Created by Daval Cato on 2/20/21.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    private var results: [SearchResult] = []
    
    // Use a customize tableView for the search
    private let tableview: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .systemBackground
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableview.isHidden = true
        return tableview
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Background coler
        view.backgroundColor = .clear
        view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Create tableview frame
        tableview.frame = view.bounds
    }
    
    func update(with results: [SearchResult]) {
        self.results = results
        tableview.reloadData()
        tableview.isHidden = results.isEmpty 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Foo"
        
        return cell
    }

}
