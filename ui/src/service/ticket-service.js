class TicketService {
    static #backendUrl = "http://localhost:8080/"
    static statusOptions = ["Open", "In Progress", "Closed"];

    static getTickets() {
        console.log("Getting all tickets...");
        const fetchOptions = {
            method: "GET",
            headers: { "Content-Type": "application/json" }
        };
        return fetch(this.#backendUrl + "tickets/", fetchOptions)
            .then(response => response.json())
            .then(data => {
                console.log("Response body from backend when fetching all tickets: ", data);
                return data;
            });
    }

    static createTicket(title, description, author) {
        console.log("Creating new ticket with title=", title, "description=", description, "author=", author);
        const ticket = {
            "title": title,
            "description": description,
            "author": author,
            "status": "Open",
        };
        const fetchOptions = {
            method: "PUT", 
            body: JSON.stringify(ticket),
            headers: { "Content-Type": "application/json" }
        };
        return fetch(this.#backendUrl + "tickets/", fetchOptions)
            .then(response => response.json())
            .then(data => {
                console.log("Response body from backend when creating ticket: ", data);
                if (data.id) {
                    return true;
                }
                return false;
            });
    }

    static deleteTicket(id) {
        console.log("Deleting ticket with id=", id);
        const fetchOptions = {
            method: "DELETE", 
            headers: { "Content-Type": "application/json" }
        };
        return fetch(this.#backendUrl + `tickets/${id}`, fetchOptions)
            .then(response => response.text())
            .then(response => {
                console.log("Response from backend when deleting ticket: ", response);
                if (response === "true") {
                    return true;
                }
                return false;
            });
    }

    static updateTicket(ticket) {
        console.log("Updating ticket as follows:", ticket);
        const fetchOptions = {
            method: "POST", 
            body: JSON.stringify(ticket),
            headers: { "Content-Type": "application/json" }
        };
        return fetch(this.#backendUrl + `tickets/${ticket.id}`, fetchOptions)
            .then(response => response.json())
            .then(data => {
                console.log("Response body from backend when updating ticket: ", data);
                if (data.id) {
                    return true;
                }
                return false;
            });
    }

}

export { TicketService };