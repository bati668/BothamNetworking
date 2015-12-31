//
//  BasicAuthentication.swift
//  BothamNetworking
//
//  Created by Davide Mendolia on 31/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
protocol CredentialsProvider {
    var credentials: (username: String, password: String) { get }
}

/**
 * Basic Authentication http://tools.ietf.org/html/rfc2617
 */
protocol BasicAuthentication: BothamRequestInterceptor {
    var credentialsProvider: CredentialsProvider { get }
}

extension BasicAuthentication {
    func intercept(request: HTTPRequest) -> HTTPRequest {

        let (username, password) = credentialsProvider.credentials
        let userPass = "\(username):\(password)"

        let userPassData = userPass.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64UserPass = userPassData.base64EncodedStringWithOptions([])

        let header = ["Authorization" : "Basic \(base64UserPass)"]
        request.appendHeaders(header)

        return request
    }
}