//
//  FinishGoalVC.swift
//  GoalPost
//
//  Created by Mariah Baysic on 5/5/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class FinishGoalVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var createGoalBtn: UIButton!
    @IBOutlet weak var pointsTxtFld: UITextField!
    
    var goalDescription : String!
    var goalType : GoalType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGoalBtn.bindToKeyboard()
        
        pointsTxtFld.delegate = self
    }
    
    func initData(description: String, type: GoalType) {
        self.goalDescription = description
        self.goalType = type
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func createGoalBtnPressed(_ sender: Any) {
    }
    
}
