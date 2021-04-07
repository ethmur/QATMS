package tms_backend.tms_backend;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
public class Controller {
	
	@RequestMapping("/")
	public String index() {
		return "Greetings from Spring Boot!";
	}

}
