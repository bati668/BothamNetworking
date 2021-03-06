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
import Result
@testable import BothamNetworking

class NSHTTPClientTests: NocillaTestCase {

    private let anyUrl = "http://www.any.com"
    private let anyStatusCode = 201
    private let anyBody = "{HttpResponseBody = true}"
    private let anyNSError = NSError(domain: "DomainError", code: 123, userInfo: nil)

    func testSendsGetRequestToAnyPath() {
        stubRequest("GET", anyUrl)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.GET, url: anyUrl)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsPostRequestToAnyPath() {
        stubRequest("POST", anyUrl)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.POST, url: anyUrl)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsPutRequestToAnyPath() {
        stubRequest("PUT", anyUrl)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.PUT, url: anyUrl)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsDeleteRequestToAnyPath() {
        stubRequest("DELETE", anyUrl)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.DELETE, url: anyUrl)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsHeadRequestToAnyPath() {
        stubRequest("HEAD", anyUrl)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.HEAD, url: anyUrl)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testReceivesHttpStatusCodeInTheHttpResponse() {
        stubRequest("GET", anyUrl).andReturn(anyStatusCode)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.GET, url: anyUrl)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testPropagatesErrorsInTheFuture() {
        stubRequest("GET", anyUrl).andFailWithError(anyNSError)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.GET, url: anyUrl)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(failWithError(.HTTPClientError(error: anyNSError)))
    }

    func testSendsParamsConfiguredInTheHttpRequest() {
        stubRequest("GET", anyUrl + "?key=value")
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.GET, url: anyUrl, params: ["key" : "value"])

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsBodyConfiguredInTheHttpRequest() {
        stubRequest("POST", anyUrl)
            .withBody("{\"key\":\"value\"}")
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.POST, url: anyUrl, body: ["key" : "value"])

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testReturnsNSConnectionErrorsAsABothamAPIClientNetworkError() {
        stubRequest("GET", anyUrl).andFailWithError(NSError.anyConnectionError())
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.GET, url: anyUrl)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(failWithError(.NetworkError))
    }

    private func givenOneHttpRequest(httpMethod: HTTPMethod,
        url: String, params: [String:String]? = nil,
        headers: [String:String]? = nil,
        body: [String:AnyObject]? = nil) -> HTTPRequest {
            var headers = headers
            headers += ["Content-Type":"application/json"]
            return HTTPRequest(url: url, parameters: params, headers: headers, httpMethod: httpMethod, body: body)
    }

}

extension NSError {

    static func anyConnectionError() -> NSError {
        return NSError(domain: NSURLErrorDomain, code: NSURLErrorNetworkConnectionLost, userInfo: nil)
    }

}