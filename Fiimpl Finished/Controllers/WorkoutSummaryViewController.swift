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
    
    override func viewDidLoad() {
        
        print (totalRounds)
        print (workoutID)
        print (workoutExercises)
        print (exerciseCount)
        
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

}
