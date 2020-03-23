//
//  HDSSL_Sec1Cell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/14.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import WebKit
//block
typealias BloclkCellHeight = (_ height: Double) -> Void //返回高度
typealias BloclkCellRefreshHeight = (_ height: Double, _ type: Int) -> Void //返回高度

protocol HDSSL_Sec1CellDelegate: NSObjectProtocol {
    func backWebviewHeight(_ height: Double , _ cell: UITableViewCell)
    func webViewFolderAction(_ model: FoldModel, _ cell: UITableViewCell)
}

class HDSSL_Sec1Cell: UITableViewCell {
    @IBOutlet weak var line: UIView!
    
    var blockHeight: BloclkCellHeight?
    var delegate: HDSSL_Sec1CellDelegate?
    var blockRefreshHeight: BloclkCellRefreshHeight?

    // MARK: - 懒加载
    
    lazy var webview: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        //初始化偏好设置属性：preferences
        webConfiguration.preferences = WKPreferences()
        webConfiguration.userContentController.add(self, name: "Fold")
        //是否支持JavaScript
        webConfiguration.preferences.javaScriptEnabled = true
        //不通过用户交互，是否可以打开窗口
        webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
       var css = "body{-webkit-user-select:none;-webkit-user-drag:none;}";
        var javascript = ""
        javascript.append("var style = document.createElement('style');")
        javascript.append("style.type = 'text/css';")
        javascript.append("var cssContent = document.createTextNode('\(css)');")
        javascript.append("style.appendChild(cssContent);")
        javascript.append("document.body.appendChild(style);")
        javascript.append("document.documentElement.style.webkitUserSelect='none';")
        javascript.append("document.documentElement.style.webkitTouchCallout='none';")
        let noneSelectScript = WKUserScript.init(source: javascript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        webConfiguration.userContentController.addUserScript(noneSelectScript)
        let webFrame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 0)
        let webView = WKWebView(frame: webFrame, configuration: webConfiguration)
        webView.backgroundColor = UIColor.blue
//        webView.navigationDelegate = self
//        webView.uiDelegate = self
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        return webView
    }()
    
    
    //block
    func blockHeightFunc(block: @escaping BloclkCellHeight) {
        blockHeight = block
    }
    
    func blockRefreshHeightFunc(block: @escaping BloclkCellRefreshHeight) {
        blockRefreshHeight = block
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.contentView.addSubview(webview)
        self.contentView.insertSubview(webview, at: 0)
    }

    func loadWebView(_ path: String?) {
        //
        if path == "" || path?.count == 0 {
            return
        }
        
        if let webUrlString = path {
            if let encodedStr = webUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                if let myUrl = URL(string: encodedStr) {
                    let myRequest = URLRequest(url: myUrl)
                    self.webview.load(myRequest)
                }
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_Sec1Cell! {
        var cell: HDSSL_Sec1Cell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_Sec1Cell.className) as? HDSSL_Sec1Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_Sec1Cell.className, bundle: nil), forCellReuseIdentifier: HDSSL_Sec1Cell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_Sec1Cell.className, owner: nil, options: nil)?.first as? HDSSL_Sec1Cell
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell!
    }
    
}

extension HDSSL_Sec1Cell:WKNavigationDelegate ,WKUIDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        var webheight = 0.0
        
        // 获取内容实际高度
        self.webview.evaluateJavaScript("document.body.scrollHeight") { [unowned self] (result, error) in
            
            if let tempHeight: Double = result as? Double {
                webheight = tempHeight
                print("webheight: \(webheight)")
            }
            
            DispatchQueue.main.async { [unowned self] in
                var tempFrame: CGRect = self.webview.frame
                tempFrame.size.height = CGFloat(webheight)
                self.webview.frame = tempFrame
                //返回高度，刷新cell
                
                weak var weakSelf = self
                if weakSelf?.blockHeight != nil {
                    weakSelf?.blockHeight!(webheight)
                }
            }
        }
    }
    
    
//    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//
//        let arr = message.components(separatedBy: ",")
//        let webheight = Double(arr.last ?? "0")
//        print(message,arr)//展开是1 , 收起是2
//
//        DispatchQueue.main.async { [unowned self] in
//            self.webview.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: CGFloat(webheight ?? 0))
//            print("(webView.frame: \(webView.frame)")
//
//            let model = FoldModel()
//            model.isfolder = arr.first
//            model.height = arr.last
//            weak var weakSelf = self
//
////            self.delegate?.webViewFolderAction(model, self)
////
//            if weakSelf?.blockRefreshHeight != nil {
//                let h: Double = Double(arr.last ?? "0") ?? 0
//                let type:Int = Int(arr.first ?? "2") ?? 2
//
//                weakSelf?.blockRefreshHeight!(h,type)
//
//            }
//        }
//        completionHandler()
//    }
}

extension HDSSL_Sec1Cell :WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        guard let arr = message.body as? NSArray else { return }
        guard let floder = arr[0] as? String else { return }
        guard let height = arr[1] as? String else { return }
        if self.blockRefreshHeight != nil {
            let type = Int(floder)
            let h = Double(height)
            self.blockRefreshHeight!(h!,type!)

        }
    }
}

class FoldModel: NSObject {
    var isfolder : String?
    var height : String?
}


