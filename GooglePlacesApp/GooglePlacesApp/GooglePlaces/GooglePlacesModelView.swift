//
//  GooglePlacesModel.swift
//  GooglePlacesApp
//
//  Created by Cesar Alejandro Guadarrama Ortega on 18/11/23.
//

import Foundation
import UIKit
import GooglePlaces
import CoreLocation

class GooglePlacesModelView: NSObject {
    
    private let client = GMSPlacesClient.shared()
    private let autocompleteController = GMSAutocompleteViewController()
    let nameField: UInt64
    let placeIDField: UInt64
    let coordinateField: UInt64
    let addressComponentsField: UInt64
    let formattedAddressField: UInt64
    let phoneNumberField: UInt64
    let ratingField: UInt64
    private let fields: GMSPlaceField!

    // Specify a filter.
    let filter = GMSAutocompleteFilter()
    
    override init(){
        //Spects Filter
        nameField = UInt64(UInt(GMSPlaceField.name.rawValue))
        placeIDField = UInt64(UInt(GMSPlaceField.placeID.rawValue))
        coordinateField = UInt64(UInt(GMSPlaceField.coordinate.rawValue))
        addressComponentsField = UInt64(GMSPlaceField.addressComponents.rawValue)
        formattedAddressField = UInt64(GMSPlaceField.formattedAddress.rawValue)
        phoneNumberField = UInt64(GMSPlaceField.phoneNumber.rawValue)
        ratingField = UInt64(GMSPlaceField.rating.rawValue)
        
        var combinedFields = nameField | placeIDField | coordinateField | addressComponentsField | formattedAddressField
        combinedFields |= phoneNumberField | ratingField
        
        fields = GMSPlaceField(rawValue: combinedFields)
        
        
        //autocompleteController.delegate = self
        autocompleteController.placeFields = fields
        filter.types = ["address"]
        autocompleteController.autocompleteFilter = filter
        super.init()
        
    }
    
    func autocompleteControllerUpdate()->GMSAutocompleteViewController{
        return autocompleteController
    }
    
}

