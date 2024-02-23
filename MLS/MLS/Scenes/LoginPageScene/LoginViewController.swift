//
//  LoginViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import UIKit

import SnapKit

class LoginViewController: BasicController {
    // MARK: - Properties

    private let viewModel: LoginViewModel
        
    // MARK: - Components

    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemOrange
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "AppLogo")
        return view
    }()
        
    private let emailTextField = CustomTextField(type: .normal, header: nil, placeHolder: "이메일 입력해주세요.")
        
    private let pwTextField = CustomTextField(type: .password, header: nil, placeHolder: "비밀번호를 입력해주세요.")

    private let autoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("자동 로그인", for: .normal)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.configuration?.imagePlacement = .leading
        button.setTitleColor(.semanticColor.text.secondary, for: .normal)
        button.titleLabel?.font = .customFont(fontSize: .body_sm, fontType: .regular)
        button.tintColor = .semanticColor.bolder.primary
        return button
    }()
    
    private let pwFindButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 변경하기", for: .normal)
        button.titleLabel?.font = .customFont(fontSize: .body_sm, fontType: .regular)
        button.setTitleColor(.semanticColor.text.secondary, for: .normal)
        return button
    }()
        
    private let logInButton = CustomButton(text: "로그인", textColor: .semanticColor.text.interactive.secondary, textFont: .customFont(fontSize: .body_md, fontType: .semiBold), borderColor: nil)
        
    private let signUpButton = CustomButton(text: "회원가입", textColor: .semanticColor.text.secondary, textFont: .customFont(fontSize: .body_md, fontType: .semiBold), backgroundColor: .themeColor(color: .base, value: .value_white), borderColor: .semanticColor.bolder.secondary)
     
    private let descriptionTailImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "loginDescription_tail")
        return view
    }()
    
    private let descriptionMainImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "loginDescription_main")
        return view
    }()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

// MARK: - SetUp
private extension LoginViewController {
    func setUp() {
        emailTextField.textField.delegate = self
        pwTextField.textField.delegate = self
        
        setUpConstraints()
        setUpNavigation()
        setUpActions()
    }
        
    func setUpConstraints() {
        view.addSubview(logoImageView)
        view.addSubview(emailTextField)
        view.addSubview(pwTextField)
        view.addSubview(autoLoginButton)
        view.addSubview(pwFindButton)
        view.addSubview(logInButton)
        view.addSubview(signUpButton)
        view.addSubview(descriptionTailImageView)
        view.addSubview(descriptionMainImageView)
            
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(Constants.spacings.lg)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
            
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(Constants.spacings.xl_4)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
            
        pwTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(Constants.spacings.lg)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
        }
            
        autoLoginButton.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(Constants.spacings.sm)
            $0.leading.equalTo(emailTextField)
            $0.height.equalTo(22)
        }
        
        pwFindButton.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(Constants.spacings.sm)
            $0.trailing.equalTo(emailTextField)
            $0.height.equalTo(22)
        }

        logInButton.snp.makeConstraints {
            $0.top.equalTo(autoLoginButton.snp.bottom).offset(139)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(56)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(logInButton.snp.bottom).offset(Constants.spacings.md)
            $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
            $0.height.equalTo(56)
        }
        
        descriptionTailImageView.snp.makeConstraints {
            $0.top.equalTo(signUpButton.snp.bottom).offset(Constants.spacings.lg)
            $0.leading.equalTo(descriptionMainImageView).inset(Constants.spacings.xl)
            $0.size.equalTo(12)
        }
        
        descriptionMainImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionTailImageView.snp.bottom)
            $0.leading.equalToSuperview().inset(Constants.spacings.xl)
            $0.trailing.equalToSuperview().inset(87)
            $0.height.equalTo(44)
        }
    }
    
    func setUpNavigation() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .themeColor(color: .base, value: .value_black)
        navigationController?.title = "로그인"
    }

    func setUpActions() {
        logInButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapLogInButton()
        }), for: .primaryActionTriggered)
            
        signUpButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapSignUpButton()
        }), for: .primaryActionTriggered)
            
        autoLoginButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapAutoLoginButton()
        }), for: .primaryActionTriggered)
            
        pwFindButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapPasswordFindButton()
        }), for: .primaryActionTriggered)
    }
}

// MARK: - Bind
private extension LoginViewController {
    func bind() {}
}

// MARK: - Method
extension LoginViewController {
    func didTapAutoLoginButton() {}
        
    func didTapPasswordFindButton() {}
        
    func didTapLogInButton() {}
    
    func didTapSignUpButton() {}
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 입력완료
        return true
    }
}