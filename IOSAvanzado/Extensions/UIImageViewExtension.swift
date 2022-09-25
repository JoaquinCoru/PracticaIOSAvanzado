//
//  UIImageViewExtension.swift
//  DragonBallApp
//
//  Created by Joaquín Corugedo Rodríguez on 24/7/22.
//

import UIKit

typealias ImageCompletion = (UIImage?) -> Void
extension UIImageView {
  
  func setImage(url: URL) {
    downloadImageWithUrlSession(url: url) { [weak self] image in
      DispatchQueue.main.async {
        self?.image = image
      }
    }
  }
  
  private func downloadImageWithUrlSession(url: URL, completion: ImageCompletion?) {
    URLSession.shared.dataTask(with: url) { data, _, _ in
      guard let data = data,
            let image = UIImage(data: data)
      else {
          let image = UIImage(named: "fondo4")
        completion?(image)
        return
      }
      completion?(image)
    }.resume()
  }
  
}

