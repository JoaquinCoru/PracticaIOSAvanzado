//
//  CellView.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 19/9/22.
//

import UIKit

class CellView: UICollectionViewCell {
    
    static var cellIdentifier:String {
        String(describing: CellView.self)
    }
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    
    
    override func awakeFromNib() {
        
        characterImage.layer.cornerRadius = 4.0
        cellView.layer.cornerRadius = 4.0
        cellView.layer.shadowColor = UIColor.gray.cgColor
        cellView.layer.shadowOffset = .zero
        cellView.layer.shadowOpacity = 0.7
        cellView.layer.shadowRadius = 4.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        characterImage.image = nil
        cellTitle.text = nil
    }
    
    func updateViews(data:HomeCellModel){
        // TODO: Obtener datos celda con modelo datos
        update(image: data.image)
        update(title: data.title)
    }
    
    
    private func update(image:URL){
        characterImage.setImage(url: image)
    }

    private func update(title:String?){
        cellTitle.text = title
    }
}
