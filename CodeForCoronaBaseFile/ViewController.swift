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

var usr:String?

struct JobData: Codable {
    var location:String
    var Items:String
    var EstCost:Float
    var itemNo: Int
    var user:String
    var payMethod: String
}

class loginController: UIViewController {
    
    @IBOutlet var output: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    
    @IBAction func loginRequest(_ sender: Any) {
        if(password.text?.isEmpty ?? true || email.text?.isEmpty ?? true){
            output.text = "You must enter your email/password"
            return
        }
        if(UserDefaults.standard.object(forKey: email.text!) == nil){
            output.text = "There is no account tied to that email"
            return
        }
        if(UserDefaults.standard.string(forKey: email.text!) == password.text){
            usr = email.text
            performSegue(withIdentifier: "loginConfirmed", sender: Any?.self)
        } else {
            output.text = "Incorrect password"
            return
        }
        
    }
}

class registerController: UIViewController {
    
    
    @IBOutlet var output: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    @IBAction func signupRequest(_ sender: Any) {
        if(email.text?.isEmpty ?? true || password.text?.isEmpty ?? true){
            output.text = "You must enter your email/password"
            return
        }
        if(UserDefaults.standard.object(forKey: email.text!) == nil){
            UserDefaults.standard.set(password.text!, forKey: email.text!)
            performSegue(withIdentifier: "signupConfirmed", sender: Any?.self)
        } else {
            output.text = "there is already an account under that email"
        }
    }
    
}


class ViewController: UIViewController {
    @IBOutlet weak var SearchLabel: UIButton!
    @IBOutlet weak var SearchLocation: UIButton!
    @IBOutlet weak var Scroll: UIScrollView!
    @IBOutlet weak var Stack: UIStackView!
    public var Jobs = [UIView]()
    public var ETALabels = [UILabel]()
    public var currentView = 0
    public var JobList:Array<JobData> = []
    
    var currentLocation: CLLocation!
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        if(UserDefaults.standard.object(forKey: "Jobs") != nil){
            print("a")
            let fetch  = UserDefaults.standard.data(forKey: "Jobs")
            self.JobList = try! PropertyListDecoder().decode([JobData].self, from: fetch!)
            print(self.JobList)
        } else {
            let jb = try! PropertyListEncoder().encode([JobData(location: "UWCDover 1207 Dover Road, Singapore", Items: "10", EstCost: 50.00, itemNo: 0, user: "David", payMethod: "Paypal")])
            UserDefaults.standard.set(jb, forKey:"Jobs")
            print("b")
        }
        // Do any additional setup after loading the view.
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1000
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        let currentLocation = self.locationManager.location?.coordinate
        print(currentLocation ?? "NONE")
//        Scroll.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20)
//        Scroll.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
//        Scroll.topAnchor.constraint(equalTo: SearchLabel.bottomAnchor, constant: 20)
//        Scroll.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
//        Stack.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//          // Attaching the content's edges to the scroll view's edges
//          Stack.leadingAnchor.constraint(equalTo: Scroll.leadingAnchor),
//          Stack.trailingAnchor.constraint(equalTo: Scroll.trailingAnchor),
//          Stack.topAnchor.constraint(equalTo: Scroll.topAnchor),
//          Stack.bottomAnchor.constraint(equalTo: Scroll.bottomAnchor),

          // Satisfying size constraints
//          Stack.widthAnchor.constraint(equalTo: Scroll.widthAnchor)
//        ])
        
        AddJob(job: self.JobList[0])
        //AddJob(location: "Paragon", Items: 5, EstCost: 34.00, itemNo: 1)
        
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
                    print(firstLocation!)
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
                        self.ETALabels[self.currentView].text = "ETA Mins away: " + travelTime
                        self.Jobs[self.currentView].addSubview(self.ETALabels[self.currentView])
                        if self.currentView < self.JobList.count{
                            self.AddJob(job: self.JobList[self.currentView])
                            self.currentView += 1
                        }
                    }
                    return
                }
            }
                
            print(kCLLocationCoordinate2DInvalid, error as NSError?)
            completion(placemarks?[0], error)
        }
    }
    
    func AddJob(job: JobData){
        let y = 18 + 168*job.itemNo
        let View = UIView(frame: CGRect(x: 27, y: y, width: Int(self.view.bounds.size.width) - 54 - 40, height: 150))
        View.backgroundColor = UIColor(displayP3Red: 255/256, green: 70/256, blue: 0, alpha: 0.42*0.75)
        View.layer.cornerRadius = 20;
        View.layer.masksToBounds = true;
        //print(View.bounds.size.width)
        self.Stack.addArrangedSubview(View)
        View.translatesAutoresizingMaskIntoConstraints = false
        View.heightAnchor.constraint(equalToConstant: 150).isActive = true
        //self.Stack.addSubview(View)
        
        let Title = UILabel(frame: CGRect(x: 0, y: 10, width: self.view.bounds.size.width - 40, height: 30))
        //print(Title.bounds.size.width)
        Title.textAlignment = .center
        Title.textColor = UIColor.white
        Title.text = job.location
        Title.font = UIFont(name: "Futura-Bold", size: 25)
//        Title.layer.borderColor = UIColor.darkGray.cgColor
//        Title.layer.borderWidth = 3.0
        //self.View.addSubview(Title)
        View.addSubview(Title)
        
        let description = UILabel(frame: CGRect(x: 0, y: 60, width: self.view.bounds.size.width - 40, height: 20))
        description.textAlignment = .center
        description.textColor = UIColor.white
        description.numberOfLines = 0
        description.text = job.Items + "     ≈ $" + String(job.EstCost) + "0"
        description.font = UIFont(name: "Futura", size: 20)
        View.addSubview(description)
        
        let ETALabel = UILabel(frame: CGRect(x: 0, y: 90, width: self.view.bounds.size.width - 40 - 54, height: 20))
        ETALabel.textAlignment = .center
        ETALabel.textColor = UIColor.white
        ETALabel.numberOfLines = 0
        currentView = job.itemNo
        getDestination(location: job.location) {(placemark, error) in
            guard let placemark = placemark, error == nil else { return }
            print("Destination is: ")
            print(placemark)
            print("location")
            print(self.locationManager.location!)
        }
        ETALabel.text = "ETA Mins away: "
        ETALabel.font = UIFont(name: "Futura", size: 20)
        View.addSubview(ETALabel)
        Jobs.append(View)
        ETALabels.append(ETALabel)
        
    }
    
    
}

