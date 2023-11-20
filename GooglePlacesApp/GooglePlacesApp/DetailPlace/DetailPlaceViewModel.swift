//
//  DetailPlaceViewModel.swift
//  GooglePlacesApp
//
//  Created by Cesar Alejandro Guadarrama Ortega on 18/11/23.
//

import Foundation
import GooglePlaces
import CoreLocation
import MapKit

protocol DetailPlaceViewModelDelegate: AnyObject{
    func updatePlaceLocation(with coordinate: CLLocationCoordinate2D)
}

class DetailPlaceViewModel: NSObject{
    private let place: GMSPlace
    
    var placeName: String{place.name!}
    var placeEditorialSummary: String{place.editorialSummary ?? ""}
    var placeId: String{place.placeID!}
    var placeAddress: String{place.formattedAddress ?? ""}
    var placeCoordinate: CLLocationCoordinate2D{place.coordinate}
    
    let buttonTitle = "Cómo llegar"
    
    var placeCoordinateLocation: CLLocationCoordinate2D? {
        willSet {
            if let newValue = newValue{
                delegate?.updatePlaceLocation(with: newValue)
            }
        }
    }
    
    weak var delegate: DetailPlaceViewModelDelegate?
    
    
    
    init(place: GMSPlace){
        self.place = place
        self.placeCoordinateLocation = place.coordinate
    }
}
