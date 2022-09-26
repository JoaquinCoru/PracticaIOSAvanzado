//
//  AnnotationView.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 26/9/22.
//

import MapKit


class AnnotationView: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      guard let value = newValue as? Annotation else { return }
      canShowCallout = true
      detailCalloutAccessoryView = CustomCallOutView(annotation: value)
    }
  }
}
