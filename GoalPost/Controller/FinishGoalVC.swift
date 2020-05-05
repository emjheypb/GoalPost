//
//  FinishGoalVC.swift
//  GoalPost
//
//  Created by Mariah Baysic on 5/5/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit
import CoreData

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
    
    func saveData(completion: (_ finished: Bool) -> ()) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        let goal = Goal(context: manageContext)
        
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue
        goal.goalCompletionValue = Int32(pointsTxtFld.text!)!
        goal.goalProgress = Int32(0)
        
        do {
            try manageContext.save()
            completion(true)
        } catch {
            debugPrint("Could not Save : \(error.localizedDescription)")
            completion(false)
        }
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func createGoalBtnPressed(_ sender: Any) {
        if pointsTxtFld.text != "" {
            saveData { (success) in
                if success {
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}
