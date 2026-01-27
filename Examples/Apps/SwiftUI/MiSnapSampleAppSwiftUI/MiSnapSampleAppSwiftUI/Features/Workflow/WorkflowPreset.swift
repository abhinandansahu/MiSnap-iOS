//
//  WorkflowPreset.swift
//  MiSnapSampleAppSwiftUI
//
//  
//

import Foundation

// MARK: - Workflow Presets
struct WorkflowPreset: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let symbolName: String
    let details: String
    let steps: [MiSnapWorkflowStep]
    
    static let idCard = WorkflowPreset(
        title: "ID Card",
        symbolName: "person.text.rectangle",
        details: "Front → Back",
        steps: [.idFront, .idBack]
    )
    
    static let check = WorkflowPreset(
        title: "Check",
        symbolName: "banknote",
        details: "Front → Back",
        steps: [.checkFront, .checkBack]
    )
    
    static let faceVoice = WorkflowPreset(
        title: "Biometric",
        symbolName: "face.smiling",
        details: "Face → Voice",
        steps: [.face, .voice]
    )
    
    static let allCategories: [WorkflowPreset] = [
        .idCard, .check, .faceVoice
    ]
}
