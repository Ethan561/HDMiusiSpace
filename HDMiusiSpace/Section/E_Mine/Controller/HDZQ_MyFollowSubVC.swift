//
//  HDZQ_MyFollowSubVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/22.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_MyFollowSubVC: HDItemBaseVC {

    private var dataArr =  [MyFollowModel]()
    public var type = 1 // 1,2
    
    private var viewModel = HDZQ_MyViewModel()
    
    lazy var tableView: UITableView = {
        let tableView:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-44), style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.HexColor(0xF1F1F1)
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowNavShadowLayer = false
        tableView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - kTopHeight)
        view.addSubview(self.tableView)
        tableView.register(UINib.init(nibName: "HDZQ_MyFollowCell", bundle: nil), forCellReuseIdentifier: "HDZQ_MyFollowCell")
        bindViewModel()
        viewModel.requestMyFollow(apiToken: HDDeclare.shared.api_token ?? "", skip: 0, take: 10, type: type, vc: self)
    }
    
    func bindViewModel() {
        viewModel.follows.bind { [weak self] (models) in
            if models.count > 0 {
                self?.dataArr = models
                self?.tableView.reloadData()
            } else {
                self?.tableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
                self?.tableView.ly_showEmptyView()
            }
        }
    }
    
}

extension HDZQ_MyFollowSubVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "HDZQ_MyFollowCell") as? HDZQ_MyFollowCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("HDZQ_MyFollowCell", owner: nil, options: nil)?.last as? HDZQ_MyFollowCell
        }
        cell?.setCellWithModel(model: model)
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == 2 {
            let storyBoard = UIStoryboard.init(name: "RootE", bundle: Bundle.main)
            let vc: HDZQ_OthersCenterVC = storyBoard.instantiateViewController(withIdentifier: "HDZQ_OthersCenterVC") as! HDZQ_OthersCenterVC
            let model = dataArr[indexPath.row]
            vc.toid = model.toid
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
