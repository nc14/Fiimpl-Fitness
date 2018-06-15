//
//  WorkoutSummaryViewController.swift
//  Fiimpl Finished
//
//  Created by Cockerill, Nicholas on 14/06/2018.
//  Copyright © 2018 Fiimpl Fitness. All rights reserved.
//

import UIKit
import RealmSwift

class WorkoutSummaryCell: UITableViewCell {
    
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var totalReps: UILabel!
}

class WorkoutSummaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var totalRounds : Int = 0
    var workoutID = UUID().uuidString
    var workoutExercises = [WorkoutExercise]()
    var exerciseCount : Int = 0
    var time : Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
   
    //MARK: TABLE CONFIGURATION
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //return number of cells equivalent to the number of exercises in the array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseCount
    }
    
    //configure tableview to use the custom workout cell UI and to use WorkoutCell as the class
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutSummaryCell", for: indexPath) as! WorkoutSummaryCell
        
        let exercises = workoutExercises[indexPath.row]
        cell.exerciseName.text = exercises.name
        cell.totalReps.text = String(exercises.reps)
        return cell
    }
    
    @IBAction func favouriteButtonTapped(_ sender: Any) {
    //set up alert controller
    let alertController : UIAlertController = UIAlertController(title: "Save as favourite", message: "Give your workout a name to save it", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = ("Workout name")
        }
        // A cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("cancelled")
        }
        //favourite object values
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let favouriteName = alertController.textFields?.first?.text ?? ("Empty")
            let workout = (realm.object(ofType: WorkoutSessionObject.self, forPrimaryKey: self.workoutID))!
            let favouriteWorkout = FavouriteObject()
            favouriteWorkout.favouriteWorkoutName = favouriteName
            favouriteWorkout.workoutReference = workout
            
            //favourite history record
            let recordTime = self.time
            let recordDate = Date()
            let recordRounds = self.totalRounds
            
            let historyRecord = FavouriteHistoryRecord()
            historyRecord.date = recordDate
            historyRecord.time = recordTime
            historyRecord.rounds = recordRounds
            
            do {
                try realm.write {
                    realm.add(favouriteWorkout)
                    realm.add(historyRecord)
                    workout.favourite = true
                }
            } catch {
                print ("Error adding favourite")
            }
            
    }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    

}
