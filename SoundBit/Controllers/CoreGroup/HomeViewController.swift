//
//  ViewController.swift
//  SoundBit
//
//  Created by Daval Cato on 2/20/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
        // Calling the API from the HomeViewController
        fetchData()
    }
    // Make multiple API calls from here 
    private func fetchData() {
        APICaller.shared.getRecommendedGenres { result in
            switch result {
            case .success(let model): 
                let genres = model.genres
                // Get five random elements from the json
                var seeds = Set<String>()
                while seeds.count < 5 {
                    // Append a random genres here
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                APICaller.shared.getRecommendations(genres: seeds) { _ in
                    
                }
                
            case .failure(let error): break
            
            }
        }
    }
    
    @objc func didTapSettings() {
        let vc = SettingViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

