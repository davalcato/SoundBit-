//
//  SearchResultsViewController.swift
//  SoundBit
//
//  Created by Daval Cato on 2/20/21.
//

import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Segment out the data in four different sections
    private var sections: [SearchSection] = []
    
    // Use a customize tableView for the search
    private let tableview: UITableView = {
        // Give search a style of group
        let tableview = UITableView(frame: .zero, style: .grouped)
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
        // Filter out various types of results
        let artists = results.filter({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })
        
        let albums = results.filter({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        
        let tracks = results.filter({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        
        let playlists = results.filter({
            switch $0 {
            case .playlist: return true
            default: return false
            }
        })
        self.sections = [
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Playlists", results: playlists),
            SearchSection(title: "Albums", results: albums)

        
        ]
        tableview.reloadData()
        tableview.isHidden = results.isEmpty 
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch result {
        // Associated cell
        case .artist(let model):
            cell.textLabel?.text = model.name
        case .album(let model):
            cell.textLabel?.text = model.name
        case .track(let model):
            cell.textLabel?.text = model.name
        case .playlist(let model):
            cell.textLabel?.text = model.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

}
