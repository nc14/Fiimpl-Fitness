//
//  FavouriteExerciseDetailViewController.swift
//  Fiimpl Finished
//
//  Created by Cockerill, Nicholas on 18/06/2018.
//  Copyright © 2018 Fiimpl Fitness. All rights reserved.
//

import UIKit
import RealmSwift

class FavouriteExerciseDetailCell: UITableViewCell {
    
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
}


class FavouriteExerciseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var favouriteObjectPassed = FavouriteObject()
    var favouriteWorkoutPassed = WorkoutSessionObject()

    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let finalExercises = favouriteWorkoutPassed.exercises
        let exercisesArray = Array(finalExercises)
        return exercisesArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteExerciseDetailCell", for: indexPath) as! FavouriteExerciseDetailCell
        let finalExercises = favouriteWorkoutPassed.exercises
        let exercisesArray = Array(finalExercises)
        
        let exerciseName = exercisesArray[indexPath.row]
        
        cell.exerciseName.text = exerciseName.name
        cell.repsLabel.text = String(exerciseName.reps)
        cell.selectionStyle = .none
        return cell
    }

    

}
