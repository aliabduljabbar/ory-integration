//
//  IndicatorHaptic.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 07/05/2024.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

public enum IndicatorHaptic {
    case success
    case warning
    case error
    case light
    case medium
    case heavy
    case rigid
    case soft

    public func impact(intensity: CGFloat = 1) {
#if canImport(UIKit)
        switch self {
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.warning)
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.error)
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred(intensity: intensity)
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred(intensity: intensity)
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred(intensity: intensity)
        case .rigid:
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            generator.prepare()
            generator.impactOccurred(intensity: intensity)
        case .soft:
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.prepare()
            generator.impactOccurred(intensity: intensity)
        }
#endif
    }
}
