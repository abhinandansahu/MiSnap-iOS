//
//  CustomTutorialViewController.swift
//
//  Created by Stas Tsuprenko on 7/26/24.
//

import UIKit
import MiSnapUX
import MiSnap
import MiSnapAssetManager

/*
 Custom UI should be added in the dedicated extension below
 */
class CustomTutorialViewController: UIViewController {
    private let documentType: MiSnapScienceDocumentType
    private let tutorialMode: MiSnapUxTutorialMode
    private let mode: MiSnapMode
    private var statuses: [MiSnapStatus] = []
    private let image: UIImage?
    private weak var delegate: MiSnapTutorialViewControllerDelegate?
    private let bundle: Bundle
    private let stringsName: String
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(for documentType: MiSnapScienceDocumentType,
         tutorialMode: MiSnapUxTutorialMode,
         mode: MiSnapMode,
         statuses: [NSNumber]?,
         image: UIImage?,
         delegate: MiSnapTutorialViewControllerDelegate) {
        self.documentType = documentType
        self.tutorialMode = tutorialMode
        self.mode = mode
        self.image = image
        self.delegate = delegate
        /*
         By default, it's assumed that this class and localizable strings are in the same bundle.
         If it's not the case then replace `type(of: self)` with a correct class that's in the same bundle as localizable strings
         */
        self.bundle = Bundle(for: type(of: self))
        /*
         By default, MiSnap localizable strings file is called "MiSnapLocalizable".
         Provide a correct name below if you renamed the file or moved strings into a different one
         */
        self.stringsName = "MiSnapLocalizable"
        
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
        
        self.statuses = getMiSnapStatuses(from: statuses)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Implement your UI inside `configureSubviews`
        configureSubviews()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        delegate = nil
        super.dismiss(animated: flag, completion: completion)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else { return }
            self.configureSubviews()
        }, completion: nil)
    }
    
    deinit {
        print("\(String(describing: type(of: self))) is deinitialized")
    }
}

// MARK: Private utilities
extension CustomTutorialViewController {
    private func getMiSnapStatuses(from statuses: [NSNumber]?) -> [MiSnapStatus] {
        guard let statuses = statuses else { return [] }
        var miSnapStatuses: [MiSnapStatus] = []
        for status in statuses {
            guard let miSnapStatus = MiSnapStatus(rawValue: status.intValue) else { continue }
            miSnapStatuses.append(miSnapStatus)
        }
        return miSnapStatuses
    }
    
    private func getLocalizedMessages(from statuses: [MiSnapStatus]) -> [String] {
        var messages: [String] = []
        /*
         In default UX up to two most frequent messages are displayed so that a user is not overwhelmed
         Tweak this number to your liking
         */
        let maxNumber: Int = 2
        for (idx, status) in statuses.enumerated() {
            if idx >= maxNumber { break }
            let key = MiSnapResult.string(from: status) + "_timeout"
            let message = localizedString(for: key)
            messages.append(message)
        }
        // Different statuses can be mapped to the same message therefore get only unique messages
        if let uniqueMessages = NSOrderedSet(array: messages).array as? [String] {
            messages = uniqueMessages
        }
        return messages
    }
    
    private func getGenericMessages() -> [String] {
        var firstKey = ""
        switch documentType {
        case .checkFront:
            firstKey = "misnap_tutorial_check_front"
        case .checkBack:
            firstKey = "misnap_tutorial_check_back"
        case .anyId:
            firstKey = "misnap_tutorial_document"
        case .idFront:
            firstKey = "misnap_tutorial_id_front"
        case .idBack:
            firstKey = "misnap_tutorial_id_back"
        case .passport:
            firstKey = "misnap_tutorial_passport"
        default:
            firstKey = "misnap_tutorial_document"
        }
        
        let secondKey = mode == .auto ? "misnap_tutorial_auto" : "misnap_tutorial_manual"
        
        return [localizedString(for: firstKey), localizedString(for: secondKey)]
    }
    
    private func localizedString(for key: String) -> String {
        bundle.localizedString(forKey: key, value: key, table: stringsName)
    }
}

// MARK: Custom UI
extension CustomTutorialViewController {
    private func configureSubviews() {
        removeAllSubviews()
        
        switch tutorialMode {
        case .instruction:  configureForInstruction()
        case .help:         configureForHelp()
        case .timeout:      configureForTimeout()
        case .review:       configureForReview()
        default:            break
        }
    }
    
    private func removeAllSubviews() {
        view.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func configureCommonSubviews(messages: [String], buttons: [(String, Selector)]) {
        guard !messages.isEmpty else { return }
        
        // Messages stack view
        let messagesStackView = UIStackView()
        messagesStackView.translatesAutoresizingMaskIntoConstraints = false
        messagesStackView.axis = .vertical
        messagesStackView.spacing = 10
        messages.forEach { messagesStackView.addArrangedSubview(configureLabel(withText: $0)) }
        
        view.addSubview(messagesStackView)
        NSLayoutConstraint.activate([
            messagesStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messagesStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Buttons
        let buttonViews = buttons.map { configureButton(withTitle: $0.0, selector: $0.1, frame: CGRect(x: 0, y: 0, width: 90, height: 40)) }
        buttonViews.forEach { view.addSubview($0) }
        
        let offset: CGFloat = 30.0
        buttonViews.first?.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: offset).isActive = true
        buttonViews.last?.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -offset).isActive = true
        
        if buttonViews.count == 3 {
            buttonViews[1].centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        }
        
        buttonViews.forEach {
            $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -offset).isActive = true
        }
    }
    
    private func configureForInstruction() {
        let messages = getGenericMessages()
        let cancelButton = ("Cancel", #selector(cancelButtonAction(_:)))
        let continueButton = ("Continue", #selector(continueButtonAction(_:)))
        let buttons = [cancelButton, continueButton]
        
        configureCommonSubviews(messages: messages, buttons: buttons)
        
        /*
         Implement your instruction tutorial here
         
         Note:
         * `documentType` is available so that messages can be tailored for each document type if needed
         * `mode` is available so that messages can be tailored for each mode if needed
         
         IMPORTANT:
         
         When implementing Cancel, Retry, Continue/Manual buttons make sure to call `addTarget(_:action:for:)`
         and pass cancelButtonAction(_:), retryButtonAction(_:), continueButtonAction(_:) selectors respectively
         that'll properly notify MiSnapViewController
         */
    }
    
    private func configureForHelp() {
        /*
         Implement your help tutorial here
         
         Note:
         * `documentType` is available so that messages can be tailored for each document type if needed
         * `mode` is available so that messages can be tailored for each mode if needed
         
         IMPORTANT:
         
         When implementing Cancel, Retry, Continue/Manual buttons make sure to pass cancelButtonAction(_:), retryButtonAction(_:), continueButtonAction(_:) selectors respectively
         that'll properly notify MiSnapViewController
         */
        
        let messages = getGenericMessages()
        let cancelButton = ("Cancel", #selector(cancelButtonAction(_:)))
        let continueButton = ("Continue", #selector(continueButtonAction(_:)))
        let buttons = [cancelButton, continueButton]
        
        configureCommonSubviews(messages: messages, buttons: buttons)
    }
    
    private func configureForTimeout() {
        /*
         Implement your timeout tutorial here
         
         Note:
         * `statuses` of type `[MiSnapStatus]` is available with ordered statuses from the most to the least frequent
         * `documentType` is available so that messages can be tailored for each document type if needed
         
         IMPORTANT:
         
         When implementing Cancel, Retry, Continue/Manual buttons make sure to pass cancelButtonAction(_:), retryButtonAction(_:), continueButtonAction(_:) selectors respectively
         that'll properly notify MiSnapViewController
         */
        
        // Alternatively, create your own map from `[MiSnapStatus]` to a `[String]`
        let messages = getLocalizedMessages(from: statuses)
        let cancelButton = ("Cancel", #selector(cancelButtonAction(_:)))
        let retryButton = ("Retry", #selector(retryButtonAction(_:)))
        let manualButton = ("Manual", #selector(continueButtonAction(_:)))
        let buttons = [cancelButton, retryButton, manualButton]
        
        configureCommonSubviews(messages: messages, buttons: buttons)
    }
    
    private func configureForReview() {
        /*
         Implement your review tutorial here
         
         Note:
         * `statuses` of type `[MiSnapStatus]` is available with ordered warnings from the highest to the lowest priority.
         * an image passed all image quality analysis checks if `statuses` is an empty array
         * `image` is available for preview
         * `documentType` is available so that messages can be tailored for each document type if needed
         
         IMPORTANT:
         
         When implementing Cancel, Retry, Continue/Manual buttons make sure to call `addTarget(_:action:for:)`
         and pass cancelButtonAction(_:), retryButtonAction(_:), continueButtonAction(_:) selectors respectively
         that'll properly notify MiSnapViewController
         */
        
        // Image preview
        if let image = image {
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 12
            imageView.layer.masksToBounds = true
            imageView.backgroundColor = .systemBackground
            
            view.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
            ])
        }
        
        // Buttons
        let retakeButton = ("Retake", #selector(retryButtonAction(_:)))
        let useThisButton = ("Use This", #selector(continueButtonAction(_:)))
        let buttons = [retakeButton, useThisButton]
        
        let buttonViews = buttons.map { configureButton(withTitle: $0.0, selector: $0.1, frame: CGRect(x: 0, y: 0, width: 90, height: 40)) }
        buttonViews.forEach { view.addSubview($0) }
        
        let offset: CGFloat = 30.0
        
        NSLayoutConstraint.activate([
            buttonViews[0].bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -offset),
            buttonViews[0].leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: offset),
            
            buttonViews[1].bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -offset),
            buttonViews[1].rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -offset)
        ])
    }
    
    private func configureButton(withTitle title: String, selector: Selector, frame: CGRect) -> UIButton {
        let button = UIButton(frame: frame)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19.0, weight: .bold)
        
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: button.frame.width),
            button.heightAnchor.constraint(equalToConstant: button.frame.height)
        ])
        
        return button
    }
    
    private func configureLabel(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.9, height: 100))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.numberOfLines = 3
        label.textColor = .label
        label.textAlignment = .center
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: label.frame.width),
            label.heightAnchor.constraint(equalToConstant: label.frame.height)
        ])
        
        return label
    }
}

// MARK: Buttons actions
extension CustomTutorialViewController {
    @objc private func cancelButtonAction(_ button: UIButton) {
        delegate?.tutorialCancelButtonAction()
    }
    
    @objc private func continueButtonAction(_ button: UIButton) {
        delegate?.tutorialContinueButtonAction(for: tutorialMode)
    }
    
    @objc private func retryButtonAction(_ button: UIButton) {
        delegate?.tutorialRetryButtonAction?()
    }
}
