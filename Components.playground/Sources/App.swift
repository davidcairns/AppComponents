import Foundation

public func run <AppType: Component, Event where Event == AppType.Action> (app: AppType, eventStream: Signal<Event>, outputHandler: Image -> ()) {
	var running = app
	eventStream.subscribe { (event: AppType.Action) in
		running.model = running.update(event, model: running.model)
		let frame = running.view(running.model)
		let rendered_frame = Draw(width: 200, height: 40, colorer: frame)
		outputHandler(rendered_frame)
	}
}
