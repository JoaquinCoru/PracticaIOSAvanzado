//
//  HomeViewController.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 17/9/22.
//

import UIKit


class HomeViewController: UIViewController {
   
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var searchBar: UISearchController = {
           let sb = UISearchController()
           sb.searchBar.placeholder = "Enter the character name"
           sb.searchBar.searchBarStyle = .minimal
           return sb
       }()
    
    //MARK: Constant
    let viewModel = HomeViewModel()
    
    private let detailIdentifier = "DetailMap"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Heroes"
        navigationController?.navigationBar.isHidden = false
        collectionView.isHidden = true
        searchBar.searchResultsUpdater = self
        navigationItem.searchController = searchBar
        
        configureViews()
        
        viewModel.onSuccess = {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.collectionView.isHidden = false
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.onError = { title, error in
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.collectionView.isHidden = false
                self?.showAlert(title: title, message: error?.localizedDescription ?? "")
            }

        }
        
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false

    }
    
    private func configureViews(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension HomeViewController:UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else{return}
        
        viewModel.filteredContent =  []
        
        if query == "" {
            viewModel.filteredContent = viewModel.content
            self.collectionView.reloadData()
        }else{
            for item in viewModel.content {
                
                if (item.name.lowercased().starts(with: query.lowercased())){
                    
                    viewModel.filteredContent.append(item)
                }
            }
            
            self.collectionView.reloadData()
            
        }
    }
    
}



extension HomeViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.filteredContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width/2) - 8, height: 190.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellView.cellIdentifier, for: indexPath) as? CellView else {
            return UICollectionViewCell()
        }
        
        let hero = viewModel.filteredContent[indexPath.row]

        cell.updateViews(data: HomeCellModel(
            image: hero.photo,
            title: hero.name,
            description: hero.description)
        )

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hero = viewModel.filteredContent[indexPath.row]
        let nextStoryboard = UIStoryboard(name: detailIdentifier,bundle: nil)
        guard let nextVC = nextStoryboard.instantiateInitialViewController() as? DetailMapViewController else {return}
        
        nextVC.set(model: hero)
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBar", for: indexPath)
           return searchView
       
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    // MAR: Search Bar Config
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        viewModel.filteredContent =  []
//
//        if searchText == "" {
//            viewModel.filteredContent = viewModel.content
//            self.collectionView.reloadData()
//        }else{
//            if searchText.count >= 3 {
//                for item in viewModel.content {
//
//                    if (item.name.lowercased().starts(with: searchText.lowercased())){
//
//                        viewModel.filteredContent.append(item)
//                    }
//                }
//
//                self.collectionView.reloadData()
//            }
//        }
//
//    }
    
}
