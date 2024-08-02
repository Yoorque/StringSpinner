// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

struct StringSpinner: View {
	@State private var animating: Bool = false
	var symbolGroups: [String]
	
	var body: some View {
		VStack {
			GeometryReader { geometry in
				Circle()
					.frame(maxHeight: .infinity)
					.foregroundStyle(Color.clear)
					.background {
						ForEach(Array(symbolGroups.enumerated()), id: \.self.offset) { idx, symbols in
							let time = Double(symbols.count / symbolGroups.count / max(idx, 1))
							ForEach(Array(symbols.map { String($0) }.enumerated()), id: \.self.offset) { index, char in
								let angle = Double((index * 360/symbols.count))
								displaySymbols(String(char), angle: angle, size: geometry.size.width/2 - CGFloat(idx) * 30)
							}
							.rotationEffect(.degrees(animating ? idx % 2 == 0 ? 360 : -360 : 0))
							.animation(animating ? .linear(duration: time).repeatForever() : .linear(duration: 0.5),  value: animating)
						}
					}
			}
		}
		.contentShape(Rectangle())
		.onTapGesture(perform: {
			animating.toggle()
		})
		.padding()
	}
	
	func displaySymbols(_ symbol: String, angle: Double, size: CGFloat) -> some View {
		return Text(symbol)
			.font(.title)
			.offset(x: size)
			.rotationEffect(.degrees(angle))
			.animation(.linear(duration: 0.5), value: angle)
	}
}
