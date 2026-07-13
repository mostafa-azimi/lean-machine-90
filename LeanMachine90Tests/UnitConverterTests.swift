import XCTest
@testable import LeanMachine90

final class UnitConverterTests: XCTestCase {
    private let converter = HealthUnitConverter()

    func testMassRoundTrip() {
        let kilograms = converter.kilograms(fromPounds: 195)

        XCTAssertEqual(kilograms, 88.450_512_15, accuracy: 0.000_001)
        XCTAssertEqual(converter.pounds(fromKilograms: kilograms), 195, accuracy: 0.000_001)
    }

    func testLengthRoundTrip() {
        let centimeters = converter.centimeters(fromInches: 74)

        XCTAssertEqual(centimeters, 187.96, accuracy: 0.000_001)
        XCTAssertEqual(converter.inches(fromCentimeters: centimeters), 74, accuracy: 0.000_001)
    }

    func testFluidVolumeRoundTrip() {
        let milliliters = converter.milliliters(fromFluidOunces: 100)

        XCTAssertEqual(milliliters, 2_957.352_956_25, accuracy: 0.000_001)
        XCTAssertEqual(converter.fluidOunces(fromMilliliters: milliliters), 100, accuracy: 0.000_001)
    }
}
