//
//  NoteViewController.swift
//  Journal App
//
//  Created by Oybek Narzikulov on 29/09/22.
//

import UIKit

class NoteViewController: UIViewController {

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var starButton: UIButton!
    
    
    var notesModel = NotesModel()
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if note != nil{
            titleTextField.text = note!.title
            bodyTextView.text = note!.body
            
            setStarButton()
            
        } else{
            
            // create new note
            let n = Note(docId: UUID().uuidString, title: titleTextField.text ?? "", body: bodyTextView.text ??  "", isStarred: note?.isStarred ?? false, createdAt: Date(), lastUpdatedAt: Date())
            
            note = n
            
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // clear the field
        note = nil
        titleTextField.text = ""
        bodyTextView.text = ""
        
    }
    
    func setStarButton(){
        
        let isStar = note!.isStarred ? "star.fill" : "star"
        starButton.setImage(UIImage(systemName: isStar), for: .normal)
        
    }
    
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        
        if note != nil{
            
            notesModel.deleteNotes(note!)
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
        // update an existing note
        self.note?.title = titleTextField.text ?? ""
        self.note?.body = bodyTextView.text
        self.note?.lastUpdatedAt = Date()
        
        notesModel.saveNotes(note!)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func starTapped(_ sender: UIButton) {
        
        // Change the star when tapp
        note?.isStarred.toggle()
        
        // Save it to the firestore
        notesModel.updateNote(note!.docId, isStarred: note!.isStarred)
        
        
        // Show result to the user
        setStarButton()
        
    }
    
}
