//
//  HDLY_IAPStore.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/28.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import StoreKit

let VERIFY_RECEIPT_URL = "https://buy.itunes.apple.com/verifyReceipt"
let ITMS_SANDBOX_VERIFY_RECEIPT_URL = "https://sandbox.itunes.apple.com/verifyReceipt"

final class HDLY_IAPStore: NSObject ,SKProductsRequestDelegate, SKPaymentTransactionObserver  {
    
    static let shared = HDLY_IAPStore()
    var productDict: NSMutableDictionary!
    var productArr:Array<Any>?
    
    override init() {
        super.init()

    }
    
    func setup() {

    }
    
    //1、根据产品ID数组 查询在线商品
    func requestProducts(_ productIdentifierArr: Array<String>?) {
        //
        addPaymentTransactionObserver()
        
        let set = NSSet(array: ["0060","0012","0018","888","spacecoin30"])
        let request = SKProductsRequest(productIdentifiers:set as! Set<String>)
        request.delegate = self;
        request.start()
        
    }
    
    //2、添加购买
    
    func buyProductPackages(productId: String) {
        //先判断是否支持内购
        if(SKPaymentQueue.canMakePayments()) {
            buyProduct(product: productDict[productId] as! SKProduct)
        }
        else {
            print("============不支持内购功能")
        }
    }
    
    func buyProduct(product: SKProduct){
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    //3、恢复内购
    func restoreTransactions() {
        
    }
    
    //4、添加票据校验
    func verifyPruchase() {
        
        // 验证凭据，获取到苹果返回的交易凭据
        let receiptURL = Bundle.main.appStoreReceiptURL
        // 从沙盒中获取到购买凭据
        let receiptData = NSData(contentsOf: receiptURL!)
        
        let encodeStr = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        let uuid = UIDevice.current.getUUID()
        LOG("uuid:\(uuid)")

        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .verifyTransaction(receipt_data: encodeStr!, password: "", is_sandbox: "1", uuid: uuid, api_token: token), showHud: false, loadingVC: UIViewController(), success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
 
        }) { (errorCode, msg) in
            
        }
    }
    
    
    //添加订单状态观察者
    func addPaymentTransactionObserver() {
        SKPaymentQueue.default().add(self)
    }
    
    //移除订单状态观察者
    func removePaymentTransactionObserver() {
         SKPaymentQueue.default().remove(self)
    }
    
    
}

extension HDLY_IAPStore {
    
    //SKProductsRequestDelegate
    //返回查询的产品
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (productDict == nil) {
            productDict = NSMutableDictionary(capacity: response.products.count)
        }
        
        for product in response.products {
            // 激活了对应的销售操作按钮，相当于商店的商品上架允许销售
            print("=======Product id=======\(product.productIdentifier)")
            print("===产品标题 ==========\(product.localizedTitle)")
            print("====产品描述信息==========\(product.localizedDescription)")
            print("=====价格: =========\(product.price)")
            if (product.productIdentifier == "spacecoin30")
            {
                if(SKPaymentQueue.canMakePayments()){
                    buyProduct(product: product)
                }
                else {
                    print("============不支持内购功能")
                }
            }
            // 填充商品字典
            productDict.setObject(product, forKey: product.productIdentifier as NSCopying)
        }
        
        self.productArr = response.products
    }
    
    
    //SKPaymentTransactionObserver
    //支付状态监控
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .deferred:
                print("延时处理")
                
            case .failed:
                print("支付失败")
                //应该移除交易队列
                queue.finishTransaction(transaction)
                
            case .purchased:
                print("支付成功")
                //应该移除交易队列
                queue.finishTransaction(transaction)
                // 获取购买凭据
                verifyPruchase()
//                self.verifyPruchase { (mydic, error) in
//                    print("verifyPruchase：\(String(describing: mydic))")
//                }
                
            case .purchasing:
                print("正在支付")
                
            case .restored:
                print("恢复购买")
                //应该移除交易队列
                queue.finishTransaction(transaction)
            }
        }
    }
    
    
    
    
    func verifyPruchase(completion:@escaping(NSDictionary?, NSError?) -> Void) {
        // 验证凭据，获取到苹果返回的交易凭据
        let receiptURL = Bundle.main.appStoreReceiptURL
        // 从沙盒中获取到购买凭据
        let receiptData = NSData(contentsOf: receiptURL!)
        #if DEBUG
        let url = NSURL(string: ITMS_SANDBOX_VERIFY_RECEIPT_URL)
        #else
        let url = NSURL(string: VERIFY_RECEIPT_URL)
        #endif
        let request = NSMutableURLRequest(url: url! as URL, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        let encodeStr = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        //        let payload = NSString(string: "{\"receipt-data\" : \"" + encodeStr! + "\"}")
        let payload = NSString(string: "{\"receipt-data\" : \"" + encodeStr! + "\",\"password\" : \"5a894b28df534473a89061417b31585c\"}")
        let payloadData = payload.data(using: String.Encoding.utf8.rawValue)
        request.httpBody = payloadData;
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil
            {
                completion(nil,error as NSError?)
            }
            else
            {
                if (data==nil)
                {
                    completion(nil,error as NSError?)
                }
                do
                {
                    let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    if (jsonResult.count != 0)
                    {
                        // 比对字典中以下信息基本上可以保证数据安全
                        // bundle_id&application_version&product_id&transaction_id
                        // 验证成功
                        print(jsonResult)
                        let receipt = jsonResult["receipt"] as! NSDictionary
                        completion(receipt,nil)
                        
                        let receiptDic:NSDictionary = jsonResult.object(forKey: "receipt") as! NSDictionary
                        let inAppArr:NSArray = receiptDic.object(forKey: "in_app") as! NSArray
                        let myDic:NSDictionary = inAppArr[0] as! NSDictionary
                        let transactionID:String = myDic.object(forKey: "transaction_id") as! String
                        let productID:String = myDic.object(forKey: "product_id") as! String
                        let purchase_date = myDic.object(forKey: "purchase_date") as! String
                        print("\(transactionID) \(productID)  \(purchase_date)")
                        //bao cun
                    }
                }
                catch
                {
                    completion(nil,nil)
                }
            }
        }
        dataTask.resume()
    }
}


    







