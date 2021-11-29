//
//  MapView.swift
//  CombineTest
//
//  Created by Роман on 29.11.2021.
//

import UIKit
import MapKit


class MapView: UIView {
    private var coordinate: CLLocationCoordinate2D! // храним координаты
    
    
     init(frame: CGRect, coordinate: CLLocationCoordinate2D) {
        super.init(frame: frame)
        self.coordinate = coordinate
    }

    func updateUIView(_ view: MKMapView) {
      let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      let region = MKCoordinateRegion(center: coordinate, span: span)
      
      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinate
      view.addAnnotation(annotation)
      
      view.setRegion(region, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
