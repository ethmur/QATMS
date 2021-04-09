package tms_backend.tms_backend.service;

import java.util.List;
import java.util.Optional;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import tms_backend.tms_backend.models.Ticket;
import tms_backend.tms_backend.repository.TicketRepository;

@Service
public class TicketService {
	
	private static final Logger LOGGER = LogManager.getLogger();
	
	@Autowired
	private TicketRepository ticketRespository;
		
	public List<Ticket> getAll() {
		LOGGER.info("Getting all tickets");
		return this.ticketRespository.findAll();
	}
	
	public Ticket create(Ticket ticket) {
		LOGGER.info("Creating following ticket: " + ticket);
		return this.ticketRespository.save(ticket);
	}
	
	public Ticket update(int id, Ticket ticket) {
		LOGGER.info("Updating following ticket: " + ticket);
		Optional<Ticket> existingOptional = this.ticketRespository.findById(id);
        Ticket existing = existingOptional.get();
        existing.setTitle(ticket.getTitle());
        existing.setDescription(ticket.getDescription());
        existing.setAuthor(ticket.getAuthor());
        existing.setStatus(ticket.getStatus());
        return this.ticketRespository.save(existing);
	}
	
	public boolean delete(int id) {
		LOGGER.info("Deleting ticket with id=" + id);
        this.ticketRespository.deleteById(id);
        boolean exists = this.ticketRespository.existsById(id);
        System.out.println(!exists);
        return !exists;
	}

}
