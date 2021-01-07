//
//  xAPI+Rep.swift
//  xSDK
//
//  Created by Mac on 2020/12/28.
//

import UIKit
import Alamofire

extension xAPI {
    
    // MARK: - 校验返回结果
    static func check(response : DataResponse<Any>,
                      record : xAPIRecord)
    {
        if response.result.isSuccess {
            self.responseSuccess(response,
                                 record: record)
        }
        else {
            self.responseFailure(response,
                                 record: record)
        }
        // 移除请求记录
        for (i, v) in shared.requestRecordList.enumerated() {
            guard v.id == record.id else { continue }
            shared.requestRecordList.remove(at: i)
            break
        }
    }
    
    // MARK: - 响应成功
    private static func responseSuccess(_ rep : DataResponse<Any>,
                                        record : xAPIRecord)
    {
        self.analysisResponseData(rep.result.value,
                                  record: record)
    }
    
    // MARK: - 响应失败
    private static func responseFailure(_ rep : DataResponse<Any>,
                                        record : xAPIRecord)
    {
        // 响应失败
        let code = rep.response?.statusCode ?? -1
        let msg = rep.error?.localizedDescription ?? ""
        xWarning("API响应状态为失败: code = \(code), \(msg)")
        if self.breakResponseFailure(statusCode: code) {
            // 中断后续操作
            self.logResponseError(response: rep,
                                  record: record)
            record.failure?("中断API响应数据分析")
        }
        else {
            // 不中断，尝试解析数据
            self.analysisResponseData(rep.data,
                                      record: record)
        }
    }
    
}
