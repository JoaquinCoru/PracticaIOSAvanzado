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
    
    //MARK: Constant
    let viewModel = HomeViewModel()
    
    private let detailIdentifier = "DetailMap"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Heroes"
        navigationController?.navigationBar.isHidden = false
        collectionView.isHidden = true
        
        configureViews()
        
        viewModel.onSuccess = {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.collectionView.isHidden = false
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.onError = { title, error in
            self.activityIndicator.stopAnimating()
            self.collectionView.isHidden = false
            print(error?.localizedDescription)
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



extension HomeViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width/2) - 8, height: 190.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellView.cellIdentifier, for: indexPath) as? CellView else {
            return UICollectionViewCell()
        }
        
        let hero = viewModel.content[indexPath.row]

        cell.updateViews(data: HomeCellModel(
            image: hero.photo,
            title: hero.name,
            description: hero.description)
        )

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hero = viewModel.content[indexPath.row]
        let nextStoryboard = UIStoryboard(name: detailIdentifier,bundle: nil)
        guard let nextVC = nextStoryboard.instantiateInitialViewController() as? DetailMapViewController else {return}
        
        nextVC.set(model: hero)
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
