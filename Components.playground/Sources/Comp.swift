import Foundation

public protocol Component {
	typealias Model
	var model: Model { get set }
	
	typealias Action
	func update(action: Action, model: Model) -> Model
	func view(model: Model) -> Colorer
}

public struct CompositeComponent <C1: Component, C2: Component> : Component {
	var lhs: C1
	var rhs: C2
	let viewCombiner: ColorerCombiner
	
	public var model: (C1.Model, C2.Model) {
		get {
			return (lhs.model, rhs.model)
		}
		set {
			lhs.model = newValue.0
			rhs.model = newValue.1
		}
	}
	
	public init(lhs: C1, rhs: C2, viewCombiner: ColorerCombiner) {
		self.lhs = lhs
		self.rhs = rhs
		self.viewCombiner = viewCombiner
	}
	
	public func update(action: Either<C1.Action, C2.Action>, model: (C1.Model, C2.Model)) -> (C1.Model, C2.Model) {
		let left_result = action.left.map { action in lhs.update(action, model: self.model.0) } ?? lhs.model
		let right_result = action.right.map { action in rhs.update(action, model: self.model.1) } ?? rhs.model
		return (left_result, right_result)
	}
	public func view(model: (C1.Model, C2.Model)) -> Colorer {
		return self.viewCombiner(self.lhs.view(model.0), self.rhs.view(model.1))
	}
}


public func nextTo <M1, M2> (lhs: M1 -> Colorer, rhs: M2 -> Colorer) -> (M1, M2) -> Colorer {
	return { (model1, model2) in
		lhs(model1) --- rhs(model2)
	}
}

public func nextTo <C1: Component, C2: Component> (lhs: C1, rhs: C2) -> CompositeComponent<C1, C2> {
	return CompositeComponent(lhs: lhs, rhs: rhs, viewCombiner: ---)
}
public func --- <C1: Component, C2: Component> (lhs: C1, rhs: C2) -> CompositeComponent<C1, C2> {
	return nextTo(lhs, rhs: rhs)
}

public func onTopOf <C1: Component, C2: Component> (lhs: C1, rhs: C2) -> CompositeComponent<C1, C2> {
	return CompositeComponent(lhs: lhs, rhs: rhs, viewCombiner: |||)
}
public func ||| <C1: Component, C2: Component> (lhs: C1, rhs: C2) -> CompositeComponent<C1, C2> {
	return onTopOf(lhs, rhs: rhs)
}
