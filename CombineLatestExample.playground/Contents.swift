import SwiftUI
import Combine
import PlaygroundSupport

// MARK: - Validation Helpers
func isValidEmail(_ email: String) -> Bool {
    // Simple regex for demonstration
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
}

// MARK: - ViewModel
class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isFormValid: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                isValidEmail(email) && password.count >= 8
            }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }
}

// MARK: - View
struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login Form")
                .font(.largeTitle)
                .bold()
            
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding(.horizontal)
            
            SecureField("Password (min 8 chars)", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button("Login") {
                print("Login tapped with email: \(viewModel.email)")
            }
            .disabled(!viewModel.isFormValid)
            .padding()
            .background(viewModel.isFormValid ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Playground Live View
PlaygroundPage.current.setLiveView(LoginView())
