//
//  HDTagChooseCareerVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/8/31.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDTagChooseCareerVC: UIViewController {

    @IBOutlet weak var lab_title: UILabel!
    @IBOutlet weak var lab_des  : UILabel!
//    @IBOutlet weak var TagBgView: UIView!
    @IBOutlet weak var TagBgView: UIScrollView!
    
    // firstGuideView
    @IBOutlet weak var firstGuideView: UIView!
    @IBOutlet weak var firstGuideScrollView: UIScrollView!
    @IBOutlet weak var firstGuideBtn: UIButton!
    @IBOutlet weak var guideImg1: UIImageView!
    @IBOutlet weak var guideImg2: UIImageView!
    @IBOutlet weak var guideImg3: UIImageView!
    
    @IBOutlet weak var img1HeightCons: NSLayoutConstraint!
    @IBOutlet weak var img2HeightCons: NSLayoutConstraint!
    @IBOutlet weak var img3HeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            self.pageControl.setImage(UIImage(named:"icon_gray"), for: .normal)
            self.pageControl.setImage(UIImage(named:"icon_red"), for: .selected)
            self.pageControl.itemSpacing = 15
            self.pageControl.interitemSpacing = 18
            
        }
    }
    
    var tagStrArray : [String] = Array.init()        //标签字符串数组
    var selectedtagArray = [HDSSL_Tag]()             //已选标签字符串数组
    var dataArr = [HDSSL_TagData]()                  //标签类别数组
    var tagList = [HDSSL_Tag]()                      //标签数组
    
    //标签页
    lazy var tagView : HD_SSL_TagView = {
        let tagview = HD_SSL_TagView.init(frame: TagBgView.bounds)
        tagview.tagViewType = TagViewType.TagViewTypeSingleSelection
        tagview.userTagType = UserTagType.UserTagTypeCareer
        
        tagview.BlockFunc { (array) in
            //1、保存选择标签
            print(array)
            
            self.selectedtagArray.removeAll() //移除所有
            
            for i: Int in 0..<array.count {
                let index : Int = Int(array[i] as! String)! //标签下标
                
                self.selectedtagArray.append(self.tagList[index]) //保存选择标签
            }
            //职业
            HDDeclare.shared.careerTagArray = self.selectedtagArray //本地保存已选标签
            
            //2、跳转vc
//            self.performSegue(withIdentifier: "HD_PushToChooseSateVCLine", sender: nil)
            let transition = CATransition.init()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            self.view.window?.layer.add(transition, forKey: nil)
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HDTagChooseStateVC") as! HDTagChooseStateVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
            
        }
        return tagview
    }()
    //MVVM
    let viewModel: HDSSL_TagViewModel = HDSSL_TagViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MVVM
        bindViewModel()
        //获取启动标签
        self.viewModel.request_getLaunchTagList(self,TagBgView)
        
        //
        setupFirstGuideView()
        
        //空数据界面
        weak var weakSelf = self
        let emptyV:HDEmptyView = HDEmptyView.emptyActionViewWithImageStr(imageStr: "img_sjjzsb", titleStr: "暂无数据", detailStr: "请检查网络连接或稍后再试", btnTitleStr: "重新加载") {
            LOG("点击刷新")
            weakSelf!.refreshAction()
        }
        
        emptyV.backgroundColor = UIColor.white
        emptyV.contentView.backgroundColor = UIColor.clear
        emptyV.contentViewY = 0
        emptyV.titleLabTextColor = UIColor.HexColor(0x9B9B9B)
        emptyV.actionBtnWidth = 60
        emptyV.actionBtnCornerRadius = 15
        emptyV.actionBtnTitleColor = UIColor.white
        emptyV.actionBtnBackGroundColor = UIColor.HexColor(0xE8593E)
        
        emptyV.contentViewY = -100
        self.TagBgView.ly_emptyView = emptyV
        self.TagBgView.ly_hideEmptyView()
        
        if UIDevice.current.isiPhoneXSeries() == true {
            //iPhoneX
            let imgH = ScreenWidth * 600 / 375
            img1HeightCons.constant = imgH
            img2HeightCons.constant = imgH
            img3HeightCons.constant = imgH
            guideImg1.image = UIImage.init(named: "img_01")
            guideImg2.image = UIImage.init(named: "img_02")
            guideImg3.image = UIImage.init(named: "img_03")
            
        } else {
            let imgH = ScreenWidth * 468 / 375
            img1HeightCons.constant = imgH
            img2HeightCons.constant = imgH
            img3HeightCons.constant = imgH
            guideImg1.image = UIImage.init(named: "img_01-1")
            guideImg2.image = UIImage.init(named: "img_02-1")
            guideImg3.image = UIImage.init(named: "img_03-1")
            
        }
        
        //返回重选
        NotificationCenter.default.addObserver(self, selector: #selector(NowResetTags), name: NSNotification.Name(rawValue: "resetSelectedCareerTags"), object: nil)
        
    }
    //MARK:--单选标签可以重置，多选标签不可重置
    @objc func NowResetTags(){
        print(selectedtagArray)
        
        let dataArr = HDDeclare.shared.careerTagArray!//已选职业标签
        
        var arr:[String] = Array.init()
        
        for i in 0..<dataArr.count {
            
            let sele = dataArr[i] //已选标签
            
            for i in 0..<tagList.count {
                
                let item = tagList[i]
                
                if item.label_id == sele.label_id { //找到已选标签位置
                    print(i)
                    arr.append(String(i))
                }
            }
        }
        
        tagView.reloadMySelectedTags(arr) //重置
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    @objc func refreshAction() {
        self.viewModel.request_getLaunchTagList(self,TagBgView)
    }
    //MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        viewModel.tagModel.bind { (tagDataArray) in
            
            
            weakSelf?.dataArr = tagDataArray  //返回标签数据，需要保存到本地
            
            HDDeclare.shared.allTagsArray = tagDataArray //保存标签
            
            let tagdatamodel = weakSelf?.dataArr[0]  //第一页单选
            
            
            weakSelf?.lab_title.text = String.init(format: "%@", (tagdatamodel?.title)!)
            weakSelf?.lab_des.text = String.init(format: "%@", (tagdatamodel?.des)!)
            weakSelf?.tagList = (tagdatamodel?.list)!
            
            //显示标签标题
            for i:Int in 0..<(weakSelf?.tagList.count)! {
                let tagmodel = weakSelf?.tagList[i]
                weakSelf?.tagStrArray.append((tagmodel?.title)!)
            }
            
            weakSelf?.loadTagView() //加载tag view
        }
    }
    
    
    func loadTagView() {

        tagView.titleArray = tagStrArray  //
        
        TagBgView.addSubview(tagView)
        tagView.loadTagsView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        if segue.identifier == "HD_PushToChooseSateVCLine" {
//            let vc:HDTagChooseStateVC = segue.destination as! HDTagChooseStateVC
//            vc.selectedtagArray = selectedtagArray
        }
    }
}

extension HDTagChooseCareerVC: UIScrollViewDelegate {
    
    func setupFirstGuideView() {
        firstGuideScrollView.showsVerticalScrollIndicator = false
        firstGuideScrollView.showsHorizontalScrollIndicator = false
        firstGuideScrollView.bounces = false
        firstGuideScrollView.delegate = self
        firstGuideScrollView.isPagingEnabled = true
        
        //
        firstGuideBtn.layer.cornerRadius = 20
        firstGuideBtn.layer.masksToBounds = true
        
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.backgroundColor = UIColor.clear
        
    }
    
    
    @IBAction func firstGuideBtnAction(_ sender: Any) {
        
//      firstGuideView.isHidden = true
        self.performSegue(withIdentifier: "HD_PushToTabBarVCLine", sender: nil)
        let userDefaults = UserDefaults.standard
        userDefaults.set("1", forKey: "saveTags")
        userDefaults.synchronize()
    }
    
    //MARK: --- UIScrollViewDelegate --
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex: NSInteger = lroundf(Float(scrollView.contentOffset.x/ScreenWidth))
        print("scrollViewDidScroll: \(pageIndex)")
        pageControl.currentPage = pageIndex
    }
    
    
}


