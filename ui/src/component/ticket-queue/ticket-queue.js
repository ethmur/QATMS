import React from 'react';
import { TicketService } from '../../service/ticket-service.js';
import { Ticket } from '../ticket/ticket';
import { TicketCreator } from '../ticket-creator/ticket-creator';

class TicketQueue extends React.Component {

    constructor(props) {
        super(props);
        this.state = { creatingTicket: false };
        this.refreshTicketQueue = this.refreshTicketQueue.bind(this);
        this.handleRefresh = this.handleRefresh.bind(this);
        this.handleCreateTicket = this.handleCreateTicket.bind(this);
        this.handleUpdateTicket = this.handleUpdateTicket.bind(this);
        this.handleDeleteTicket = this.handleDeleteTicket.bind(this);
        this.toggleCreatingTicket = this.toggleCreatingTicket.bind(this);
    }

    componentDidMount() {
        this.refreshTicketQueue();
    }

    refreshTicketQueue() {
        TicketService.getTickets()
            .then(
                (data) => {
                    this.setState( prevState => ({ ...prevState, tickets: data } ));
                },
                (error) => {
                    console.log(error);
                }
            );
    }

    handleRefresh() {
        console.log("Refreshing ticket queue...");
        this.setState( prevState => ({ ...prevState, tickets: [] }));
        this.refreshTicketQueue();
    }

    handleCreateTicket(title, description, author) {
        TicketService.createTicket(title, description, author)
            .then(
                (data) => {
                    if (data === true) {
                        alert("Successfully created ticket");
                    }
                    else {
                        alert("Failed to create ticket");
                    }
                },
                (error) => {
                    console.log(error);
                    alert("Failed to create ticket")
                }
            )
            .then(
                this.refreshTicketQueue()
            );
    }

    handleDeleteTicket(id) {
        TicketService.deleteTicket(id)
            .then(
                (data) => {
                    if (data === true) {
                        alert("Successfully deleted ticket");
                    }
                    else {
                        alert("Failed to delete ticket");
                    }
                },
                (error) => {
                    console.log(error);
                    alert("Failed to delete ticket")
                }
            )
            .then(
                this.refreshTicketQueue()
            );
    }

    handleUpdateTicket(ticket) {
        TicketService.updateTicket(ticket)
            .then(
                (data) => {
                    if (data === true) {
                        alert("Successfully updated ticket");
                    }
                    else {
                        alert("Failed to update ticket");
                    }
                },
                (error) => {
                    console.log(error);
                    alert("Failed to update ticket")
                }
            )
            .then(
                this.refreshTicketQueue()
            );
    }

    toggleCreatingTicket() {
        this.setState( prevState => ({ ...prevState, creatingTicket: !prevState.creatingTicket } ));
    }

    render() {
        let { tickets, creatingTicket } = this.state;
        tickets = tickets || [];
        return (
            <div>
                <h1>Tickets</h1>
                <input type="button" value="Create Ticket" onClick={this.toggleCreatingTicket}></input>
                <input type="button" value="Refresh" onClick={this.handleRefresh}></input>
                { creatingTicket 
                    ? 
                        <TicketCreator 
                            createTicketCb={this.handleCreateTicket}
                            cancelCb={this.toggleCreatingTicket}>
                        </TicketCreator> 
                    : null
                }
                {tickets.map(ticket => (
                    <Ticket 
                        key={ticket.id}
                        ticket={ticket}
                        deleteTicketCb={this.handleDeleteTicket}
                        updateTicketCb={this.handleUpdateTicket}>
                    </Ticket>
                ))}
            </div>
        );
    }
}
  
export { TicketQueue };

