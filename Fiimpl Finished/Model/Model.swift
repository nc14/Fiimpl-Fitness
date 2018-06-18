//
//  Model.swift
//  Fiimpl Finished
//
//  Created by Cockerill, Nicholas on 11/06/2018.
//  Copyright © 2018 Fiimpl Fitness. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

let realm = try! Realm()

// MARK: Notes Object

class NotesObject: Object {
    
    @objc dynamic var note = ""

    }

// MARK: Streak Objects

class StreakObject: Object {
    @objc dynamic var lastWorkoutDate = Date()
    @objc dynamic var currentStreak = 0
    @objc dynamic var longestStreak = 0
}

//MARK: Workout Objects

// This struct is used to pass time variables and the workout details between VC's.

struct FinalWorkout {
    
    var generatedWorkout : Workout
    var timeForWorkout : Int
    
}

// This struct holds workout exercises to pass between VC's.

struct Workout {
    
    let workoutExercises : [WorkoutExercise]
    
}

/* An exercise generator object is what provides the criteria for an instance of an exercise.
 It has a range of reps it could choose from and contains a function to generate a WorkoutExercise instance. */

class ExerciseGeneratorObject: Object {
    @objc dynamic var name = ""
    @objc dynamic var minReps = 0
    @objc dynamic var maxReps = 0
    @objc dynamic var type = ""
    
    override class func primaryKey() -> String? {
        return "name"
    }
    
    convenience init(name: String, minReps: Int, maxReps: Int) {
        self.init()
        self.name = name
        self.minReps = minReps
        self.maxReps = maxReps
    }

    // this function generates an instance of the workout exercise
    func generateExercise() -> WorkoutExercise {
        return WorkoutExercise(
            name: name,
            reps: Int(arc4random_uniform(UInt32(maxReps-minReps))) + minReps
        )
    }
}

/* A Workout Exercise is a stored instance of an exercise.
 It is generated from the generator object and forms part of a workout */

class WorkoutExercise: Object {
    @objc dynamic var name = ""
    @objc dynamic var reps = 0
    
    convenience init(name: String, reps: Int) {
        self.init()
        self.name = name
        self.reps = reps
    }
    
}

/* The workout generator contains the struct and functions to generate a full workout, made up of various Exercise Objects.*/

 struct WorkoutGenerator {
    
    // This is the exercise pool it draws from - a pool of exerciseGeneratorObjects.
    
    let realmExercisePool = realm.objects(ExerciseGeneratorObject.self)
    
    // Min and max amount of exercises in the workout
    
    let minCount: Int
    let maxCount: Int
    
    // Function to generate a workout
    
    func generate() -> Workout {
        let amount = Int(arc4random_uniform(UInt32(maxCount - minCount))) + minCount
        let myExercises : [WorkoutExercise] = (0..<amount).map { _ in
            // Selects an exercise generator at random
            let index = Int(arc4random_uniform(UInt32(realmExercisePool.count)))
            // Generates a random workout exercise from this generator
            
            return realmExercisePool[index].generateExercise()
        }
        
        return Workout(workoutExercises: myExercises)
        
    }
    
    static var standardWorkout: WorkoutGenerator {
        return WorkoutGenerator(
            minCount: 3,
            maxCount: 6
        )
        
    }
    
    static var repeaterWorkout: WorkoutGenerator {
        return WorkoutGenerator(
            minCount: 1,
            maxCount: 2
        )
        
    }
    
    static var varietyWorkout: WorkoutGenerator {
        return WorkoutGenerator(
            minCount: 6,
            maxCount: 10
        )
        
    }

}

// This is the stored instance of a completed workout session.

class WorkoutSessionObject: Object {
    @objc dynamic var workoutID = UUID().uuidString
    @objc dynamic var workoutType = ""
    let exercises = List<WorkoutExercise>()
    @objc dynamic var totalExerciseCount = 0
    @objc dynamic var rounds = 0
    @objc dynamic var workoutTime = 0
    @objc dynamic var favourite : Bool = false
    
    override class func primaryKey() -> String? {
        return "workoutID"
    }
}

class FavouriteObject: Object {
    @objc dynamic var workoutID = UUID().uuidString
    @objc dynamic var favouriteWorkoutName = ""
    @objc dynamic var workoutReference:WorkoutSessionObject?
    let workoutHistory = List<FavouriteHistoryRecord>()
    
    override class func primaryKey() -> String? {
        return "workoutID"
    }
}

class FavouriteHistoryRecord: Object {
    
    @objc dynamic var date = Date()
    @objc dynamic var time = 0
    @objc dynamic var rounds = 0

}





