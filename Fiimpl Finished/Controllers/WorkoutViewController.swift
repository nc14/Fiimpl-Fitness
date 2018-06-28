//
//  WorkoutViewController.swift
//  Fiimpl Finished
//
//  Created by Cockerill, Nicholas on 14/06/2018.
//  Copyright © 2018 Fiimpl Fitness. All rights reserved.
//

import UIKit
import RealmSwift

class WorkoutCell : UITableViewCell {
    
    var delegate: WorkoutCellDelegate?

    @IBAction func swapButtonTapped(_ sender: Any) {
        delegate?.swapButtonTapped(cell: self)
    }
    
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var repsNumber: UILabel!
    @IBOutlet weak var swapButton: UIButton!
    
}

protocol WorkoutCellDelegate {
    func swapButtonTapped(cell: WorkoutCell)
}

class WorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WorkoutCellDelegate {

    @IBOutlet weak var workoutTableView: UITableView!
    @IBOutlet weak var roundsLabel: UILabel!
    @IBOutlet weak var timerControlOutlet: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    var swapButtonEnabled : Bool = true
    var workoutID = UUID().uuidString
    var rounds = 0
    var isTimerRunning = false
    var workoutTimerObject = Timer()
    var firstTime = false
    
    var selectedWorkoutExerciseArray = [WorkoutExercise]()
    var selectedWorkoutTime : Int = 0
    var originalTime : Int = 0
    var selectedWorkoutType = ""
    var isFavourite = false
    
    
    override func viewDidLoad() {
        
        originalTime = selectedWorkoutTime
        selectedWorkoutTime = selectedWorkoutTime * 60
        timeLabel.text = timeString(time: TimeInterval(selectedWorkoutTime))
        roundsLabel.text = String(0)
        super.viewDidLoad()
        
        let streakObject = realm.objects(StreakObject.self)
        if streakObject.count == 0 {
            firstTime = true
        } else {
            firstTime = false
        }
        }
    
    //MARK: Table set up
    
    //return number of cells equivalent to the number of exercises in the array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedWorkoutExerciseArray.count
    }
    
    //configure tableview to use the custom workout cell UI and to use WorkoutCell as the class
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutExerciseCell", for: indexPath) as! WorkoutCell
        cell.delegate = self
        let exerciseName = selectedWorkoutExerciseArray[indexPath.row]
        
        cell.swapButton.isEnabled = swapButtonEnabled
        cell.exerciseName.text = exerciseName.name
        cell.repsNumber.text = String(exerciseName.reps)
        cell.selectionStyle = .none

        return cell
    }
    
    func swapButtonTapped(cell: WorkoutCell) {
        
        let myIndexPath = workoutTableView.indexPath(for: cell)
        
        let realmExercisePool = realm.objects(ExerciseGeneratorObject.self)
        let index = Int(arc4random_uniform(UInt32(realmExercisePool.count)))
        let newExercise = realmExercisePool[index].generateExercise()
        
        selectedWorkoutExerciseArray[(myIndexPath?.row)!] = newExercise
        
        cell.exerciseName.text = newExercise.name
        cell.repsNumber.text = String(newExercise.reps)
      
    }

//MARK: Timer functions
    
    @IBAction func timerControlTapped(_ sender: UIButton) {
        
        if isTimerRunning == false {
            sender.setImage(#imageLiteral(resourceName: "timerPause"), for: UIControlState.normal)
            runTimer()
            isTimerRunning = true
            swapButtonEnabled = false
            workoutTableView.reloadData()
            
        } else {
            sender.setImage(#imageLiteral(resourceName: "timerPlay"), for: UIControlState.normal)
            workoutTimerObject.invalidate()
            isTimerRunning = false
        }
    }
    
    @IBAction func addRoundTapped(_ sender: Any) {
        
        rounds = rounds + 1
        roundsLabel.text = String(rounds)
        
    }
    
//run timer function
    func runTimer() {
    workoutTimerObject = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(WorkoutViewController.workoutTimer), userInfo: nil, repeats: true)
        
    isTimerRunning = true
    }

//function to convert workout time to a decent format
    func timeString(time:TimeInterval) -> String {
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i", minutes, seconds)
}

//Workout Timer function.  Decrements the timer by 1 each time.  Called from runTimer function.
@objc func workoutTimer() {
    
    if isFavourite == false {
    
    let alert = UIAlertController(title: "Workout Done", message: "Save and go to summary", preferredStyle: .alert)
    let saveWorkoutAction = UIAlertAction(title: "Save", style: .default) { (UIAlertAction) in
        self.saveToRealm()
        self.updateStreak()
        self.performSegue(withIdentifier: "goToWorkoutSummary", sender: self)
    }
    
    selectedWorkoutTime = selectedWorkoutTime - 1
    timeLabel.text = timeString(time: TimeInterval(selectedWorkoutTime))
    //what to do when timer reaches 0
    if (selectedWorkoutTime==0) {
        timerControlOutlet.isEnabled = false
        workoutTimerObject.invalidate()
        alert.addAction(saveWorkoutAction)
        present (alert, animated: true, completion: nil)
    }
    }
    else {
    
        let alert = UIAlertController(title: "Nice work", message: "Go to summary to save", preferredStyle: .alert)
        let saveWorkoutAction = UIAlertAction(title: "Go to summary", style: .default) { (UIAlertAction) in
            self.updateStreak()
            self.performSegue(withIdentifier: "goToWorkoutSummary", sender: self)
        }
        
        selectedWorkoutTime = selectedWorkoutTime - 1
        timeLabel.text = timeString(time: TimeInterval(selectedWorkoutTime))
        //what to do when timer reaches 0
        if (selectedWorkoutTime==0) {
            timerControlOutlet.isEnabled = false
            workoutTimerObject.invalidate()
            alert.addAction(saveWorkoutAction)
            present (alert, animated: true, completion: nil)
        }
    }
    }
    //MARK: Realm functions
    
    //save to Realm
    
    func saveToRealm() {
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let workoutData = WorkoutSessionObject()
        workoutData.workoutID = workoutID
        workoutData.exercises.append(objectsIn: selectedWorkoutExerciseArray)
        workoutData.rounds = Int(roundsLabel.text!)!
        workoutData.totalExerciseCount = selectedWorkoutExerciseArray.count
        workoutData.workoutTime = originalTime
        workoutData.workoutType = selectedWorkoutType
        
        do {
            try realm.write {
                realm.add(workoutData)
            }
        } catch {
            print("error adding workout to realm")
        }
    }
    
    //Quit Button Code
    
    @IBAction func quitButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Quit workout?", message: "Are you sure you want to quit?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes, quit", style: .default, handler: { action in self.performSegue(withIdentifier: "quitWorkout", sender: self) }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
            
        }
    
    
    //update Streak function
    
    func updateStreak() {
        
        let calendar = Calendar.current
        let streakObject = realm.objects(StreakObject.self).first
        let currentStreak = streakObject?.currentStreak ?? 0
        let bestStreak = streakObject?.longestStreak ?? 0
        let newStreak = (currentStreak) + 1
        let lastDate = streakObject?.lastWorkoutDate ?? Date()
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: lastDate)
        let date2 = calendar.startOfDay(for: Date())
        
        let daysBetween = calendar.dateComponents([.day], from: date1, to: date2)

        if firstTime == true {
            let firstStreakObject = StreakObject()
                firstStreakObject.lastWorkoutDate = date2
                firstStreakObject.currentStreak = 1
                firstStreakObject.longestStreak = 1
            
                try!
                realm.write {
                realm.add(firstStreakObject)
                }
        } else {
        
        try! realm.write {
            streakObject?.currentStreak = newStreak
        }
        
        if (daysBetween.day) == 0 {
            try! realm.write {
                streakObject?.currentStreak = newStreak
                streakObject?.lastWorkoutDate = Date()
            }
        } else {
            try! realm.write {
                streakObject?.currentStreak = 0
                streakObject?.lastWorkoutDate = Date()
            }
        }
        if newStreak > bestStreak {
            try! realm.write {
                streakObject?.longestStreak = newStreak
            }
        }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let workoutData = WorkoutSessionObject()
        workoutData.workoutID = workoutID
        workoutData.rounds = Int(roundsLabel.text!)!
        workoutData.totalExerciseCount = selectedWorkoutExerciseArray.count
        
        if let destVC = segue.destination as? WorkoutSummaryViewController {
            destVC.totalRounds = workoutData.rounds
            destVC.workoutID = workoutData.workoutID
            destVC.workoutExercises = selectedWorkoutExerciseArray
            destVC.exerciseCount = workoutData.totalExerciseCount
            destVC.time = originalTime
            destVC.isFavourite = isFavourite
        }
    }
    
    
}
    


