//
//  Network.swift
//  JustRun
//
//  Created by Crystal Liu on 5/2/18.
//  Copyright © 2018 Luis Londono. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON
import GooglePlaces
import GoogleMaps

class Network {
    
    private static let landmarkEndpoint = "http://13.59.217.0/api/v0/"
    private static let pathEndpoint = "https://maps.googleapis.com/maps/api/directions/json?"
    
    static func getLandmark(withLocation location: String, withRadius radius: String, withTypes types: String, _ completion: @escaping ([String: String]) -> Void) {
        
        let parameters: Parameters = [
            "location" : location,
            "radius" : radius,
            "types" : types.replacingOccurrences(of: " ", with: "+")
        ]
        
        Alamofire.request(landmarkEndpoint, parameters: parameters).validate().responseJSON { (response) in

            switch response.result {

            case .success(let json):
                let json = JSON(json)
                let data = json["data"]

                var landmarkInfo: [String: String] = [:]

                landmarkInfo["destName"] = data["name"].stringValue
                landmarkInfo["destAddress"] = data["end"].stringValue
                landmarkInfo["destLat"] = data["end_lat"].stringValue
                landmarkInfo["destLong"] = data["end_lng"].stringValue

                // return dictionary of landmark info
                completion(landmarkInfo)

            case .failure(let error):
                print("[Network] Error:", error)
                completion([:])

            }

        }
        
        
    }
    
    static func getRoute(withOrigin origin: String, withDest dest: String, _ completion: @escaping ([GMSPolyline]) -> Void) {
        
        let parameters: Parameters = [
            "origin" : origin.replacingOccurrences(of: " ", with: "+"),
            "destination" : dest.replacingOccurrences(of: " ", with: "+"),
            "key" : "AIzaSyCdnnDCFVIS3u9oNpK-iRPCfaIjLyopkHw",
            "mode" : "walking"
        ]
        
        Alamofire.request(pathEndpoint, parameters: parameters).validate().responseJSON { (response) in
            
            switch response.result {
                
            case .success(let json):
                let json = JSON(json)
//                print(json)
                let routes = json["routes"].arrayValue
                
                var polylines: [GMSPolyline] = []
                
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    
                    let polyline = GMSPolyline(path: path)
                    polyline.strokeColor = UIColor(red: 0.36, green: 1, blue: 0.69, alpha: 1)
                    polyline.strokeWidth = 4
                    polylines.append(polyline)
                }
                
                // return array of polylines
                completion(polylines)
                
            case .failure(let error):
                print("[Network] Error:", error)
                completion([])
                
            }
            
        }
        
        
    }
    
}
