//
//  HomeViewModel.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 18/9/22.
//

import Foundation

protocol HomeViewModelProtocol {
    var dataCount:Int{get}
    
    func onViewsLoaded()
    
    func data(for index: Int) -> HomeCellModel?
}

final class HomeViewModel{
    
    private weak var viewDelegate:HomeViewProtocol?
    private var viewData:[HomeCellModel] = [HomeCellModel]()
    
    private let dataManager = CoreDataManager()
    
    init(viewDelegate: HomeViewProtocol?) {
        self.viewDelegate = viewDelegate
    }
    
    //MARK: Variable
    var heroes: [Hero] = []
    

    func getHeroes() {

        heroes = self.dataManager.fetchHeroe()
        viewData = heroes.compactMap({
            HomeCellModel(image: URL(string: $0.photo ?? "")!, title: $0.name ?? "", description: $0.description)
        })
        viewDelegate?.showLoading(false)
        viewDelegate?.updateViews()
        
    }
}

extension HomeViewModel:HomeViewModelProtocol{
    
    func data(for index: Int) -> HomeCellModel? {
        guard index < dataCount else { return nil }
        return viewData[index]
    }
    
    func onViewsLoaded() {
        getHeroes()
    }
    
    var dataCount: Int {
        heroes.count
    }
    
}
