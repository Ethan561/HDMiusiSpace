//
//  HDMyGamePrizeDetailVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2020/8/7.
//  Copyright © 2020 hengdawb. All rights reserved.
//

import UIKit

class HDMyGamePrizeDetailVC: HDItemBaseVC {
    public var order_sn:String!
    private var tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: .plain)
    private var prizeModel: PrizeListModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "HDMyGamePrizeQRCodeCell", bundle: nil), forCellReuseIdentifier: "HDMyGamePrizeQRCodeCell")
        tableView.register(UINib.init(nibName: "HDMyGamePrizeInfoCell", bundle: nil), forCellReuseIdentifier: "HDMyGamePrizeInfoCell")
        getDetail()
    }
    
    
    func getDetail() {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getMyGamePrizeDetail(api_token: HDDeclare.shared.api_token ?? "", id: order_sn), success: { (result) in
            let jsonDecoder = JSONDecoder()
            let model:PrizeDetailData = try! jsonDecoder.decode(PrizeDetailData.self, from: result)
            self.prizeModel = model.data!
            self.tableView.reloadData()
        }) { (error, msg) in
            
        }
    }
    
}

extension HDMyGamePrizeDetailVC:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.prizeModel.go_status == "5" {
                return 0
            } else {
                return 1
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HDMyGamePrizeQRCodeCell") as! HDMyGamePrizeQRCodeCell
            cell.qrImgV.kf.setImage(with: URL(string: self.prizeModel.qrcode!), placeholder: UIImage(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HDMyGamePrizeInfoCell") as! HDMyGamePrizeInfoCell
            cell.orderSnLabel.text = prizeModel.order_sn
            cell.positionL.text = prizeModel.museum_name
            cell.poiL.text = prizeModel.pos_info
            cell.timeL.text = prizeModel.start_time
            cell.getPrizeTimeL.text = prizeModel.complete_time
            if prizeModel.go_status == "33" {
              
            } else {
               
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 340
        } else {
            return 275
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.HexColor(0xF3F5F9)
        return footer
    }
    
}
