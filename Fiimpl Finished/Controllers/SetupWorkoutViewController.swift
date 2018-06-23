//
//  SetupWorkoutViewController.swift
//  Fiimpl Finished
//
//  Created by Cockerill, Nicholas on 14/06/2018.
//  Copyright © 2018 Fiimpl Fitness. All rights reserved.
//

import UIKit
import RealmSwift

class SetupWorkoutViewController: UIViewController, UITextFieldDelegate {

    var selectedWorkout : FinalWorkout!
    
    @IBOutlet weak var timeInputField: UITextField!
    @IBOutlet weak var workoutTypeControl: UISegmentedControl!
    @IBOutlet weak var goButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        
        timeInputField.delegate = self
        
        super.viewDidLoad()

    }
    
    //MARK: Segue preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToWorkout" {
            let finalWorkoutTime = selectedWorkout.timeForWorkout
            let finalWorkoutExercises = selectedWorkout.generatedWorkout.workoutExercises
        
        if let destVC = segue.destination as? WorkoutViewController {
            destVC.selectedWorkoutTime = finalWorkoutTime
            destVC.selectedWorkoutExerciseArray = finalWorkoutExercises
            destVC.selectedWorkoutType = workoutTypeControl.titleForSegment(at: workoutTypeControl.selectedSegmentIndex)!
            destVC.isFavourite = false
            }
        }
    }
    
    //MARK: Functions
    
    func standardWorkout() {
        let finalWorkoutTime = Int(timeInputField.text!)
        self.selectedWorkout = FinalWorkout(generatedWorkout: WorkoutGenerator.standardWorkout.generate(), timeForWorkout: finalWorkoutTime!)
        performSegue(withIdentifier: "goToWorkout", sender: self )

    }
    
    func repeaterWorkout() {
        let finalWorkoutTime = Int(timeInputField.text!)
        self.selectedWorkout = FinalWorkout(generatedWorkout: WorkoutGenerator.repeaterWorkout.generate(), timeForWorkout: finalWorkoutTime!)
        performSegue(withIdentifier: "goToWorkout", sender: self )

    }
    
    func varietyWorkout() {
        let finalWorkoutTime = Int(timeInputField.text!)
        self.selectedWorkout = FinalWorkout(generatedWorkout: WorkoutGenerator.varietyWorkout.generate(), timeForWorkout: finalWorkoutTime!)
        performSegue(withIdentifier: "goToWorkout", sender: self )
    }
    
    
    //MARK: Go Button
    
    @IBAction func goButtonTapped(_ sender: Any) {
        
        if workoutTypeControl.titleForSegment(at: workoutTypeControl.selectedSegmentIndex) == "Standard" {
            standardWorkout()
        }
        
        if workoutTypeControl.titleForSegment(at: workoutTypeControl.selectedSegmentIndex) == "Repeater" {
            repeaterWorkout()
        }
        
        if workoutTypeControl.titleForSegment(at: workoutTypeControl.selectedSegmentIndex) == "Variety" {
            varietyWorkout()
        }
        
    }
    
    //Form validation
    
    //only allow numbers in reps fields
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == timeInputField {
            
            let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
            
            
            return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
        }
        return true
    }
    
    //disable button if not all fields completed when finished editing
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if timeInputField.text?.isEmpty == false {
            goButtonOutlet.isEnabled = true
        } else {
            goButtonOutlet.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
     
        return true
    }
}
