//
//  DetailPlaceViewController.swift
//  GooglePlacesApp
//
//  Created by Cesar Alejandro Guadarrama Ortega on 18/11/23.
//

import UIKit
import GooglePlaces
import CoreLocation
import MapKit

class DetailPlaceViewController: UIViewController {
    
    let viewModel: DetailPlaceViewModel
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 2
        label.text = "Nombre del lugar: " + viewModel.placeName
        return label
    }()
    
    private lazy var coordinateLatitudLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 2
        label.text = "Latitud: "+String(viewModel.placeCoordinate.latitude)
        return label
    }()
    private lazy var coordinateLongitudLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 2
        label.text = "Longitud: " + String(viewModel.placeCoordinate.longitude)
        return label
    }()
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 10
        label.text = "Dirección completa: "+viewModel.placeAddress
        return label
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        //mapView.preferredConfiguration = MKHybridMapConfiguration()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    
    private lazy var webButton: UIButton = {
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.title = viewModel.buttonTitle
        
        let locationButton = UIButton(configuration: buttonConfiguration)
        locationButton.addTarget(self,
                                        action: #selector(locationButtonPressed),
                                        for: .touchUpInside)
        return locationButton
    }()
    
    init(place: GMSPlace){
        self.viewModel = DetailPlaceViewModel(place: place)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.delegate = self
        print(viewModel.placeName)
        setupView()
        updateLocation(with: viewModel.placeCoordinate)

    }
    
    func updateLocation(with coordinate: CLLocationCoordinate2D) {
        let userLocationPin = MKPointAnnotation()
        userLocationPin.coordinate = coordinate
        
        mapView.addAnnotation(userLocationPin)
        
        let mapRegion = MKCoordinateRegion(center: coordinate,
                                           span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                                  longitudeDelta: 0.01))
        mapView.region = mapRegion
    }
    
    @objc func locationButtonPressed(){
        // Reemplaza "latitude" y "longitude" con las coordenadas del lugar que deseas mostrar
        let latitude: String = String(viewModel.placeCoordinate.latitude)
        let longitude: String = String(viewModel.placeCoordinate.longitude)
        // Reemplaza "nombre+de+lugar" con el nombre del lugar o su dirección
        let lugar = viewModel.placeId
        // Construye la URL de Google Maps con las coordenadas y el nombre del lugar
        guard let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(latitude),\(longitude)&query_place_id=\(lugar)") else {
            return
            }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    
    }
    
    
    
    
    private func setupView(){
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        

        
        let contentViewHeighAncor = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        contentViewHeighAncor.isActive = true
        contentViewHeighAncor.priority = UILayoutPriority.required - 1

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
        ])
        
        let infoStackView = UIStackView()
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.spacing = 10
        infoStackView.distribution = .fill
        
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(addressLabel)
        infoStackView.addArrangedSubview(coordinateLatitudLabel)
        infoStackView.addArrangedSubview(coordinateLongitudLabel)
        infoStackView.addArrangedSubview(mapView)
        infoStackView.addArrangedSubview(webButton)

        
        contentView.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        
    }
    
    


}

extension DetailPlaceViewController: DetailPlaceViewModelDelegate {
    func updatePlaceLocation(with coordinate: CLLocationCoordinate2D) {
        let userLocationPin = MKPointAnnotation()
        userLocationPin.coordinate = coordinate
        
        mapView.addAnnotation(userLocationPin)
        
        let mapRegion = MKCoordinateRegion(center: coordinate,
                                           span: MKCoordinateSpan(latitudeDelta: 0.001,
                                                                  longitudeDelta: 0.001))
        mapView.region = mapRegion
    }
}
