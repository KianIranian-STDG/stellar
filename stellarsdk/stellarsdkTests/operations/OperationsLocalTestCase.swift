//
//  OperationsLocalTestCase.swift
//  stellarsdkTests
//
//  Created by Istvan Elekes on 2/21/18.
//  Copyright © 2018 Soneso. All rights reserved.
//

import XCTest
import stellarsdk

class OperationsLocalTestCase: XCTestCase {
    let sdk = StellarSDK()
    var operationsResponsesMock: OperationsResponsesMock? = nil
    var mockRegistered = false
    
    override func setUp() {
        super.setUp()
        
        if !mockRegistered {
            URLProtocol.registerClass(ServerMock.self)
            mockRegistered = true
        }
        
        operationsResponsesMock = OperationsResponsesMock()
        let allOperationTypesResponse = successResponse()
        operationsResponsesMock?.addOperationsResponse(key: "19", response: allOperationTypesResponse)
    }
    
    override func tearDown() {
        operationsResponsesMock = nil
        super.tearDown()
    }
    
    func testGetOperations() {
        let expectation = XCTestExpectation(description: "Get operations and parse their details")
        
        sdk.operations.getOperations(limit: 19) { (response) -> (Void) in
            switch response {
            case .success(let operationsResponse):
                validateResult(operationsResponse:operationsResponse)
            case .failure(let error):
                StellarSDKLog.printHorizonRequestErrorMessage(tag:"GO Test", horizonRequestError: error)
                XCTAssert(false)
            }
            expectation.fulfill()
        }
        
        func validateResult(operationsResponse:PageResponse<OperationResponse>) {
            
            XCTAssertNotNil(operationsResponse.links)
            XCTAssertNotNil(operationsResponse.links.selflink)
            XCTAssertEqual(operationsResponse.links.selflink.href, "https://horizon-testnet.stellar.org/operations?order=desc&limit=19&cursor=")
            XCTAssertNil(operationsResponse.links.selflink.templated)
            
            XCTAssertNotNil(operationsResponse.links.next)
            XCTAssertEqual(operationsResponse.links.next?.href, "https://horizon-testnet.stellar.org/operations?order=desc&limit=19&cursor=32069348273168385-1")
            XCTAssertNil(operationsResponse.links.next?.templated)
            
            XCTAssertNotNil(operationsResponse.links.prev)
            XCTAssertEqual(operationsResponse.links.prev?.href, "https://horizon-testnet.stellar.org/operations?order=asc&limit=19&cursor=32069369748004865-2")
            XCTAssertNil(operationsResponse.links.prev?.templated)
            
            XCTAssertEqual(operationsResponse.records.count, 11)
            
            for record in operationsResponse.records {
                switch record.operationType {
                case .accountCreated:
                    if record is AccountCreatedOperationResponse {
                        validateAccountCreatedOperationResponse(operationResponse: record as! AccountCreatedOperationResponse)
                    } else {
                        XCTAssert(false)
                    }
                case .payment:
                    if record is PaymentOperationResponse {
                        validatePaymentOperationResponse(operationResponse: record as! PaymentOperationResponse)
                    } else {
                        XCTAssert(false)
                    }
                case .pathPayment:
                    if record is PathPaymentOperationResponse {
                        validatePathPaymentOperationResponse(operationResponse: record as! PathPaymentOperationResponse)
                    } else {
                        XCTAssert(false)
                    }
                case .manageOffer:
                    if record is ManageOfferOperationResponse {
                        validateManageOfferOperationResponse(operationResponse: record as! ManageOfferOperationResponse)
                    } else {
                        XCTAssert(false)
                    }
                case .createPassiveOffer:
                    if record is CreatePassiveOfferOperationResponse {
                        validateCreatePassiveOfferOperationResponse(operationResponse: record as! CreatePassiveOfferOperationResponse)
                    } else {
                        XCTAssert(false)
                    }
                case .setOptions:
                    if record is SetOptionsOperationResponse {
                        validateSetOptionsOperationResponse(operationResponse: record as! SetOptionsOperationResponse)
                    } else {
                        XCTAssert(false)
                    }
                case .changeTrust:
                    if record is ChangeTrustOperationResponse {
                        validateChangeTrustOperationResponse(operationResponse: record as! ChangeTrustOperationResponse)
                    } else {
                        XCTAssert(false)
                    }
                case .allowTrust:
                    if record is AllowTrustOperationResponse {
                        validateAllowTrustOperationResponse(operationResponse: record as! AllowTrustOperationResponse)
                    } else {
                        XCTAssert(false)
                    }
                case .accountMerge:
                    if record is AccountMergeOperationResponse {
                        validateAccountMergeOperationResponse(operationResponse: record as! AccountMergeOperationResponse)
                    } else {
                        XCTAssert(false)
                    }
                case .inflation:
                    if record is InflationOperationResponse {
                        validateInflationOperationResponse(operationResponse: record as! InflationOperationResponse)
                    } else {
                        XCTAssert(false)
                    }
                case .manageData:
                    if record is ManageDataOperationResponse {
                        validateManageDataOperationResponse(operationResponse: record as! ManageDataOperationResponse)
                    } else {
                        XCTAssert(false)
                    }
                }
            }
        }
        // validate account created operation response
        func validateAccountCreatedOperationResponse(operationResponse: AccountCreatedOperationResponse) {
            XCTAssertNotNil(operationResponse.links)
            XCTAssertNotNil(operationResponse.links.effects)
            XCTAssertEqual(operationResponse.links.effects.href, "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}")
            XCTAssertEqual(operationResponse.links.effects.templated, true)
            
            XCTAssertNotNil(operationResponse.links.succeeds)
            XCTAssertEqual(operationResponse.links.succeeds.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc")
            XCTAssertNil(operationResponse.links.succeeds.templated)
            
            XCTAssertNotNil(operationResponse.links.precedes)
            XCTAssertEqual(operationResponse.links.precedes.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc")
            XCTAssertNil(operationResponse.links.precedes.templated)
            
            XCTAssertNotNil(operationResponse.links.transaction)
            XCTAssertEqual(operationResponse.links.transaction.href, "https://horizon-testnet.stellar.org/transactions/77309415424")
            XCTAssertNil(operationResponse.links.transaction.templated)
            
            XCTAssertNotNil(operationResponse.links.selfLink)
            XCTAssertEqual(operationResponse.links.selfLink.href, "https://horizon-testnet.stellar.org/operations/77309415424")
            XCTAssertNil(operationResponse.links.selfLink.templated)
            
            XCTAssertEqual(operationResponse.id, "77309415424")
            XCTAssertEqual(operationResponse.pagingToken, "77309415424")
            XCTAssertEqual(operationResponse.sourceAccount, "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY")
            let createdAt = DateFormatter.iso8601.date(from:"2018-02-21T09:56:26Z")
            XCTAssertEqual(operationResponse.createdAt, createdAt)
            XCTAssertEqual(operationResponse.transactionHash, "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d")
            
            XCTAssertEqual(operationResponse.operationTypeString, "create_account")
            XCTAssertEqual(operationResponse.operationType, OperationType.accountCreated)
            XCTAssertEqual(operationResponse.account, "GBIA4FH6TV64KSPDAJCNUQSM7PFL4ILGUVJDPCLUOPJ7ONMKBBVUQHRO")
            XCTAssertEqual(operationResponse.funder, "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ")
            XCTAssertEqual(operationResponse.startingBalance, Decimal(1e+14))
        }
        
        func validatePaymentOperationResponse(operationResponse: PaymentOperationResponse) {
            XCTAssertNotNil(operationResponse.links)
            XCTAssertNotNil(operationResponse.links.effects)
            XCTAssertEqual(operationResponse.links.effects.href, "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}")
            XCTAssertEqual(operationResponse.links.effects.templated, true)
            
            XCTAssertNotNil(operationResponse.links.succeeds)
            XCTAssertEqual(operationResponse.links.succeeds.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc")
            XCTAssertNil(operationResponse.links.succeeds.templated)
            
            XCTAssertNotNil(operationResponse.links.precedes)
            XCTAssertEqual(operationResponse.links.precedes.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc")
            XCTAssertNil(operationResponse.links.precedes.templated)
            
            XCTAssertNotNil(operationResponse.links.transaction)
            XCTAssertEqual(operationResponse.links.transaction.href, "https://horizon-testnet.stellar.org/transactions/77309415424")
            XCTAssertNil(operationResponse.links.transaction.templated)
            
            XCTAssertNotNil(operationResponse.links.selfLink)
            XCTAssertEqual(operationResponse.links.selfLink.href, "https://horizon-testnet.stellar.org/operations/77309415424")
            XCTAssertNil(operationResponse.links.selfLink.templated)
            
            XCTAssertEqual(operationResponse.id, "77309415424")
            XCTAssertEqual(operationResponse.pagingToken, "77309415424")
            XCTAssertEqual(operationResponse.sourceAccount, "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY")
            let createdAt = DateFormatter.iso8601.date(from:"2018-02-21T09:56:26Z")
            XCTAssertEqual(operationResponse.createdAt, createdAt)
            XCTAssertEqual(operationResponse.transactionHash, "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d")
            
            XCTAssertEqual(operationResponse.operationTypeString, "payment")
            XCTAssertEqual(operationResponse.operationType, OperationType.payment)
            XCTAssertEqual(operationResponse.amount, "100.0")
            XCTAssertEqual(operationResponse.assetType, AssetTypeAsString.CREDIT_ALPHANUM4)
            XCTAssertEqual(operationResponse.assetCode, "EUR")
            XCTAssertEqual(operationResponse.assetIssuer, "GAZN3PPIDQCSP5JD4ETQQQ2IU2RMFYQTAL4NNQZUGLLO2XJJJ3RDSDGA")
            XCTAssertEqual(operationResponse.from, "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY")
            XCTAssertEqual(operationResponse.to, "GBIA4FH6TV64KSPDAJCNUQSM7PFL4ILGUVJDPCLUOPJ7ONMKBBVUQHRO")
        }
        
        func validatePathPaymentOperationResponse(operationResponse: PathPaymentOperationResponse) {
            XCTAssertNotNil(operationResponse.links)
            XCTAssertNotNil(operationResponse.links.effects)
            XCTAssertEqual(operationResponse.links.effects.href, "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}")
            XCTAssertEqual(operationResponse.links.effects.templated, true)
            
            XCTAssertNotNil(operationResponse.links.succeeds)
            XCTAssertEqual(operationResponse.links.succeeds.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc")
            XCTAssertNil(operationResponse.links.succeeds.templated)
            
            XCTAssertNotNil(operationResponse.links.precedes)
            XCTAssertEqual(operationResponse.links.precedes.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc")
            XCTAssertNil(operationResponse.links.precedes.templated)
            
            XCTAssertNotNil(operationResponse.links.transaction)
            XCTAssertEqual(operationResponse.links.transaction.href, "https://horizon-testnet.stellar.org/transactions/77309415424")
            XCTAssertNil(operationResponse.links.transaction.templated)
            
            XCTAssertNotNil(operationResponse.links.selfLink)
            XCTAssertEqual(operationResponse.links.selfLink.href, "https://horizon-testnet.stellar.org/operations/77309415424")
            XCTAssertNil(operationResponse.links.selfLink.templated)
            
            XCTAssertEqual(operationResponse.id, "77309415424")
            XCTAssertEqual(operationResponse.pagingToken, "77309415424")
            XCTAssertEqual(operationResponse.sourceAccount, "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY")
            let createdAt = DateFormatter.iso8601.date(from:"2018-02-21T09:56:26Z")
            XCTAssertEqual(operationResponse.createdAt, createdAt)
            XCTAssertEqual(operationResponse.transactionHash, "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d")
            
            XCTAssertEqual(operationResponse.operationTypeString, "path_payment")
            XCTAssertEqual(operationResponse.operationType, OperationType.pathPayment)
            XCTAssertEqual(operationResponse.amount, "100.0")
            XCTAssertEqual(operationResponse.sourceAmount, "50.0")
            XCTAssertEqual(operationResponse.assetType, AssetTypeAsString.NATIVE)
            XCTAssertNil(operationResponse.assetCode)
            XCTAssertNil(operationResponse.assetIssuer)
            XCTAssertEqual(operationResponse.from, "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY")
            XCTAssertEqual(operationResponse.to, "GBIA4FH6TV64KSPDAJCNUQSM7PFL4ILGUVJDPCLUOPJ7ONMKBBVUQHRO")
            XCTAssertEqual(operationResponse.sendAssetType, AssetTypeAsString.CREDIT_ALPHANUM4)
            XCTAssertEqual(operationResponse.sendAssetCode, "EUR")
            XCTAssertEqual(operationResponse.sendAssetIssuer, "GAZN3PPIDQCSP5JD4ETQQQ2IU2RMFYQTAL4NNQZUGLLO2XJJJ3RDSDGA")
        }
        
        func validateManageOfferOperationResponse(operationResponse: ManageOfferOperationResponse) {
            XCTAssertNotNil(operationResponse.links)
            XCTAssertNotNil(operationResponse.links.effects)
            XCTAssertEqual(operationResponse.links.effects.href, "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}")
            XCTAssertEqual(operationResponse.links.effects.templated, true)
            
            XCTAssertNotNil(operationResponse.links.succeeds)
            XCTAssertEqual(operationResponse.links.succeeds.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc")
            XCTAssertNil(operationResponse.links.succeeds.templated)
            
            XCTAssertNotNil(operationResponse.links.precedes)
            XCTAssertEqual(operationResponse.links.precedes.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc")
            XCTAssertNil(operationResponse.links.precedes.templated)
            
            XCTAssertNotNil(operationResponse.links.transaction)
            XCTAssertEqual(operationResponse.links.transaction.href, "https://horizon-testnet.stellar.org/transactions/77309415424")
            XCTAssertNil(operationResponse.links.transaction.templated)
            
            XCTAssertNotNil(operationResponse.links.selfLink)
            XCTAssertEqual(operationResponse.links.selfLink.href, "https://horizon-testnet.stellar.org/operations/77309415424")
            XCTAssertNil(operationResponse.links.selfLink.templated)
            
            XCTAssertEqual(operationResponse.id, "77309415424")
            XCTAssertEqual(operationResponse.pagingToken, "77309415424")
            XCTAssertEqual(operationResponse.sourceAccount, "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY")
            let createdAt = DateFormatter.iso8601.date(from:"2018-02-21T09:56:26Z")
            XCTAssertEqual(operationResponse.createdAt, createdAt)
            XCTAssertEqual(operationResponse.transactionHash, "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d")
            
            XCTAssertEqual(operationResponse.operationTypeString, "manage_offer")
            XCTAssertEqual(operationResponse.operationType, OperationType.manageOffer)
            XCTAssertEqual(operationResponse.offerId, "5b422945c99ec8bd8b29b0086aeb89027a774be")
            XCTAssertEqual(operationResponse.amount, "100.0")
            XCTAssertEqual(operationResponse.price, "50.0")
            XCTAssertEqual(operationResponse.sellingAssetType, AssetTypeAsString.NATIVE)
            XCTAssertNil(operationResponse.sellingAssetCode)
            XCTAssertNil(operationResponse.sellingAssetIssuer)
            XCTAssertEqual(operationResponse.buyingAssetType, AssetTypeAsString.CREDIT_ALPHANUM4)
            XCTAssertEqual(operationResponse.buyingAssetCode, "EUR")
            XCTAssertEqual(operationResponse.buyingAssetIssuer, "GAZN3PPIDQCSP5JD4ETQQQ2IU2RMFYQTAL4NNQZUGLLO2XJJJ3RDSDGA")
        }
        
        func validateCreatePassiveOfferOperationResponse(operationResponse: CreatePassiveOfferOperationResponse) {
            XCTAssertNotNil(operationResponse.links)
            XCTAssertNotNil(operationResponse.links.effects)
            XCTAssertEqual(operationResponse.links.effects.href, "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}")
            XCTAssertEqual(operationResponse.links.effects.templated, true)
            
            XCTAssertNotNil(operationResponse.links.succeeds)
            XCTAssertEqual(operationResponse.links.succeeds.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc")
            XCTAssertNil(operationResponse.links.succeeds.templated)
            
            XCTAssertNotNil(operationResponse.links.precedes)
            XCTAssertEqual(operationResponse.links.precedes.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc")
            XCTAssertNil(operationResponse.links.precedes.templated)
            
            XCTAssertNotNil(operationResponse.links.transaction)
            XCTAssertEqual(operationResponse.links.transaction.href, "https://horizon-testnet.stellar.org/transactions/77309415424")
            XCTAssertNil(operationResponse.links.transaction.templated)
            
            XCTAssertNotNil(operationResponse.links.selfLink)
            XCTAssertEqual(operationResponse.links.selfLink.href, "https://horizon-testnet.stellar.org/operations/77309415424")
            XCTAssertNil(operationResponse.links.selfLink.templated)
            
            XCTAssertEqual(operationResponse.id, "77309415424")
            XCTAssertEqual(operationResponse.pagingToken, "77309415424")
            XCTAssertEqual(operationResponse.sourceAccount, "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY")
            let createdAt = DateFormatter.iso8601.date(from:"2018-02-21T09:56:26Z")
            XCTAssertEqual(operationResponse.createdAt, createdAt)
            XCTAssertEqual(operationResponse.transactionHash, "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d")
            
            XCTAssertEqual(operationResponse.operationTypeString, "create_passive_offer")
            XCTAssertEqual(operationResponse.operationType, OperationType.createPassiveOffer)
            XCTAssertEqual(operationResponse.offerId, "5b422945c99ec8bd8b29b0086aeb89027a774be")
            XCTAssertEqual(operationResponse.amount, "100.0")
            XCTAssertEqual(operationResponse.price, "50.0")
            XCTAssertEqual(operationResponse.sellingAssetType, AssetTypeAsString.NATIVE)
            XCTAssertNil(operationResponse.sellingAssetCode)
            XCTAssertNil(operationResponse.sellingAssetIssuer)
            XCTAssertEqual(operationResponse.buyingAssetType, AssetTypeAsString.CREDIT_ALPHANUM4)
            XCTAssertEqual(operationResponse.buyingAssetCode, "EUR")
            XCTAssertEqual(operationResponse.buyingAssetIssuer, "GAZN3PPIDQCSP5JD4ETQQQ2IU2RMFYQTAL4NNQZUGLLO2XJJJ3RDSDGA")
        }
        
        func validateSetOptionsOperationResponse(operationResponse: SetOptionsOperationResponse) {
            XCTAssertNotNil(operationResponse.links)
            XCTAssertNotNil(operationResponse.links.effects)
            XCTAssertEqual(operationResponse.links.effects.href, "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}")
            XCTAssertEqual(operationResponse.links.effects.templated, true)
            
            XCTAssertNotNil(operationResponse.links.succeeds)
            XCTAssertEqual(operationResponse.links.succeeds.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc")
            XCTAssertNil(operationResponse.links.succeeds.templated)
            
            XCTAssertNotNil(operationResponse.links.precedes)
            XCTAssertEqual(operationResponse.links.precedes.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc")
            XCTAssertNil(operationResponse.links.precedes.templated)
            
            XCTAssertNotNil(operationResponse.links.transaction)
            XCTAssertEqual(operationResponse.links.transaction.href, "https://horizon-testnet.stellar.org/transactions/77309415424")
            XCTAssertNil(operationResponse.links.transaction.templated)
            
            XCTAssertNotNil(operationResponse.links.selfLink)
            XCTAssertEqual(operationResponse.links.selfLink.href, "https://horizon-testnet.stellar.org/operations/77309415424")
            XCTAssertNil(operationResponse.links.selfLink.templated)
            
            XCTAssertEqual(operationResponse.id, "77309415424")
            XCTAssertEqual(operationResponse.pagingToken, "77309415424")
            XCTAssertEqual(operationResponse.sourceAccount, "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY")
            let createdAt = DateFormatter.iso8601.date(from:"2018-02-21T09:56:26Z")
            XCTAssertEqual(operationResponse.createdAt, createdAt)
            XCTAssertEqual(operationResponse.transactionHash, "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d")
            
            XCTAssertEqual(operationResponse.operationTypeString, "set_options")
            XCTAssertEqual(operationResponse.operationType, OperationType.setOptions)
            XCTAssertEqual(operationResponse.lowThreshold, 1)
            XCTAssertEqual(operationResponse.medThreshold, 2)
            XCTAssertEqual(operationResponse.highThreshold, 3)
            XCTAssertEqual(operationResponse.inflationDestination, "GAZN3PPIDQCSP5JD4ETQQQ2IU2RMFYQTAL4NNQZUGLLO2XJJJ3RDSDGA")
            XCTAssertEqual(operationResponse.signerKey, "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY")
            XCTAssertEqual(operationResponse.signerWeight, 122)
            XCTAssertEqual(operationResponse.masterKeyWeight, 222)
        }
        
        func validateChangeTrustOperationResponse(operationResponse: ChangeTrustOperationResponse) {
            XCTAssertNotNil(operationResponse.links)
            XCTAssertNotNil(operationResponse.links.effects)
            XCTAssertEqual(operationResponse.links.effects.href, "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}")
            XCTAssertEqual(operationResponse.links.effects.templated, true)
            
            XCTAssertNotNil(operationResponse.links.succeeds)
            XCTAssertEqual(operationResponse.links.succeeds.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc")
            XCTAssertNil(operationResponse.links.succeeds.templated)
            
            XCTAssertNotNil(operationResponse.links.precedes)
            XCTAssertEqual(operationResponse.links.precedes.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc")
            XCTAssertNil(operationResponse.links.precedes.templated)
            
            XCTAssertNotNil(operationResponse.links.transaction)
            XCTAssertEqual(operationResponse.links.transaction.href, "https://horizon-testnet.stellar.org/transactions/77309415424")
            XCTAssertNil(operationResponse.links.transaction.templated)
            
            XCTAssertNotNil(operationResponse.links.selfLink)
            XCTAssertEqual(operationResponse.links.selfLink.href, "https://horizon-testnet.stellar.org/operations/77309415424")
            XCTAssertNil(operationResponse.links.selfLink.templated)
            
            XCTAssertEqual(operationResponse.id, "77309415424")
            XCTAssertEqual(operationResponse.pagingToken, "77309415424")
            XCTAssertEqual(operationResponse.sourceAccount, "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY")
            let createdAt = DateFormatter.iso8601.date(from:"2018-02-21T09:56:26Z")
            XCTAssertEqual(operationResponse.createdAt, createdAt)
            XCTAssertEqual(operationResponse.transactionHash, "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d")
            
            XCTAssertEqual(operationResponse.operationTypeString, "change_trust")
            XCTAssertEqual(operationResponse.operationType, OperationType.changeTrust)
            XCTAssertEqual(operationResponse.trustor, "GAZN3PPIDQCSP5JD4ETQQQ2IU2RMFYQTAL4NNQZUGLLO2XJJJ3RDSDGA")
            XCTAssertEqual(operationResponse.trustee, "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY")
            XCTAssertEqual(operationResponse.assetType, AssetTypeAsString.NATIVE)
            XCTAssertNil(operationResponse.assetCode)
            XCTAssertNil(operationResponse.assetIssuer)
            XCTAssertEqual(operationResponse.limit, "5")
        }
        
        func validateAllowTrustOperationResponse(operationResponse: AllowTrustOperationResponse) {
            XCTAssertNotNil(operationResponse.links)
            XCTAssertNotNil(operationResponse.links.effects)
            XCTAssertEqual(operationResponse.links.effects.href, "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}")
            XCTAssertEqual(operationResponse.links.effects.templated, true)
            
            XCTAssertNotNil(operationResponse.links.succeeds)
            XCTAssertEqual(operationResponse.links.succeeds.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc")
            XCTAssertNil(operationResponse.links.succeeds.templated)
            
            XCTAssertNotNil(operationResponse.links.precedes)
            XCTAssertEqual(operationResponse.links.precedes.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc")
            XCTAssertNil(operationResponse.links.precedes.templated)
            
            XCTAssertNotNil(operationResponse.links.transaction)
            XCTAssertEqual(operationResponse.links.transaction.href, "https://horizon-testnet.stellar.org/transactions/77309415424")
            XCTAssertNil(operationResponse.links.transaction.templated)
            
            XCTAssertNotNil(operationResponse.links.selfLink)
            XCTAssertEqual(operationResponse.links.selfLink.href, "https://horizon-testnet.stellar.org/operations/77309415424")
            XCTAssertNil(operationResponse.links.selfLink.templated)
            
            XCTAssertEqual(operationResponse.id, "77309415424")
            XCTAssertEqual(operationResponse.pagingToken, "77309415424")
            XCTAssertEqual(operationResponse.sourceAccount, "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY")
            let createdAt = DateFormatter.iso8601.date(from:"2018-02-21T09:56:26Z")
            XCTAssertEqual(operationResponse.createdAt, createdAt)
            XCTAssertEqual(operationResponse.transactionHash, "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d")
            
            XCTAssertEqual(operationResponse.operationTypeString, "allow_trust")
            XCTAssertEqual(operationResponse.operationType, OperationType.allowTrust)
            XCTAssertEqual(operationResponse.trustor, "GAZN3PPIDQCSP5JD4ETQQQ2IU2RMFYQTAL4NNQZUGLLO2XJJJ3RDSDGA")
            XCTAssertEqual(operationResponse.trustee, "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY")
            XCTAssertEqual(operationResponse.assetType, AssetTypeAsString.CREDIT_ALPHANUM4)
            XCTAssertEqual(operationResponse.assetCode, "EUR")
            XCTAssertEqual(operationResponse.assetIssuer, "GAZN3PPIDQCSP5JD4ETQQQ2IU2RMFYQTAL4NNQZUGLLO2XJJJ3RDSDGA")
            XCTAssertEqual(operationResponse.authorize, true)
        }
        
        func validateAccountMergeOperationResponse(operationResponse: AccountMergeOperationResponse) {
            XCTAssertNotNil(operationResponse.links)
            XCTAssertNotNil(operationResponse.links.effects)
            XCTAssertEqual(operationResponse.links.effects.href, "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}")
            XCTAssertEqual(operationResponse.links.effects.templated, true)
            
            XCTAssertNotNil(operationResponse.links.succeeds)
            XCTAssertEqual(operationResponse.links.succeeds.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc")
            XCTAssertNil(operationResponse.links.succeeds.templated)
            
            XCTAssertNotNil(operationResponse.links.precedes)
            XCTAssertEqual(operationResponse.links.precedes.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc")
            XCTAssertNil(operationResponse.links.precedes.templated)
            
            XCTAssertNotNil(operationResponse.links.transaction)
            XCTAssertEqual(operationResponse.links.transaction.href, "https://horizon-testnet.stellar.org/transactions/77309415424")
            XCTAssertNil(operationResponse.links.transaction.templated)
            
            XCTAssertNotNil(operationResponse.links.selfLink)
            XCTAssertEqual(operationResponse.links.selfLink.href, "https://horizon-testnet.stellar.org/operations/77309415424")
            XCTAssertNil(operationResponse.links.selfLink.templated)
            
            XCTAssertEqual(operationResponse.id, "77309415424")
            XCTAssertEqual(operationResponse.pagingToken, "77309415424")
            XCTAssertEqual(operationResponse.sourceAccount, "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY")
            let createdAt = DateFormatter.iso8601.date(from:"2018-02-21T09:56:26Z")
            XCTAssertEqual(operationResponse.createdAt, createdAt)
            XCTAssertEqual(operationResponse.transactionHash, "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d")
            
            XCTAssertEqual(operationResponse.operationTypeString, "account_merge")
            XCTAssertEqual(operationResponse.operationType, OperationType.accountMerge)
            XCTAssertEqual(operationResponse.account, "GBIA4FH6TV64KSPDAJCNUQSM7PFL4ILGUVJDPCLUOPJ7ONMKBBVUQHRO")
            XCTAssertEqual(operationResponse.into, "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ")
        }
        
        func validateInflationOperationResponse(operationResponse: InflationOperationResponse) {
            XCTAssertNotNil(operationResponse.links)
            XCTAssertNotNil(operationResponse.links.effects)
            XCTAssertEqual(operationResponse.links.effects.href, "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}")
            XCTAssertEqual(operationResponse.links.effects.templated, true)
            
            XCTAssertNotNil(operationResponse.links.succeeds)
            XCTAssertEqual(operationResponse.links.succeeds.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc")
            XCTAssertNil(operationResponse.links.succeeds.templated)
            
            XCTAssertNotNil(operationResponse.links.precedes)
            XCTAssertEqual(operationResponse.links.precedes.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc")
            XCTAssertNil(operationResponse.links.precedes.templated)
            
            XCTAssertNotNil(operationResponse.links.transaction)
            XCTAssertEqual(operationResponse.links.transaction.href, "https://horizon-testnet.stellar.org/transactions/77309415424")
            XCTAssertNil(operationResponse.links.transaction.templated)
            
            XCTAssertNotNil(operationResponse.links.selfLink)
            XCTAssertEqual(operationResponse.links.selfLink.href, "https://horizon-testnet.stellar.org/operations/77309415424")
            XCTAssertNil(operationResponse.links.selfLink.templated)
            
            XCTAssertEqual(operationResponse.id, "77309415424")
            XCTAssertEqual(operationResponse.pagingToken, "77309415424")
            XCTAssertEqual(operationResponse.sourceAccount, "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY")
            let createdAt = DateFormatter.iso8601.date(from:"2018-02-21T09:56:26Z")
            XCTAssertEqual(operationResponse.createdAt, createdAt)
            XCTAssertEqual(operationResponse.transactionHash, "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d")
            
            XCTAssertEqual(operationResponse.operationTypeString, "inflation")
            XCTAssertEqual(operationResponse.operationType, OperationType.inflation)
        }
        
        func validateManageDataOperationResponse(operationResponse: ManageDataOperationResponse) {
            XCTAssertNotNil(operationResponse.links)
            XCTAssertNotNil(operationResponse.links.effects)
            XCTAssertEqual(operationResponse.links.effects.href, "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}")
            XCTAssertEqual(operationResponse.links.effects.templated, true)
            
            XCTAssertNotNil(operationResponse.links.succeeds)
            XCTAssertEqual(operationResponse.links.succeeds.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc")
            XCTAssertNil(operationResponse.links.succeeds.templated)
            
            XCTAssertNotNil(operationResponse.links.precedes)
            XCTAssertEqual(operationResponse.links.precedes.href, "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc")
            XCTAssertNil(operationResponse.links.precedes.templated)
            
            XCTAssertNotNil(operationResponse.links.transaction)
            XCTAssertEqual(operationResponse.links.transaction.href, "https://horizon-testnet.stellar.org/transactions/77309415424")
            XCTAssertNil(operationResponse.links.transaction.templated)
            
            XCTAssertNotNil(operationResponse.links.selfLink)
            XCTAssertEqual(operationResponse.links.selfLink.href, "https://horizon-testnet.stellar.org/operations/77309415424")
            XCTAssertNil(operationResponse.links.selfLink.templated)
            
            XCTAssertEqual(operationResponse.id, "77309415424")
            XCTAssertEqual(operationResponse.pagingToken, "77309415424")
            XCTAssertEqual(operationResponse.sourceAccount, "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY")
            let createdAt = DateFormatter.iso8601.date(from:"2018-02-21T09:56:26Z")
            XCTAssertEqual(operationResponse.createdAt, createdAt)
            XCTAssertEqual(operationResponse.transactionHash, "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d")
            
            XCTAssertEqual(operationResponse.operationTypeString, "manage_data")
            XCTAssertEqual(operationResponse.operationType, OperationType.manageData)
            XCTAssertEqual(operationResponse.name, "ManageData")
            XCTAssertEqual(operationResponse.value, "5b422945c99ec8bd8b29b")
        }
        
        wait(for: [expectation], timeout: 15.0)
    }
    
    func successResponse() -> String {
        
        // account created
        var operationsResponseString = """
        {
            "_links": {
                "self": {
                    "href": "https://horizon-testnet.stellar.org/operations?order=desc&limit=19&cursor="
                },
                "next": {
                    "href": "https://horizon-testnet.stellar.org/operations?order=desc&limit=19&cursor=32069348273168385-1"
                },
                "prev": {
                    "href": "https://horizon-testnet.stellar.org/operations?order=asc&limit=19&cursor=32069369748004865-2"
                }
            },
            "_embedded": {
                "records": [
        """
        
        operationsResponseString.append(accountCreatedOperation)
        operationsResponseString.append("," + paymentOperation)
        operationsResponseString.append("," + pathPaymentOperation)
        operationsResponseString.append("," + manageOfferOperation)
        operationsResponseString.append("," + createPassiveOfferOperation)
        operationsResponseString.append("," + setOptionsOperation)
        operationsResponseString.append("," + changeTrustOperation)
        operationsResponseString.append("," + allowTrustOperation)
        operationsResponseString.append("," + accountMergeOperation)
        operationsResponseString.append("," + inflationOperation)
        operationsResponseString.append("," + manageDataOperation)
        
        
        let end = """
                    ]
                }
            }
        """
        
        operationsResponseString.append(end)
        return operationsResponseString
    }
    
    let accountCreatedOperation = """
            {
                "_links": {
                    "effects": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}",
                        "templated": true
                    },
                    "precedes": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc"
                    },
                    "self": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424"
                    },
                    "succeeds": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc"
                    },
                    "transaction": {
                        "href": "https://horizon-testnet.stellar.org/transactions/77309415424"
                    }
                },
                "id": "77309415424",
                "paging_token": "77309415424",
                "type_i": 0,
                "type": "create_account",
                "source_account": "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY",
                "created_at": "2018-02-21T09:56:26Z",
                "transaction_hash": "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d",
                "account": "GBIA4FH6TV64KSPDAJCNUQSM7PFL4ILGUVJDPCLUOPJ7ONMKBBVUQHRO",
                "funder": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ",
                "starting_balance": "1e+14"
            }
    """
    
    let paymentOperation = """
            {
                "_links": {
                    "effects": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}",
                        "templated": true
                    },
                    "precedes": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc"
                    },
                    "self": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424"
                    },
                    "succeeds": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc"
                    },
                    "transaction": {
                        "href": "https://horizon-testnet.stellar.org/transactions/77309415424"
                    }
                },
                "id": "77309415424",
                "paging_token": "77309415424",
                "type_i": 1,
                "type": "payment",
                "source_account": "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY",
                "created_at": "2018-02-21T09:56:26Z",
                "transaction_hash": "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d",
                "asset_type": "credit_alphanum4",
                "asset_code": "EUR",
                "asset_issuer": "GAZN3PPIDQCSP5JD4ETQQQ2IU2RMFYQTAL4NNQZUGLLO2XJJJ3RDSDGA",
                "amount": "100.0",
                "from": "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY",
                "to": "GBIA4FH6TV64KSPDAJCNUQSM7PFL4ILGUVJDPCLUOPJ7ONMKBBVUQHRO"
            }
    """
    
    let pathPaymentOperation = """
            {
                "_links": {
                    "effects": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}",
                        "templated": true
                    },
                    "precedes": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc"
                    },
                    "self": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424"
                    },
                    "succeeds": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc"
                    },
                    "transaction": {
                        "href": "https://horizon-testnet.stellar.org/transactions/77309415424"
                    }
                },
                "id": "77309415424",
                "paging_token": "77309415424",
                "type_i": 2,
                "type": "path_payment",
                "source_account": "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY",
                "created_at": "2018-02-21T09:56:26Z",
                "transaction_hash": "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d",
                "asset_type": "native",
                "amount": "100.0",
                "source_amount": "50.0",
                "from": "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY",
                "to": "GBIA4FH6TV64KSPDAJCNUQSM7PFL4ILGUVJDPCLUOPJ7ONMKBBVUQHRO",
                "send_asset_type": "credit_alphanum4",
                "send_asset_code": "EUR",
                "send_asset_issuer": "GAZN3PPIDQCSP5JD4ETQQQ2IU2RMFYQTAL4NNQZUGLLO2XJJJ3RDSDGA"
            }
    """
    
    let manageOfferOperation = """
            {
                "_links": {
                    "effects": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}",
                        "templated": true
                    },
                    "precedes": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc"
                    },
                    "self": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424"
                    },
                    "succeeds": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc"
                    },
                    "transaction": {
                        "href": "https://horizon-testnet.stellar.org/transactions/77309415424"
                    }
                },
                "id": "77309415424",
                "paging_token": "77309415424",
                "type_i": 3,
                "type": "manage_offer",
                "source_account": "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY",
                "created_at": "2018-02-21T09:56:26Z",
                "transaction_hash": "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d",
                "offer_id": "5b422945c99ec8bd8b29b0086aeb89027a774be",
                "amount": "100.0",
                "price": "50.0",
                "selling_asset_type": "native",
                "buying_asset_type": "credit_alphanum4",
                "buying_asset_code": "EUR",
                "buying_asset_issuer": "GAZN3PPIDQCSP5JD4ETQQQ2IU2RMFYQTAL4NNQZUGLLO2XJJJ3RDSDGA"
            }
    """
    
    let createPassiveOfferOperation = """
            {
                "_links": {
                    "effects": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}",
                        "templated": true
                    },
                    "precedes": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc"
                    },
                    "self": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424"
                    },
                    "succeeds": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc"
                    },
                    "transaction": {
                        "href": "https://horizon-testnet.stellar.org/transactions/77309415424"
                    }
                },
                "id": "77309415424",
                "paging_token": "77309415424",
                "type_i": 4,
                "type": "create_passive_offer",
                "source_account": "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY",
                "created_at": "2018-02-21T09:56:26Z",
                "transaction_hash": "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d",
                "offer_id": "5b422945c99ec8bd8b29b0086aeb89027a774be",
                "amount": "100.0",
                "price": "50.0",
                "selling_asset_type": "native",
                "buying_asset_type": "credit_alphanum4",
                "buying_asset_code": "EUR",
                "buying_asset_issuer": "GAZN3PPIDQCSP5JD4ETQQQ2IU2RMFYQTAL4NNQZUGLLO2XJJJ3RDSDGA"
            }
    """
    
    let setOptionsOperation = """
            {
                "_links": {
                    "effects": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}",
                        "templated": true
                    },
                    "precedes": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc"
                    },
                    "self": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424"
                    },
                    "succeeds": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc"
                    },
                    "transaction": {
                        "href": "https://horizon-testnet.stellar.org/transactions/77309415424"
                    }
                },
                "id": "77309415424",
                "paging_token": "77309415424",
                "type_i": 5,
                "type": "set_options",
                "source_account": "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY",
                "created_at": "2018-02-21T09:56:26Z",
                "transaction_hash": "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d",
                "low_threshold": 1,
                "med_threshold": 2,
                "high_threshold": 3,
                "inflation_dest": "GAZN3PPIDQCSP5JD4ETQQQ2IU2RMFYQTAL4NNQZUGLLO2XJJJ3RDSDGA",
                "signer_key": "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY",
                "signer_weight": 122,
                "master_key_weight": 222
            }
    """
    
    let changeTrustOperation = """
            {
                "_links": {
                    "effects": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}",
                        "templated": true
                    },
                    "precedes": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc"
                    },
                    "self": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424"
                    },
                    "succeeds": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc"
                    },
                    "transaction": {
                        "href": "https://horizon-testnet.stellar.org/transactions/77309415424"
                    }
                },
                "id": "77309415424",
                "paging_token": "77309415424",
                "type_i": 6,
                "type": "change_trust",
                "source_account": "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY",
                "created_at": "2018-02-21T09:56:26Z",
                "transaction_hash": "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d",
                "asset_type": "native",
                "limit": "5",
                "trustor": "GAZN3PPIDQCSP5JD4ETQQQ2IU2RMFYQTAL4NNQZUGLLO2XJJJ3RDSDGA",
                "trustee": "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY"
            }
    """
    
    let allowTrustOperation = """
            {
                "_links": {
                    "effects": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}",
                        "templated": true
                    },
                    "precedes": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc"
                    },
                    "self": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424"
                    },
                    "succeeds": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc"
                    },
                    "transaction": {
                        "href": "https://horizon-testnet.stellar.org/transactions/77309415424"
                    }
                },
                "id": "77309415424",
                "paging_token": "77309415424",
                "type_i": 7,
                "type": "allow_trust",
                "source_account": "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY",
                "created_at": "2018-02-21T09:56:26Z",
                "transaction_hash": "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d",
                "asset_type": "credit_alphanum4",
                "asset_code": "EUR",
                "asset_issuer": "GAZN3PPIDQCSP5JD4ETQQQ2IU2RMFYQTAL4NNQZUGLLO2XJJJ3RDSDGA",
                "trustor": "GAZN3PPIDQCSP5JD4ETQQQ2IU2RMFYQTAL4NNQZUGLLO2XJJJ3RDSDGA",
                "trustee": "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY",
                "authorize": true
            }
    """
    
    let accountMergeOperation = """
            {
                "_links": {
                    "effects": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}",
                        "templated": true
                    },
                    "precedes": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc"
                    },
                    "self": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424"
                    },
                    "succeeds": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc"
                    },
                    "transaction": {
                        "href": "https://horizon-testnet.stellar.org/transactions/77309415424"
                    }
                },
                "id": "77309415424",
                "paging_token": "77309415424",
                "type_i": 8,
                "type": "account_merge",
                "source_account": "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY",
                "created_at": "2018-02-21T09:56:26Z",
                "transaction_hash": "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d",
                "account": "GBIA4FH6TV64KSPDAJCNUQSM7PFL4ILGUVJDPCLUOPJ7ONMKBBVUQHRO",
                "into": "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ"
            }
    """
    
    let inflationOperation = """
            {
                "_links": {
                    "effects": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}",
                        "templated": true
                    },
                    "precedes": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc"
                    },
                    "self": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424"
                    },
                    "succeeds": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc"
                    },
                    "transaction": {
                        "href": "https://horizon-testnet.stellar.org/transactions/77309415424"
                    }
                },
                "id": "77309415424",
                "paging_token": "77309415424",
                "type_i": 9,
                "type": "inflation",
                "source_account": "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY",
                "created_at": "2018-02-21T09:56:26Z",
                "transaction_hash": "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d"
            }
    """
    
    let manageDataOperation = """
            {
                "_links": {
                    "effects": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424/effects/{?cursor,limit,order}",
                        "templated": true
                    },
                    "precedes": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=asc"
                    },
                    "self": {
                        "href": "https://horizon-testnet.stellar.org/operations/77309415424"
                    },
                    "succeeds": {
                        "href": "https://horizon-testnet.stellar.org/operations?cursor=77309415424&order=desc"
                    },
                    "transaction": {
                        "href": "https://horizon-testnet.stellar.org/transactions/77309415424"
                    }
                },
                "id": "77309415424",
                "paging_token": "77309415424",
                "type_i": 10,
                "type": "manage_data",
                "source_account": "GDWGJSTUVRNFTR7STPUUHFWQYAN6KBVWCZT2YN7MY276GCSSXSWPS6JY",
                "created_at": "2018-02-21T09:56:26Z",
                "transaction_hash": "5b422945c99ec8bd8b29b0086aeb89027a774be54e8663d3fa538775cde8b51d",
                "name": "ManageData",
                "value": "5b422945c99ec8bd8b29b"
            }
    """
}
