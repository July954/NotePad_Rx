//
//  NotePadDataHelper.swift
//  Notepad
//
//  Created by adcapsule on 2020/02/17.
//  Copyright © 2020 shAhn. All rights reserved.
//

import UIKit
import CoreData

class NotePadDataHelper {

    private(set) static var count:Int = 0
    
    static func createNotePadCoreData(notepadToBeCreated: NotePadDataModel, intoManagedObjectContext: NSManagedObjectContext) {
        
        let noteEntity = NSEntityDescription.entity(forEntityName: "Note", in: intoManagedObjectContext)!
        let newNoteToBeCreated = NSManagedObject(entity: noteEntity, insertInto: intoManagedObjectContext)
        
        newNoteToBeCreated.setValue(notepadToBeCreated.noteId, forKey: "noteId")
        newNoteToBeCreated.setValue(notepadToBeCreated.noteTitle, forKey: "noteTitle")
        newNoteToBeCreated.setValue(notepadToBeCreated.noteText, forKey: "noteText")
        newNoteToBeCreated.setValue(notepadToBeCreated.noteImage, forKey: "noteImage")
        newNoteToBeCreated.setValue(notepadToBeCreated.noteTimeStamp, forKey: "noteTimeStamp")
        
        
        do {
            try intoManagedObjectContext.save()
            count += 1
        } catch (let error as NSError?) {
            if error != nil {
                print("createNotePadCoreData Error ::: \(error!.localizedDescription)")
            }
        }
    }
    
    static func updateNoteCoreData(notepadToBeChanged: NotePadDataModel, intoManagedObjectContext: NSManagedObjectContext) {
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let noteIdPredicate = NSPredicate(format: "noteId = %@", notepadToBeChanged.noteId as CVarArg)
        
        fetchReq.predicate = noteIdPredicate
        
        do {
            let fetchedNoteFromCoreData = try intoManagedObjectContext.fetch(fetchReq)
            let noteManagedObjToBeChanged = fetchedNoteFromCoreData[0] as! NSManagedObject
            
            noteManagedObjToBeChanged.setValue(notepadToBeChanged.noteTitle, forKey: "noteTitle")
            noteManagedObjToBeChanged.setValue(notepadToBeChanged.noteText, forKey: "noteText")
            noteManagedObjToBeChanged.setValue(notepadToBeChanged.noteImage, forKey: "noteImage")
            noteManagedObjToBeChanged.setValue(notepadToBeChanged.noteTimeStamp, forKey: "noteTimeStamp")
            
            try intoManagedObjectContext.save()
            
        } catch (let error as NSError?) {
            if error != nil {
                print("updateNoteCoreData Error ::: \(error!.localizedDescription)")
            }
        }
    }
    static func readNotesFromCoreData(fromManagedObjContext: NSManagedObjectContext) -> [NotePadDataModel] {
        
        var notes = [NotePadDataModel]()
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        fetchReq.predicate = nil
        
        do {
            let fetchedNotesFromCoreData = try fromManagedObjContext.fetch(fetchReq)
            fetchedNotesFromCoreData.forEach { (result) in
                let noteManagedObjToBeRead = result as! NSManagedObject
                notes.append(NotePadDataModel.init(noteId: noteManagedObjToBeRead.value(forKey: "noteId") as! UUID,
                                                   noteTitle: noteManagedObjToBeRead.value(forKey: "noteTitle") as! String,
                                                   noteText: noteManagedObjToBeRead.value(forKey: "noteText") as! String,
                                                   noteImage: noteManagedObjToBeRead.value(forKey: "noteImage") as? [Data],
                                                   noteTimeStamp: noteManagedObjToBeRead.value(forKey: "noteTimeStamp") as! Int64))
            }
        } catch (let error as NSError?) {
            if error != nil {
                print("readNotesFromCoreData Error ::: \(error!.localizedDescription)")
            }
        }
        
        self.count = notes.count
        
        return notes
    }
    
    static func readNoteFromCoreData(noteIdToBeRead: UUID, fromManagedObjContext: NSManagedObjectContext) -> NotePadDataModel? {
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let noteIdPredicate = NSPredicate(format: "noteId = %@", noteIdToBeRead as CVarArg)
        
        fetchReq.predicate = noteIdPredicate
        
        
        do {
            let fetchedNotesFromCoreData = try fromManagedObjContext.fetch(fetchReq)
            let noteManagedObjToBeRead = fetchedNotesFromCoreData[0] as! NSManagedObject
            
            return NotePadDataModel.init(noteId: noteManagedObjToBeRead.value(forKey: "noteId") as! UUID,
                                         noteTitle: noteManagedObjToBeRead.value(forKey: "noteTitle") as! String,
                                         noteText: noteManagedObjToBeRead.value(forKey: "noteText") as! String,
                                         noteImage: noteManagedObjToBeRead.value(forKey: "noteImage") as? [Data],
                                         noteTimeStamp: noteManagedObjToBeRead.value(forKey: "noteTimeStamp") as! Int64)

        } catch (let error as NSError?) {
           if error != nil {
                print("readNoteFromCoreData Error ::: \(error!.localizedDescription)")
            }
            return nil
        }
    }
    
    static func deleteNoteFromCoreData(noteIdToBeDelete: UUID, fromManagedObjContext: NSManagedObjectContext) {
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        let noteId = noteIdToBeDelete as CVarArg
        let noteIdPredicate = NSPredicate(format: "noteId == %@", noteId)
        
        fetchReq.predicate = noteIdPredicate
        
        do {
            let fetchedNoteFromCoreData = try fromManagedObjContext.fetch(fetchReq)
            let noteManagedObjToBeDelete = fetchedNoteFromCoreData[0] as! NSManagedObject
            fromManagedObjContext.delete(noteManagedObjToBeDelete)
            
            do {
                try fromManagedObjContext.save()
                self.count -= 1
            } catch (let error as NSError?) {
                if error != nil {
                    print("deleteNoteFromCoreData ::: fromManagedObjContext Error ::: \(error!.localizedDescription)")
                }
            }
        } catch  (let error as NSError?) {
            if error != nil {
                print("deleteNoteFromCoreData Error ::: \(error!.localizedDescription)")
            }
        }
    }
}
