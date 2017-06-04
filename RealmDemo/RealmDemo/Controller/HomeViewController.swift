//
//  HomeViewController.swift
//  RealmDemo
//
//  Created by Mahesh on 18/05/17.
//  Copyright © 2017 TestProject. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController , UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var selectionSegmentControl: UISegmentedControl!

    var userLessionList : [UserLessionsRealmModel] = []

    let homeCellIdentifier = "HomeMainTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Home"
        // Do any additional setup after loading the view, typically from a nib.
        mainTableView.register(UINib(nibName: "HomeMainTableViewCell", bundle: nil), forCellReuseIdentifier: homeCellIdentifier)

        selectionSegmentControl.selectedSegmentIndex = 0
        segmentIndexChanged(sender: selectionSegmentControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.userLessionList.count);
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44;//Choose your custom row height
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HomeMainTableViewCell = mainTableView.dequeueReusableCell(withIdentifier: homeCellIdentifier) as! HomeMainTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let userLessionsRealmModel = self.userLessionList[indexPath.row] as UserLessionsRealmModel!;
        cell.lessonTitleLabel.text = userLessionsRealmModel?.lessionTitle
        
        cell.lessonStatusLabel.text = userLessionsRealmModel?.status
        
        return cell
    }
    
    
    @IBAction func segmentIndexChanged(sender:UISegmentedControl)
    {
        let title = sender.titleForSegment(at: sender.selectedSegmentIndex)
        let selector = NSSelectorFromString(title!)
        if responds(to: selector) {
            clearStack()
            perform(selector)
        } else {
            GLOBAL.sharedInstance.showAlert(APPLICATION.applicationName, message: "Method does not exist!", actions: nil)
        }
        
    }
    
    // MARK : Clear List
    func clearStack()  {
        if (self.userLessionList.count) > 0 {
            self.userLessionList.removeAll()
        }
    }
    
    // MARK : Find Completed Lessions
    func completed() {
        let bodyParams: [String: AnyObject] = [UserLessionStatus.statusKey: UserLessionStatus.completed as String as AnyObject]
        refreshList(bodyParams)

    }
    
    // MARK : Find Pending Lessions
    func pending() {
        let bodyParams: [String: AnyObject] = [UserLessionStatus.statusKey: UserLessionStatus.pending as String as AnyObject]
        refreshList(bodyParams)
    }
    
    // MARK : Refresh List
    func refreshList(_ bodyParameters: [String: AnyObject]?)  {
        self.userLessionList = RealmHelper.sharedInstance.getUserLessonList(bodyParameters)!
        self.mainTableView.reloadData()
        
    }
    

}


