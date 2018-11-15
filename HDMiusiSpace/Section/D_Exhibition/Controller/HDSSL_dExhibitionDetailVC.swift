//
//  HDSSL_dExhibitionDetailVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/13.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

let kBannerHeight = ScreenWidth*250/375.0

class HDSSL_dExhibitionDetailVC: HDItemBaseVC {
    //接收
    var exhibition_id: Int?
    
    //
    @IBOutlet weak var bannerBg: UIView!
    @IBOutlet weak var dTableView: UITableView!
    

    //
    var exdataModel: ExhibitionDetailDataModel?
    //
    var bannerView: ScrollBannerView!//banner
    var bannerImgArr: [String]? = Array.init() //轮播图数组
    var imgsArr: Array<String>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hd_navigationBarHidden = true
        
        //
        loadMyDatas()
        //banner
        setupBannerView()
        //
        setupdTableView()
    }
    
    //MARK: 加载数据
    func loadMyDatas() {
        bannerImgArr?.append("http://www.muspace.net/img/test/1.jpg")
        bannerImgArr?.append("http://www.muspace.net/img/test/2.jpg")
        bannerImgArr?.append("http://www.muspace.net/img/test/3.jpg")
    }
    
    
    
    
    //MARK: action
    @IBAction func action_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func action_topButton(_ sender: UIButton) {
        print(sender.tag)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HDSSL_dExhibitionDetailVC: ScrollBannerViewDelegate {
    //MARK:---显示banner View
    func setupBannerView() {
        
        bannerView = ScrollBannerView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: kBannerHeight))//750:422
        view.insertSubview(bannerView, aboveSubview: bannerBg)
        bannerView.placeholderImg = UIImage.init(named: "img_nothing")!
        bannerView.pageControlAliment = .center
        bannerView.pageControlBottomDis = 15
        //        if bannerView.pageControl != nil {
        //            bannerView.pageControl!.isHidden = true
        //        }
        
        //img相对地址
        //        if self.bannerImgArr != nil {
        //            var imgArr = Array<String>()
        //            for path in self.bannerImgArr! {
        //                let imagePath = HDDeclare.IP_Request_Header() + path
        //                imgArr.append(imagePath)
        //            }
        //            bannerView.imgPathArr = imgArr
        //            imgsArr = imgArr
        //        }
        //img绝对地址
        bannerView.imgPathArr = bannerImgArr!
        imgsArr = bannerImgArr
        bannerView.delegate = self
        bannerView.clickItemClosure = { (index) -> Void in
            LOG("闭包回调---\(index)")
        }
        
        
    }
    
    func cycleScrollView(_ scrollView: ScrollBannerView, didScorllToIndex index: Int) {
        if imgsArr != nil {
            let str = "\(index+1)/\(imgsArr!.count)"
        }
    }
    
    func cycleScrollView(_ scrollView: ScrollBannerView, didSelectItemAtIndex index: Int) {
        
        showBigImageAtIndex(index)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //let result = webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight")
        LOG("加载完成")
    }
    
    //查看大图
    func showBigImageAtIndex(_ index: NSInteger) {
        if imgsArr != nil {
            let vc = HD_SSL_BigImageVC.init()
            vc.imageArray = imgsArr as NSArray? as! [String]
            vc.atIndex = index
            self.present(vc, animated: true, completion: nil)
            
        }
    }
}

extension HDSSL_dExhibitionDetailVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }else if section == 1 {
            return 2
        }else if section == 2 {
            return 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 80
            }else if indexPath.row == 1 {
                return 70
            }
            return 40
        }else if indexPath.section == 1 {
            return 200
        }
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = HDSSL_Sec0_Cell0.getMyTableCell(tableV: tableView) as HDSSL_Sec0_Cell0
                
                return cell
            }
            else if indexPath.row == 1 {
                let cell = HDSSL_Sec0_Cell1.getMyTableCell(tableV: tableView) as HDSSL_Sec0_Cell1
                cell.cell_timeL.text = "2018.02.27-07.22 9:00-17:00 （周一闭馆）\n 9:00-17:00 （夏季）\n 9:00-17:00 （冬季）"
                return cell
            }
            else  {
                let cell = HDSSL_Sec0_cellNormal.getMyTableCell(tableV: tableView) as HDSSL_Sec0_cellNormal
                
                var name: String?
                var title: String?
                
                if indexPath.row == 2 {
                    name = "展厅："
                    title = "西区1层B展厅"
                }else if indexPath.row == 3 {
                    name = "费用："
                    title = "免费（需携带身份证）"
                }else if indexPath.row == 4 {
                    name = "地址："
                    title = "北京市西城区复兴门外大街16号"
                    cell.accessoryType = .disclosureIndicator
                }
                
                cell.cell_nameL.text = name
                cell.cell_titleL.text = title
                
                return cell
            }
            
            
        }
        else if indexPath.section == 1 {
            //加载两个webView
            //展览介绍🈴️展品介绍
            if indexPath.row == 0 {
                let cell = HDSSL_Sec1Cell.getMyTableCell(tableV: tableView) as HDSSL_Sec1Cell
                let path = "https://www.baidu.com"
                cell.loadWebView(path)
                return cell
            }else if indexPath.row == 1{
                let cell = HDSSL_Sec1Cell.getMyTableCell(tableV: tableView) as HDSSL_Sec1Cell
                let path = "https://www.baidu.com"
                cell.loadWebView(path)
                return cell
            }
        }
        let cell = HDSSL_Sec0_Cell0.getMyTableCell(tableV: tableView) as HDSSL_Sec0_Cell0
        return cell
        
    }
    
    func setupdTableView()  {
        //
        dTableView.delegate = self
        dTableView.dataSource = self
        
    }
    
    
}
