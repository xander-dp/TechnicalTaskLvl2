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
        "Error cases",
        arguments: [
            expectingErrorNullNameCase,
            expectingErrorNoNameCase,
            expectingErrorFieldsWithNonIntegerNumbers,
            expectingErrorWithoutRoles
        ]
    )
    func errorWithoutNameTest(params: (input: String, expected: DecodingError.Type)) {
        #expect(throws: params.expected) {
            let data = Data(params.input.utf8)
            
            let _ = try JSONDecoder().decode(ShipEntity.self, from: data)
        }
    }
    
    //"name" is required and cannot be null by the schema
    static var expectingErrorNullNameCase: (input: String, expected: DecodingError.Type) {
        let normalEntityFields = """
        {
            "name": null
            "roles": []
        }
        """
        let expectedData = DecodingError.self
        
        return (input: normalEntityFields, expected: expectedData)
    }
    
    //"name" is required and cannot be null by the schema
    static var expectingErrorNoNameCase: (input: String, expected: DecodingError.Type) {
        let normalEntityFields = """
        {
            "type": "Tug",
            "year_built": 1976,
            "image": "https://i.imgur.com/woCxpkj.jpg"
            "roles": []
        }
        """
        let expectedError = DecodingError.self
        
        return (input: normalEntityFields, expected: expectedError)
    }
    
    static var expectingErrorFieldsWithNonIntegerNumbers: (input: String, expected: DecodingError.Type) {
        let normalEntityFields = """
        {
            "year_built": 1976.3,
            "name": "American Champion",
            "mass_kg": 266712.7,
            "roles": []
        }
        """
        let expectedError = DecodingError.self
        
        return (input: normalEntityFields, expected: expectedError)
    }
    
    //roles always at least empty array by the schema
    static var expectingErrorWithoutRoles: (input: String, expected: DecodingError.Type) {
        let normalEntityFields = """
        {
            "name": "American Champion"
        }
        """
        let expectedError = DecodingError.self
        
        return (input: normalEntityFields, expected: expectedError)
    }
    
    //MARK: Positive cases
    @Test(
        "Testing decoding from mocked JSON",
          arguments: [
            normalFieldsCase,
            numbersWithFloatingPointCase,
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
            "name": "American Champion",
            "mass_kg": 266712,
            "home_port": "Port of Los Angeles",
            "roles": [
                "Support Ship",
                "Fairing Recovery"
            ]
        }
        """
        let expectedData = ShipEntity(
            name: "American Champion",
            type: "Tug",
            builtYear: 1976,
            weight: 266712,
            homePort: "Port of Los Angeles",
            image: "https://i.imgur.com/woCxpkj.jpg",
            roles: [
                "Support Ship",
                "Fairing Recovery"
            ]
        )
        
        return (input: normalEntityFields, expected: expectedData)
    }
    
    static var numbersWithFloatingPointCase: (input: String, expected: ShipEntity) {
        let normalEntityFields = """
        {
            "type": "Tug",
            "year_built": 2010.0,
            "image": "https://i.imgur.com/woCxpkj.jpg",
            "name": "American Champion",
            "mass_kg": 266712.0,
            "home_port": "Port of Los Angeles",
            "roles": []
        }
        """
        let expectedData = ShipEntity(
            name: "American Champion",
            type: "Tug",
            builtYear: 2010,
            weight: 266712,
            homePort: "Port of Los Angeles",
            image: "https://i.imgur.com/woCxpkj.jpg",
            roles: []
        )
        
        return (input: normalEntityFields, expected: expectedData)
    }
    
    static var optionalFieldsNullCase: (input: String, expected: ShipEntity) {
        let normalEntityFields = """
        {
            "type": null,
            "year_built": null,
            "image": null,
            "name": "American Champion",
            "mass_kg": null,
            "home_port": null,
            "roles": []
        }
        """
        let expectedData = ShipEntity(
            name: "American Champion",
            type: nil,
            builtYear: nil,
            weight: nil,
            homePort: nil,
            image: nil,
            roles: []
        )
        
        return (input: normalEntityFields, expected: expectedData)
    }
    
    static var optionalFieldsNotExistCase: (input: String, expected: ShipEntity) {
        let normalEntityFields = """
        {
            "name": "American Champion",
            "roles": [
                "Support Ship",
                "Fairing Recovery"
            ]
        }
        """
        let expectedData = ShipEntity(
            name: "American Champion",
            type: nil,
            builtYear: nil,
            weight: nil,
            homePort: nil,
            image: nil,
            roles: [
                "Support Ship",
                "Fairing Recovery"
            ]
        )
        
        return (input: normalEntityFields, expected: expectedData)
    }
    
    static var emptyNameCase: (input: String, expected: ShipEntity) {
        let normalEntityFields = """
        {
            "name": "",
            "roles": []
        }
        """
        let expectedData = ShipEntity(
            name: "",
            type: nil,
            builtYear: nil,
            weight: nil,
            homePort: nil,
            image: nil,
            roles: []
        )
        
        return (input: normalEntityFields, expected: expectedData)
    }
}
