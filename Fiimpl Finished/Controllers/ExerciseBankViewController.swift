//
//  ExerciseBankViewController.swift
//  Fiimpl Finished
//
//  Created by Cockerill, Nicholas on 12/06/2018.
//  Copyright © 2018 Fiimpl Fitness. All rights reserved.
//

import UIKit
import RealmSwift

//MARK: Exercise Bank Cell

class ExerciseBankExerciseCell : UITableViewCell {
    
    var delegate: ExerciseBankExerciseCellDelegate?
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.deleteButtonTapped(cell: self)
    }
    
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var minReps: UILabel!
    @IBOutlet weak var maxReps: UILabel!
    
}

protocol ExerciseBankExerciseCellDelegate {
        func deleteButtonTapped(cell: ExerciseBankExerciseCell)
    }

//MARK: Set up table view

class ExerciseBankViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExerciseBankExerciseCellDelegate {

    
    @IBOutlet weak var exerciseBankTable: UITableView!

    // reload table every time the table appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.exerciseBankTable.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // make number of rows equal number of exercises in Realm
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realmExercisePool = realm.objects(ExerciseGeneratorObject.self)
        return realmExercisePool.count
        
    }
    
    // set cell contents to values from Realm
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseBankCell", for: indexPath) as! ExerciseBankExerciseCell
        
        cell.delegate = self
        
        let exercise = realm.objects(ExerciseGeneratorObject.self)[indexPath.row]
        cell.exerciseName.text = exercise.name
        cell.minReps.text = String(exercise.minReps)
        cell.maxReps.text = String(exercise.maxReps)
        
        return cell
        
    }
    
    // set delete functionality where primary key is the exercise name
    func deleteButtonTapped(cell: ExerciseBankExerciseCell) {
        let exerciseToBeDeleted = realm.object(ofType: ExerciseGeneratorObject.self, forPrimaryKey: cell.exerciseName.text)
        do { try realm.write {
            realm.delete(exerciseToBeDeleted!)
            self.exerciseBankTable.reloadData()
            }
        } catch {
            print ("error removing from favourites")
        }
    }
    
}
