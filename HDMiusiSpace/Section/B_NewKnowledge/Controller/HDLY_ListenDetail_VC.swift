//
//  HDLY_ListenDetail_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/20.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import WebKit

class HDLY_ListenDetail_VC: HDItemBaseVC,UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate{

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var statusBarHCons: NSLayoutConstraint!
    @IBOutlet weak var myTableView: UITableView!
    var reloadFlag = true

    var webView = WKWebView()
    var webViewH:CGFloat = 0
    var infoModel: ListenDetail?
    var listen_id:String?
    
    lazy var testWebV: WKWebView = {
        let webV = WKWebView.init(frame: CGRect.zero)
        webV.navigationDelegate = self
        return webV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarHCons.constant = kStatusBarHeight+24
        self.hd_navigationBarHidden = true
        myTableView.separatorStyle = .none
        
        dataRequest()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataRequest()  {
        guard let listenID = listen_id else {
            return
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseListenDetail(listen_id: listenID, api_token: ""), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let dataDic:Dictionary<String,Any> = dic?["data"] as! Dictionary<String, Any>
            //JSON转Model：
            let dataA:Data = HD_LY_NetHelper.jsonToData(jsonDic: dataDic)!
            let model:ListenDetail = try! jsonDecoder.decode(ListenDetail.self, from: dataA)
            self.infoModel = model
            self.imgV.kf.setImage(with: URL.init(string: model.img), placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)
            self.getWebHeight()
            
        }) { (errorCode, msg) in
            
        }
    }
    
    func getWebHeight() {
        guard let url = self.infoModel?.url else {
            return
        }
        self.testWebV.load(URLRequest.init(url: URL.init(string: url)!))
        self.myTableView.reloadData()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.back()
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




extension HDLY_ListenDetail_VC {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    //footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    //row
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        if index == 0 {
            return 182*ScreenWidth/375.0
        }else if index == 1 {
            return webViewH
        }else if index == 2 {
            return 95
        }else if index == 3 {
            return 280*ScreenWidth/375.0
        }
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let model = infoModel
        
        if index == 0 {
            let cell = HDLY_CourseTitle_Cell.getMyTableCell(tableV: tableView)
            cell?.titleL.text = model?.title
            cell?.nameL.text = model?.teacherName
            cell?.desL.text = model?.teacherTitle
            
            return cell!
        }
        else if index == 1 {
            let cell = HDLY_CourseWeb_Cell.getMyTableCell(tableV: tableView)
            self.webView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height:CGFloat(webViewH))
            cell?.addSubview(webView)
            guard let url = self.infoModel?.url else {
                return cell!
            }
            if reloadFlag == true {
                self.webView.load(URLRequest.init(url: URL.init(string: url)!))
            }
            
            return cell!
        }
        else if index == 2 {
            let cell = HDLY_ListenPlayer_Cell.getMyTableCell(tableV: tableView)
            
            return cell!
        }else if index == 3 {
            let cell = HDLY_CourseComment_Cell.getMyTableCell(tableV: tableView)
            
            return cell!
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: ---- WKNavigationDelegate ----

extension HDLY_ListenDetail_VC {
    //开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("_____开始加载_____")
    }
    
    //完成加载
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("_____完成加载_____")
        //禁止长按手势操作
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil)
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
        //js方法获取高度
        webView.evaluateJavaScript("Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)") { (result, error) in
            let height = result
            self.webViewH = CGFloat(height as! Float)
            self.myTableView.reloadData()
            if self.webViewH > 10 {
                self.reloadFlag = false
            }
        }
    }
    //加载失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("_____加载失败_____")
        
    }
    
    
    
}






