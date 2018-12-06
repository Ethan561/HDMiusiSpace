//
//  HDSSL_TransactionRecordVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/28.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import ESPullToRefresh

class HDSSL_TransactionRecordVC: HDItemBaseVC {
    @IBOutlet weak var dTableView: UITableView!
    private var take = 10
    private var skip = 0
    //mvvm
    private var viewModel = HDZQ_MyViewModel()
    private var recordArray =  [OrderRecordDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "交易记录"
        dTableView.delegate = self
        dTableView.dataSource = self
        dTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        addRefresh() //刷新
        
        bindViewModel()
        
        requestData()
    }
    //请求订单列表
    func requestData() {
        viewModel.getOrderRecordList(apiToken: "123456", skip: skip*10, take: take, vc: self)  //HDDeclare.shared.api_token ?? ""
    }

    //MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        //标签数组
        viewModel.orderRecordList.bind { (array) in
            //
            
            weakSelf?.refreshTableView(array)
        }
        
    }
    
    //刷新列表
    func refreshTableView(_ models:[OrderRecordDataModel]) {
        if models.count > 0 {
            if skip == 0 {
                self.recordArray.removeAll()
            }
            self.recordArray += models
            self.dTableView.reloadData()
            self.dTableView.es.stopPullToRefresh()
            self.dTableView.es.stopLoadingMore()
        }else{
            self.dTableView.es.noticeNoMoreData()
        }
        
        if self.recordArray.count == 0 {
            
            self.dTableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
            self.dTableView.ly_showEmptyView()
            
        }
        
    }
    
    func addRefresh() {
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
        self.dTableView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.refresh()
        }
        self.dTableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        self.dTableView.refreshIdentifier = String.init(describing: self)
        self.dTableView.expiredTimeInterval = 10.0
    }
    
    private func refresh() {
        skip = 0
        requestData()
    }
    
    private func loadMore() {
        skip += 1
        requestData()
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
extension HDSSL_TransactionRecordVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return recordArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = recordArray[section]
        return model.dateList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 40))
        let monthLabel = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 300, height: 40))
        
        let model = recordArray[section]
        
        monthLabel.text = model.month ?? ""
        
        headerview.addSubview(monthLabel)
        
        
        return headerview
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let modelSec = recordArray[indexPath.section]
        
        let cell = HDSSL_recordCell.getMyTableCell(tableV: tableView) as HDSSL_recordCell
        if modelSec.dateList!.count > 0 {
            let model = modelSec.dateList![indexPath.row]
            cell.cellData = model
        }
        return cell
    }
    
    
}
