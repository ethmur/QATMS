class TicketService {
    static #tickets = [
        {
            "id": 1,
            "title": "ticket1",
            "description": "description1",
            "author": "person1",
            "status": "Open",
            "timeCreated": "2020-01-31"
        },
        {
            "id": 2,
            "title": "ticket2",
            "description": "description2222222222",
            "author": "person2",
            "status": "Closed",
            "timeCreated": "2020-01-31"
        },
    ];
    static statusOptions = ["Open", "In Progress", "Closed"];

    static getTickets() {
        console.log("Getting all tickets...");
        const tickets = this.#tickets;
        console.log("Got all tickets:", tickets);
        return Promise.resolve(tickets);
    }

    static createTicket(title, description, author) {
        console.log("Creating new ticket with title=", title, "description=", description, "author=", author);
        const ticket = {
            "id": this.#tickets.length + 1,
            "title": title,
            "description": description,
            "author": author,
            "status": "Open",
            "timeCreated": "2020-01-31"
        }
        this.#tickets.push(ticket);
        console.log("Successfully created ticket");
        return Promise.resolve(true);
    }

    static deleteTicket(id) {
        console.log("Deleting ticket with id=", id);
        this.#tickets = this.#tickets.filter(ticket => ticket.id !== id);
        console.log("Successfully deleted ticket");
        return Promise.resolve(true);
    }

    static updateTicket(ticket) {
        console.log("Updating ticket as follows:", ticket);
        const index = this.#tickets.findIndex(t => t.id === ticket.id);
        this.#tickets[index] = ticket;
        console.log("Successfully updated ticket");
        return Promise.resolve(true);
    }

}

export { TicketService };