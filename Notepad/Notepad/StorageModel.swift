//
//  StorageModel.swift
//  Notepad
//
//  Created by adcapsule on 2020/02/17.
//  Copyright © 2020 shAhn. All rights reserved.
//

import UIKit
import CoreData

class StorageModel {

    static let storage: StorageModel = StorageModel()
    
    private var noteIndex: [Int:UUID] = [:]
    private var currentIndex: Int = 0
    
    private(set) var managedObjContext: NSManagedObjectContext
    private var managedContextSetFlag: Bool = false
    
    private init() {
        managedObjContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    }
    
    func setManagedContext(managedObjContext: NSManagedObjectContext) {
        self.managedObjContext = managedObjContext
        self.managedContextSetFlag = true
        let note = NotePadDataHelper.readNotesFromCoreData(fromManagedObjContext: self.self.managedObjContext)
        currentIndex = NotePadDataHelper.count
        
        for (index, note) in note.enumerated() {
            noteIndex[index] = note.noteId
        }
    }
    
    func addNote(noteToBeAdded: NotePadDataModel) {
        if managedContextSetFlag {
            noteIndex[currentIndex] = noteToBeAdded.noteId
            NotePadDataHelper.createNotePadCoreData(notepadToBeCreated: noteToBeAdded, intoManagedObjectContext: self.managedObjContext)
            
            currentIndex += 1
        }
    }

    func removeNote(at: Int) {
        if managedContextSetFlag {
            if at < 0 || at > currentIndex-1 {
                return
            }
            
            let noteUUID = noteIndex[at]
            NotePadDataHelper.deleteNoteFromCoreData(noteIdToBeDelete: noteUUID!, fromManagedObjContext: self.managedObjContext)

            if (at < currentIndex - 1) {

                for i in at ... currentIndex - 2 {
                    noteIndex[i] =  noteIndex[i+1]
                }
            }

            noteIndex.removeValue(forKey: currentIndex)

            currentIndex -= 1
        }
    }
    
    func readNote(at: Int) -> NotePadDataModel? {
        if managedContextSetFlag {
            if at < 0 || at > currentIndex-1 {
                return nil
            }
            let noteUUID = noteIndex[at]
            let noteReadFromCoreData: NotePadDataModel?
            noteReadFromCoreData = NotePadDataHelper.readNoteFromCoreData(noteIdToBeRead: noteUUID!, fromManagedObjContext: self.managedObjContext)
            return noteReadFromCoreData
        }
        return nil
    }
    
    
    func updateNote(noteToBeChanged: NotePadDataModel) {
        if managedContextSetFlag {
            var noteToBeChangedIndex : Int?
            noteIndex.forEach { (index: Int, noteId: UUID) in
                if noteId == noteToBeChanged.noteId {
                    noteToBeChangedIndex = index
                    return
                }
            }
            if noteToBeChangedIndex != nil {
                NotePadDataHelper.updateNoteCoreData(notepadToBeChanged: noteToBeChanged, intoManagedObjectContext: self.managedObjContext)
            } else {
                
            }
        }
    }
    
    func count() -> Int {
        return NotePadDataHelper.count
    }
    
}
