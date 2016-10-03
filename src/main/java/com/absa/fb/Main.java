package com.absa.fb;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ImportResource;

import com.absa.fb.job.FBNotifier;


@SpringBootApplication
@ImportResource("classpath:applicationContext.xml")
public class Main implements CommandLineRunner {
	

	public static void main(String[] args) {
        ApplicationContext ctx = SpringApplication.run(Main.class, args);
    }
	

	@Override
	public void run(String... args) throws Exception {
	
	}
}
