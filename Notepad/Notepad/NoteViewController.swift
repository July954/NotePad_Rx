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

class NoteViewController: BaseViewController, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet var goBackBtn: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tfTitle: UITextField!
    @IBOutlet var tvContent: UITextView!
    @IBOutlet var btnDone: UIButton!
    
    private(set) var updateNotePadDataModel: NotePadDataModel?
    private let timeStamp: Int64 = Date().toSeconds()
    private var isKeyBoardUP: Bool = false
    
    var currentType: NoteViewType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: UIWindow.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: UIWindow.keyboardWillShowNotification, object: nil)
        
        
        initObserver()
        noteViewSetting()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func keyboardWillHideNotification(_ notification: NSNotification) {
//        buttonMovementAction(false, notification)
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillShowNotification(_ notification: NSNotification) {
//        buttonMovementAction(true, notification)
        
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height - 20
        scrollView.contentInset = contentInset
    }
    
    func initObserver() {
        
        self.goBackBtn.rx.tap
            .asObservable()
            .subscribe(onNext: { (_) in
                self.navigationController?.popViewController(animated: true)
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
        
        self.tfTitle.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .subscribe(onNext: { (_) in
                self.tfTitle.resignFirstResponder()
            })
            .disposed(by: disPoseBag)
        
        self.tfTitle.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { (_) in
                if self.updateNotePadDataModel != nil {
                    //update
                    self.doneBtnState(enable: true)
                } else {
                    //create
                    if (self.tfTitle.text?.isEmpty ?? true) || (self.tvContent.text.isEmpty) {
                        self.doneBtnState(enable: false)
                    } else {
                        self.doneBtnState(enable: true)
                    }
                }
            })
            .disposed(by: disPoseBag)
        
        
        self.tvContent.rx.didChange
            .asObservable()
            .subscribe(onNext: { (_) in
                if self.updateNotePadDataModel != nil {
                    //update
                    self.doneBtnState(enable: true)
                } else {
                    //create
                    if (self.tfTitle.text?.isEmpty ?? true) || (self.tvContent.text.isEmpty) {
                        self.doneBtnState(enable: false)
                    } else {
                        self.doneBtnState(enable: true)
                    }
                }
            })
            .disposed(by: disPoseBag)
        
        
        
    }
    
    //NoteType별 Editable Setting
    private func noteViewSetting() {
        switch self.currentType {
        case .ADD:
            self.tfTitle.isEnabled = true
            self.tvContent.isEditable = true
            self.doneBtnState(enable: false)
            self.btnDone.isHidden = false
            Utilty.shared.print(output: "add")
        case .UPDATE:
            self.setUpDataUpdateState()
            self.tfTitle.isEnabled = true
            self.tvContent.isEditable = true
            self.doneBtnState(enable: false)
            self.btnDone.isHidden = false
            Utilty.shared.print(output: "UPDATE")
        default :
            self.tfTitle.isEnabled = true
            self.tvContent.isEditable = true
            self.doneBtnState(enable: false)
            self.btnDone.isHidden = true
            Utilty.shared.print(output: "default")
        }
        
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
            self.navigationController?.popViewController(animated: true)
        } else {
            CommonAlert.showAlertType1(vc: self, title: "오류", message: "저장에 실패했습니다. 잠시후 다시 시도해 주세요", completeTitle: "확인") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func doneBtnState(enable: Bool) {
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
    
    
    func buttonMovementAction(_ isUp: Bool, _ with: NSNotification) {
        if self.tvContent.isFirstResponder {
            if !(isKeyBoardUP && isUp){
                if let userInfo = with.userInfo {
                    let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                    let durateion = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
                    let animationOptions = UIView.KeyframeAnimationOptions(rawValue: (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).uintValue)
                    
                    
                    let frame = self.btnDone.frame
                    let rect: CGRect = CGRect(x: frame.origin.x,
                                              y: frame.origin.y + endFrame.size.height * (isUp ? -1 : 1),
                                              width: frame.size.width,
                                              height: frame.size.height)
                    
                    
                    self.isKeyBoardUP = isUp
                    self.btnDone.frame = rect
                    
                    UIView.animateKeyframes(withDuration: durateion, delay: 0.0, options: animationOptions, animations: {
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                }
            }
        }
    }
    
}
