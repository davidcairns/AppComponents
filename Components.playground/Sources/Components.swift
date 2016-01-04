//import Foundation
//
//public struct Updater <Model, Action> {
//	public typealias Func = (Model, Action) -> Model
//}
//
//public struct Renderer <Model, View> {
//	public typealias Func = Model -> View
//}
//
//public struct ComponentProto <Model, Action, View> {
//	public typealias UpdateFunc = Updater<Model, Action>.Func
//	public let update: UpdateFunc
//	
//	public typealias RenderFunc = Renderer<Model, View>.Func
//	public let render: RenderFunc
//	
//	public init(updater: UpdateFunc, renderer: RenderFunc) {
//		self.update = updater
//		self.render = renderer
//	}
//}
//
//func compose_updaters <M1, A1, M2, A2> (lhs: Updater<M1, A1>.Func, _ rhs: Updater<M2, A2>.Func) -> Updater<(M1, M2), Either<A1, A2>>.Func {
//	return { (model, action) in
//		let left_result = action.left.map { a in lhs(model.0, a) } ?? model.0
//		let right_result = action.right.map { b in rhs(model.1, b) } ?? model.1
//		return (left_result, right_result)
//	}
//}
//public func + <M1, A1, M2, A2>(lhs: Updater<M1, A1>.Func, rhs: Updater<M2, A2>.Func) -> Updater<(M1, M2), Either<A1, A2>>.Func {
//	return compose_updaters(lhs, rhs)
//}
//
//func compose_renderers <M1, V1, M2, V2> (lhs: Renderer<M1, V1>.Func, _ rhs: Renderer<M2, V2>.Func) -> Renderer<(M1, M2), (V1, V2)>.Func {
//	return { model in
//		let left_view = lhs(model.0)
//		let right_view = rhs(model.1)
//		return (left_view, right_view)
//	}
//}
//public func + <M1, V1, M2, V2> (lhs: Renderer<M1, V1>.Func, rhs: Renderer<M2, V2>.Func) -> Renderer<(M1, M2), (V1, V2)>.Func {
//	return compose_renderers(lhs, rhs)
//}
//
//
//func compose_component_protos <M1, A1, V1, M2, A2, V2> (lhs: ComponentProto<M1, A1, V1>, _ rhs: ComponentProto<M2, A2, V2>) -> ComponentProto<(M1, M2), Either<A1, A2>, (V1, V2)> {
//	return ComponentProto(updater: compose_updaters(lhs.update, rhs.update),
//		renderer: compose_renderers(lhs.render, rhs.render))
//}
//public func + <M1, A1, V1, M2, A2, V2> (lhs: ComponentProto<M1, A1, V1>, rhs: ComponentProto<M2, A2, V2>) -> ComponentProto<(M1, M2), Either<A1, A2>, (V1, V2)> {
//	return compose_component_protos(lhs, rhs)
//}
//
//
//
//public struct Component <Model, Action, View> {
//	public let proto: ComponentProto <Model, Action, View>
//	public let state: Model
//	public let view: Signal<View>
//	
//	public init (proto: ComponentProto <Model, Action, View>, state: Model, view: Signal<View>) {
//		self.proto = proto
//		self.state = state
//		self.view = view
//	}
//	public init (proto: ComponentProto <Model, Action, View>, state: Model) {
//		self.init(proto: proto, state: state, view: Signal<View>())
//	}
//	
//	public func update(action: Action) -> Component <Model, Action, View> {
//		return Component(proto: self.proto, 
//						 state: self.proto.update(self.state, action),
//						  view: self.view)
//	}
//	
//	public func render() {
//		self.view.emit(self.proto.render(self.state))
//	}
//}
//
//
//public func compose_components <M1, A1, V1, M2, A2, V2> (lhs: Component <M1, A1, V1>, rhs: Component <M2, A2, V2>) -> Component <(M1, M2), Either<A1, A2>, (V1, V2)> {
//	return Component(proto: lhs.proto + rhs.proto, state: (lhs.state, rhs.state))
//}
//public func + <M1, A1, V1, M2, A2, V2> (lhs: Component <M1, A1, V1>, rhs: Component <M2, A2, V2>) -> Component <(M1, M2), Either<A1, A2>, (V1, V2)> {
//	return compose_components(lhs, rhs: rhs)
//}
//
//
//
//
//
//extension ComponentProto {
//	public func Instantiate (model: Model) -> Component <Model, Action, View> {
//		return Component(proto: self, state: model)
//	}
//}
//
