//
//  SignUpView.swift
//  Folio
//
//  Created by Hailey Pan on 1/22/24.
//

import SwiftUI

struct SignUpView: View {
//    @StateObject private var viewModel = SignInEmailViewModel()
    @ObservedObject var viewModel: SignInEmailViewModel
    @Binding var showSignUpView: Bool
    @Binding var isAuthenticated: Bool
    @State private var showVerificationView = false
    @State private var passwordVisible = false

    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                HStack {
                    Button(action: {
                        showSignUpView = false
                    }) {
                        HStack(spacing: 3) {
                            Image(systemName: "arrow.backward")
                            Text("Back")
                        }
                        .foregroundColor(.customTurquoise)
                        .padding()
                    }
                    
                    Spacer()
                    
                    Text("Sign up")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.customGray)
                        .shadow(color: .black.opacity(0.25), radius: 10, x: 5, y: 5)
                    
                    Spacer()
                    
                    HStack(spacing: 3) {
                        Image(systemName: "arrow.backward").opacity(0)
                        Text("Back").opacity(0)
                    }
                    .padding()
                }
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .center)
                
                TextField("Email...", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                    .foregroundColor(.customGray)
                    .padding(.bottom, 8)
                
//                SecureField("Password...", text: $viewModel.password)
//                    .padding()
//                    .background(Color.gray.opacity(0.4))
//                    .cornerRadius(10)
//                    .foregroundColor(.customGray)
//                    .padding(.bottom, 20)
                
                HStack {
                    if passwordVisible {
                        TextField("Password...", text: $viewModel.password)
                    } else {
                        SecureField("Password...", text: $viewModel.password)
                    }

                        Button(action: {
                            passwordVisible.toggle()
                        }) {
                            Image(systemName: passwordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.customGray)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                    .padding(.bottom, 8)

                
                Button(action: {
                    Task {
                        do {
                            try await viewModel.signUp()
                            
                            if viewModel.signUpSuccess {
                                print("Signed up successfully")
                                //isAuthenticated = true
                                showVerificationView = true
                            }
                        } catch {
                            print("Sign up error: \(error)")
                        }
                    }
                }) {
                    Text("Sign up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.customTurquoise)
                        .cornerRadius(10)
                }
                .buttonStyle(BlueButtonStyle())
                .padding(.top, 20)
                
                
                if viewModel.weakPasswordError {
                    Text("The password must be 6 characters long or more.")
                        .foregroundColor(.red)
                }
                
                if viewModel.invalidEmailError {
                    Text("The email address is badly formatted.")
                        .foregroundColor(.red)
                }
                
                // Navigation link that will be activated on successful sign up
                NavigationLink(destination: VerificationView(viewModel: viewModel, showVerificationView: $showVerificationView, isAuthenticated: $isAuthenticated), isActive: $showVerificationView) {
                    EmptyView()
                }
                
                
                Spacer()
            }
            
            //        .alert("Verification Required", isPresented: $viewModel.showVerificationAlert) {
            //            Button("OK", role: .cancel) {}
            //        } message: {
            //            Text("Please verify your email. Check your inbox for the verification link. You can verify your email later in Settings.")
            //        }
            .padding()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            // Create an instance of SignInEmailViewModel with default values
            SignUpView(viewModel: SignInEmailViewModel(), showSignUpView: .constant(true), isAuthenticated: .constant(false))
        }
    }
}


