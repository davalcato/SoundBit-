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
    case featuredPlaylists(viewModels: [FeaturedPlaylistCellViewModel]) // 2
    case recommendedTracks(viewModels: [RecommendedTrackCellViewModel]) // 3
    
    // Adding a computed property
    var title: String {
        switch self {
        case .newReleases:
            return "New Released Albums"
        case .featuredPlaylists:
            return "Featured Playlists"
        case .recommendedTracks:
            return "Recommended"
        
        }
    }
}

class HomeViewController: UIViewController {
    private var newAlbums: [Album] = []
    private var playlists: [Playlist] = []
    private var tracks: [AudioTrack] = []
    
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
        
        // Configuring the collectionView here
        configureCollectionView()
        // So the title Browse scroll with the collectionView
        view.addSubview(spinner)
        // Calling the API from the HomeViewController
        fetchData()
        // Long tap
        addLongTapGesture()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // addLongTapGesture Function
    private func addLongTapGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(gesture)
    }
    // Create #selector
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        // If the user long press in the collection
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint),
              // Guard section 2
              indexPath.section == 2 else {
            return
        }
        // Get the model
        let model = tracks[indexPath.row]
        //create actionsheet
        let actionSheet = UIAlertController(
            title: model.name,
            message: "Would like to add this to a playlist?",
            preferredStyle: .actionSheet
        )
        // Present actionSheets
        actionSheet.addAction(UIAlertAction(
                                title: "Cancel",
                                style: .cancel,
                                handler: nil))
        
        actionSheet.addAction(UIAlertAction(
                                title: "Add to Playlist",
                                style: .default,
                                handler: { [weak self]_ in
            // Main Thread
                                    DispatchQueue.main.async {
                                        // Pick which playlist
                                          let vc = LibraryPlaylistsViewController()
                                        // Pass it back to the caller - return playlist
                                        vc.selectionHandler = { playlist in
                                            
                                            
                                        }
                                        vc.title = "Select Playlist"
                                        // Present in NavigationController
                                            self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
              }
                                    
         }))
        
        present(actionSheet, animated: true)
    }
    
    
    // Setting up the delegates and datasource here
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        
        // Register the TitleHeaderCollectionReusableView
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    // Make multiple API calls from here 
    private func fetchData() {
        // Group together mutliple groups of operations or APICalls
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        print("Start fetching data")
        
        var newReleases: NewReleasesResponse?
        var featuredPlaylist: FeaturedPlaylistsResponse?
        var recommendations: RecommedationsResponse?
        
        // New Releases
        APICaller.shared.getNewReleases { result in
            defer {
                group.leave()
                
            }
            switch result {
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print(error.localizedDescription)
            
            }
        }
        // Featured Playlists
        APICaller.shared.getFeaturePlaylists { result in
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let model): featuredPlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
            
            }
        }
        
        // Recommended Tracks
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
                APICaller.shared.getRecommendations(genres: seeds) { recommendedResult in
                    defer {
                        group.leave()
                        
                    }
                    switch recommendedResult {
                    case .success(let model): recommendations = model
                    case .failure(let error): print(error.localizedDescription)
                    
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        // When it hit's a group enter
        group.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylist?.playlists.items,
                  let tracks = recommendations?.tracks else {
                fatalError("Models are nil")
               
                }
            
            print("Configuring viewModels")
            self.configureModels(
                newAlbums: newAlbums,
                playlists: playlists,
                tracks: tracks)
            }
        }
    
        private func configureModels(
            newAlbums: [Album],
            playlists: [Playlist],
            tracks: [AudioTrack]
        
        ) {
            // Adding properties to configureModels
            self.newAlbums = newAlbums
            self.playlists = playlists
            self.tracks = tracks
           
            // Configuring the Models here
            sections.append(.newReleases(viewModels: newAlbums.compactMap({
                // Convert every album into the viewModels
                return NewReleasesCellViewModel(
                    name: $0.name,
                    artworkURL: URL(string: $0.images.first?.url ?? ""),
                    numberOfTracks: $0.total_tracks,
                    artistName: $0.artists.first?.name ?? "-")
                
            })))
            // ViewModel for FeaturedPlaylistCellViewModel
            sections.append(.featuredPlaylists(viewModels: playlists.compactMap({
                return FeaturedPlaylistCellViewModel(
                    name: $0.name,
                    artworkURL: URL(string: $0.images.first?.url ?? ""),
                    creatorName: $0.owner.display_name)
                
            })))
            sections.append(.recommendedTracks(viewModels: tracks.compactMap({
                return RecommendedTrackCellViewModel(
                    name: $0.name,
                    artistName: $0.artists.first?.name ?? "-",
                    artworkURL: URL(string: $0.album?.images.first?.url ?? ""))
                
            })))
            collectionView.reloadData()
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
        // Retrieving a particular section
        let type = sections[section]
        
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
            
        case .featuredPlaylists(let viewModels):
            return viewModels.count
            
        case .recommendedTracks(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        
        switch type {
        case .newReleases(let viewModels):
           guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleaseCollectionViewCell.identifier,
                    for: indexPath) as? NewReleaseCollectionViewCell else {
            return UICollectionViewCell()
           }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            
            return cell
            
        case .featuredPlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                 withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                     for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
             return UICollectionViewCell()
            }
            cell.configure(with: viewModels[indexPath.row])
             return cell
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                 withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
                     for: indexPath) as? RecommendedTrackCollectionViewCell else {
             return UICollectionViewCell()
            }
             // Configure the cell
            cell.configure(with: viewModels[indexPath.row])
             return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // Get the section here
        let section = sections[indexPath.section]
        switch section {
        case .featuredPlaylists:
            let playlist = playlists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            break
        case .newReleases:
            // Query data API of Album
            let album = newAlbums[indexPath.row]
            // Creating the ViewController for AlbumViewController
            let vc = AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            // Push the navigation onton the stack here
            navigationController?.pushViewController(vc, animated: true)
            break
        case .recommendedTracks:
            let track = tracks[indexPath.row]
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
            break
        
        }
    }
    
    // Dequeue TitleHeaderCollectionReusableView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
                                                                     for: indexPath
        ) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let title = sections [section].title
        header.configure(with: title)
        return header
    }
    
    // Creates the layout here
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        
        let supplementaryViews = [
        NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        ]
        
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
            section.boundarySupplementaryItems = supplementaryViews
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
            section.boundarySupplementaryItems = supplementaryViews
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
            section.boundarySupplementaryItems = supplementaryViews
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
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
    }
}

