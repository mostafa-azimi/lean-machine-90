import Foundation

protocol UnitConverting: Sendable {
    func kilograms(fromPounds pounds: Double) -> Double
    func pounds(fromKilograms kilograms: Double) -> Double
    func centimeters(fromInches inches: Double) -> Double
    func inches(fromCentimeters centimeters: Double) -> Double
    func milliliters(fromFluidOunces ounces: Double) -> Double
    func fluidOunces(fromMilliliters milliliters: Double) -> Double
}

struct HealthUnitConverter: UnitConverting {
    func kilograms(fromPounds pounds: Double) -> Double {
        Measurement(value: pounds, unit: UnitMass.pounds)
            .converted(to: .kilograms)
            .value
    }

    func pounds(fromKilograms kilograms: Double) -> Double {
        Measurement(value: kilograms, unit: UnitMass.kilograms)
            .converted(to: .pounds)
            .value
    }

    func centimeters(fromInches inches: Double) -> Double {
        Measurement(value: inches, unit: UnitLength.inches)
            .converted(to: .centimeters)
            .value
    }

    func inches(fromCentimeters centimeters: Double) -> Double {
        Measurement(value: centimeters, unit: UnitLength.centimeters)
            .converted(to: .inches)
            .value
    }

    func milliliters(fromFluidOunces ounces: Double) -> Double {
        Measurement(value: ounces, unit: UnitVolume.fluidOunces)
            .converted(to: .milliliters)
            .value
    }

    func fluidOunces(fromMilliliters milliliters: Double) -> Double {
        Measurement(value: milliliters, unit: UnitVolume.milliliters)
            .converted(to: .fluidOunces)
            .value
    }
}
