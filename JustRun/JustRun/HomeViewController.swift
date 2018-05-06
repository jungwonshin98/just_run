//
//  JustRun
//
//  Created by Luis Londono on 4/27/18.
//  Copyright © 2018 Luis Londono. All rights reserved.
//

import UIKit
import SnapKit

protocol updatePaceDelegate {
    func submitTimeButtonPressed(withPace pace: Double)
}


class HomeViewController: UIViewController {
    var mainColor: UIColor! = UIColor(red: 0.36, green: 1, blue: 0.69, alpha: 1)

    
    var dateFormatter = DateFormatter()
    
    var continueButton: UIButton!
    var welcomeLabel: UILabel!
    
    var runningPaceLabel: UILabel!
    var colonLabel: UILabel!
    var runningPaceMinutesField: UITextField!
    var runningPaceSecondsField: UITextField!
    var updatePaceDelegate: updatePaceDelegate?

    
    var submitTimeButton: UIButton!
    
//    var kilometerPaceSeconds = 281.25

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    

        makeSubmitTimeButton()
        makeWelcomeLabel()
        makeTapToContinueButton()
        makePaceUI()
        setupConstraints()
    }
   
    func makePaceUI(){
        runningPaceLabel = UILabel()
        runningPaceLabel.text =  "What is your mile time?"
        runningPaceLabel.font = UIFont.boldSystemFont(ofSize: 35)
        runningPaceLabel.textColor = mainColor
        runningPaceLabel.isHidden = true
        
        
        colonLabel = UILabel()
        colonLabel.text = " : "
        colonLabel.font = UIFont.boldSystemFont(ofSize: 35)
        colonLabel.isHidden = true
        
        
        runningPaceMinutesField = UITextField()
        runningPaceMinutesField.font = UIFont.systemFont(ofSize: 35)
        runningPaceMinutesField.text = "07"
        runningPaceMinutesField.isHidden = true
        
        runningPaceSecondsField = UITextField()
        runningPaceSecondsField.font = UIFont.systemFont(ofSize: 35)
        runningPaceSecondsField.text = "30"
        runningPaceSecondsField.isHidden = true
        
        
        runningPaceMinutesField.translatesAutoresizingMaskIntoConstraints = false
        runningPaceSecondsField.translatesAutoresizingMaskIntoConstraints = false
        runningPaceLabel.translatesAutoresizingMaskIntoConstraints = false
        colonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        view.addSubview(runningPaceMinutesField)
        view.addSubview(colonLabel)
        view.addSubview(runningPaceSecondsField)
        view.addSubview(runningPaceLabel)
    }
    
    func makeTapToContinueButton(){
        continueButton = UIButton(frame: CGRect(x: 0, y: view.center.y, width: 400, height: 300))
        continueButton.setTitle("  Tap to Continue  ", for: .normal)
        continueButton.setTitleColor(.black, for: .normal)
        continueButton.titleLabel?.font? = UIFont.systemFont(ofSize: 33)
        continueButton.addTarget(self, action: #selector(continueButtonPressed), for: UIControlEvents.touchUpInside)
        continueButton.isSpringLoaded = true
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(continueButton)
    }
    
    func makeSubmitTimeButton(){
        submitTimeButton = UIButton(frame: CGRect(x: 0, y: view.center.y, width: 400, height: 300))
        submitTimeButton.setTitle("  Submit  ", for: .normal)
        submitTimeButton.setTitleColor(.black, for: .normal)
        submitTimeButton.titleLabel?.font? = UIFont.systemFont(ofSize: 33)
        submitTimeButton.addTarget(self, action: #selector(submitTimeButtonPressed), for: UIControlEvents.touchUpInside)

        submitTimeButton.isSpringLoaded = true
        submitTimeButton.isHidden = true
        
        submitTimeButton.layer.borderWidth = 4
        submitTimeButton.layer.cornerRadius = 18
        submitTimeButton.backgroundColor = .lightGray
        submitTimeButton.setTitleColor(.white, for: .normal)
        submitTimeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(submitTimeButton)
    }
    
    @objc func submitTimeButtonPressed(){
        print("submitTime button pressed in HomeViewController")
        
        let minutes: Int? = Int(runningPaceMinutesField.text!)
        let seconds: Int? = Int(runningPaceSecondsField.text!)
        
        let mileTime: Int! = (minutes! * 60) + seconds!
        let kmTime = Double(mileTime) / 1.609
        
        updatePaceDelegate?.submitTimeButtonPressed(withPace: kmTime)
        
        
    }
    
    
    
    @objc func continueButtonPressed(sender: UIButton!){
        print("Continue button pressed")
        
        welcomeLabel.isHidden = true
        continueButton.isHidden = true
        
        runningPaceMinutesField.isHidden = false
        runningPaceLabel.isHidden = false
        submitTimeButton.isHidden = false
        runningPaceSecondsField.isHidden = false
        colonLabel.isHidden = false
        
    }
    
    func makeWelcomeLabel(){
        welcomeLabel = UILabel()
        welcomeLabel.text = " Welcome to JustRun "
        welcomeLabel.textColor = mainColor
        welcomeLabel.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
    }
    
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 100),
            
            runningPaceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            runningPaceLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            
            colonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colonLabel.topAnchor.constraint(equalTo: runningPaceLabel.bottomAnchor, constant: 16),
            
            runningPaceMinutesField.rightAnchor.constraint(equalTo: colonLabel.leftAnchor, constant: 8),
            runningPaceMinutesField.centerYAnchor.constraint(equalTo: colonLabel.centerYAnchor),
            
            
            runningPaceSecondsField.leftAnchor.constraint(equalTo: colonLabel.rightAnchor, constant: -4),
            runningPaceSecondsField.centerYAnchor.constraint(equalTo: colonLabel.centerYAnchor),
            
            submitTimeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitTimeButton.topAnchor.constraint(equalTo: colonLabel.bottomAnchor, constant: 16)
            
            
            
            
            ])
    }
}

