//
//  HDZQ_MyFootprintVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/24.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_MyFootprintVC: HDItemBaseVC {

    private var dayList = [FootprintModel]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 400
        requestFootPrintData()
    }
}

extension HDZQ_MyFootprintVC {
    func requestFootPrintData() {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getMyFootPrint(api_token: HDDeclare.shared.api_token ?? "", skip: 0, take: 10), success: { (result) in
            let jsonDecoder = JSONDecoder()
            guard let model:FootprintData = try? jsonDecoder.decode(FootprintData.self, from: result) else { return }
            self.dayList = model.data
            self.tableView.reloadData()
        }) { (error, msg) in
            
        }
    }
}

extension HDZQ_MyFootprintVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dayList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dayList[section].list_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dayList[indexPath.section].list_data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HDZQ_FoorprintCell") as? HDZQ_FoorprintCell
        cell?.exhibitionLabel.text = model.museum_title
        cell?.exhibitionTitleLabel.text = model.exhibition_title
        cell?.setupExhibitView(model:model)
        cell?.setupCellViews(model: model)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let date = dayList[section]
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as? HDZQ_FPSectionHeaderView
        if header == nil {
            header = HDZQ_FPSectionHeaderView.init(reuseIdentifier: "sectionHeader")
        }
        header!.setDateData(date:date.look_date!)
        if section == 0 {
            header?.topLineView.isHidden = true
        } else {
            header?.topLineView.isHidden = false
        }
        return header
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dayList[indexPath.section].list_data[indexPath.row]
        if model.class_list.count > 0 {
            return CGFloat(90 + 55 * model.exhibit_list.count + 45 + 150 + 20)
        } else {
            return CGFloat(90 + 55 * model.exhibit_list.count + 20)
        }
    }
    
}

//MARK:使seactionheader跟随tableview一起滑动
extension HDZQ_MyFootprintVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeaderHeight: CGFloat = 45 //这里是我的headerView和footerView的高度
        if tableView.contentOffset.y <= sectionHeaderHeight && tableView.contentOffset.y >= 0 {
            tableView.contentInset = UIEdgeInsetsMake(-tableView.contentOffset.y, 0, 0, 0)
        } else if tableView.contentOffset.y >= sectionHeaderHeight {
            tableView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0)
        }
    }
}

extension HDZQ_MyFootprintVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}


class HDZQ_FoorprintCell: UITableViewCell {
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var exhibitionTitleLabel: UILabel!
    @IBOutlet weak var exhibitionLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    public var exhibitContentView = UIView()
    public var classContentView = UIView()
    public var model = FPContent()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(exhibitContentView)
        classContentView.backgroundColor = UIColor.white
        self.addSubview(classContentView)
    }
    
    func setupExhibitView(model:FPContent) {
        if model.exhibit_list.count > 0 {
            let x = exhibitionLabel.ly_left
            let y = Int(exhibitionLabel.ly_bottom) + 20
            let height = 44
            let width  = 220
            exhibitContentView.removeAllSubviews()
            exhibitContentView.frame = CGRect.init(x:Int(x), y: y, width: width, height: (height + 10) * model.exhibit_list.count)
            for i in 0..<model.exhibit_list.count {
                let margin:Int = (height + 10) * i
                let exhibitView = UIView.init(frame: CGRect.init(x: 0, y: margin, width: width, height: height))
                exhibitView.layer.cornerRadius = 22.0
                
                let exhibitLabel = UILabel.init(frame: CGRect.init(x: 20, y: 12, width: 150, height: 20))
                exhibitLabel.font = UIFont.systemFont(ofSize: 14.0)
                exhibitLabel.text = model.exhibit_list[i].exhibit_title
                exhibitLabel.textColor = .white
                
                let playBtn = UIButton.init(frame: CGRect.init(x: width - 43, y: 1, width: 42, height: 42))
                playBtn.setImage(UIImage.init(named: "wd_dlzj_paly"), for: .normal)
                playBtn.setImage(UIImage.init(named: "wd_dlzj_pause"), for: .selected)
                exhibitView.addSubview(playBtn)
                exhibitView.addSubview(exhibitLabel)
                exhibitView.backgroundColor = UIColor.HexColor(0xE8593E)
                exhibitContentView.addSubview(exhibitView)
            }
        } else {
            exhibitContentView.frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
            exhibitContentView.isHidden = true
        }
    }
    
    func setupCellViews(model:FPContent) {
        let x = exhibitionLabel.ly_left
        let y = Int(exhibitContentView.ly_bottom) + 15
        let height = 180
        let width  = Int(ScreenWidth - 60)
        if model.class_list.count > 0 {
            classContentView.removeAllSubviews()
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 25))
            label.font = UIFont.systemFont(ofSize: 18.0)
            label.textColor = UIColor.HexColor(0x4A4A4A)
            label.text = "相关课程"
            self.model = model
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 15
            layout.minimumInteritemSpacing = 15
            layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
            layout.itemSize = CGSize(width: 140, height:150)
            
            let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 30, width: width, height: 150), collectionViewLayout: layout)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib.init(nibName: "HDZQ_RelatedClassCell", bundle: nil), forCellWithReuseIdentifier: "HDZQ_RelatedClassCell")
            collectionView.backgroundColor = .white
            classContentView.addSubview(collectionView)
            classContentView.addSubview(label)
            classContentView.frame = CGRect.init(x:Int(x), y: y, width: width, height: height)
        } else {
            classContentView.frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
            classContentView.isHidden = true
        }
    }
    
}

extension HDZQ_FoorprintCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.class_list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.model.class_list[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HDZQ_RelatedClassCell", for: indexPath) as? HDZQ_RelatedClassCell
        cell?.exhibitTitleLabel.text = model.title
        cell?.teacherLabel.text = model.teacher_name
        cell?.exhibitImageView.kf.setImage(with: URL.init(string: model.img!))
        return cell!
    }
    
    
}

extension HDZQ_FoorprintCell:UICollectionViewDelegate {
    
}
