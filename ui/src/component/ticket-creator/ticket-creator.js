import React from 'react';
import './ticket-creator.css';

class TicketCreator extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            "title": "",
            "description": "",
            "author": ""
        };
        this.handleTitleChange = this.handleTitleChange.bind(this);
        this.handleDescriptionChange = this.handleDescriptionChange.bind(this);
        this.handleAuthorChange = this.handleAuthorChange.bind(this);
    }

    handleTitleChange(event) {
        this.setState( prevState => ({ ...prevState, title: event.target.value }) );
    }

    handleDescriptionChange(event) {
        this.setState( prevState => ({ ...prevState, description: event.target.value }) );
    }

    handleAuthorChange(event) {
        this.setState( prevState => ({ ...prevState, author: event.target.value }) );
    }

    render() {
        const { title, description, author } = this.state;
        const { createTicketCb, cancelCb } = this.props;
        return (
            <div>
                <div className="ticket new-ticket">
                    <h3 style={{"textAlign": "center"}}>New Ticket</h3>
                    <div className="ticket-title">
                        <label>Title: </label>
                        <input type="text" value={title} onChange={this.handleTitleChange}></input>
                    </div>
                    <div className="ticket-detail ticket-description">
                        <label>Description: </label>
                        <input type="text" value={description} onChange={this.handleDescriptionChange}></input>
                    </div>
                    <div className="ticket-detail ticket-author">
                        <label>Author: </label>
                        <input type="text" value={author} onChange={this.handleAuthorChange}></input>
                    </div>
                </div>
                <input type="button" value="Create" onClick={() => { createTicketCb(title, description, author); cancelCb(); }}></input>
                <input type="button" value="Cancel" onClick={() => cancelCb()}></input>
            </div>
        );
    }
}

export { TicketCreator };