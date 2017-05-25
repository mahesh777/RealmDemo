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

    var userLessionList : [UserLessionsRealmModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Home"
        // Do any additional setup after loading the view, typically from a nib.
        mainTableView.register(UINib(nibName: "HomeMainTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeMainTableViewCell")

        selectionSegmentControl.selectedSegmentIndex = 0
        segmentIndexChanged(sender: selectionSegmentControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.userLessionList!.count);
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44;//Choose your custom row height
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HomeMainTableViewCell = mainTableView.dequeueReusableCell(withIdentifier: "HomeMainTableViewCell") as! HomeMainTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let userLessionsRealmModel = self.userLessionList?[indexPath.row] as UserLessionsRealmModel!;
        cell.lessonTitleLabel.text = userLessionsRealmModel?.lessionTitle
        
        cell.lessonStatusLabel.text = userLessionsRealmModel?.status
        
        return cell
    }
    
    
    @IBAction func segmentIndexChanged(sender:UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
            case 0:
 
                if self.userLessionList != nil {
                    if (self.userLessionList?.count)! > 0 {
                        self.userLessionList?.removeAll()
                    }
                }
                self.userLessionList = RealmHelper.sharedInstance.getUserLessonList(UserInfo.sharedInstance.getUserDefault(key: UserInfoKeys.userID) as! String, isCompleted: true)
                self.mainTableView.reloadData()

                break;
            case 1:
                
                if (self.userLessionList?.count)! > 0 {
                    self.userLessionList?.removeAll()
                }
                
                self.userLessionList = RealmHelper.sharedInstance.getUserLessonList(UserInfo.sharedInstance.getUserDefault(key: UserInfoKeys.userID) as! String, isCompleted: false)
                self.mainTableView.reloadData()
                break;
            default:
                break;
        }
    }
    
}


