//
//  ViewController.swift
//  Journal App
//
//  Created by Oybek Narzikulov on 29/09/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var starFilterButton: UIBarButtonItem!
    
    private var starFilter = false
    
    private var notesModel = NotesModel()
    private var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set self as delegate and dataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set self as delegate for note view protocol methods
        notesModel.delegate = self
        
        // Run getNotes method to retrieve data from Firestore
        notesModel.getNotes(starFilter)
        
        // Set the star
        setStarFilterButton()
        
    }
    
    func setStarFilterButton(){
        
        let star = starFilter ? "star.fill" : "star"
        starFilterButton.image = UIImage(systemName: star)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let noteVC = segue.destination as? NoteViewController
        
        if tableView.indexPathForSelectedRow != nil{
            noteVC?.note = notes[tableView.indexPathForSelectedRow!.row]
            
            // Deselect the row so that is doesn't interfere with new note creation
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        }
        
    }

    
    @IBAction func starFilterTapped(_ sender: Any) {
        
        // Change the star once click
        starFilter.toggle()
        
        // Call getNotes method
        notesModel.getNotes(starFilter)
        
        // Show it to the user
        setStarFilterButton()
        
    }
    

}

//MARK: - TableView Delegate and DataSource Methods

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        // Configure the cell
        let titleLabel = cell.viewWithTag(1) as? UILabel
        titleLabel?.text = notes[indexPath.row].title
        
        let bodyLabel = cell.viewWithTag(2) as? UILabel
        bodyLabel?.text = notes[indexPath.row].body
        
        return cell
        
    }
    
}

//MARK: - Notes Model Protocol Methods

extension ViewController: NotesModelProtocol{
    
    func notesRetrieved(_ notes: [Note]) {
        
        self.notes = notes
        tableView.reloadData()
        
    }
    
}
