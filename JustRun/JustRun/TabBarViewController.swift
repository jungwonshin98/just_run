//
//  TabBarViewController.swift
//  Final
//
//  Created by Crystal Liu on 4/29/18.
//  Copyright © 2018 Crystal Liu. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var mainColor: UIColor! = UIColor(red: 0.36, green: 1, blue: 0.69, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = mainColor
        self.tabBar.unselectedItemTintColor = .white
        
        let HomeVC = HomeViewController()
        let HomeNC = UINavigationController(rootViewController: HomeVC)
        HomeVC.title = "Home Page"
        HomeNC.tabBarItem.image = UIImage(named: "home_icon")
        HomeNC.tabBarItem.title = "Home"
        
        
        let PastWorkoutsVC = PastWorkoutsViewController()
        let PastWorkoutsNC = UINavigationController(rootViewController: PastWorkoutsVC)
        PastWorkoutsVC.title = "Past Workouts"
        PastWorkoutsNC.tabBarItem.image = UIImage(named: "history_icon")
        PastWorkoutsNC.tabBarItem.title = "Past Workouts"
        
        
        let RunVC = RunViewController()
        let RunNC = UINavigationController(rootViewController: RunVC)
        RunVC.title = "Run"
        RunNC.tabBarItem.image = UIImage(named: "run_icon")
        RunNC.tabBarItem.title = "Run"
        
        viewControllers = [HomeNC,PastWorkoutsNC,RunNC]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
