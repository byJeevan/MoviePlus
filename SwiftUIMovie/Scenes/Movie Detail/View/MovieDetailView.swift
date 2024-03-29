//
//  MovieDetailView.swift
//  SwiftUIMovie
//
//  Created by Jeevan on 15/05/21.
//  Copyright © 2021 Jeevan-1382. All rights reserved.
//

import SwiftUI

struct MovieDetailView: View {

  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @ObservedObject var viewModel:MoviewDetailViewModel

  var body: some View {

    ZStack(alignment: .top) {

      if $viewModel.isMovieDetailVisible.wrappedValue {

        ScrollView {

          GeometryReader{reader in
            MovieBGCard(moviePosterPath: $viewModel.movieDetail.wrappedValue?.poster_path ?? "")
              .offset(y: -reader.frame(in: .global).minY)
              // Adding parallax effect....
              .frame(width: UIScreen.main.bounds.width, height:  reader.frame(in: .global).minY + 500)

          }
          .frame(height: 380)

          VStack(alignment: .leading, spacing: 8) {

            // row - 0
            VStack(alignment: .leading, spacing: 4) {

              HStack(alignment: .bottom) {
                Text($viewModel.movieDetail.wrappedValue?.title ?? "").font(.title).foregroundColor(.black).bold()
                Spacer()
                HStack(alignment: .center) {
                  Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.yellow)

                  Text(String(format: "%.1f", Float($viewModel.movieDetail.wrappedValue?.vote_average ?? 0.0))).foregroundColor(Color.black).font(.title).bold()
                }
              }

              Text($viewModel.genras.wrappedValue ?? "").font(.subheadline).foregroundColor(.gray)
              Text("Run Time : \($viewModel.duration.wrappedValue ?? "")").font(.subheadline).foregroundColor(.gray)
            }.padding()

            // row - 1
            VStack(alignment: .leading, spacing: 8) {
              Text("Brief Story :").font(.headline).foregroundColor(.black).bold()

              Text($viewModel.movieDetail.wrappedValue?.overview ?? "").font(.subheadline).foregroundColor(.black).lineSpacing(8.0)

            }.padding()

          }
          .padding(0)
          .padding(.top, 25)
          .background(Color.white)
          .cornerRadius(20)
          .offset(y: -35)

          VStack(alignment: .leading, spacing: 4) {

            Button(action: {
              self.presentationMode.wrappedValue.dismiss()

            }) {
              Text("ADD TO WATCHLIST")
                .fontWeight(.bold)
                .font(.headline)
                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 50)
                .background(Color.black.opacity(0.8))
                .foregroundColor(Color.white)
                .cornerRadius(25.0)
            }.padding(.bottom, 16.0)
          }
          .padding()

        }

        HStack{
          Spacer()
          Button(action: {
            self.presentationMode.wrappedValue.dismiss()
          }) {

            Image(systemName: "xmark")
              .foregroundColor(.white)
              .padding()
              .background(Color.black.opacity(0.8))
              .clipShape(Circle())

          }
        }
        .padding(EdgeInsets.init(top: 40, leading: 0, bottom: 0, trailing: 32))
        .background(Color.clear)
      }
    }
    .edgesIgnoringSafeArea(.all)
    .navigationBarHidden(true)
    .onAppear(perform: fetch)
  }

  private func fetch(){
    viewModel.loadMovieDetails()
  }
}

struct MovieBGCard: View {
  var moviePosterPath:String

  var body: some View {
    let fullPosterURL = URL.init(string: "https://image.tmdb.org/t/p/w500\(moviePosterPath)")!
    WebImage(imageURL:fullPosterURL)
  }
}

struct MovieDetailView_Previews: PreviewProvider {
  static var previews: some View {
    MovieDetailView( viewModel: MoviewDetailViewModel(selectedMovieId: 19404, networkManager: NetworkManager()))
  }
}
