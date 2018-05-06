//
//  ViewController.swift
//  Final
//
//  Created by Crystal Liu on 4/29/18.
//  Copyright © 2018 Crystal Liu. All rights reserved.
//

import UIKit

class PastWorkoutsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddWorkoutDelegate {
    
    var workoutsTable: UITableView!
    var workouts: [Workout] = []
    let reuseWorkoutCell = "workoutCell"
    
    let workout1 = Workout(time: "1:30", date: "January 20, 2019", distance: 3, interval: 2)
    let workout2 = Workout(time: "2:53", date: "January 22, 2019", distance: 2, interval: 4)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        workoutsTable = UITableView()
        workoutsTable.bounces = true
        workoutsTable.dataSource = self
        workoutsTable.delegate = self
        workoutsTable.translatesAutoresizingMaskIntoConstraints = false
        workoutsTable.register(WorkoutTableViewCell.self, forCellReuseIdentifier: reuseWorkoutCell)

        workouts.append(workout1)
        workouts.append(workout2)

        view.addSubview(workoutsTable)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            workoutsTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            workoutsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            workoutsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            workoutsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    //data source functions - setting the data for cells:
    //number of rows in tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    //height of cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
    //set cells as Table View cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseWorkoutCell) as! WorkoutTableViewCell
        cell.timeLabel.text = String(describing: workouts[indexPath.row].time)
        cell.dateLabel.text = workouts[indexPath.row].date
        cell.distanceLabel.text = String(describing: workouts[indexPath.row].distance)
        cell.intervalLabel.text = String(describing: workouts[indexPath.row].interval)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    
    func addWorkout(time: String, date: String, distance: Double, interval: Int) {
        let workout = Workout(time: time, date: date, distance: distance, interval: interval)
        workouts.append(workout)
        print(self.workouts)
        print(self.workoutsTable)
        workoutsTable.reloadData()
    }
    
    
}

