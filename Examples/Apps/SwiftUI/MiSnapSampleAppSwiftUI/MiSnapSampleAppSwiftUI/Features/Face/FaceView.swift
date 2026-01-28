//
//  FaceView.swift
//  MiSnapSampleAppSwiftUI
//
//  
//

import SwiftUI

struct FaceView: View {
    @StateObject var viewModel: FaceViewModel
    
    private let columns = [
        GridItem(.adaptive(minimum: 140), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 16) {
                        aiBasedRtsToggle
                        captureTypesGrid
                    }
                }
            }
            .navigationTitle("Face")
            .fullScreenCover(isPresented: $viewModel.shouldShowCapture) {
                if let preset = viewModel.selectedPreset {
                    captureView(for: preset)
                }
            }
            .sheet(item: $viewModel.captureResult) { result in
                resultView(for: result)
            }
            .alert(item: $viewModel.alert) { $0.alert }
        }
        // Face capture: portrait only on iPhone, all orientations on iPad
        .onAppear { OrientationManager.shared.setOrientation(iPhone: .portrait, iPad: .all) }
    }
    
    // MARK: - Subviews
    
    private var aiBasedRtsToggle: some View {
        HStack {
            Label("AI-based RTS", systemImage: "sparkles")
                .font(.headline)
            Spacer()
            Toggle("", isOn: $viewModel.aiBasedRtsEnabled)
                .labelsHidden()
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var captureTypesGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(viewModel.availablePresets) { preset in
                CapturePresetCard(
                    symbolName: preset.symbolName,
                    title: preset.rawValue
                ) {
                    viewModel.selectPreset(preset)
                }
            }
        }
        .padding()
    }
    
    private func captureView(for preset: FacePreset) -> some View {
        let configuration = viewModel.makeConfiguration(for: preset)
        
        return MiSnapFacialCaptureViewControllerRepresentable(
            configuration: configuration,
            onLicenseStatus: viewModel.handleLicenseStatus,
            onSuccess: viewModel.handleSuccessfulCapture,
            onCancelled: viewModel.handleCancellation,
            onExeption: viewModel.handleExeption,
            onShouldBeDismissed: viewModel.handleDismiss
        )
        .background(Color.black)
        .ignoresSafeArea()
    }
    
    private func resultView(for result: FaceCaptureResult) -> some View {
        let text = result.mibiString ?? "Failed to extract MIBI data."
        return ResultView(response: text, image: result.image)
    }
}

// MARK: - Previews

#Preview("Face") {
    FaceView(viewModel: FaceViewModel())
}
