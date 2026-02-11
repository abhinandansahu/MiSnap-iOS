//
//  CustomTutorialHandler.swift
//  MiSnapSampleAppSwiftUI
//
//  
//

import UIKit
import MiSnap
import MiSnapUX

typealias CustomTutorialHandler = (
    _ documentType: MiSnapScienceDocumentType,
    _ tutorialMode: MiSnapUxTutorialMode,
    _ mode: MiSnapMode,
    _ statuses: [NSNumber]?,
    _ image: UIImage?,
    _ viewController: MiSnapViewController?
) -> Void
