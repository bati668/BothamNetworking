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

    private let anyPath = "path"
    private let anyHTTPMethod = HTTPMethod.GET

    func shouldSendARequestToTheURLPassedAsArgument() {
        stubRequest(anyHTTPMethod.rawValue, anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath)

        expect(result).toEventually(beSuccess())
    }

    func shouldSendARequestToTheURLPassedUsingParams() {
        stubRequest(anyHTTPMethod.rawValue, anyPath + "?k=v")
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath, params: ["k": "v"])

        expect(result).toEventually(beSuccess())
    }


    func testReturns30XResponsesAsError() {
        stubRequest("GET", anyPath).andReturn(300)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath)

        expect(result).toEventually(failWithError(BothamError.HTTPResponseError(statusCode: 300, body: "")))
    }

    private func givenABothamAPIClient() -> BothamAPIClient {
        return BothamAPIClient(baseEndpoint: "www.anyhost.com", httpClient: NSHTTPClient())
    }

}