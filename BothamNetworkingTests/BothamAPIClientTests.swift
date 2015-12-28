//
//  BothamAPIClientTests.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 23/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import Nimble
import BrightFutures
import Nocilla
@testable import BothamNetworking

class BothamAPIClientTests: NocillaTestCase {

    private let anyHost = "http://www.anyhost.com/"
    private let anyPath = "path"
    private let anyHTTPMethod = HTTPMethod.GET

    func testSendsGetRequestToAnyPath() {
        stubRequest("GET", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.GET(anyPath)

        expect(result).toEventually(beSuccess2())
    }

    func testSendsPostRequestToAnyPath() {
        stubRequest("POST", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.POST(anyPath)

        expect(result).toEventually(beSuccess2())
    }

    func testSendsPutRequestToAnyPath() {
        stubRequest("PUT", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.PUT(anyPath)

        expect(result).toEventually(beSuccess2())
    }

    func XtestSendsDeleteRequestToAnyPath() {
        stubRequest("DELETE", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.DELETE(anyPath)

        expect(result).toEventually(beSuccess2())
    }

    func testSendsPatchRequestToAnyPath() {
        stubRequest("PATCH", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.PATCH(anyPath)

        expect(result).toEventually(beSuccess2())
    }

    func testSendsARequestToTheURLPassedAsArgument() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath)

        expect(result).toEventually(beSuccess2())
    }

    func testSendsARequestToTheURLPassedUsingParams() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath + "?k=v")
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath, params: ["k": "v"])

        expect(result).toEventually(beSuccess2())
    }

    func testReturns40XResponsesAsError() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath).andReturn(400)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath)

        expect(result).toEventually(failWithError(.HTTPResponseError(statusCode: 400, body: NSData())))
    }

    func testReturns50XResponsesAsError() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath).andReturn(500)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath)

        expect(result).toEventually(failWithError(.HTTPResponseError(statusCode: 500, body: NSData())))
    }

    func testInterceptRequestsUsingInterceptorsAddedLocally() {
        stubRequest("GET", anyHost + anyPath)
        let spyInterceptor = SpyRequestInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithInterceptor(spyInterceptor)

        bothamAPIClient.GET(anyPath)

        expect(spyInterceptor.intercepted).toEventually(beTrue())
        expect(spyInterceptor.interceptedRequest.url).toEventually(equal(anyHost + anyPath))
    }

    func testInterceptRequestUsingInterceptorsAddedGlobally() {
        stubRequest("GET", anyHost + anyPath)
        let spyInterceptor = SpyRequestInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithGlobalInterceptor(spyInterceptor)

        bothamAPIClient.GET(anyPath)

        expect(spyInterceptor.intercepted).toEventually(beTrue())
        expect(spyInterceptor.interceptedRequest.url).toEventually(equal(anyHost + anyPath))
    }

    private func givenABothamAPIClientWithInterceptor(interceptor: BothamRequestInterceptor? = nil) -> BothamAPIClient {
        let bothamAPIClient = givenABothamAPIClient()
        if let interceptor = interceptor {
            bothamAPIClient.addRequestInterceptor(interceptor)
        }
        return bothamAPIClient
    }

    private func givenABothamAPIClientWithGlobalInterceptor(interceptor: BothamRequestInterceptor? = nil) -> BothamAPIClient {
        let bothamAPIClient = givenABothamAPIClient()
        if let interceptor = interceptor {
            BothamAPIClient.addGlobalRequestInterceptor(interceptor)
        }
        return bothamAPIClient
    }

    private func givenABothamAPIClient() -> BothamAPIClient {
        return BothamAPIClient(baseEndpoint: anyHost, httpClient: NSHTTPClient())
    }

}