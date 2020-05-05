//
//  GoalsVC.swift
//  GoalPost
//
//  Created by Mariah Baysic on 5/3/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    
    var goals : [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
        tableView.reloadData()
    }
    
    func fetchCoreDataObjects() {
        fetch { (success) in
            if success {
                tableView.isHidden = !(goals.count > 0)
            }
        }
    }

    @IBAction func addGoalBtnPressed(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(identifier: "createGoalVC") else { return }
        presentDetail(vc: createGoalVC)
    }

}

extension GoalsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else { return GoalCell() }
        cell.configureCell(goal: goals[indexPath.row])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (rowAction, view, success) in
            self.removeGoal(indexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        deleteAction.image = UIImage(systemName: "trash")
        
        let addAction = UIContextualAction(style: .normal, title: "") { (rowAction, view, success) in
            self.setProgress(indexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.reloadData()
        }
        
        addAction.backgroundColor = #colorLiteral(red: 0.9385011792, green: 0.7164435983, blue: 0.3331357837, alpha: 1)
        addAction.image = UIImage(systemName: "plus")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, addAction])
        return swipeActions
    }
    
}

extension GoalsVC {
    func setProgress(indexPath: IndexPath) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let chosenGoal = goals[indexPath.row]
        
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress += 1
            
            do {
                try manageContext.save()
            } catch {
                debugPrint("Could not set progress: \(error.localizedDescription)")
            }
        } else {
            return
        }
    }
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            goals = try manageContext.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint("Could not fetch data: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func removeGoal(indexPath: IndexPath) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        
        manageContext.delete(goals[indexPath.row])
        
        do {
            try manageContext.save()
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
}
