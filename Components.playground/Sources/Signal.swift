import Foundation

internal struct Emission <T> {
	let timestamp: NSTimeInterval
	let value: T
}

public class Signal <T> {
	public typealias BlockType = T -> ()
	typealias EmissionBlockType = Emission<T> -> ()
	var blocks: [EmissionBlockType] = []
	
	public init() {}
	
	public func emit(value: T) {
		let timestamp = NSDate.timeIntervalSinceReferenceDate()
		let emission = Emission(timestamp: timestamp, value: value)
		for block in blocks {
			block(emission)
		}
	}
	
	func subscribeTime(block: EmissionBlockType) {
		blocks.append(block)
	}
	public func subscribe(block: BlockType) {
		subscribeTime { emission in block(emission.value) }
	}
}


//public class HoldingSignal <T, Hold> : Signal <T> {
//	var hold: Hold
//}


public class SequenceSignal <T> : Signal <T> {
	var items: [T]
	public init(items: [T]) {
		self.items = items
	}
	
	override func subscribeTime(block: EmissionBlockType) {
		for item in items {
			block(Emission(timestamp: 0, value: item))
		}
		
		blocks.append(block)
	}
}


public extension Signal {
	public func map <U> (f: T -> U) -> Signal<U> {
		let signal = Signal<U>()
		self.subscribe { x in 
			signal.emit(f(x))
		}
		return signal
	}
	
//	public func reduce <U> (initial: U, combine: f: (U, T) -> U) -> Signal<U> {
//		var running = initial
//		let result = Signal<U>()
//		self.subscribe { val in
//			
//			result.emit(running)
//		}
//		
//		return result
//	}
}


public func signal_or <T, U> (lhs: Signal <T>, rhs: Signal <U>) -> Signal <Either<T, U>> {
	let s = Signal<Either<T, U>>()
	
	// Whenever either signal emits a value, post it to the combined signal.
	lhs.subscribe { (val: T) in
		s.emit(Either<T, U>.Left(val))
	}
	rhs.subscribe { (val: U) in
		s.emit(Either<T, U>.Right(val))
	}
	
	return s
}
public func || <T, U> (lhs: Signal <T>, rhs: Signal <U>) -> Signal <Either<T, U>> {
	return signal_or(lhs, rhs: rhs)
}


public func signal_and <T, U> (lhs: Signal <T>, rhs: Signal <U>) -> Signal <(T, U)> {
	let s = Signal<(T, U)>()
	
	// When one of the signals emits a value, wait for the other to do so as well.
	lhs.subscribe { (val: T) in
		let lastT: T = val
		
		rhs.subscribe { (val: U) in
			s.emit((lastT, val))
		}
	}
	rhs.subscribe { (val: U) in
		let lastU: U = val
		
		lhs.subscribe { (val: T) in
			s.emit((val, lastU))
		}
	}
	
	return s
}
public func && <T, U> (lhs: Signal <T>, rhs: Signal <U>) -> Signal <(T, U)> {
	return signal_and(lhs, rhs: rhs)
}


public extension Signal {
	public func zipWith(other: Signal<T>, f: (T, T) -> T) -> Signal<T> {
		let left_and_right = self && other
		let composite = Signal<T>()
		left_and_right.subscribe { (left: T, right: T) in
			let combined: T = f(left, right)
			composite.emit(combined)
		}
		return composite
	}
}


//public extension Signal {
//	public func throttle(by: NSTimeInterval) -> Signal<T> {
//		let throttled = Signal()
//		self.subscribe { value in 
//			throttled.emit(<#T##value: T##T#>)
//		}
//		return throttled
//	}
//}








//let s1 = Signal<Int>()
//s1.subscribe { x in print("s1 emitted \(x)") }
//let s2 = Signal<String>()
//s2.subscribe { x in print("s2 emitted '\(x)'") }
//
//let s1_and_s2 = s1 && s2
//s1_and_s2.subscribe { (x: (Int, String)) in print("s1 emitted \(x.0) AND s2 emitted '\(x.1)'") }
//
//let s1_or_s2 = s1 || s2
//s1_or_s2.subscribe { (x: Either<Int, String>) in
//	print("s1 emitted \(x.left) OR s2 emitted '\(x.right)'")
//}
//
//s1.emit(5)
//s2.emit("Hello, World!")
//s1.emit(42)
//s2.emit("My name is David")

