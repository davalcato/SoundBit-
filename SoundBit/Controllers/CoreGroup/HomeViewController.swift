//
//  ViewController.swift
//  SoundBit
//
//  Created by Daval Cato on 2/20/21.
//

import UIKit

// Provider a different section layout here
enum BrowseSectionType {
    // Sections
    case newReleases(viewModels: [NewReleasesCellViewModel]) // 1
    case featuredPlaylists(viewModels: [NewReleasesCellViewModel]) // 2
    case recommendedTracks(viewModels: [NewReleasesCellViewModel]) // 3
}

class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView =  UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in return HomeViewController.createSectionLayout(section: sectionIndex)
        })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // Array called sections
    private var sections = [BrowseSectionType]()
    
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
        // Adding as a subview
        view.addSubview(spinner)
        
        // Configuring the collectionView here
        configureCollectionView()
        // So the title Browse scroll with the collectionView
        view.addSubview(spinner)
        // Calling the API from the HomeViewController
        fetchData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    // Setting up the delegates and datasource here
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    // Make multiple API calls from here 
    private func fetchData() {
        // Featured Playlists
        
        // Recommended Tracks
        // New Releases
        
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
        // Configuring the Models here
        sections.append(.newReleases(viewModels: []))
        sections.append(.featuredPlaylists(viewModels: []))
        sections.append(.recommendedTracks(viewModels: []))
        
    }
    
    @objc func didTapSettings() {
        let vc = SettingViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if indexPath.section == 0 {
            cell.backgroundColor = .systemGreen
        }
        else if indexPath.section == 1 {
            cell.backgroundColor = .systemRed
        }
        else if indexPath.section == 2 {
            cell.backgroundColor = .systemBlue
        }
        return cell
    }
    
    // Creates the layout here
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        switch section {
        case 0:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                         leading: 2,
                                                         bottom: 2,
                                                         trailing: 2)
            
            // Vertical group inside the horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)),
                subitem: item,
                count: 3
            )
            
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(390)),
                subitem: verticalGroup,
                count: 1
            )
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            // This snapped the page views together
            section.orthogonalScrollingBehavior = .groupPaging
            return section
            
        case 1:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                         leading: 2,
                                                         bottom: 2,
                                                         trailing: 2)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)),
                subitem: item,
                count: 2
            )
         
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)),
                subitem: verticalGroup,
                count: 1
            )
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            // This snapped the page views together
            section.orthogonalScrollingBehavior = .continuous
            return section
            
        case 2:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                         leading: 2,
                                                         bottom: 2,
                                                         trailing: 2)
           
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(80)),
                subitem: item,
                count: 1
            )
            // Section
            let section = NSCollectionLayoutSection(group: group)
            return section
            
        default:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(70)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                         leading: 2,
                                                         bottom: 2,
                                                         trailing: 2)
            
            // Vertical group inside the horizontal group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)),
                subitem: item,
                count: 1
            )
            // Section
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
}

