//
//  NSHTTPClientTests.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

import Foundation
import XCTest
import Nocilla
import Nimble
import BrightFutures
@testable import BothamNetworking

class NSHTTPClientTests: NocillaTestCase {

    private let anyUrl = "http://www.any.com"
    private let anyStatusCode = 201
    private let anyBody = "{HttpResponseBody = true}"
    private let anyError = NSError(domain: "DomainError", code: 123, userInfo: nil)

    func testSendsGetRequestToAnyPath() {
        stubRequest("GET", anyUrl)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.GET, url: anyUrl)

        let result = httpClient.send(request)

        expect(result).toEventually(beSuccess())
    }

    func testSendsPostRequestToAnyPath() {
        stubRequest("POST", anyUrl)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.POST, url: anyUrl)

        let result = httpClient.send(request)

        expect(result).toEventually(beSuccess())
    }

    func testSendsPutRequestToAnyPath() {
        stubRequest("PUT", anyUrl)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.PUT, url: anyUrl)

        let result = httpClient.send(request)

        expect(result).toEventually(beSuccess())
    }

    func testSendsDeleteRequestToAnyPath() {
        stubRequest("DELETE", anyUrl)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.DELETE, url: anyUrl)

        let result = httpClient.send(request)

        expect(result).toEventually(beSuccess())
    }

    func testReceivesHttpStatusCodeInTheHttpResponse() {
        stubRequest("GET", anyUrl).andReturn(anyStatusCode)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.GET, url: anyUrl)

        let result = httpClient.send(request)

        expect(result).toEventually(beSuccess())
    }

    func testPropagatesErrorsInTheFuture() {
        stubRequest("GET", anyUrl).andFailWithError(anyError)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.GET, url: anyUrl)

        let result = httpClient.send(request)

        expect(result).toEventually(failWithError(anyError))
    }

    func testSendsParamsConfiguredInTheHttpRequest() {
        stubRequest("GET", "http://www.any.com/?key=value")
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.GET, url: "http://www.any.com/", params: ["key" : "value"])

        let result = httpClient.send(request)

        expect(result).toEventually(beSuccess())
    }

    private func givenOneHttpRequest(httpMethod: HTTPMethod,
        url: String, params: [String:String]? = nil,
        headers: [String:String]? = nil) -> HTTPRequest {
            return HTTPRequest(url: url, parameters: params, headers: headers, httpMethod: httpMethod)
    }
}
