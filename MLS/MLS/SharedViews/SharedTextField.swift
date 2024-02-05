//
//  SharedTextField.swift
//  MLS
//
//  Created by SeoJunYoung on 1/18/24.
//

import UIKit

import SnapKit

// $0 leading trailing 변경 addsubview 변경 준영

class SharedTextField: UIView {
    
    enum TextFieldType {
        case normal
        case password
        case title
        case titlePassword
    }
    
    // MARK: - Components

    var textField: UITextField = {
        let view = UITextField()
        view.font = Typography.body1.font
        view.autocapitalizationType = .none
        return view
    }()
    
    lazy var showButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .systemGray4
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        label.textColor = .black
        return label
    }()
    
    lazy var trailingView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.cornerRadius = Constants.defaults.radius
        return view
    }()
    
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body2.font
        return label
    }()
    
    private let type: TextFieldType
    
    init(type: TextFieldType, placeHolder: String) {
        self.type = type
        super.init(frame: .zero)
        textField.placeholder = placeHolder
        setUp(type: type)
    }
    
    convenience init(type: TextFieldType, placeHolder: String, title: String) {
        self.init(type: type, placeHolder: placeHolder)
        titleLabel.text = title
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension SharedTextField {
    func setUp(type: TextFieldType) {
        setUpLayer(type: type)
        switch type {
        case .normal:
            setUpNormal()
        case .password:
            setUpPassword()
        case .title:
            setUpTitle()
        case .titlePassword:
            setUpTitlePassword()
        }
    }
    
    func setUpLayer(type: TextFieldType) {
        if type != .title, type != .titlePassword {
            layer.borderWidth = 1
            layer.borderColor = UIColor.systemGray4.cgColor
            layer.cornerRadius = Constants.defaults.radius
        }
    }
    
    func setUpNormal() {
        snp.makeConstraints { make in
            make.height.equalTo(Constants.defaults.blockHeight)
        }
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.defaults.horizontal)
        }
    }
    
    func setUpPassword() {
        snp.makeConstraints { make in
            make.height.equalTo(Constants.defaults.blockHeight)
        }
        showButton.addTarget(self, action: #selector(changeShowButtonColor), for: .touchUpInside)
        textField.isSecureTextEntry = true
        addSubview(showButton)
        showButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(Constants.screenHeight * 0.03)
        }
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.defaults.vertical)
            make.left.bottom.equalToSuperview().inset(Constants.defaults.horizontal)
            make.right.equalTo(showButton.snp.left)
        }
    }
    
    func setUpTitle() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        addSubview(stateLabel)
        stateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(Constants.defaults.horizontal)
        }
        addSubview(trailingView)
        trailingView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.defaults.vertical)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(Constants.defaults.blockHeight)
        }
        trailingView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.defaults.horizontal)
        }
    }
    
    func setUpTitlePassword() {
        textField.isSecureTextEntry = true
        showButton.addTarget(self, action: #selector(changeShowButtonColor), for: .touchUpInside)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        addSubview(stateLabel)
        stateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(Constants.defaults.horizontal)
        }
        addSubview(trailingView)
        trailingView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.defaults.vertical)
            make.height.equalTo(Constants.defaults.blockHeight)
            make.left.right.bottom.equalToSuperview()
        }

        trailingView.addSubview(showButton)
        showButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.defaults.horizontal)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(Constants.screenHeight * 0.03)
        }
        trailingView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(Constants.defaults.vertical)
            make.top.equalToSuperview().inset(Constants.defaults.horizontal)
            make.right.equalTo(showButton.snp.left)
        }
    }
}

// MARK: - Methods
extension SharedTextField {
    
    @objc private func changeShowButtonColor() {
        textField.isSecureTextEntry.toggle()
        if textField.isSecureTextEntry {
            UIView.animate(withDuration: 0.1) {
                self.showButton.tintColor = .systemGray4
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.showButton.tintColor = .systemOrange
            }
        }
    }
    
    func changeBorderColor(color: UIColor, animated: Bool) {
        let action: () -> Void = {
            switch self.type {
            case .normal, .password:
                self.layer.borderColor = color.cgColor
            case .title, .titlePassword:
                self.trailingView.layer.borderColor = color.cgColor
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.4) { action() }
        } else {
            action()
        }
    }
    
    func changeStatelabel(color: UIColor, text: String) {
        stateLabel.text = text
        stateLabel.textColor = color
    }
}
