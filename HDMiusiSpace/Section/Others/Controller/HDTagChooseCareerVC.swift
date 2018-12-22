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
        let emptyV:HDEmptyView = HDEmptyView.emptyActionViewWithImageStr(imageStr: "net_error", titleStr: "暂无数据", detailStr: "请检查网络连接或稍后再试", btnTitleStr: "重新加载") {
            LOG("点击刷新")
            weakSelf!.refreshAction()
        }
        
        emptyV.contentViewY = -100
        emptyV.actionBtnBackGroundColor = .lightGray
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
        let tagView = HD_SSL_TagView.init(frame: TagBgView.bounds)
        tagView.tagViewType = TagViewType.TagViewTypeSingleSelection
        
        tagView.BlockFunc { (array) in
            //1、保存选择标签
            print(array)
            for i: Int in 0..<array.count {
                let index : Int = Int(array[i] as! String)! //标签下标
//                let str : String = self.tagStrArray[index] //
                
                self.selectedtagArray.append(self.tagList[index]) //保存选择标签
            }
            
            
            //2、跳转vc
            self.performSegue(withIdentifier: "HD_PushToChooseSateVCLine", sender: nil)
        }
        tagView.titleArray = tagStrArray  //
        
        TagBgView.addSubview(tagView)
        tagView.loadTagsView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "HD_PushToChooseSateVCLine" {
            let vc:HDTagChooseStateVC = segue.destination as! HDTagChooseStateVC
            vc.selectedtagArray = selectedtagArray
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
        
        firstGuideView.isHidden = true
    }
    
    //MARK: --- UIScrollViewDelegate --
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex: NSInteger = lroundf(Float(scrollView.contentOffset.x/ScreenWidth))
        print("scrollViewDidScroll: \(pageIndex)")
        pageControl.currentPage = pageIndex
    }
    
    
}


