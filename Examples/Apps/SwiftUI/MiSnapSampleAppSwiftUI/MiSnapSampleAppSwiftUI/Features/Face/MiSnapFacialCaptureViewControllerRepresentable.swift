//
//  MiSnapFacialCaptureViewControllerRepresentable.swift
//  MiSnapSampleAppSwiftUI
//
//  
//

import SwiftUI
import MiSnapFacialCapture
import MiSnapFacialCaptureUX

struct MiSnapFacialCaptureViewControllerRepresentable: UIViewControllerRepresentable {
    let configuration: MiSnapFacialCaptureConfiguration
    let onLicenseStatus: (MiSnapLicenseStatus) -> Void
    let onSuccess: (MiSnapFacialCaptureResult) -> Void
    let onCancelled: (MiSnapFacialCaptureResult) -> Void
    let onExeption: (NSException) -> Void
    let onShouldBeDismissed: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            onLicenseStatus: onLicenseStatus,
            onSuccess: onSuccess,
            onCancelled: onCancelled,
            onExeption: onExeption,
            onShouldBeDismissed: onShouldBeDismissed
        )
    }
    
    class Coordinator: NSObject, MiSnapFacialCaptureViewControllerDelegate {
        let onLicenseStatus: (MiSnapLicenseStatus) -> Void
        let onSuccess: (MiSnapFacialCaptureResult) -> Void
        let onCancelled: (MiSnapFacialCaptureResult) -> Void
        let onExeption: (NSException) -> Void
        let onShouldBeDismissed: () -> Void
        
        init(
            onLicenseStatus: @escaping (MiSnapLicenseStatus) -> Void,
            onSuccess: @escaping (MiSnapFacialCaptureResult) -> Void,
            onCancelled: @escaping (MiSnapFacialCaptureResult) -> Void,
            onExeption: @escaping (NSException) -> Void,
            onShouldBeDismissed: @escaping () -> Void
        ) {
            self.onLicenseStatus = onLicenseStatus
            self.onSuccess = onSuccess
            self.onCancelled = onCancelled
            self.onExeption = onExeption
            self.onShouldBeDismissed = onShouldBeDismissed
        }
        
        func miSnapFacialCaptureLicenseStatus(_ status: MiSnapLicenseStatus) {
            onLicenseStatus(status)
        }
        
        func miSnapFacialCaptureSuccess(_ result: MiSnapFacialCaptureResult) {
            onSuccess(result)
        }
        
        func miSnapFacialCaptureCancelled(_ result: MiSnapFacialCaptureResult) {
            onCancelled(result)
        }
        
        func miSnapException(_ exception: NSException) {
            onExeption(exception)
        }
        
        func miSnapFacialCaptureShouldBeDismissed() {
            onShouldBeDismissed()
        }
    }
    
    func makeUIViewController(context: Context) -> MiSnapFacialCaptureViewController {
        return MiSnapFacialCaptureViewController(with: configuration, delegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: MiSnapFacialCaptureViewController, context: Context) {}
}
