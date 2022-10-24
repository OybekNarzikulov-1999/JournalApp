//
//  NoteModel.swift
//  Journal App
//
//  Created by Oybek Narzikulov on 29/09/22.
//

import Foundation
import FirebaseFirestore

protocol NotesModelProtocol {
    func notesRetrieved(_ notes: [Note])
}

class NotesModel{
    
    var delegate: NotesModelProtocol?
    var listener: ListenerRegistration?
    
    deinit {
        listener?.remove()
    }
    
    
    func getNotes(_ starredOnly:Bool = false){
        
        listener?.remove()
        
        let db = Firestore.firestore()
        
        var query:Query? = db.collection("notes")
        
        if starredOnly{
            query = query?.whereField("isStarred", isEqualTo: true)
        }
        
        listener = query?.addSnapshotListener({ querySnapshot, error in
            
            if error == nil && querySnapshot != nil {
                
                var notes = [Note]()
                
                for query in querySnapshot!.documents{
                    
                    let createdAtDate = Timestamp.dateValue(query["createdAt"] as! Timestamp)
                    let lastUpdatedAtDate = Timestamp.dateValue(query["lastUpdatedAt"] as! Timestamp)
                    
                    let note = Note(docId: query["docId"] as! String, title: query["title"] as! String, body: query["body"] as! String, isStarred: query["isStarred"] as! Bool, createdAt: createdAtDate(), lastUpdatedAt: lastUpdatedAtDate())
                    
                    notes.append(note)
                }
                
                DispatchQueue.main.async {
                    self.delegate?.notesRetrieved(notes)
                }
            }
        })
        
    }
    
    func deleteNotes(_ note: Note){
        
        let db = Firestore.firestore()
        
        db.collection("notes").document(note.docId).delete()
        
    }
    
    func saveNotes(_ note: Note){
 
        let db = Firestore.firestore()
        
        db.collection("notes").document(note.docId).setData(noteConverter(note))
        
    }
    
    func noteConverter(_ note: Note) ->[String:Any]{
        
        var dict = [String:Any]()
        
        dict["docId"] = note.docId
        dict["title"] = note.title
        dict["body"] = note.body
        dict["createdAt"] = note.createdAt
        dict["lastUpdatedAt"] = note.lastUpdatedAt
        dict["isStarred"] = note.isStarred
        
        
        return dict
    }
    
    func updateNote(_ docId: String, isStarred: Bool){
        
        let db = Firestore.firestore()
        
        db.collection("notes").document(docId).updateData(["isStarred" : isStarred])
        
    }
    
}
