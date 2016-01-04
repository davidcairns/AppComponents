//import Foundation
//
//public struct ViewComponent<Model, Action> {
//	public typealias ProtoType = ComponentProto <Model, Action, Colorer>
//	public typealias Type = Component <Model, Action, Colorer>
//}
//
//internal func compose <M1, A1, M2, A2> (lhs: Component<M1, A1, Colorer>, _ rhs: Component<M2, A2, Colorer>, with combiner: ColorerCombiner) -> Component<(M1, M2), Either<A1, A2>, Colorer> {
//	let renderer = { (model: (M1, M2)) in
//		return combiner(lhs.proto.render(model.0), rhs.proto.render(model.1))
//	}
//	let proto = ComponentProto(updater: lhs.proto.update + rhs.proto.update, renderer: renderer)
//	
//	let composite_view = lhs.view.zipWith(rhs.view, f: combiner)
//	return Component(proto: proto, state: (lhs.state, rhs.state), view: composite_view)
//}
//
//public func onTopOf <M1, A1, M2, A2> (lhs: Component<M1, A1, Colorer>, _ rhs: Component<M2, A2, Colorer>) -> Component<(M1, M2), Either<A1, A2>, Colorer> {
//	return compose(lhs, rhs, with: ---)
//}
//
//public func --- <M1, A1, M2, A2> (lhs: Component<M1, A1, Colorer>, rhs: Component<M2, A2, Colorer>) -> Component<(M1, M2), Either<A1, A2>, Colorer> {
//	return onTopOf(lhs, rhs)
//}
//
//public func nextTo <M1, A1, M2, A2> (lhs: Component<M1, A1, Colorer>, _ rhs: Component<M2, A2, Colorer>) -> Component<(M1, M2), Either<A1, A2>, Colorer> {
//	return compose(lhs, rhs, with: |||)
//}
//
//public func ||| <M1, A1, M2, A2> (lhs: Component<M1, A1, Colorer>, rhs: Component<M2, A2, Colorer>) -> Component<(M1, M2), Either<A1, A2>, Colorer> {
//	return nextTo(lhs, rhs)
//}
