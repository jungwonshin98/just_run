//
//  Workout.swift
//  JustRun
//
//  Created by Luis Londono on 4/29/18.
//  Copyright © 2018 Luis Londono. All rights reserved.
//

import Foundation
import UIKit

class Workout {
    var time: String
    var date: String
    var distance: Double
    var interval: Int
    
    init(time: String, date: String, distance: Double, interval: Int){
        self.time = time
        self.date = date
        self.distance = distance
        self.interval = interval
    }
}
