//
//  HDLY_CourseList_SubVC2.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/17.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import WebKit

class HDLY_CourseList_SubVC2: HDItemBaseVC,UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buyBtn: UIButton!
    
    var webView = WKWebView()
    var webViewH: CGFloat = 100
    
    lazy var testWebV: WKWebView = {
        let webV = WKWebView.init(frame: CGRect.zero)
        webV.navigationDelegate = self
        return webV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        buyBtn.layer.cornerRadius = 28
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buyBtnAction(_ sender: Any) {
        
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


extension HDLY_CourseList_SubVC2 {
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        if index == 0 {
            return 182*ScreenWidth/375.0
        }else if index == 1 {
            return webViewH
        }else if index == 2 {
            return 145*ScreenWidth/375.0
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
//        let model = infoModel?.data
        
        if index == 0 {
            let cell = HDLY_CourseTitle_Cell.getMyTableCell(tableV: tableView)
//            cell?.titleL.text = model?.title
//            cell?.nameL.text = model?.teacher
//            cell?.desL.text = model?.tdes
            
            return cell!
        }
        else if index == 1 {
            let cell = HDLY_CourseWeb_Cell.getMyTableCell(tableV: tableView)
            self.webView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height:CGFloat(webViewH))
            cell?.addSubview(webView)
//            guard let url = self.infoModel?.data.url else {
//                return cell!
//            }
//            self.webView.load(URLRequest.init(url: URL.init(string: url)!))
            
            return cell!
        }
        else if index == 2 {
            let cell = HDLY_BuyNote_Cell.getMyTableCell(tableV: tableView)
//            cell?.contentL.text = model?.buynotice
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

extension HDLY_CourseList_SubVC2 {
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
        }
    }
    //加载失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("_____加载失败_____")
        
    }
    
    
    
}
