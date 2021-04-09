package tms_backend.tms_backend;

import java.sql.Timestamp;
import java.util.Optional;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

import tms_backend.tms_backend.models.Ticket;
import tms_backend.tms_backend.repository.TicketRepository;
import tms_backend.tms_backend.service.TicketService;

@SpringBootTest
public class TmsBackendApplicationMockitoTests {
	
	@Autowired
    private TicketService ticketService;

    @MockBean
    private TicketRepository ticketRepository;
	
	@Test
	public void createMockitoUnitTest() {
		// GIVEN
		Ticket newTicket = new Ticket();
		newTicket.setTitle("Test Title 1");
		newTicket.setDescription("Test Description 1");
		newTicket.setAuthor("ME");
		newTicket.setStatus("Open");
		Ticket newTicketSaved = new Ticket();
		newTicketSaved.setId(1);
		newTicket.setTitle("Test Title 1");
		newTicket.setDescription("Test Description 1");
		newTicket.setAuthor("ME");
		newTicket.setStatus("Open");
		newTicket.setTimeCreated(new Timestamp(System.currentTimeMillis()));
		
		// When
		Mockito.when(this.ticketRepository.save(newTicket)).thenReturn(newTicketSaved);

	    // THEN
	    Assertions.assertEquals(this.ticketService.create(newTicket), newTicketSaved);

	    // Verify that mocked method was called exactly once
	    Mockito.verify(this.ticketRepository, Mockito.times(1)).save(newTicket);
	}
	
	@Test
	public void updateMockitoUnitTest() {
		// GIVEN
		int ticketId = 1;
		Ticket originalTicket = new Ticket();
		originalTicket.setId(ticketId);
		originalTicket.setTitle("Test Title 1");
		originalTicket.setDescription("Test Description 1");
		originalTicket.setAuthor("ME");
		originalTicket.setStatus("Open");
		originalTicket.setTimeCreated(new Timestamp(System.currentTimeMillis()));
		Ticket updatedTicket = new Ticket();
		updatedTicket.setId(originalTicket.getId());
		updatedTicket.setTitle("Test Title 2");
		updatedTicket.setDescription("Test Description 2");
		updatedTicket.setAuthor("ME");
		updatedTicket.setStatus("In Progress");
		updatedTicket.setTimeCreated(originalTicket.getTimeCreated());
		
		// When
		Mockito.when(this.ticketRepository.findById(ticketId)).thenReturn(Optional.of(originalTicket));
		Mockito.when(this.ticketRepository.save(updatedTicket)).thenReturn(updatedTicket);

	    // THEN
	    Assertions.assertEquals(this.ticketService.update(ticketId, updatedTicket), updatedTicket);

	    // Verify that mocked method was called exactly once
	    Mockito.verify(this.ticketRepository, Mockito.times(1)).findById(ticketId);
	    Mockito.verify(this.ticketRepository, Mockito.times(1)).save(updatedTicket);
	}
	
	@Test
	public void deleteMockitoUnitTest() {
		// GIVEN
		int ticketId = 1;
		
		// When
		Mockito.when(this.ticketRepository.existsById(ticketId)).thenReturn(false);

	    // THEN
	    Assertions.assertEquals(this.ticketService.delete(ticketId), true);

	    // Verify that mocked method was called exactly once
	    Mockito.verify(this.ticketRepository, Mockito.times(1)).existsById(ticketId);
	}

}
