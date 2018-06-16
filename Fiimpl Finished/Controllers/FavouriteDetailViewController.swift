//
//  FavouriteDetailViewController.swift
//  Fiimpl Finished
//
//  Created by Cockerill, Nicholas on 15/06/2018.
//  Copyright © 2018 Fiimpl Fitness. All rights reserved.
//

import UIKit

class FavouriteDetailViewController: UIViewController {

    var favouriteWorkoutPassed = WorkoutSessionObject()
    var favouriteObjectPassed = FavouriteObject()
    
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var previousRoundsLabel: UILabel!
    @IBOutlet weak var previousTimeLabel: UILabel!
    @IBOutlet weak var goButtonOutlet: UIButton!
    @IBOutlet weak var timeInputOutlet: UITextField!
    
    
    override func viewDidLoad() {

        let lastRecord = favouriteObjectPassed.workoutHistory.first
        workoutNameLabel.text = favouriteObjectPassed.favouriteWorkoutName
 
        if let lastRecord = lastRecord {
            previousRoundsLabel.text = "\(lastRecord.rounds) rounds"
        }
        
        if let lastRecord = lastRecord {
            previousTimeLabel.text = "\(lastRecord.time) minutes"
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToFavouriteWorkout", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let finalExercisesList = favouriteWorkoutPassed.exercises
        let exercisesArray = Array(finalExercisesList)
        
        if segue.identifier == "goToFavouriteWorkout" {
            
            if let destVC = segue.destination as? WorkoutViewController {
                destVC.selectedWorkoutTime = Int(timeInputOutlet.text!)!
                destVC.selectedWorkoutExerciseArray = exercisesArray
                destVC.selectedWorkoutType = favouriteWorkoutPassed.workoutType
                destVC.isFavourite = true
                destVC.workoutID = favouriteWorkoutPassed.workoutID
            }
            
        }
        
            
        }
    }

