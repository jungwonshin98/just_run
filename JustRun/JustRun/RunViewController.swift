//
//  RunViewController.swift
//  JustRun
//
//  Created by Luis Londono on 4/29/18.
//  Copyright © 2018 Luis Londono. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import GoogleMaps
import GooglePlaces

protocol AddWorkoutDelegate {
    func addWorkout(time: String, date: String, distance: Double, interval: Int)
}

class RunViewController: UIViewController, updatePaceDelegate {
    
    func submitTimeButtonPressed(withPace pace: Double) {
        print("pace updated in RunViewController")
        self.kilometerPaceSeconds = pace
        PaceLabel.text = formatTime(raw_seconds: Int(kilometerPaceSeconds))
    }
    
    var delegate: AddWorkoutDelegate?
    var mainColor: UIColor! = UIColor(red: 0.36, green: 1, blue: 0.69, alpha: 1)

    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var polylines: [GMSPolyline] = []
    
    // A default location to use when location permission is not granted.
//    let defaultLocation = CLLocation(latitude: 42.447583, longitude: -76.484944)
    
    var landmarkInfo: [String: String] = [:]
    var landmarkTypes: [String] =  ["restaurant", "park", "library", "school", "cafe","church", "store","street","shop","hall","bus"]
    
    
    let locationManager = CLLocationManager()

    
    var timeLabel: UILabel!
    
    var dateFormatter = DateFormatter()
    var kilometerPaceSeconds : Double!
    var counter: Int!
    var timeString : String!
    var timeElapsed = 0
    var intervalDistance = 250
    var intervalsCompleted = 0
    
    var intervalsCompletedLabel: UILabel!
    
    var workoutStarted = false
    var hasReachedCheckpoint = true
    
    var PaceLabel: UILabel!
    var PaceLabelTitle: UILabel!
    
    var WorkoutButton: UIButton!
    var intervalDoneButton: UIButton!
    
    var DestinationLabelTitle: UILabel!
    var DestinationLabel: UILabel!
    
    var BingaleeDingalee = CLLocation(latitude: 42.447553, longitude: -76.484948)
    var CornellClub = CLLocation(latitude: 40.754488, longitude: -73.979338)
    
    var currentLocation = CLLocation(latitude: 40.754488, longitude: -73.979338)
    var endLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
//            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
//
//            self.currentLocation = locationManager.location!
//        }
        
        view.backgroundColor = .white
        
        
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        kilometerPaceSeconds = 279.6
        counter = Int(Double(Double(self.intervalDistance)/1000) * Double(kilometerPaceSeconds))

        createDestinationLabel()
        createPaceLabel()
        createIntervalsCompletedLabel()
        createIntervalDoneButton()
        createMap()
        createTimeLabel()
        createWorkoutButton()
        setupConstraints()
        
    }
    
    func createPaceLabel(){
        PaceLabel = UILabel()
        PaceLabel.text = formatTime(raw_seconds: Int(kilometerPaceSeconds))
        PaceLabel.textColor = .black
        PaceLabel.font = UIFont.systemFont(ofSize: 16)
        PaceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        PaceLabelTitle = UILabel()
        PaceLabelTitle.text = "1k time:"
        PaceLabelTitle.textColor = .black
        PaceLabelTitle.font = UIFont.systemFont(ofSize: 12)
        PaceLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(PaceLabelTitle)
        view.addSubview(PaceLabel)
    }
    
    func createDestinationLabel(){
        DestinationLabelTitle = UILabel()
        DestinationLabelTitle.text = "Destination: "
        DestinationLabelTitle.textColor = mainColor
        DestinationLabelTitle.font = UIFont.systemFont(ofSize: 18)
        DestinationLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        
        DestinationLabel = UILabel()
        DestinationLabel.text = "Nowhere"
        DestinationLabel.textColor = .black
        DestinationLabel.font = UIFont.systemFont(ofSize: 18)
        DestinationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        view.addSubview(DestinationLabelTitle)
        view.addSubview(DestinationLabel)
    }
    
    @objc func updateCounter() {
//        print("The counter is at: " + String(counter) + " workoutStarted is: " + String(workoutStarted) + " and hasReachedCheckPoint is: " + String(hasReachedCheckpoint))
        
        // Workout hasn't been started, or it is over
        if (!workoutStarted){
//            timeString = (counter > 0) ? formatTime(raw_seconds: counter) : "DONE"
            timeString = " DONE  "
        }
        
        // Currently Running and needs new Landmark
        if (workoutStarted && hasReachedCheckpoint){
            self.DestinationLabel.text = findNearbyLandmark(start: self.currentLocation)
            counter = Int(Double(Double(intervalDistance)/1000) * Double(kilometerPaceSeconds))
            timeString = formatTime(raw_seconds: counter)
            hasReachedCheckpoint = false
        }
        
        //Currently Running to Landmark
        if (workoutStarted && !hasReachedCheckpoint){
            timeElapsed += 1
            if (0 <= counter && counter <= 10){
                UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.preferredFramesPerSecond60, animations: {
                    
                    self.timeLabel.center.y = self.timeLabel.center.y - 5
                    self.timeLabel.textColor = .red
                    
                    }, completion: nil)
                
                timeString = formatTime(raw_seconds: counter)
                counter = counter - 1
            }
            
            if (counter < 0){
                workoutStarted = false
                timeString = " DONE  "
                stopWorkout()
            }
            
            if (counter > 10){
                timeString = formatTime(raw_seconds: counter)
                counter = counter - 1
                self.timeLabel.textColor = .black
            }
        }
        timeLabel.text = timeString
    }
    
    @objc func updateWorkoutState(sender: UIButton!){
        if !(workoutStarted){
            // Goes off when starting a NEW Workout
            workoutStarted = true
            WorkoutButton.setTitle("  Stop  ", for: .normal)
            WorkoutButton.backgroundColor = .red
            WorkoutButton.setTitleColor(.white, for: .normal)
            print("Workout has been started")
        }
        else{
            // Goes off when workout is force ended
            workoutStarted = false
            stopWorkout()
            WorkoutButton.backgroundColor = .gray
            WorkoutButton.setTitleColor(.blue, for: .normal)
            
            WorkoutButton.setTitle("  Start New  ", for: .normal)
        }
    }
    
    func stopWorkout(){
        print ("STOPPING WORKOUT")
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let year = calendar.component(.year, from: date)
        let stringDate = "\(month) \(day), \(year)"
        let distanceParameter = Double(intervalDistance * intervalsCompleted)
        let timeParameter = formatTime(raw_seconds: timeElapsed)
        
        delegate?.addWorkout(time: timeParameter, date: stringDate, distance: distanceParameter, interval: intervalDistance)
        
        self.counter = -1
//        self.counter = Int(intervalDistance/1000) * Int(kilometerPaceSeconds)
//        print("Counter reset to: " + String(Int(intervalDistance/1000) * Int(kilometerPaceSeconds)))

        if (self.workoutStarted == false && self.hasReachedCheckpoint == false){
            
            self.timeElapsed = 0
            self.counter = Int(Double(intervalDistance) * Double(kilometerPaceSeconds)/1000)
            self.intervalsCompleted = 0
            self.intervalsCompletedLabel.text = "0"
        }
        
        self.workoutStarted = false
        self.hasReachedCheckpoint = false
        
    }
    
    func formatTime(raw_seconds: Int) -> String{
        assert(raw_seconds < 3600)
        assert(raw_seconds >= 0)
        let minutes = raw_seconds/60
        let seconds = raw_seconds-minutes*60
        let minutes_string = (minutes < 10) ? "0" + String(minutes) : String(minutes)
        let seconds_string = (seconds < 10) ? "0" + String(seconds) : String(seconds)
        return minutes_string + ":" + seconds_string
        
        
    }
    
    func createMap(){
        placesClient = GMSPlacesClient.shared()

        let runCamera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: zoomLevel)
        
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height*67/100), camera: runCamera)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 250
        locationManager.startUpdatingLocation()
        locationManager.delegate = self as? CLLocationManagerDelegate
        
        
        
        view.addSubview(mapView)
    }
    
    func createWorkoutButton() {
        let buttonTitle = "  Start  "
        
        WorkoutButton = UIButton()
        WorkoutButton.setTitle(buttonTitle,for: .normal)
        WorkoutButton.titleLabel?.font = WorkoutButton.titleLabel?.font.withSize(30)
        WorkoutButton.setTitleColor(UIColor.blue, for: .normal)
        WorkoutButton.backgroundColor = UIColor.lightGray
        WorkoutButton.frame = CGRect(x: 0 , y: view.frame.height*3/4, width: 200, height: 36)
        WorkoutButton.center.x = view.center.x
        WorkoutButton.tintColor = .green
        
        WorkoutButton.titleLabel?.minimumScaleFactor = 1
        WorkoutButton.titleLabel?.numberOfLines = 1
        WorkoutButton.titleLabel?.adjustsFontSizeToFitWidth = true
        WorkoutButton.addTarget(self, action: #selector(updateWorkoutState), for: UIControlEvents.touchUpInside)
        
        
        // Make it round
        WorkoutButton.layer.borderWidth = 4
        WorkoutButton.layer.cornerRadius = 18
        
        //
        WorkoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(WorkoutButton)
    }
    
    func createTimeLabel(){
        timeLabel = UILabel()
        timeLabel.text = formatTime(raw_seconds: counter)
        timeLabel.textColor = .black
        timeLabel.font = timeLabel.font.withSize(100)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
      
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            
//            WorkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            WorkoutButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -16),
            WorkoutButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            
            PaceLabel.leftAnchor.constraint(equalTo: timeLabel.rightAnchor),
            PaceLabel.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: -25),
            
            PaceLabelTitle.leftAnchor.constraint(equalTo: timeLabel.rightAnchor),
            PaceLabelTitle.bottomAnchor.constraint(equalTo: PaceLabel.topAnchor, constant: 4),
            
            intervalsCompletedLabel.leftAnchor.constraint(equalTo: timeLabel.rightAnchor, constant: -8),
            intervalsCompletedLabel.bottomAnchor.constraint(equalTo: PaceLabelTitle.topAnchor),
            
            intervalDoneButton.leftAnchor.constraint(equalTo: WorkoutButton.rightAnchor, constant: 32),
            intervalDoneButton.centerYAnchor.constraint(equalTo: WorkoutButton.centerYAnchor),
            
            DestinationLabelTitle.leftAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: 0),
            DestinationLabelTitle.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: 22),
            
            DestinationLabel.leftAnchor.constraint(equalTo: DestinationLabelTitle.rightAnchor, constant: 0),
            DestinationLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: 23)
            
            ])
    }
    
    func createIntervalsCompletedLabel(){
        intervalsCompletedLabel = UILabel()
        intervalsCompletedLabel.text = "  0  "
        intervalsCompletedLabel.textColor = .blue
        intervalsCompletedLabel.font = intervalsCompletedLabel.font.withSize(33)
        intervalsCompletedLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(intervalsCompletedLabel)
    }
    
    func createIntervalDoneButton(){
        let buttonTitle = "  Reached  "
        
        intervalDoneButton = UIButton()
        intervalDoneButton.setTitle(buttonTitle,for: .normal)
        intervalDoneButton.titleLabel?.font = intervalDoneButton.titleLabel?.font.withSize(30)
        intervalDoneButton.setTitleColor(UIColor.blue, for: .normal)
        intervalDoneButton.backgroundColor = UIColor.lightGray
        intervalDoneButton.frame = CGRect(x: 0 , y: view.frame.height*3/4, width: 200, height: 36)
        intervalDoneButton.center.x = view.center.x
        intervalDoneButton.tintColor = .green
        
        intervalDoneButton.titleLabel?.minimumScaleFactor = 1
        intervalDoneButton.titleLabel?.numberOfLines = 1
        intervalDoneButton.titleLabel?.adjustsFontSizeToFitWidth = true
        intervalDoneButton.addTarget(self, action: #selector(finishInterval), for: UIControlEvents.touchUpInside)
        
        
        // Make it round
        intervalDoneButton.layer.borderWidth = 4
        intervalDoneButton.layer.cornerRadius = 18
        
        //
        intervalDoneButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(intervalDoneButton)
    }
    
    @objc func finishInterval(){
        print("The pace for the user's kilometer is: " + String(kilometerPaceSeconds))
        if workoutStarted{
            hasReachedCheckpoint = true
            intervalsCompleted += 1
            intervalsCompletedLabel.text = "  " + String(intervalsCompleted) + "  "
            currentLocation = endLocation
//            hasSomeDestination = false
        }
    }
    
    func findNearbyLandmark(start: CLLocation) -> String {
        
        // Location (Lat,Long) String
        let location = "\(String(start.coordinate.latitude)),\(String(start.coordinate.longitude))"
        
        //Generates random Landmark
        let randomLandmarkType = landmarkTypes[Int(arc4random_uniform(UInt32(landmarkTypes.count)))]
        
        // Call to Network, Google Api
        Network.getLandmark(withLocation: location, withRadius: String(intervalDistance), withTypes: randomLandmarkType) { (landmarkInfo) in
                self.landmarkInfo = landmarkInfo
            
                if let destName = landmarkInfo["destName"] {
                    if (destName != "") {
                        print("You are running to \n \(destName) of type: " + String(randomLandmarkType) + " within a radius of: " + String(self.intervalDistance))
                        self.DestinationLabel.text = destName
                        
                        self.endLocation = CLLocation(latitude: Double(landmarkInfo["destLat"]!)!, longitude: Double(landmarkInfo["destLong"]!)!)
                        
                        self.mapView.clear()
                        self.displayPath(startLat: String(start.coordinate.latitude), startLong: String(start.coordinate.longitude), destLat: landmarkInfo["destLat"]!, destLong: landmarkInfo["destLong"]!)
        
                    }
                    else {
                        print( "No Landmarks Found that matched the type: " + String(randomLandmarkType))
                        print(" and with current location: " + location)
                    }
                }
            }
        if let destName = landmarkInfo["destName"]{
            if (destName != ""){
                return destName
            }
            else{
                return "Nowhere"
            }
        }
        return "Google's API has Failed You!"
    }
    
    func displayPath(startLat: String, startLong: String,destLat: String, destLong: String) {

        let origin = startLat + "," + startLong
        let destination = destLat + "," + destLong
        
        Network.getRoute(withOrigin: origin, withDest: destination) { (polylines) in
            for p in polylines {
                p.map = self.mapView
            }
            let camera = GMSCameraPosition.camera(withLatitude: Double(startLat)!, longitude: Double(startLong)!, zoom: self.zoomLevel)
            
            self.mapView.camera = camera
            self.mapView.animate(to: camera)
        }
    }
    
}

