package tms_backend.tms_backend;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import tms_backend.tms_backend.models.Ticket;
import tms_backend.tms_backend.service.TicketService;

@SpringBootTest
class TmsBackendApplicationTests {
	
	@Autowired
	private TicketService ticketService;

	@Test
	public void testHelloWorld() {
		System.out.println("Hello world");
	}
	
	@Test
	public void integrationTests() {
		
		List<Ticket> tickets = ticketService.getAll();
		assertEquals(tickets.size(), 0);
		
		Ticket newTicket = new Ticket();
		newTicket.setTitle("Test Title 1");
		newTicket.setDescription("Test Description 1");
		newTicket.setAuthor("ME");
		newTicket.setStatus("Open");
		System.out.println("New Ticket: " + newTicket);
		Ticket newTicketSaved = ticketService.create(newTicket);
		System.out.println("New Ticket created: " + newTicketSaved);
		assertEquals(newTicket.getTitle(), newTicketSaved.getTitle());
		assertEquals(newTicket.getDescription(), newTicketSaved.getDescription());
		assertEquals(newTicket.getAuthor(), newTicketSaved.getAuthor());
		assertEquals(newTicket.getStatus(), newTicketSaved.getStatus());
		assertNotNull(newTicketSaved.getId());
		assertNotNull(newTicketSaved.getTimeCreated());
		int newTicketId = newTicketSaved.getId();
		tickets = ticketService.getAll();
		assertEquals(tickets.size(), 1);
		assertEquals(tickets.get(0).getId(), newTicketId);
		
		Ticket updatedTicket = newTicketSaved;
		String updatedTicketStatus = "In Progress";
		updatedTicket.setStatus(updatedTicketStatus);
		System.out.println("Updated Ticket: " + updatedTicket);
		Ticket updatedTicketSaved = ticketService.update(newTicketId, updatedTicket);
		System.out.println("Updated Ticket Saved: " + updatedTicketSaved);
		assertEquals(updatedTicket.getTitle(), updatedTicketSaved.getTitle());
		assertEquals(updatedTicket.getDescription(), updatedTicketSaved.getDescription());
		assertEquals(updatedTicket.getAuthor(), updatedTicketSaved.getAuthor());
		assertEquals(updatedTicket.getStatus(), updatedTicketSaved.getStatus());
		assertNotNull(updatedTicketSaved.getId());
		assertNotNull(updatedTicketSaved.getTimeCreated());
		tickets = ticketService.getAll();
		assertEquals(tickets.size(), 1);
		assertEquals(tickets.get(0).getId(), newTicketId);
		
		boolean deleted = ticketService.delete(newTicketId);
		assertTrue(deleted);
		tickets = ticketService.getAll();
		assertEquals(tickets.size(), 0);
		
	}

}
