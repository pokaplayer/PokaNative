//
//  PlayerView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/8.
//

import SwiftUI


struct PlayerTimeView: View {
  let timeObserver = PlayerTimeObserver()
  @State private var currentTime: TimeInterval = 0
  var body: some View {
    Text(formatTime(seconds: currentTime))
          .foregroundColor(Color.white)
    .onReceive(timeObserver.publisher) { time in
      self.currentTime = time
    }
  }
}


func formatTime(seconds: TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits =  [.minute, .second]
    formatter.unitsStyle = .positional
    return formatter.string(from: DateComponents(second: Int(seconds))) ?? "0:00"
}

struct PlayerView: View {
    @StateObject private var ppplayer = player
    
    var body: some View {
        if (ppplayer.currentPlayingItem != nil) {
            
            ZStack{
                if #available(iOS 15.0, *) {
                    AsyncImage(url: URL(string: baseURL + player.currentPlayingItem!.song.cover) ){ image in
                        image.resizable()
                    } placeholder: {
                        
                        Rectangle()
                            .fill(Color.black.opacity(0.7))
                            .aspectRatio(1.0, contentMode: .fit)
                        
                    }
                    .frame(width: .infinity, height: .infinity)
                    .blur(radius: 10, opaque: true)
                    .ignoresSafeArea()
                }
                
                Rectangle() .fill(Color.black.opacity(0.5))
                    .ignoresSafeArea()
                VStack{
                    VStack{
                        if #available(iOS 15.0, *) {
                            ZStack{
                                AsyncImage(url: URL(string: baseURL + player.currentPlayingItem!.song.cover) ){ image in
                                    image.resizable()
                                } placeholder: {
                                    ZStack{
                                        VStack {
                                            Rectangle()
                                                .fill(Color.black.opacity(0.2))
                                                .aspectRatio(1.0, contentMode: .fit)
                                            Spacer()
                                        }
                                        ProgressView()
                                    }
                                }
                                    .frame(width: 200, height: 200)
                                    .cornerRadius(5)
                                    .aspectRatio(1, contentMode: .fill)
                                    .offset(y: 10)
                                    .blur(radius: 10)
                                    .opacity(0.25)
                                AsyncImage(url: URL(string: baseURL + player.currentPlayingItem!.song.cover) ){ image in
                                    image.resizable()
                                } placeholder: {
                                    ZStack{
                                        VStack {
                                            Rectangle()
                                                .fill(Color.black.opacity(0.2))
                                                .aspectRatio(1.0, contentMode: .fit)
                                            Spacer()
                                        }
                                        ProgressView()
                                    }
                                }
                                    .frame(width: 200, height: 200)
                                    .cornerRadius(5)
                                    .aspectRatio(1, contentMode: .fill)
                            }
                        }
                        Text(player.currentPlayingItem!.song.name)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                        Text(player.currentPlayingItem!.song.artist)
                            .font(.headline)
                            .foregroundColor(Color.white)
                            .opacity(0.75)
                            .multilineTextAlignment(.center)
                        HStack  {
                            PlayerTimeView()
                            Spacer()
                            Button(action: {player.previousTrack()}) {
                                Image(systemName: "backward.end.alt")
                                    .font(.system(size: 20))
                                    .padding()
                                .foregroundColor(Color.white)
                            }.buttonStyle(PlainButtonStyle())
                            Button(action: { ppplayer.isPaused ? player.playTrack() : player.pause() }) {
                                Image(systemName: ppplayer.isPaused ? "play" :"pause")
                                    .font(.system(size: 24))
                                    .padding()
                                    .foregroundColor(Color.white)
                            }.buttonStyle(PlainButtonStyle())
                                .frame(width: 56, height: 56)
                                .background(Color.black.opacity(0.25))
                                .cornerRadius(.infinity)
                            
                            Button(action: {player.nextTrack()}) {
                                Image(systemName: "forward.end.alt")
                                    .font(.system(size: 20))
                                    .padding()
                                    .foregroundColor(Color.white)
                            }.buttonStyle(PlainButtonStyle())
                            Spacer()
                            Text("0:00")
                        }
                    }
                    List {
                        ForEach(Array(ppplayer.playerItems.enumerated()), id: \.offset) { index, item in
                            Button(action: {
                                player.setTrack(index: index)
                            }){
                                VStack(alignment: .leading){
                                    Text(item.song.name)
                                    Text(item.song.artist)
                                        .font(.caption)
                                        .opacity(0.75)
                                }
                            }.buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 5.0)
                    } .listStyle(GroupedListStyle())
                }
            }
        } else{
            Text("No songs in queue")
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
