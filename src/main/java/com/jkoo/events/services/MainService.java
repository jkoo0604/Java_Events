package com.jkoo.events.services;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jkoo.events.models.Event;
import com.jkoo.events.models.Message;
import com.jkoo.events.models.User;
import com.jkoo.events.repositories.EventRepository;
import com.jkoo.events.repositories.MessageRepository;
import com.jkoo.events.repositories.UserRepository;

@Service
public class MainService {
	@Autowired
	private UserRepository uRepo;
	@Autowired
	private EventRepository eRepo;
	@Autowired
	private MessageRepository mRepo;
	
	public User getUser(Long id) {
		Optional<User> checkU = uRepo.findById(id);
		if (checkU.isPresent()) {
			User user = checkU.get();
			return user;
		}
		return null;
	}
	
	public List<Event> getFutureEvents() {
		Instant nowinstant = Instant.now();
		Date now = Date.from(nowinstant);
		return eRepo.findByEventDateAfterOrderByEventDateAsc(now);
	}
	
	public List<Event> getFutureEventsHosted(Long id) {
		Optional<User> checkU = uRepo.findById(id);
		if (checkU.isPresent()) {
			Instant nowinstant = Instant.now();
			Date now = Date.from(nowinstant);
			User user = checkU.get();
			return eRepo.findByEventDateAfterAndHostOrderByEventDateAsc(now, user);
		}
		return null;
	}
	
	public List<Event> getPastEventsHosted(Long id) {
		Optional<User> checkU = uRepo.findById(id);
		if (checkU.isPresent()) {
			Instant nowinstant = Instant.now();
			Date now = Date.from(nowinstant);
			User user = checkU.get();
			return eRepo.findByEventDateBeforeAndHostOrderByEventDateDesc(now, user);
		}
		return null;
	}
	
	public List<Event> getFutureEventsAttended(Long id) {
		Optional<User> checkU = uRepo.findById(id);
		if (checkU.isPresent()) {
			Instant nowinstant = Instant.now();
			Date now = Date.from(nowinstant);
			User user = checkU.get();
			return eRepo.findByEventDateAfterAndAttendeesContainingOrderByEventDateAsc(now, user);
		}
		return null;
	}
	
	public List<Event> getPastEventsAttended(Long id) {
		Optional<User> checkU = uRepo.findById(id);
		if (checkU.isPresent()) {
			Instant nowinstant = Instant.now();
			Date now = Date.from(nowinstant);
			User user = checkU.get();
			return eRepo.findByEventDateBeforeAndAttendeesContainingOrderByEventDateDesc(now, user);
		}
		return null;
	}
	
	public List<Message> getMessagesEvent(Long id) {
		Optional<Event> checkE = eRepo.findById(id);
		if (checkE.isPresent()) {
			Event event = checkE.get();
			return mRepo.findByEventOrderByCreatedAtDesc(event);
		}
		return null;		
	}
	
	public User registerUser(User user) {
        String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
        user.setPassword(hashed);
        return uRepo.save(user);
    }
	
	public User findByEmail(String email) {
        return uRepo.findByEmail(email);
    }
	
	public boolean authenticateUser(String email, String password) {
        User user = uRepo.findByEmail(email);
        if(user == null) {
            return false;
        } else {
            if(BCrypt.checkpw(password, user.getPassword())) {
                return true;
            } else {
                return false;
            }
        }
    }
	
	public boolean duplicateEmail(String email) {
    	User user = uRepo.findByEmail(email);
    	if (user == null) {
    		return false;
    	}
    	return true;
    }
	
	public Event getEvent(Long id) {
		Optional<Event> checkE = eRepo.findById(id);
		if (checkE.isPresent()) {
			Event event = checkE.get();
			return event;
		}
		return null;
	}
	
	public Event createEvent(Event e) {
		return eRepo.save(e);
	}
	
	public Event updateEvent(Event e) {
		Optional<Event> checkE = eRepo.findById(e.getId());
		if (checkE.isPresent()) {
			Event event = checkE.get();
			event.setName(e.getName());
			event.setEventDate(e.getEventDate());
			event.setLocation(e.getLocation());
			event.setState(e.getState());
			return eRepo.save(event);
		}
		return null;
	}
	
	public Event updateEvent2(String name, Date eventDate, String location, String state, Long id) {
		Optional<Event> checkE = eRepo.findById(id);
		if (checkE.isPresent()) {
			Event event = checkE.get();
			event.setName(name);
			event.setEventDate(eventDate);
			event.setLocation(location);
			event.setState(state);
			return eRepo.save(event);
		}
		return null;
	}
	
	public boolean removeEvent(Long id) {
		Optional<Event> checkE = eRepo.findById(id);
		if (checkE.isPresent()) {
			Event event = checkE.get();
			eRepo.delete(event);
			return true;
		}
		return false;
	}
	
	public Message createMessage(String text, User poster, Event event) {
		Message message = new Message();
		message.setText(text);
		message.setEvent(event);
		message.setPoster(poster);
		return mRepo.save(message);
	}
	
	public boolean joinEvent(Long eventID, Long userID) {
		Optional<Event> checkE = eRepo.findById(eventID);
		Optional<User> checkU = uRepo.findById(userID);
		if (checkE.isPresent() && checkU.isPresent()) {
			Event event = checkE.get();
			User user = checkU.get();
			if (event.getAttendees() == null) {
				ArrayList<User> userList = new ArrayList<User>();
				userList.add(user);
				event.setAttendees(userList);
				eRepo.save(event);
				return true;
			}
			if (event.getAttendees().contains(user)) {
				return true;
			}
			event.getAttendees().add(user);
			eRepo.save(event);
			return true;
		}
		return false;
	}
	
	public boolean leaveEvent(Long eventID, Long userID) {
		Optional<Event> checkE = eRepo.findById(eventID);
		Optional<User> checkU = uRepo.findById(userID);
		if (checkE.isPresent() && checkU.isPresent()) {
			Event event = checkE.get();
			User user = checkU.get();
			if (event.getAttendees().contains(user)) {
				event.getAttendees().remove(user);
				eRepo.save(event);
				return true;
			}
			return true;
		}
		return false;
	}
	
	public boolean checkState(String state) {
		List<String> states = Arrays.asList("AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", "GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY");
		if (states.contains(state)) {
			return true;
		}
		return false;
	}
	
}
