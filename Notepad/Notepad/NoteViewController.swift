//
//  NoteViewController.swift
//  Notepad
//
//  Created by adcapsule on 2020/02/15.
//  Copyright © 2020 shAhn. All rights reserved.
//

import UIKit
import RxCocoa
import RxKeyboard
import RxSwift

class NoteViewController: BaseViewController, UITextViewDelegate {
    
    @IBOutlet var goBackBtn: UIButton!
    @IBOutlet var tfTitle: UITextField!
    @IBOutlet var tvContent: UITextView!
    @IBOutlet var btnDone: UIButton!
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    private(set) var updateNotePadDataModel: NotePadDataModel?
    private let timeStamp: Int64 = Date().toSeconds()
    
    private var currentType: NoteViewType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
  
        initObserver()
    }
    
    
    func initObserver() {
        
     
        self.goBackBtn.rx.tap
            .asObservable()
            .subscribe(onNext: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disPoseBag)
        
        //NoteType별 Editable Setting
        self.noteViewType
            .subscribe(onNext: { (type) in
                switch type {
                case .ADD:
                    self.tfTitle.isEnabled = true
                    self.tvContent.isEditable = true
                    self.donBtnState(enable: false)
                    self.btnDone.isHidden = false
                    
                    Utilty.shared.print(output: "add")
                case .UPDATE:
                    self.tfTitle.isEnabled = true
                    self.tvContent.isEditable = true
                    self.donBtnState(enable: false)
                    self.btnDone.isHidden = false
                    Utilty.shared.print(output: "UPDATE")
                    self.setUpDataUpdateState()
                case .VIEW:
                    self.tfTitle.isEnabled = false
                    self.tvContent.isEditable = false
                    self.donBtnState(enable: false)
                    self.btnDone.isHidden = true
                    Utilty.shared.print(output: "VIEW")
                default :
                    self.tfTitle.isEnabled = false
                    self.tvContent.isEditable = false
                    self.donBtnState(enable: false)
                    self.btnDone.isHidden = true
                    Utilty.shared.print(output: "default")
                }
                
                self.currentType = type
            })
            .disposed(by: disPoseBag)
        
        self.btnDone.rx.tap
            .asObservable()
            .subscribe(onNext: {
                if self.updateNotePadDataModel != nil {
                    self.updateNotePadData()
                } else {
                    self.addNotePadData()
                }
            })
            .disposed(by: disPoseBag)
        
        self.tfTitle.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { (_) in
                if self.updateNotePadDataModel != nil {
                    //update
                    self.donBtnState(enable: true)
                } else {
                    //create
                    if (self.tfTitle.text?.isEmpty ?? true) || (self.tvContent.text.isEmpty) {
                        self.donBtnState(enable: false)
                    } else {
                        self.donBtnState(enable: true)
                    }
                }
            })
            .disposed(by: disPoseBag)
   
    }
    
    func setUpdateNoteDataModel(dataModel: NotePadDataModel?) {
        self.updateNotePadDataModel = dataModel
    }
    
    private func setUpDataUpdateState() {
        if let model = updateNotePadDataModel {
            self.tfTitle.text = model.noteTitle
            self.tvContent.text = model.noteText
            //이미지 추가하기
        }
    }
    
    private func addNotePadData() {
        let note = NotePadDataModel(noteTitle: tfTitle.text!, noteText: tvContent.text, noteTimeStamp: timeStamp)
        StorageModel.storage.addNote(noteToBeAdded: note)
        self.navigationController?.popViewController(animated: true)
    }

    private func updateNotePadData() {
        if let notePadDataModel = self.updateNotePadDataModel {
            let note = NotePadDataModel(noteId: notePadDataModel.noteId, noteTitle: tfTitle.text!, noteText: tvContent.text, noteTimeStamp: timeStamp)
            //이미지 추가하기
            StorageModel.storage.updateNote(noteToBeChanged: note)
        } else {
            CommonAlert.showAlertType1(vc: self, title: "오류", message: "저장에 실패했습니다. 잠시후 다시 시도해 주세요", completeTitle: "확인") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func donBtnState(enable: Bool) {
        if enable {
            self.btnDone.titleLabel?.textColor = Utilty.shared.rgbToUIColor(red: 10, green: 10, blue: 150)
            self.btnDone.isEnabled = true
        } else {
            self.btnDone.titleLabel?.textColor = UIColor.gray
            self.btnDone.isEnabled = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.updateNotePadDataModel != nil {
            //update
            self.donBtnState(enable: true)
        } else {
            //create
            if (self.tfTitle.text?.isEmpty ?? true) || (self.tvContent.text.isEmpty) {
                self.donBtnState(enable: false)
            } else {
                self.donBtnState(enable: true)
            }

        }
    }
    
    

}
