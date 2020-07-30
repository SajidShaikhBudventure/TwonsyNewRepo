//
//  SampleAppFileTransferHandler.swift
//  Runner
//
//  Created by aditya jaitly on 14/07/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import Photos
import mesibo


@objcMembers public class SampleAppFileTransferHandler: NSObject, MesiboDelegate {
    public var token: String?
         
       
    func initialize(accessToken : String ) {
        token=accessToken
        Mesibo.getInstance().addListener(self)
    }
    
    func mesibo_(onStartUpload file: MesiboFileInfo?) -> Bool {
        let type = Mesibo.getInstance().getNetworkConnectivity()
        
        if MESIBO_CONNECTIVITY_WIFI != type && file?.userInteraction == nil {
            return false
        }
        
        let params = file?.getParams()
        
        var post: [AnyHashable : Any] = [:]
        
        post["op"] = "upload"
        post["token"] = token
        post["mid"] = String(params!.mid)
        post["profile"] = "0"
        
        let handler = { (http: MesiboHttp?, state: Int32, httpprogress: Int32) -> Bool in
            
            var progress: Int32 = httpprogress
            
            var status = file?.getStatus() ?? 0
            
            if MESIBO_FILESTATUS_RETRYLATER != status {
                status = MESIBO_FILESTATUS_INPROGRESS
                if progress < 0 {
                    status = MESIBO_FILESTATUS_FAILED
                }
            }
            
            if 100 == progress && MESIBO_HTTPSTATE_DOWNLOAD == state {
                var _: Error? = nil
                
                let data = http?.getDataString().data(using: .utf8)
                var jsonObject: Any? = nil
                do {
                    if let data = data {
                        jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    }
                } catch _ {
                }
                let returnedDict = jsonObject as? [AnyHashable : Any]
                let fileUrl = returnedDict?["file"] as? String
                
                if fileUrl != nil {
                    file!.setUrl(fileUrl)
                } else {
                    progress = -1
                    status = MESIBO_FILESTATUS_FAILED
                }
            }
            if progress < 100 || (100 == progress && MESIBO_HTTPSTATE_DOWNLOAD == state) {
                Mesibo.getInstance().updateFileTransferProgress(file, progress: progress, status: status)
            }
            
            return (100 == progress && MESIBO_HTTPSTATE_DOWNLOAD == state) || MESIBO_FILESTATUS_RETRYLATER != status
            } as Mesibo_onHTTPProgress
        
        let http = MesiboHttp()
        http.url = "https://s3.mesibo.com/api.php"
        http.uploadPhAsset = file?.asset
        http.uploadLocalIdentifier = file?.localIdentifier
        http.uploadFile = file?.getPath()
        http.postBundle = post
        http.uploadFileField = "photo"
        http.listener = handler
        
        file?.fileTransferContext = http
        
        return http.execute()
    }
    
    func mesibo_(onStartDownload file: MesiboFileInfo?) -> Bool {
        let type = Mesibo.getInstance().getNetworkConnectivity()
        
        if !true && MESIBO_CONNECTIVITY_WIFI != type && file?.userInteraction == nil {
            return false
        }
        
        let params = file?.getParams()
        
        if MESIBO_ORIGIN_REALTIME != params?.origin && file?.userInteraction == nil {
            return false
        }
        
        var url = file?.getUrl()
        
        if !(url?.hasPrefix("http://") ?? false) && !(url?.hasPrefix("https://") ?? false) {
            url = "https://appimages.mesibo.com/" + (url!)
        }
        
        let handler = { (http: MesiboHttp?, state: Int32, progress: Int32) -> Bool in
            var status = file?.getStatus() ?? 0
            
            if MESIBO_FILESTATUS_RETRYLATER != status {
                status = MESIBO_FILESTATUS_INPROGRESS
                if progress < 0 {
                    status = MESIBO_FILESTATUS_FAILED
                }
            }
            
            Mesibo.getInstance().updateFileTransferProgress(file, progress: progress, status: status)
            return 100 == progress || MESIBO_FILESTATUS_RETRYLATER != status
            } as Mesibo_onHTTPProgress
        
        let http = MesiboHttp()
        http.url = url
        http.downloadFile = file?.getPath()
        http.resume = true
        http.listener = handler
        
        file?.fileTransferContext = http
        
        return http.execute()
        
    }
    
    public func mesibo_(onStartFileTransfer file: MesiboFileInfo?) -> Bool {
        
        if MESIBO_FILEMODE_DOWNLOAD == file?.mode {
            return mesibo_(onStartDownload: file)
        }
        
        return mesibo_(onStartUpload: file)
        
    }
    
    public func mesibo_(onStopFileTransfer file: MesiboFileInfo?) -> Bool {
        let http = file!.getFileTransferContext() as? MesiboHttp
        if http != nil {
            http!.cancel()
        }
        return true
    }
}
