import React from 'react';
import './ticket.css';
import { TicketService } from '../../service/ticket-service.js';

class Ticket extends React.Component {

    constructor(props) {
        super(props);
        this.state = { ticket: props.ticket };
        this.handleTitleChange = this.handleTitleChange.bind(this);
        this.handleDescriptionChange = this.handleDescriptionChange.bind(this);
        this.handleStatusChange = this.handleStatusChange.bind(this);
    }

    componentDidMount() {
        this.setState( prevState => ({ ...prevState, statusOptions: TicketService.statusOptions }) );
    }

    handleTitleChange(event) {
        this.setState( prevState => ({ ...prevState, ticket: { ...prevState.ticket, title: event.target.value } }) );
    }

    handleDescriptionChange(event) {
        this.setState( prevState => ({ ...prevState, ticket: { ...prevState.ticket, description: event.target.value } }) );
    }

    handleStatusChange(event) {
        this.setState( prevState => ({ ...prevState, ticket: { ...prevState.ticket, status: event.target.value } }) );
    }

    render() {
        const { deleteTicketCb, updateTicketCb } = this.props;
        let { ticket, statusOptions } = this.state;
        const { id, title, description, author, status, timeCreated } = ticket;
        statusOptions = statusOptions || [];
        return (
            <div>
                <div className="ticket">
                    <div className="ticket-title">
                        <label>Title: </label>
                        <input type="text" value={title} onChange={this.handleTitleChange}></input>
                    </div>
                    <div className="ticket-detail ticket-description">
                        <label>Description: </label>
                        <input type="text" value={description} onChange={this.handleDescriptionChange}></input>
                    </div>
                    <div className="ticket-detail ticket-author">
                        <p> Author: {author}</p>
                    </div>
                    <div className="ticket-detail ticket-status">
                        <label>Status: </label>
                        <select value={status} onChange={this.handleStatusChange}>
                            {statusOptions.map(statusOption => 
                                <option value={statusOption} key={statusOption}>{statusOption}</option>
                            )}
                        </select>
                    </div>
                    <div className="ticket-detail ticket-time-created">
                        <p>Time Created: {timeCreated}</p>
                    </div>
                </div>
                <input type="button" value="Update" onClick={() => updateTicketCb(ticket)}></input>
                <input type="button" value="Delete" onClick={() => deleteTicketCb(id)}></input>
            </div>
        );
    }
  }
  
  export { Ticket };

