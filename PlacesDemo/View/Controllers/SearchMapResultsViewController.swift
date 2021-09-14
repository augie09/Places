//
//  SearchMapResultsViewController.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import UIKit
import Combine
import MapKit

class SearchMapResultsViewController: UIViewController {

    @IBOutlet private var mapView: MKMapView!
    
    private let viewModel : SearchViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: INIT
    init(viewModel: SearchViewModelProtocol){
        self.viewModel = viewModel
        super.init(nibName: "SearchMapResultsViewController", bundle: nil)
    }

    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad: SearchMapResultsViewController")
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(PlaceAnnotation.self))
        mapView.delegate = self
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear: SearchMapResultsViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear: SearchMapResultsViewController")
    }
    
    //MARK: MKAnnotations
    private var displayedAnnotations: [MKAnnotation]? {
        willSet {
            if let currentAnnotations = displayedAnnotations {
                mapView.removeAnnotations(currentAnnotations)
            }
        }
        didSet {
            if let newAnnotations = displayedAnnotations {
                mapView.addAnnotations(newAnnotations)
            }
        }
    }
    
    private func handleNew(_ places: [Place]){
        
        let annotations = places.map{ place in
            return PlaceAnnotation(with: place)
        }
        displayedAnnotations = annotations
        print("handleNew: displayedAnnotations \(annotations.count)")
    }
    
    //MARK: BINDING
    private func bind() {
        viewModel.placesPublisher
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] places in
                self?.handleNew(places)
            }
            .store(in: &cancellables)
        
        // Observe Location changes
        viewModel.firstKnownLocation
            .sink { (_) in
                //
            } receiveValue: { [weak self] (location) in
                
                // this apps requirements is only interested in initial user location, not updating as user moves
                if let location = location {
                    self?.centerMap(location)
                }
            }.store(in: &cancellables)
    }
    
    func centerMap(_ location: (latitude: Double, longitude: Double)){
        let centerLocation = CLLocationCoordinate2D.init(latitude: location.latitude, longitude: location.longitude)
        let viewRegion = MKCoordinateRegion(center: centerLocation, latitudinalMeters: CLLocationDistance(viewModel.radius*2), longitudinalMeters: CLLocationDistance(viewModel.radius*2))
        mapView.setRegion(viewRegion, animated: false)
    }
}


extension SearchMapResultsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let placeAnnotation = annotation as? PlaceAnnotation,
              let place = viewModel.places.filter({ $0.id == placeAnnotation.placeId }).first else {
            print("matching place not found")
            return nil
        }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(PlaceAnnotation.self), for: annotation)
        let quicklookview = PlaceQuickLookView.loadFromNib()// here configure label and imageView
        
 
        quicklookview.load(place: place, delegate: self)
        annotationView.detailCalloutAccessoryView = quicklookview
        annotationView.canShowCallout = true
        annotationView.image = #imageLiteral(resourceName: "mapPin")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.image = #imageLiteral(resourceName: "mapPinSelected")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = #imageLiteral(resourceName: "mapPin")
    }
}

extension SearchMapResultsViewController: PlaceQuickLookViewDelegate {
    func photoUrl(from reference: String) -> URL? {
        return viewModel.photoUrl(from: reference)
    }
    
    
}

class PlaceAnnotation : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
   // var title: String?
    var subtitle: String?
    var placeId: String
    
    init(with place: Place){
        coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
       // title = place.name
        subtitle = place.priceLevelSigns()
        placeId = place.id
    }
}
