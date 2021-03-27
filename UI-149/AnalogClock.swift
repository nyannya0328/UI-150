//
//  AnalogClock.swift
//  UI-149
//
//  Created by にゃんにゃん丸 on 2021/03/27.
//

import SwiftUI

struct AnalogClock: View {
    @State var show = false
    @State var currentTime = Time(min: 0, hour: 0, sec: 0)
    @State var Receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    @State var multicolor = false
     var body: some View {
        VStack{
            
            HStack{
                
                TextSheimer(multicolor: $multicolor, txt: "Clock")
             
                .colorScheme(.dark)
                
                Toggle(isOn: $multicolor, label: {
                    Text("Enable Muti Color")
                        .font(.caption)
                        .fontWeight(.semibold)
                })
               
                    
                
                Spacer()
                
                Button(action: {
                    
                    show.toggle()
                }, label: {
                    Image(systemName: show ? "moon.fill" : "sun.min.fill")
                        .font(.system(size: 22))
                        .foregroundColor(show ? .black : . white)
                        .padding(22)
                        .background(Color.primary)
                        .clipShape(Circle())
                })
                
                
                
            }
            .padding()
            
            
        
            
            Spacer(minLength: 0)
            
            ZStack{
                
                Circle()
                    .fill(Color.red.opacity(0.3))
                
                ForEach(0..<60,id:\.self){index in
                    
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 2, height: (index % 5) == 0 ? 15 : 5)
                        .offset(y: (getRect().width - 110) / 2)
                        .rotationEffect(.init(degrees: Double(index)*6))
                    
                }
                
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 2, height: (getRect().width - 180) / 2)
                    .offset(y: -(getRect().width - 180) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.sec)*6))
                
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4, height: (getRect().width - 200) / 2)
                    .offset(y: -(getRect().width - 200) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.min)*6))
                
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4.5, height: (getRect().width - 240) / 2)
                    .offset(y: -(getRect().width - 240) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.hour) + (Double(currentTime.min) / 60)) * 30)
                
                Circle()
                    .fill(Color.primary)
                    .frame(width: 15, height: 15)
                    
                
            }
            .frame(width: getRect().width - 80, height: getRect().width - 80)
            
            TextSheimer(multicolor: $multicolor, txt: getTime())
//                .font(.largeTitle)
//                .fontWeight(.heavy)
//                .foregroundColor(.purple)
//                .padding(.top,30)
//
            
            Spacer(minLength: 0)
        }
        
        .onAppear(perform: {
            
            let carrneder = Calendar.current
            let min = carrneder.component(.minute, from: Date())
            let sec = carrneder.component(.second, from: Date())
            let hour = carrneder.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.3)){
            
            self.currentTime = Time(min: min, hour: hour, sec: sec)
                
            }
            
        })
        .onReceive(Receiver, perform: { _ in
            let carrneder = Calendar.current
            let min = carrneder.component(.minute, from: Date())
            let sec = carrneder.component(.second, from: Date())
            let hour = carrneder.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.3)){
            
            self.currentTime = Time(min: min, hour: hour, sec: sec)
                
            }
            
            
        })
       
        .preferredColorScheme(show ? .dark : .light)
        
    }
    func getTime()->String{
        
        let format = DateFormatter()
        format.dateFormat = "hh: mm: a "
        return format.string(from: Date())
    }
}

struct AnalogClock_Previews: PreviewProvider {
    static var previews: some View {
        AnalogClock()
    }
}

extension View{
    
    func getRect()->CGRect{
        
        return UIScreen.main.bounds
    }
}

struct Time {
    var min : Int
    var hour : Int
    var sec : Int
}

struct TextSheimer : View {
    
    @State var animation = false
    @Binding var multicolor : Bool
    
    var txt : String
    var body: some View{
        
        ZStack{
            
            
            Text(txt)
                .font(.system(size: 53, weight: .heavy))
                .foregroundColor(Color.red.opacity(0.3))
                
                
            HStack(spacing:0){
                
                
                ForEach(0..<txt.count,id:\.self){index in
                    
                    
                    Text(String(txt[txt.index(txt.startIndex, offsetBy: index)]))
                        .font(.system(size: 53, weight: .heavy))
                        .foregroundColor(multicolor ? randomColor() : .red)
                       
                }
            }
            .mask(
            
            Rectangle()
                .fill(LinearGradient(gradient: .init(colors: [.blue,.pink]), startPoint: .top, endPoint: .bottom))
                .rotationEffect(.init(degrees: 70))
                .padding(20)
                .offset(x: -250)
                .offset(x: animation ? 500 : 0)
            
            )
            .onAppear(perform: {
                withAnimation(Animation.linear(duration: 6).repeatForever(autoreverses: true)){
                    
                    animation.toggle()
                    
                }
            })
            
        }
        
        
    }
    func randomColor()->Color{
        
        let color = UIColor(displayP3Red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        
        return Color(color)
    }
}
