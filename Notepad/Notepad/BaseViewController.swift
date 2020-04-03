//
//  BaseViewController.swift
//  Notepad
//
//  Created by adcapsule on 2020/02/15.
//  Copyright © 2020 shAhn. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

enum NoteViewType: Int {
    case DEFAULT
    case ADD
    case UPDATE
    case VIEW
}


class BaseViewController: UIViewController {

    var disPoseBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Enable swipe back when no navigation bar
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
  
        
        
    }
    
    
    
 

}
