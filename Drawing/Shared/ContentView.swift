//
//  ContentView.swift
//  Shared
//
//  Created by Daniel Vaswani on 19/08/2021.
//

import SwiftUI

struct ContentView : View {
    var body : some View {
        Text("Hello world!")
            .padding()
    }
}

struct ColorCyclingCircleView : View {
    @State private var colorCycle = 0.0
    
    var body : some View {
        VStack{
            ColorCyclingCircle(amount: self.colorCycle)
                .frame(width: 300, height: 300)
            Slider(value: $colorCycle)
        }
    }
}

struct ColorCyclingCircle : View {
    var amount = 0.0
    var steps = 100
    
    var body : some View {
        ZStack {
            ForEach(0..<steps){ value in
                Circle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.5)
                    ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ImagePaintView : View {
    var body : some View {
        ScrollView {
            VStack (spacing: 30){
                Text("Hello world!")
                    .frame(width: 300, height: 300)
                    .background(Color.red)
                
                Text("Hello world")
                    .frame(width: 300, height: 300)
                    .border(Color.red)
                
                Text("Hello world!")
                    .frame(width: 300, height: 300)
                    .border(ImagePaint(image: Image("Example"), scale: 0.2), width: 30)
                
                Text("Hello world!")
                    .frame(width: 300, height: 300)
                    .border(ImagePaint(image:
                                        Image("Example"),
                                       sourceRect: CGRect(x: 0, y: 0.25, width: 1, height: 0.5),
                                       scale: 0.1),
                            width: 30
                    )
                
                Capsule()
                    .strokeBorder(ImagePaint(image: Image("Example"), scale: 0.1), lineWidth: 20)
                    .frame(width: 300, height: 200)
            }
        }
    }
}

struct FlowerView : View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0
    
    var body : some View {
        VStack {
            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                .fill(Color.red, style: FillStyle(eoFill:true))
            
            Text("Offset")
            Slider(value: $petalOffset, in: -40...40)
                .padding([.horizontal, .bottom])
            
            Text("Width")
            Slider(value: $petalWidth, in: 0...100)
                .padding(.horizontal)
        }
    }
}

struct Flower : Shape {
    var petalOffset: Double = -20
    var petalWidth: Double = -20
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            for number in stride(from: 0, to: CGFloat.pi * 2 , by: CGFloat.pi / 8) {
                let rotation = CGAffineTransform(rotationAngle: number)
                let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
                let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width / 2))
                let rotatedPetal = originalPetal.applying(position)
                path.addPath(rotatedPetal)
            }
        }
    }
    
    
}

struct CircleView : View {
    var body : some View {
        Circle()
            .strokeBorder(Color.blue, lineWidth: 40)
            .padding(40)
    }
}

struct ArcView : View {
    var body : some View {
        Arc(startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
            .strokeBorder(Color.blue, lineWidth: 40)
    }
}

struct Arc : InsettableShape {
    var startAngle : Angle
    var endAngle : Angle
    var clockwise : Bool
    var insetAmount : CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        return Path{ $0.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise) }
    }
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

struct TriangleView : View {
    @State private var tiltAmount = 0.0
    var body : some View {
        Triangle()
            .stroke(Color.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .frame(width: 300, height :300)
    }
}

struct Triangle  : Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX , y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            //path.addLine(to: CGPoint(x: 100, y: 300))
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct ColorCyclingCircleView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCyclingCircleView()
    }
}

struct ImagePaintView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePaintView()
    }
}

struct FlowerView_Previews: PreviewProvider {
    static var previews: some View {
        FlowerView()
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView()
    }
}

struct TriangleView_Previews: PreviewProvider {
    static var previews: some View {
        TriangleView()
    }
}

struct ArcView_Previews: PreviewProvider {
    static var previews: some View {
        ArcView()
    }
}
