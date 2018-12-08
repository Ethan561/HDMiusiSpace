//
//  HDLY_NumGuideVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/6.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_NumGuideVC: HDItemBaseVC,HDLY_AudioPlayer_Delegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var slide: UISlider!
    @IBOutlet weak var cleanBtn: UIButton!
    @IBOutlet weak var numL: UILabel!
    let player = HDLY_AudioPlayer.shared
    
    var numStr = ""
    var exhibit_num = 0
    var exhibition_id: Int?
    
    var dataArr = ["1","2","3","4","5","6","7","8","9","","0",""]
    var exhibitInfo: HDLY_ExhibitListM?
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "古蜀华章——四川古代文物展"
        let layout = UICollectionViewFlowLayout()
        let itemW = 90
        let itemH = 60
        
        
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.scrollDirection = .vertical
        self.collectionView.collectionViewLayout = layout
        collectionView.register(UINib.init(nibName: HDLY_Listen_CollectionCell.className, bundle: nil), forCellWithReuseIdentifier: HDLY_Listen_CollectionCell.className)
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        setupNavBarItem()
        self.collectionView.reloadData()

        if exhibit_num != 0 {
            dataRequest(exhibit_num: exhibit_num)
            numL.text = "\(exhibit_num)"
        }
        player.delegate = self
        numL.text = ""
        
    }
    
    func setupNavBarItem() {
        let rightBtn = UIButton.init(type: UIButton.ButtonType.custom)
        rightBtn.addTarget(self, action: #selector(helpAlertShow), for: UIControl.Event.touchUpInside)
        rightBtn.setImage(UIImage.init(named: "dl_icon_help"), for: UIControl.State.normal)
        let rightBtnItem = UIBarButtonItem.init(customView: rightBtn)
        
        self.navigationItem.rightBarButtonItems = [rightBtnItem]
    }
    
    @objc func helpAlertShow() {
        let tipView:HDLY_NumGuideHelpView = HDLY_NumGuideHelpView.createViewFromNib() as! HDLY_NumGuideHelpView
        tipView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        if kWindow != nil {
            kWindow!.addSubview(tipView)
        }
    }
    
    @IBAction func cleanAction(_ sender: Any) {
        self.exhibitInfo = nil
        numStr = ""
        numL.text = numStr
        player.stop()
        slide.value = 0
        timeL.text = "00:00/00:00"
        isPlaying = false
        self.collectionView.reloadData()
    }
    
    @IBAction func sliderValueChangeAction(_ sender: UISlider) {
        
    }
    
    @objc func pageTitleViewToTop() {
        self.collectionView.contentOffset = CGPoint.zero
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func dataRequest(exhibit_num: Int) {
        player.stop()
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        guard let exhibitionID = exhibition_id else {
            return
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .guideExhibitInfo(exhibition_id: exhibitionID, exhibit_num: "\(exhibit_num)", api_token: token), showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            let dataDic:Dictionary<String,Any> = dic!["data"] as! Dictionary<String,Any>
            let data = HD_LY_NetHelper.jsonToData(jsonDic: dataDic)
            let jsonDecoder = JSONDecoder()
            let model:HDLY_ExhibitListM = try! jsonDecoder.decode(HDLY_ExhibitListM.self, from: data!)
            self.exhibitInfo = model
            self.title = model.title
            self.playAction()
            
        }) { (errorCode, msg) in

        }
    }
    
    func playAction() {
        if player.state == .playing {
            player.pause()
            isPlaying = false
        } else {
            if player.state == .paused {
                player.play()
                isPlaying = true
            }else {
                if self.exhibitInfo?.audio != nil {
                    player.play(file: Music.init(name: "", url:URL.init(string: self.exhibitInfo!.audio!)!))
                    player.url = self.exhibitInfo!.audio!
                    player.fileno = numStr
                    isPlaying = true
                }
            }
        }
        self.collectionView.reloadData()
    }
    
    //MARK: -- HDLY_AudioPlayer_Delegate --
    func finishPlaying() {
        isPlaying = false
        self.collectionView.reloadData()
    }
    
    func playerTime(_ currentTime:String,_ totalTime:String,_ progress:Float) {
        slide.value = progress
        timeL.text = "\(currentTime)/\(totalTime)"
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            player.stop()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

private let reuseIdentifier = "Cell"

extension HDLY_NumGuideVC :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: ----- UICollectionView ---
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            
            let reuseIdentifier = HDLY_NumCollectionCell.className+"\(indexPath.section)"+"\(indexPath.row)"
            
            collectionView.register(UINib.init(nibName: HDLY_NumCollectionCell.className, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
            
            let cell:HDLY_NumCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HDLY_NumCollectionCell

            cell.titleL.text = dataArr[indexPath.row]
            if indexPath.row < 9 {
                cell.tagBtn.isHidden = true
            }
            if indexPath.row == 9{
                cell.tagBtn.setImage(UIImage.init(named: "dl_icon_sc"), for: UIControlState.normal)
            }
            
            if indexPath.row == 11{
                cell.tagBtn.setImage(UIImage.init(named: "dl_icon_paly_red"), for: UIControlState.normal)
                cell.tagBtn.setImage(UIImage.init(named: "dl_icon_pause_red"), for: UIControlState.selected)
                if isPlaying == true {
                    cell.tagBtn.isSelected = true
                }else {
                    cell.tagBtn.isSelected = false
                }
            }
            
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isPlaying == true {
            if indexPath.row == 11{
                playAction()
            }
        }else {
            if indexPath.row < 11 {
                if indexPath.row < 9 {
                    numStr.append("\(indexPath.row+1)")
                }
                if indexPath.row == 10 {
                    numStr.append("0")
                }
                if indexPath.row == 9 && numStr.count > 0{
                    numStr.removeLast()
                }
                if numStr.count > 4 {
                    numStr =  String(numStr.prefix(4))
                }
                numL.text = numStr
            }
            
            if indexPath.row == 11 {
                if player.fileno != numStr && numStr.count > 0 {
                    dataRequest(exhibit_num: Int(numStr) ?? 0)
                }else {
                    playAction()
                }
            }
            
        }
    }
    
    //MARK ----- UICollectionViewDelegateFlowLayout ------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemW = (ScreenWidth-20*3)/2.0
        let itemH = itemW*60/90.0
        if indexPath.section == 0 {
            return CGSize.init(width: 90, height: 60)
        }
        return CGSize.init(width: itemW, height: itemH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let width:CGFloat   = 90
        let space = (ScreenWidth-3*width)/4.0
        let spaceH:CGFloat = 20.0
        
        return UIEdgeInsets.init(top: spaceH, left: space, bottom: spaceH, right: space)
    }
    
    
}



