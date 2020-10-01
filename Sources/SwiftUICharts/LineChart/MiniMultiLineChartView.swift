//
//  File.swift
//  
//
//  Created by Emory Dunn on 10/1/20.
//

import SwiftUI

public struct MiniMultiLineChartView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var data: [MultiLineChartData]
//    public var title: String
//    public var legend: String?
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle
    public var formSize: CGSize
    public var valueSpecifier:String
    
    @State private var touchLocation:CGPoint = .zero
    @State private var showIndicatorDot: Bool = false
    @State private var currentValue: Double = 2 {
        didSet {
            if (oldValue != self.currentValue && showIndicatorDot) {
                HapticFeedback.playSelection()
            }
            
        }
    }
    
    var globalMin: Double {
        if let min = data.flatMap({$0.onlyPoints()}).min() {
            return min
        }
        return 0
    }
    
    var globalMax: Double {
        if let max = data.flatMap({$0.onlyPoints()}).max() {
            return max
        }
        return 0
    }
    
    var frame = CGSize(width: 180, height: 120)
    
    public init(data: [([Double], GradientColor)],
                style: ChartStyle = Styles.lineChartStyleOne,
                form: CGSize = ChartForm.medium,
                valueSpecifier: String = "%.1f") {
        
        self.data = data.map({ MultiLineChartData(points: $0.0, gradient: $0.1)})
        self.style = style
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
        self.formSize = form
        frame = CGSize(width: self.formSize.width, height: self.formSize.height / 2)
        self.valueSpecifier = valueSpecifier
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<self.data.count) { i in
                    Line(data: self.data[i],
                         frame: .constant(geometry.frame(in: .local)),
                         touchLocation: self.$touchLocation,
                         showIndicator: self.$showIndicatorDot,
                         minDataValue: .constant(self.globalMin),
                         maxDataValue: .constant(self.globalMax),
                         showBackground: false,
                         gradient: self.data[i].getGradient(),
                         index: i)
                }
            }
            
        }
        .frame(width: frame.width, height: frame.height)
//        .clipShape(RoundedRectangle(cornerRadius: 20))

    }
    
//    @discardableResult func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
//        let points = self.data.onlyPoints()
//        let stepWidth: CGFloat = width / CGFloat(points.count-1)
//        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
//
//        let index:Int = Int(round((toPoint.x)/stepWidth))
//        if (index >= 0 && index < points.count){
//            self.currentValue = points[index]
//            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index])*stepHeight)
//        }
//        return .zero
//    }
}

struct MiniMultiWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MiniMultiLineChartView(
                data: [
                    ([4925, 4650, 5225, 2500, 566, 11325, 0, 2035, 4500], GradientColors.orange),
                    ([4720, 4925, 2650, 6000, 3375, 566, 2325, 9000, 3025], GradientColors.blue)
                ],
                form: ChartForm.large)
                .environment(\.colorScheme, .light)
        }
    }
}
