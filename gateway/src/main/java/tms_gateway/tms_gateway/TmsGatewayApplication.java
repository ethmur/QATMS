package tms_gateway.tms_gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.zuul.EnableZuulProxy;

@SpringBootApplication
@EnableZuulProxy
public class TmsGatewayApplication {

	public static void main(String[] args) {
		SpringApplication.run(TmsGatewayApplication.class, args);
	}

}
