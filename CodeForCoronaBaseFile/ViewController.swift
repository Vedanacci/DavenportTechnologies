//
//  ViewController.swift
//  CodeForCoronaBaseFile
//
//  Created by Vedant Bahadur on 9/5/20.
//  Copyright © 2020 Youth Hacks. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var SearchLocation: UIButton!
    @IBOutlet weak var Scroll: UIScrollView!
    @IBOutlet weak var Stack: UIStackView!
    public var Jobs = [UIView]()
    public var ETALabels = [UILabel]()
    
    var currentLocation: CLLocation!
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1000
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        let currentLocation = self.locationManager.location?.coordinate
        print(currentLocation ?? "NONE")
        
        //AddJob(location: "1207 Dover Road, Singapore", Items: 10, EstCost: 50.00, itemNo: 0)
        //AddJob(location: "1207 Dover Road, Singapore", Items: 4, EstCost: 90.00, itemNo: 1)
    }
    @IBAction func Location(_ sender: Any) {
        let currentLocation = self.locationManager.location?.coordinate
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
                
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    //SearchLocation.setTitle("Search Near: " + String(firstLocation!), for: .normal)
                    print(firstLocation)
                }
                else {
                 // An error occurred during geocoding.
                    print("o")
                }
            })
        }
        else {
            // No location was available.
            print("0")
        }
        print(currentLocation ?? "NONE")
        AddJob(location: "1207 Dover Road, Singapore", Items: 10, EstCost: 50.00, itemNo: 0)
    }
    func requestETA(userCLLocation: CLLocationCoordinate2D, coordinate: CLLocationCoordinate2D, completion: @escaping (_ string: String?, _ error: Error?) -> () ) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userCLLocation, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        print("direction")
        print(directions)
        var travelTime: String?
        directions.calculate { response, error in
            print("routes ")
            print(response?.routes)
            if let route = response?.routes.first {
                travelTime = String(round(route.expectedTravelTime/60))
                print("Travel Time is: ")
                print(travelTime)
                print(response?.source)
                print(response?.destination)
            }
            completion(travelTime, error)
        }
        print("Travel Time is: ")
        print(travelTime)
    }
    
    func getDestination(location:String, completion: @escaping (_ string: CLPlacemark?, _ error: Error?) -> ()){
        let currentLocation = (self.locationManager.location?.coordinate)!
        let geocoder = CLGeocoder()
        var Destination:CLLocationCoordinate2D?
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location1 = placemark.location!
                        
                    print("UWC is: ")
                    print(location1.coordinate)
                    Destination = location1.coordinate
                    let currentLocation = self.locationManager.location?.coordinate
                    self.requestETA(userCLLocation: currentLocation!, coordinate: Destination!) { (travelTime, error) in
                        guard let travelTime = travelTime, error == nil else { return }
                        print("Travel Time is: ")
                        print(travelTime)
                        //let ETALabel = self.ETALabels[0]
                        //let View = self.Jobs[0]
                        self.ETALabels[0].text = "ETA Mins away: " + travelTime
                        self.Jobs[0].addSubview(self.ETALabels[0])
                    }
                    return
                }
            }
                
            print(kCLLocationCoordinate2DInvalid, error as NSError?)
            completion(placemarks?[0], error)
        }
    }
    
    func AddJob(location:String, Items:Int, EstCost:Float, itemNo: Int){
        let y = 18 + 193*itemNo
        let View = UIView(frame: CGRect(x: 27, y: y, width: Int(self.view.bounds.size.width) - 54 - 40, height: 175))
        View.backgroundColor = UIColor(displayP3Red: 255/256, green: 70/256, blue: 0, alpha: 0.42*0.75)
        View.layer.cornerRadius = 20;
        View.layer.masksToBounds = true;
        //print(View.bounds.size.width)
        //self.Stack.addSubview(View)
        self.Stack.addSubview(View)
        
        let Title = UILabel(frame: CGRect(x: 0, y: 10, width: self.view.bounds.size.width - 40 - 54, height: 30))
        //print(Title.bounds.size.width)
        Title.textAlignment = .center
        Title.textColor = UIColor.white
        Title.text = location
        Title.font = UIFont(name: "Futura-Bold", size: 30)
        //Title.layer.borderColor = UIColor.darkGray.cgColor
        //Title.layer.borderWidth = 3.0
        //self.View.addSubview(Title)
        View.addSubview(Title)
        
        let description = UILabel(frame: CGRect(x: 0, y: 60, width: self.view.bounds.size.width - 40 - 54, height: 20))
        description.textAlignment = .center
        description.textColor = UIColor.white
        description.numberOfLines = 0
        description.text = String(Items) + " Items     ≈ $" + String(EstCost) + "0"
        description.font = UIFont(name: "Futura", size: 20)
        View.addSubview(description)
        
        let ETALabel = UILabel(frame: CGRect(x: 0, y: 90, width: self.view.bounds.size.width - 40 - 54, height: 20))
        ETALabel.textAlignment = .center
        ETALabel.textColor = UIColor.white
        ETALabel.numberOfLines = 0
        
//        let request = MKDirections.Request()
//        request.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation!, addressDictionary: nil))
//        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: Destination!, addressDictionary: nil))
//        request.requestsAlternateRoutes = true
//        request.transportType = .automobile
//
//        let directions = MKDirections(request: request)
//        var travelTime: String?
//        directions.calculate { [unowned self] response, error in
//            if let route = response?.routes.first {
//                travelTime = String(route.expectedTravelTime/60)
//            }
//            print("travel time: ")
//            print(travelTime)
//        }
//
//        print("Directions: ")
//        print(directions)
        getDestination(location: location) {(placemark, error) in
            guard let placemark = placemark, error == nil else { return }
            print("Destination is: ")
            print(placemark)
            print("location")
            print(self.locationManager.location!)
            //print(placemark)
//            let currentLocation = self.locationManager.location?.coordinate
//            let location1 = placemark.location!
//            let Destination = location1.coordinate
//            self.requestETA(userCLLocation: currentLocation!, coordinate: Destination) { (travelTime, error) in
//                guard let travelTime = travelTime, error == nil else { return }
//                print("Travel Time is: ")
//                print(travelTime)
//            }
        }
        ETALabel.text = "ETA Mins away: "
        ETALabel.font = UIFont(name: "Futura", size: 20)
        View.addSubview(ETALabel)
        Jobs.append(View)
        ETALabels.append(ETALabel)
        
    }
    
    
}

