//
//  SearchMapResultsViewController.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//
//  Note.  It was found during testing that Google places does not respect search radius as per documentation at
//  https://developers.google.com/maps/documentation/places/web-service/search-nearby
/*   You may bias results to a specified circle by passing a location and a radius parameter. Doing so instructs the Places service to prefer showing results within that circle; results outside of the defined area may still be displayed.
 */
//  To handle this, we need a feature update that removes results outside the search area before providing to the viewmodel.  Due to time constraints this has yet to be implemented

import UIKit
import Combine
import MapKit

class SearchMapResultsViewController: UIViewController {

    // IBOutlets
    @IBOutlet private var mapView: MKMapView!
    
    // Dependencies
    private let viewModel : SearchViewModelProtocol
    
    // Combine
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: INIT
    init(viewModel: SearchViewModelProtocol){
        self.viewModel = viewModel
        super.init(nibName: "SearchMapResultsViewController", bundle: nil)
    }

    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad: SearchMapResultsViewController")
        setupMapView()
        bind()
    }
    
    func setupMapView(){
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(PlaceAnnotation.self))
        mapView.delegate = self
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
               
                // replace above line with this line if we want map to autozoom so all places are shown
                // see comment at top about google api as to why this is not implemented yet
                //mapView.showAnnotations(newAnnotations, animated: true)
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
