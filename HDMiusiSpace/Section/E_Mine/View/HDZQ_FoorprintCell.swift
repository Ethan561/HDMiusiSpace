//
//  HDZQ_FoorprintCell.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/12/1.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

protocol HDZQ_FPExhibitPlayActionDelegate:NSObjectProtocol {
    func exhibitPlayAction(index:IndexPath,row:Int,idxStrig:String,url:String)
}

class HDZQ_FoorprintCell: UITableViewCell {
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var exhibitionTitleLabel: UILabel!
    @IBOutlet weak var exhibitionLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    weak var delegate: HDZQ_FPExhibitPlayActionDelegate?
    public var index = IndexPath()
    public var currentIndex : String?
    public var exhibitContentView = UITableView()
    public var classContentView = UIView()
    public var classCollectionView : UICollectionView?
    public var lab = UILabel()
    public var model = FPContent()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(exhibitContentView)
//        exhibitContentView.delegate = self
        exhibitContentView.dataSource = self
        exhibitContentView.rowHeight = 54
        exhibitContentView.separatorStyle = .none
        classContentView.backgroundColor = UIColor.white
        self.addSubview(classContentView)
    
        let width  = Int(ScreenWidth - 60)
        
        lab = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 25))
        lab.font = UIFont.systemFont(ofSize: 18.0)
        lab.textColor = UIColor.HexColor(0x4A4A4A)
        lab.text = "相关课程"
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: 140, height:150)
        
        classCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 30, width: width, height: 150), collectionViewLayout: layout)
        classCollectionView!.delegate = self
        classCollectionView!.dataSource = self
        classCollectionView!.register(UINib.init(nibName: "HDZQ_RelatedClassCell", bundle: nil), forCellWithReuseIdentifier: "HDZQ_RelatedClassCell")
        classCollectionView!.backgroundColor = .white
        classContentView.addSubview(lab)
        classContentView.addSubview(classCollectionView!)
        
    }
    
    
    func setupExhibitView(model:FPContent) {
        if model.exhibit_list.count > 0 {
            let x = exhibitionLabel.ly_left
            let y = Int(exhibitionLabel.ly_bottom) + 20
            let height = 44
            let width  = 220
            self.model = model
            exhibitContentView.frame = CGRect.init(x:Int(x), y: y, width: width, height: (height + 10) * model.exhibit_list.count)
            exhibitContentView.register(UINib.init(nibName: "HDZQ_FPExhibitPlayCell", bundle: nil), forCellReuseIdentifier: "HDZQ_FPExhibitPlayCell")
            exhibitContentView.reloadData()
        } else {
            exhibitContentView.frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
            exhibitContentView.isHidden = true
        }
    }
    
    func setupCellViews(model:FPContent) {
        if model.class_list.count > 0 {
            self.model = model
            let x = exhibitionLabel.ly_left
            let y = Int(exhibitContentView.ly_bottom) + 15
            let height = 180
            let width  = Int(ScreenWidth - 60)
            classContentView.frame = CGRect.init(x:Int(x), y: y, width: width, height: height)
            classContentView.isHidden = false
            classCollectionView!.reloadData()
        } else {
            classContentView.frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
            classContentView.isHidden = true
        }
    }
}

extension HDZQ_FoorprintCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.exhibit_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mo = model.exhibit_list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HDZQ_FPExhibitPlayCell") as? HDZQ_FPExhibitPlayCell
        cell?.exhibitLabel.text = mo.exhibit_title
        var idxStrig = "\(index.section)" + "#" + "\(index.row)" + "#\(indexPath.row)"
        if currentIndex == idxStrig  {
            cell?.playBtn.isSelected = true
        } else {
            cell?.playBtn.isSelected = false
        }
        cell?.playBtn.addTouchUpInSideBtnAction({ [weak self] (btn) in
            btn.isSelected = !btn.isSelected
            if btn.isSelected == false {
                idxStrig = ""
            }
            if self?.delegate != nil {
                self?.delegate?.exhibitPlayAction(index: (self?.index)!,row:indexPath.row,idxStrig:idxStrig,url:mo.voice ?? "")
            }
        })
        return cell!
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


