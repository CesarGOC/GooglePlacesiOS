//
//  ViewController.swift
//  GooglePlacesApp
//
//  Created by Cesar Alejandro Guadarrama Ortega on 17/11/23.
//

import UIKit
import GooglePlaces


class ViewController: UIViewController {

    let modelView = GooglePlacesModelView()
    override func viewDidLoad() {
        
        //Delegado
        modelView.autocompleteControllerUpdate().delegate = self

        // Agrega la vista de autocompletado como un niño del controlador actual.
        addChild(modelView.autocompleteControllerUpdate())
        modelView.autocompleteControllerUpdate().view.frame = view.bounds
        view.addSubview(modelView.autocompleteControllerUpdate().view)
        modelView.autocompleteControllerUpdate().didMove(toParent: self)
        
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate  {

    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place ID: \(place.placeID ?? "")")
        print("Place address: \(place.addressComponents ?? [])")
        print("Place format addres: \(place.formattedAddress ?? "")")
        let detailPlaceViewController = DetailPlaceViewController(place: place)
        present(detailPlaceViewController, animated: true)
        
        
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
      // TODO: handle the error.
      print("Error: ", error.localizedDescription)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
      
    }
}


