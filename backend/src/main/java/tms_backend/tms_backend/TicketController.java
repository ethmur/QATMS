package tms_backend.tms_backend;

import org.springframework.web.bind.annotation.RestController;

import tms_backend.tms_backend.models.Ticket;
import tms_backend.tms_backend.service.TicketService;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@RestController
@RequestMapping("/tickets")
public class TicketController {
	
	@Autowired
	private TicketService ticketService;
	
	@RequestMapping(value = "", method = RequestMethod.GET)
	public List<Ticket> getAll() {
		return this.ticketService.getAll();
	}
	
	@RequestMapping(value = "", method = RequestMethod.PUT)
	public Ticket create(@RequestBody Ticket ticket) {
		return this.ticketService.create(ticket);
	}
	
	@RequestMapping(value = "/{id}", method = RequestMethod.POST)
	public Ticket update(@PathVariable("id") int id, @RequestBody Ticket ticket) {
		return this.ticketService.update(id, ticket);
	}
	
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public boolean delete(@PathVariable("id") int id) {
		return this.ticketService.delete(id);
	}
	
	

}
