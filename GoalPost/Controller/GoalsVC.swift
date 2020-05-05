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
        fetch { (success) in
            if success {
                tableView.reloadData()
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
    
}

extension GoalsVC {
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            goals = try manageContext.fetch(fetchRequest) as! [Goal]
            completion(true)
        } catch {
            debugPrint("Could not fetch data: \(error.localizedDescription)")
            completion(false)
        }
    }
}
