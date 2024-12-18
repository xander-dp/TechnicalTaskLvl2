//
//  ShipsInfoTests.swift
//  ShipsInfoTests
//
//  Created by Oleksandr Savchenko on 17.12.24.
//

import Testing
import Foundation
@testable import ShipsInfo

@Suite class ShipEntityTests {
    //MARK: Negative cases
    @Test(
        "Parsing fails without 'name' field or with null value",
        arguments: [
            expectingErrorNullNameCase,
            expectingErrorNoNameCase
        ]
    )
    func errorWithoutNameTest(params: (input: String, expected: DecodingError.Type)) {
        #expect(throws: params.expected) {
            let data = Data(params.input.utf8)
            
            let _ = try JSONDecoder().decode(ShipEntity.self, from: data)
        }
    }
    
    static var expectingErrorNullNameCase: (input: String, expected: DecodingError.Type) {
        let normalEntityFields = """
        {
            "name": null
        }
        """
        let expectedData = DecodingError.self
        
        return (input: normalEntityFields, expected: expectedData)
    }
    
    static var expectingErrorNoNameCase: (input: String, expected: DecodingError.Type) {
        let normalEntityFields = """
        {
            "type": "Tug",
            "year_built": 1976,
            "image": "https://i.imgur.com/woCxpkj.jpg"
        }
        """
        let expectedData = DecodingError.self
        
        return (input: normalEntityFields, expected: expectedData)
    }
    
    //MARK: Positive cases
    @Test(
        "Testing decoding from mocked JSON",
          arguments: [
            normalFieldsCase,
            floatingPointYearCase,
            optionalFieldsNullCase,
            optionalFieldsNotExistCase,
            emptyNameCase
          ]
    )
    func decodingTest(params: (input: String, expected: ShipEntity)) throws {
        let data = Data(params.input.utf8)
        
        let actual = try JSONDecoder().decode(ShipEntity.self, from: data)
        
        #expect(actual == params.expected)
    }
    
    static var normalFieldsCase: (input: String, expected: ShipEntity) {
        let normalEntityFields = """
        {
            "type": "Tug",
            "year_built": 1976,
            "image": "https://i.imgur.com/woCxpkj.jpg",
            "name": "American Champion"
        }
        """
        let expectedData = ShipEntity(
            name: "American Champion",
            type: "Tug",
            builtYear: 1976,
            image: "https://i.imgur.com/woCxpkj.jpg"
        )
        
        return (input: normalEntityFields, expected: expectedData)
    }
    
    static var floatingPointYearCase: (input: String, expected: ShipEntity) {
        let normalEntityFields = """
        {
            "type": "Tug",
            "year_built": 2010.0,
            "image": "https://i.imgur.com/woCxpkj.jpg",
            "name": "American Champion"
        }
        """
        let expectedData = ShipEntity(
            name: "American Champion",
            type: "Tug",
            builtYear: 2010,
            image: "https://i.imgur.com/woCxpkj.jpg"
        )
        
        return (input: normalEntityFields, expected: expectedData)
    }
    
    static var optionalFieldsNullCase: (input: String, expected: ShipEntity) {
        let normalEntityFields = """
        {
            "type": null,
            "year_built": null,
            "image": null,
            "name": "American Champion"
        }
        """
        let expectedData = ShipEntity(
            name: "American Champion",
            type: nil,
            builtYear: nil,
            image: nil
        )
        
        return (input: normalEntityFields, expected: expectedData)
    }
    
    static var optionalFieldsNotExistCase: (input: String, expected: ShipEntity) {
        let normalEntityFields = """
        {
            "name": "American Champion"
        }
        """
        let expectedData = ShipEntity(
            name: "American Champion",
            type: nil,
            builtYear: nil,
            image: nil
        )
        
        return (input: normalEntityFields, expected: expectedData)
    }
    
    static var emptyNameCase: (input: String, expected: ShipEntity) {
        let normalEntityFields = """
        {
            "name": ""
        }
        """
        let expectedData = ShipEntity(
            name: "",
            type: nil,
            builtYear: nil,
            image: nil
        )
        
        return (input: normalEntityFields, expected: expectedData)
    }
}
