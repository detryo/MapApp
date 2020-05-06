//
//  ViewController.swift
//  MapApp
//
//  Created by Cristian Sedano Arenas on 29/04/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pullUpView: UIView!
    @IBOutlet weak var pullUpHeightViewConstraint: NSLayoutConstraint!
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius : Double = 1000
    
    var spinner : UIActivityIndicatorView?
    var progressLabel : UILabel?
    var screenSize = UIScreen.main.bounds
    
    var collectionView : UICollectionView?
    var flowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
       mapView.delegate = self
       locationManager.delegate = self
       configureLocationServices()
       addDoubleTap()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        pullUpView.addSubview(collectionView!)
    }
    
    func addDoubleTap(){
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
    }
    
    func addSwipe(){
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDowsn))
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)
    }
    
    @objc func animateViewDowsn(){
        
        pullUpHeightViewConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func animateViewUp(){
        
        pullUpHeightViewConstraint.constant = 300
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func addSpinner(){
        
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (screenSize.width / 2) - ((spinner?.frame.width)! / 2), y: 150)
        spinner?.style = .large
        spinner?.color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        spinner?.startAnimating()
        collectionView?.addSubview(spinner!)
    }
    
    func removeSpinner(){
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    }
    
    func addProgressLabel(){
        progressLabel = UILabel()
        progressLabel?.frame = CGRect(x: (screenSize.width / 2) - 120, y: 175, width: 200, height: 40)
        progressLabel?.font = UIFont(name: "Avenir Next", size: 18)
        progressLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        progressLabel?.textAlignment = .center
        progressLabel?.text = "Load Images"
        collectionView?.addSubview(progressLabel!)
    }
    
    func removeProgressLabel () {
        if progressLabel != nil {
            progressLabel?.removeFromSuperview()
        }
    }

    @IBAction func centerMapButtonWasPressed(_ sender: UIButton){
        
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse{
            centerMapOnUserLocation()
        }
    }
    
}

extension MapVC: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { return nil }
        
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.987544477, green: 0.6673021317, blue: 0, alpha: 1)
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    }
    
    func centerMapOnUserLocation(){
        
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func dropPin(sender : UITapGestureRecognizer){
        
        removePin()
        removeSpinner()
        removeProgressLabel()
        animateViewUp()
        addSwipe()
        addSpinner()
        addProgressLabel()
        
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        
        mapView.addAnnotation(annotation)
        
        let coordinateRegion = MKCoordinateRegion(center: touchCoordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    func removePin() {
        
        for annotation in mapView.annotations {
            
            mapView.removeAnnotation(annotation)
        }
    }
}

extension MapVC: CLLocationManagerDelegate {
    
    func configureLocationServices() {
        
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
}

extension MapVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell
        
        return cell!
    }
}
