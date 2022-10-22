//
//  SwiftUIView.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-10-09.
//

import SwiftUI
import Kingfisher

struct MovieInfoView: View {

    var viewModel: MovieInfoViewModel

    init(viewModel: MovieInfoViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        GeometryReader { metrics in
            VStack(alignment: .center) {
                VStack() {
                    if let url = viewModel.posterURL {
                        ZStack {
                              Rectangle()
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.5), radius: 4, x: 0, y: 0)
                            KFImage(url)
                                .resizable()
                        }
                        .frame(width: metrics.size.width * DrawingConstants.imageScale,
                                height: metrics.size.width * DrawingConstants.imageScale * 1.5)

                    }

                }
                ScrollView {
                    VStack(alignment: .leading) {
                        if let title = viewModel.title {
                            Text(title)
                                .multilineTextAlignment(.center)
                                .font(.title2)
                                .fontWeight(.heavy)
                        }
                        HStack {
                            if let rating = viewModel.rating {
                                Text("\(rating.formatted())%")
                                    .foregroundColor(viewModel.ratingColor)
                            }
                            if let date = viewModel.date {
                                Text(date)
                            }
                        }
                        if let description = viewModel.description {
                            Text(description)
                        }
                        HStack {
                            VStack {
                                Image(systemName: "star")
                                    .font(.title3)
                                Text("Save")
                                    .font(.footnote)
                            }
                            .padding(4)
                        }
                        .onTapGesture {
                            viewModel.addToFavourites()
                        }
                    }
                }
            }

        }
        .padding(20)
        .lineSpacing(0.5)
    }



    private struct DrawingConstants {
        static let imageScale: CGFloat = 0.5
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MovieInfoViewModel(movie: Movie(
            id: 10, adult: nil, backdropPath: nil,
            genreIDS: nil, originalLanguage: nil,
            originalTitle: nil, overview: nil,
            popularity: nil, posterPath: nil,
            releaseDate: nil, title: nil, video: nil,
            voteAverage: nil, voteCount: nil))
        MovieInfoView(viewModel: viewModel)
    }
}
