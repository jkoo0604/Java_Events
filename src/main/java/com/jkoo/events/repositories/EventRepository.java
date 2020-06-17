package com.jkoo.events.repositories;

import java.util.Date;
import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.jkoo.events.models.Event;
import com.jkoo.events.models.User;

@Repository
public interface EventRepository extends CrudRepository<Event, Long>{
	List<Event> findAllByOrderByEventDateAsc();
	List<Event> findByHostOrderByEventDateAsc(User host);
	List<Event> findByAttendeesContainingOrderByEventDateAsc(User attendee);
	List<Event> findByEventDateAfterOrderByEventDateAsc(Date date);
	List<Event> findByEventDateAfterAndHostOrderByEventDateAsc(Date date, User user);
	List<Event> findByEventDateAfterAndAttendeesContainingOrderByEventDateAsc(Date date, User user);
	List<Event> findByEventDateBeforeAndHostOrderByEventDateDesc(Date date, User user);
	List<Event> findByEventDateBeforeAndAttendeesContainingOrderByEventDateDesc(Date date, User user);
	
}
