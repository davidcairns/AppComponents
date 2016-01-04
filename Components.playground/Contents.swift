//: Playground - noun: a place where people can play

import UIKit

// Define what a "Counter" is. This is basically a mini-program!
public struct Counter: Component {
	public var model: Int
	let color: Color
	public init(initial: Int, color: Color) {
		self.model = initial
		self.color = color
	}
	
	// `model` can either by incremented or decremented.
	public enum Action {
		case Increment
		case Decrement
	}
	
	public func update(action: Action, model: Int) -> Int {
		switch action {
		case .Increment: return model + 1
		case .Decrement: return model - 1
		}
	}
	
	public func view(model: Int) -> Colorer {
		return Array(0 ..< model).map({ _ -> Colorer in Filled(color: self.color, shape: Circle(radius: 10)) }).reduce(EmptyColorer(), combine: |||)
	}
}

// Our "whole app" is two Counter mini-apps, stacked vertically (switch the operator to ||| to stack horizontally).
var app = Counter(initial: 1, color: Red) --- Counter(initial: 5, color: Blue)

// Define the inputs our program receives while running (Note that because there are two Counters, the inputs also must be differentiated).
let inputs: [Either<Counter.Action, Counter.Action>] = [
	.Left(.Increment),
	.Left(.Increment),
	.Left(.Increment),
	.Left(.Decrement),
	.Right(.Decrement),
	.Right(.Decrement),
]

// Collect the output while running the app and display it.
var outputStream: [Image] = []
run(app, eventStream: SequenceSignal(items: inputs), outputHandler: { frame in outputStream.append(frame) })

outputStream

