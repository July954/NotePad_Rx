//
//  NotePadDataModel.swift
//  Notepad
//
//  Created by adcapsule on 2020/02/17.
//  Copyright © 2020 shAhn. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

struct SectionCustomModel: SectionModelType {
    typealias Item = NotePadDataModel
    var items: [Item]
    
    init(original: SectionCustomModel, items: [Item]) {
        self.items = items
    }
}

class NotePadDataModel {
    
    private(set) var noteId       : UUID
    private(set) var noteTitle    : String
    private(set) var noteText     : String
    private(set) var noteImage    : [Data]?
    private(set) var noteTimeStamp: Int64
    
    
    init(noteTitle: String, noteText: String, noteImage: [Data]? = nil, noteTimeStamp: Int64) {
        self.noteId = UUID()
        self.noteTitle = noteTitle
        self.noteText = noteText
        self.noteImage = noteImage
        self.noteTimeStamp = noteTimeStamp
    }
    
    init(noteId: UUID, noteTitle: String, noteText: String, noteImage: [Data]? = nil, noteTimeStamp: Int64 ) {
        self.noteId = noteId
        self.noteTitle = noteTitle
        self.noteText = noteText
        self.noteImage = noteImage
        self.noteTimeStamp = noteTimeStamp
    }

}
