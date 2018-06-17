//
//  NotesViewController.swift
//  Fiimpl Finished
//
//  Created by Cockerill, Nicholas on 17/06/2018.
//  Copyright © 2018 Fiimpl Fitness. All rights reserved.
//

import UIKit
import RealmSwift

class NotesCell: UITableViewCell {
    
    var delegate: NotesCellDelegate?
    
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.deleteButtonTapped(cell: self)
    }
}
    
    protocol NotesCellDelegate {
        func deleteButtonTapped(cell: NotesCell)
    }


class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NotesCellDelegate {
    
    let realm = try! Realm()
    @IBOutlet weak var notesTableOutlet: UITableView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.notesTableOutlet.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let notes = realm.objects(NotesObject.self)
        return notes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notebookCell", for: indexPath) as! NotesCell
        
        let notes = realm.objects(NotesObject.self)

        cell.delegate = self
        
        cell.noteLabel.text = notes[indexPath.row].note
        
        return cell
    }
    
    // set delete functionality
    func deleteButtonTapped(cell: NotesCell) {
        let noteToBeDeleted = realm.object(ofType: NotesObject.self, forPrimaryKey: cell.noteLabel.text)
        
        do { try realm.write {
            realm.delete(noteToBeDeleted!)
            }
        } catch {
            print ("error removing from favourites")
        }
        self.notesTableOutlet.reloadData()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        let alertController : UIAlertController = UIAlertController(title: "New note", message: "Add a record, reminder or workout note here", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = ("Workout note")
        }
        // A cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("cancelled")
        }
        // This action handles your confirmation action
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            let noteText = alertController.textFields?.first?.text ?? ("Empty")
            let note = NotesObject()
            note.note = noteText
            
            do {
                try self.realm.write {
                    self.realm.add(note)
                }
            } catch {
                print ("Error adding note")
            }
            self.notesTableOutlet.reloadData()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        // Present to user
        present(alertController, animated: true, completion: nil)
    }
        
}
