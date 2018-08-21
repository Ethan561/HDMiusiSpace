//
//  HDLY_CourseList_SubVC3.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/17.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_CourseList_SubVC3: HDItemBaseVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buyBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        buyBtn.layer.cornerRadius = 28
        // Do any additional setup after loading the view.
    }

    @IBAction func buyBtnAction(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
