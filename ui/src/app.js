import React from 'react';
import './app.css';
import { TicketQueue } from './component/ticket-queue/ticket-queue'

class App extends React.Component {
	render() {
		return <TicketQueue></TicketQueue>;
	}
}

export { App };
