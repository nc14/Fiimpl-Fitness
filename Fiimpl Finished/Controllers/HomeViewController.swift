//
//  HomeViewController.swift
//  Fiimpl Finished
//
//  Created by Cockerill, Nicholas on 11/06/2018.
//  Copyright © 2018 Fiimpl Fitness. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var currentStreakLabel: UILabel!
    @IBOutlet weak var longestStreakLabel: UILabel!
    @IBOutlet weak var keepStreakOutlet: UIButton!
    @IBOutlet weak var keepStreakTextLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        let realm = try! Realm()
        let streakObject = realm.objects(StreakObject.self)
        if streakObject.count == 0 {
            keepStreakOutlet.isEnabled = false
            keepStreakTextLabel.text = "The Keep Streak button is available once you've completed your first Fiimpl Workout"
        } else {
            keepStreakOutlet.isEnabled = true
            keepStreakTextLabel.text = "Did you play a sport, go for a run or do soemthing else?  Keep your streak alive by tapping the button.  Remember you're only cheating yourself!"
        }
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        getStreakStatus()
        getStreaksUI()
    }

    //set navigation bar hiding on first page only
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func keepStreakButtonTapped(_ sender: Any) {
        let calendar = Calendar.current
        let streakObject = realm.objects(StreakObject.self).first
        let today = calendar.startOfDay(for: Date())
        let currentStreak = streakObject?.currentStreak
        let newStreak = (currentStreak)! + 1
        let bestStreak = streakObject?.longestStreak
        
        try! realm.write {
            streakObject?.lastWorkoutDate = today
            streakObject?.currentStreak = newStreak
        }
        
        if newStreak >= bestStreak! {
            try! realm.write {
                streakObject?.longestStreak = newStreak
            }
        }
        getStreaksUI()
        
    }
    
    
    //streak functions
    
    func getStreaksUI() {
        let streakObject = realm.objects(StreakObject.self).first
        let currentStreak = streakObject?.currentStreak ?? 0
        let longestStreak = streakObject?.longestStreak ?? 0
        
        currentStreakLabel.text = String(currentStreak)
        longestStreakLabel.text = String(longestStreak)
        
    }
    
    func getStreakStatus() {
        
        let calendar = Calendar.current
        let streakObject = realm.objects(StreakObject.self).first
        let lastDate = streakObject?.lastWorkoutDate ?? Date()
        
        // Replace the hour (time) of both dates with 00:00
        
        let date1 = calendar.startOfDay(for: (lastDate))
        
        
        let date2 = calendar.startOfDay(for: Date())
        
        let daysBetween = calendar.dateComponents([.day], from: date1, to: date2)
        print (daysBetween)
        
        if (daysBetween.day) != 0 {
            try! realm.write {
                streakObject?.currentStreak = 0
            }
        }
    }
    
}
