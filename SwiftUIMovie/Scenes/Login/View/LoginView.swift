//
//  LoginView.swift
//  SwiftUIMovie
//
//  Created by Jeevan-1382 on 17/04/20.
//  Copyright © 2020 Jeevan-1382. All rights reserved.
//

import SwiftUI

/*
 * Login View for user
 */
struct LoginView: View {
  @ObservedObject var loginViewModel: LoginViewModel //injected when LoginView instantiated.

  var body: some View {
    NavigationView {
      VStack {
        LoginImage()
        LoginTitle()
        UserNameField(userNameString: $loginViewModel.userName)
        PasswordField(passwordString: $loginViewModel.userPass)
        LoginButton(loginViewModel: loginViewModel)
      }.padding(Constants.Styles.pagePadding50)
    }
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView(loginViewModel: LoginViewModel(router: ViewRouter()))
  }
}

//MARK:- UI Elements

struct LoginImage : View {
  var body:some View {
    Image("pop-corn")
      .resizable()
      .frame(width: 128, height: 128)
      .clipShape(Circle())
      .overlay(Circle().stroke(Color.white, lineWidth: 4))

      .shadow(color: Color.gray.opacity(0.25), radius: 10)
      .padding(.bottom, Constants.Styles.bottomPadding20)
  }
}

struct LoginTitle : View {

  var body : some View {
    Text("Hello!! Login to find out latest movie release.")
      .font(.subheadline)
      .fontWeight(.semibold)
      .multilineTextAlignment(.center)
      .padding(.bottom, Constants.Styles.bottomPadding20)
  }
}

struct UserNameField:View {
  var userNameString:Binding<String>
  var body:some View {
    TextField("Username", text: userNameString)
      .padding()
      .background(Constants.Colors.lightGray)
      .cornerRadius(Constants.Styles.smallCornerRadius)
      .padding(.bottom, Constants.Styles.bottomPadding20)
  }
}

struct PasswordField:View {
  var passwordString:Binding<String>
  var body:some View {
    SecureField("Password", text: passwordString)
      .padding()
      .background(Constants.Colors.lightGray)
      .cornerRadius(Constants.Styles.smallCornerRadius)
      .padding(.bottom, Constants.Styles.bottomPadding20)
  }
}

struct LoginButton:View{
  @ObservedObject var loginViewModel: LoginViewModel

  var body:some View {

    Button(action: {
      self.loginViewModel.validateLoginButton()
    }) {
      Text("LOGIN")
        .font(.headline)
        .foregroundColor(.white)
        .padding()
        .frame(width: 220, height: 60)
        .background(loginViewModel.isLoginEnable ? Constants.Colors.buttonBlue  : Constants.Colors.darkGray)
        .cornerRadius(30)
    }
    .alert(isPresented: $loginViewModel.isLoginAlertShown) {
      Alert(title: Text("Invalid Credentails !!"), message: Text("Please login with valid username or password"), dismissButton: .default(Text("OK")))
    }
    .disabled(!loginViewModel.isLoginEnable)

  }


}

