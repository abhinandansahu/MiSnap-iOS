//
//  FacePreset.swift
//  MiSnapSampleAppSwiftUI
//
//  
//

import Foundation

enum FacePreset: String, CaseIterable, Identifiable {
    case selfieCountdown = "Selfie Countdown"
    case selfieSmile = "Selfie Smile"
    case selfieGoodIQA = "Selfie Good IQA"
    
    var id: String { rawValue }
    
    var symbolName: String {
        switch self {
        case .selfieCountdown:     return "person.crop.circle.badge.clock"
        case .selfieSmile: return "face.smiling"
        case .selfieGoodIQA:  return "person.crop.circle.badge.checkmark"
        }
    }
}
