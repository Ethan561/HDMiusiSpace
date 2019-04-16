//
//  HDZQ_VoiceSearchView.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2019/1/8.
//  Copyright © 2019 hengdawb. All rights reserved.
//

import UIKit

protocol HDZQ_VoiceResultDelegate : NSObjectProtocol {
    func voiceResult(result:String)
}

class HDZQ_VoiceSearchView: UIView {

    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var voiceLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    var gifView : HDGIFImageView?
    var iFlySpeechRecognizer : IFlySpeechRecognizer?
    var uploader : IFlyDataUploader?
    var pcmRecorder : IFlyPcmRecorder?
    var voiceResult = ""
    
    public weak var delegate:HDZQ_VoiceResultDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let path = Bundle.main.path(forResource: "voiceSearch", ofType: "gif")
        self.gifView = HDGIFImageView.init(frame: CGRect.init(x:ScreenWidth * 0.5 - 30 - 50, y: 80, width: 100, height: 40), path: path!)
        self.gifView?.isHidden = false
        self.voiceBtn.isHidden = true
        self.gifView?.startAnimating()
        self.bgView.addSubview(gifView!)
        self.bgView.layer.cornerRadius = 10
        self.bgView.clipsToBounds = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(removeVoiceView))
        containerView.addGestureRecognizer(tap)
        initRecognizer()
    }

    @objc func removeVoiceView() {
        iFlySpeechRecognizer?.cancel()
        self.isHidden = true
    }
    
    @IBAction func collectVoiceAction(_ sender: Any) {
        startCollectVoice()
        self.gifView?.isHidden = false
        self.voiceBtn.isHidden = true
    }
    
    func startCollectVoice() {
        if iFlySpeechRecognizer == nil {
            self.initRecognizer()
        }
        
        iFlySpeechRecognizer?.cancel()
        
        //Set microphone as audio source
        iFlySpeechRecognizer?.setParameter(IFLY_AUDIO_SOURCE_MIC, forKey: "audio_source")
        
        //Set result type
        iFlySpeechRecognizer?.setParameter("json", forKey: IFlySpeechConstant.result_TYPE())
        
        //Set the audio name of saved recording file while is generated in the local storage path of SDK,by default in library/cache.
        iFlySpeechRecognizer?.setParameter("asr.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH())
        
        iFlySpeechRecognizer?.delegate = self
        
        var ret: Bool = iFlySpeechRecognizer!.startListening()
    }
    
    func initRecognizer() {
        
        if iFlySpeechRecognizer == nil {
            iFlySpeechRecognizer = IFlySpeechRecognizer.sharedInstance()
        }
        
        iFlySpeechRecognizer?.setParameter("", forKey: IFlySpeechConstant.params())
        iFlySpeechRecognizer?.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
        iFlySpeechRecognizer?.delegate = self
        if iFlySpeechRecognizer != nil {
            iFlySpeechRecognizer!.setParameter("30000", forKey: IFlySpeechConstant.speech_TIMEOUT())
            iFlySpeechRecognizer!.setParameter("3000", forKey: IFlySpeechConstant.vad_EOS())
            iFlySpeechRecognizer!.setParameter("1500", forKey: IFlySpeechConstant.vad_BOS())
            iFlySpeechRecognizer!.setParameter("20000", forKey: IFlySpeechConstant.net_TIMEOUT())
            iFlySpeechRecognizer!.setParameter("16000", forKey: IFlySpeechConstant.sample_RATE())
            iFlySpeechRecognizer!.setParameter("zh_cn", forKey: IFlySpeechConstant.language())
            iFlySpeechRecognizer!.setParameter("mandarin", forKey: IFlySpeechConstant.accent())
            iFlySpeechRecognizer!.setParameter("0", forKey: IFlySpeechConstant.asr_PTT())
        }
        
        if pcmRecorder == nil {
            pcmRecorder = IFlyPcmRecorder.sharedInstance()
        }
        pcmRecorder?.delegate = self
        pcmRecorder?.setSample("16000")
        pcmRecorder?.setSaveAudioPath(nil)
        
    }
    //未获取语音授权时弹出提示信息
    func showAudioAcessDeniedAlert() {
        let alertController = UIAlertController(title: "暂时不能使用语音搜索功能哦",
                                                message: "请到：设置-隐私-麦克风 允许“缪斯空间”使用您的麦克风",
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "设置", style: .default) { (alertAction) in
            
            // THIS IS WHERE THE MAGIC HAPPENS!!!!
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(appSettings as URL)
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

}

extension HDZQ_VoiceSearchView : IFlySpeechRecognizerDelegate {
    
    func onVolumeChanged(_ volume: Int32) {
        
    }
    
    func onBeginOfSpeech() {
        print("onBeginOfSpeech")
    }
    
    func onEndOfSpeech() {
        print("onEndOfSpeech")  
        pcmRecorder?.stop()
        if delegate != nil {
            if voiceResult == "" {
                return
            }
            delegate?.voiceResult(result: voiceResult)
        }
    }
    
    func onCompleted(_ errorCode: IFlySpeechError!) {
        print(errorCode.errorDesc)
        if errorCode.errorDesc == "录音失败" {
            //提示开启权限，到设置
            removeVoiceView()
            
            showAudioAcessDeniedAlert()
            
        }
        if errorCode.errorCode == 0 {
            print(voiceResult)
            if voiceResult.count == 0 {
                self.voiceLabel.text = "呀，没听清，再试试吧"
                self.gifView?.isHidden = true
                self.voiceBtn.isHidden = false
                return
            } else {
                voiceResult = ""
            }
            
        }
    }
    
    func onResults(_ results: [Any]!, isLast: Bool) {
        if results == nil {
            return
        }
        var resultStr : String = ""
        let resultDic : Dictionary<String, String> = results[0] as! Dictionary<String, String>
        for key in resultDic.keys {
            resultStr += key
        }
        let dataStr = resultStr.data(using: String.Encoding.utf8)
        let jsonDecoder = JSONDecoder()
        //JSON转Model：
        do {
            let model:IFlyModel = try jsonDecoder.decode(IFlyModel.self, from: dataStr!)
            var result = ""
            model.ws.forEach { (ws) in
                ws.cw.forEach({ (cw) in
                    result = result + cw.w!
                })
            }
            voiceResult = voiceResult + result
            self.voiceLabel.text = voiceResult
            print(result)
            
        }
        catch let error {
            LOG("解析错误：\(error)")
        }
    }
    
    func onCancel() {
        
    }
}

extension HDZQ_VoiceSearchView : IFlyPcmRecorderDelegate {
    func onIFlyRecorderBuffer(_ buffer: UnsafeRawPointer!, bufferSize size: Int32) {
        
    }
    
    func onIFlyRecorderError(_ recoder: IFlyPcmRecorder!, theError error: Int32) {
        
    }
    
    func onIFlyRecorderVolumeChanged(_ power: Int32) {
        
    }
    
}

struct IFlyModel:Codable {
    var ls: Bool = false
    var ws = [Ws]()
    var sn: Int = 0
    var ed: Int = 0
    var bg: Int = 0
}

struct Cw:Codable {
    var sc: Float = 0.0
    var w: String?
}

struct Ws:Codable {
    var cw = [Cw]()
    var bg: Int = 0
}

