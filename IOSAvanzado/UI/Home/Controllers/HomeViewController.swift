//
//  HomeViewController.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 17/9/22.
//

import UIKit

protocol HomeViewProtocol:AnyObject{
    
    func showLoading(_ show:Bool)
    func updateViews()
}

class HomeViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Constant
    var viewModel:HomeViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        viewModel?.onViewsLoaded()
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

extension HomeViewController:HomeViewProtocol{

    func showLoading(_ show: Bool) {
            
        switch show{
            case true :
                activityIndicator.startAnimating()
                collectionView.isHidden = true
                
            case false:
                activityIndicator.stopAnimating()
                collectionView.isHidden = false
            }
            
    }
    
    func updateViews() {
        collectionView.reloadData()
    }

}

extension HomeViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel?.dataCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width/2) - 8, height: 190.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellView.cellIdentifier, for: indexPath) as? CellView

        if let data = viewModel?.data(for: indexPath.row) {
            cell?.updateViews(data: data)
        }

        return cell ?? UICollectionViewCell()
        
    }
    
}
