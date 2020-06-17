package com.jkoo.events.repositories;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.jkoo.events.models.Event;
import com.jkoo.events.models.Message;

@Repository
public interface MessageRepository extends CrudRepository<Message, Long>{
	List<Message> findAll();
	List<Message> findByEventOrderByCreatedAtDesc(Event event);
}
