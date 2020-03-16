//
//  ViewController.swift
//  Notepad
//
//  Created by adcapsule on 2020/02/15.
//  Copyright © 2020 shAhn. All rights reserved.
//

import RxCocoa
import RxSwift
import RxDataSources
import UIKit

class ViewController: BaseViewController {
    
    @IBOutlet var goNoteBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            return
        }
        
        let managedContext = appDelegate.presistentContainer.viewContext
        StorageModel.storage.setManagedContext(managedObjContext: managedContext)
        
        
        
        initObserver()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }

    
    func initObserver() {
        self.goNoteBtn.rx.tap
            .asObservable()
            .subscribe(onNext: { (_) in
                let vc = Utilty.shared.getStoryboardWithController(strSBName: "Main", strControllerName: "NoteViewController") as! NoteViewController
                self.noteViewType.accept(.ADD)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disPoseBag)
    }
    
    private func convertDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let str = formatter.string(from: date)
        let strDate = formatter.date(from: str)!
        
        formatter.dateFormat = "EEEE, MMM, d, yyyy, hh:mm:ss"
        return formatter.string(from: strDate)
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StorageModel.storage.count()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell

        if let dataModel = StorageModel.storage.readNote(at: indexPath.row) {
            cell.titleLb.text = dataModel.noteTitle
            cell.contentLb.text = dataModel.noteText
            cell.writeDateLb.text = convertDate(date: Date(seconds: dataModel.noteTimeStamp))
                
        }

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageModel.storage.removeNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Utilty.shared.getStoryboardWithController(strSBName: "Main", strControllerName: "NoteViewController") as! NoteViewController
        vc.setUpdateNoteDataModel(dataModel: StorageModel.storage.readNote(at: indexPath.row))
        
        self.noteViewType.accept(.UPDATE)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
