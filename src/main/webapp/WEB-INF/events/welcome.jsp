<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %> 
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Events</title>
<link href="/webjars/bootstrap/4.5.0/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="/css/style.css">
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
	  <a class="navbar-brand" href="#">Events</a>
	  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
	    <span class="navbar-toggler-icon"></span>
	  </button>
	  <div class="collapse navbar-collapse" id="navbarNavDropdown">
	    <ul class="navbar-nav mr-auto">
	      <li class="nav-item active">
	        <a class="nav-link" href="/events">Home</a>
	      </li>
	      <li class="nav-item dropdown">
	        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
	          Your Events
	        </a>
	        <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
	          <a class="dropdown-item" href="/user/host">Hosted Events</a>
	          <a class="dropdown-item" href="/user/attend">Attended Events</a>
	        </div>
	      </li>
	    </ul>
	    <span class="navbar-text">
	      <a href="/logout">Logout</a>
	    </span>
	  </div>
	</nav>
	<div class="container">
		<div class="row">
			<div class="col">
				<h3>Welcome, ${user.firstName}</h3>
			</div>
		</div>
		<div class="row padding"></div>
		<div class="row">
			<div class="col">
				<h6>Here are some of the events in your state:</h6>
			</div>
		</div>
		<div class="row">
			<div class="col">
				<table class="table table-striped">
				<thead class="thead-dark">
				    <tr>
				      <th scope="col">Name</th>
				      <th scope="col">Date</th>
				      <th scope="col">Location</th>
				      <th scope="col">Host</th>
				      <th scope="col">Action / Status</th>
				    </tr>
				</thead>
				<tbody>
				  	<c:forEach items="${events}" var="e">
				  	<c:choose>
				  	<c:when test="${e.state == user.state}">
				    <tr>
				      <th scope="row"><a href="/events/${e.id}"><c:out value="${e.name}"/></a></th>
				      <td><fmt:formatDate value="${e.eventDate}" type="BOTH" timeZone="America/Los_Angeles" dateStyle="long" timeStyle="long"/></td>
				      <td><c:out value="${e.location}"/></td>
				      <td><c:out value="${e.host.firstName}"/></td>
				      <td>
				      	<c:choose>
					      	<c:when test="${e.host.id == user.id}">
					      		<ul class="list-inline">
						            <li class="list-inline-item">
						                <a href="/events/${e.id}/edit" class="btn btn-link btn-sm" role="button">Edit</a>
						            </li>
						            <li class="list-inline-item"> | </li>
						            <li class="list-inline-item">
						            	<form action="/events/${e.id}" method="post">
							  				<input type="hidden" name="_method" value="delete">
							  				<input type="submit" value="Delete" class="btn btn-link btn-sm">
										</form>
					      				<!-- <button type="button" class="btn btn-link btn-sm" data-toggle="modal" data-target="#deleteModal">Delete</button> -->
						            </li>
						        </ul>
					      	</c:when>
					      	<c:when test="${e.attendees.contains(user)}">
					      		<ul class="list-inline">
						            <li class="list-inline-item">
						                Attending
						            </li>
						            <li class="list-inline-item"> | </li>
						            <li class="list-inline-item">
						                <form class="form-inline" method="post" action="/events/${e.id}/leave">
						                	<input type="hidden" name="_method" value="put">
    										<input type="submit" value="Cancel" class="btn btn-link btn-sm">
						                </form>
						            </li>
						        </ul>
					      	</c:when>
							<c:otherwise>
								<ul class="list-inline">
						            <li class="list-inline-item">
						                <form class="form-inline" method="post" action="/events/${e.id}/join">
						                	<input type="hidden" name="_method" value="put">
    										<input type="submit" value="Join" class="btn btn-link btn-sm">
						                </form>
						            </li>
						        </ul>	
							</c:otherwise>
						</c:choose>			      	
					  </td>
				    </tr>
				    </c:when>
				    </c:choose>
				    </c:forEach>
				</tbody>
				</table>
			</div>
		</div>
		<div class="row padding"></div>
		<div class="row">
			<div class="col">
				<h6>Here are some of the events in your state:</h6>
			</div>
		</div>
		<div class="row">
			<div class="col">
				<table class="table table-striped">
				<thead class="thead-dark">
				    <tr>
				      <th scope="col">Name</th>
				      <th scope="col">Date</th>
				      <th scope="col">Location</th>
				      <th scope="col">State</th>
				      <th scope="col">Host</th>
				      <th scope="col">Action / Status</th>
				    </tr>
				</thead>
				<tbody>
				  	<c:forEach items="${events}" var="e">
				  	<c:choose>
				  	<c:when test="${e.state != user.state}">
				    <tr>
				      <th scope="row"><a href="/events/${e.id}"><c:out value="${e.name}"/></a></th>
				      <td><fmt:formatDate value="${e.eventDate}" type="BOTH" timeZone="America/Los_Angeles" dateStyle="long" timeStyle="long"/></td>
				      <td><c:out value="${e.location}"/></td>
				      <td><c:out value="${e.state}"/></td>
				      <td><c:out value="${e.host.firstName}"/></td>
				      <td>
				      	<c:choose>
					      	<c:when test="${e.host.id == user.id}">
					      		<ul class="list-inline">
						            <li class="list-inline-item">
						                <a href="/events/${e.id}/edit" class="btn btn-link btn-sm" role="button">Edit</a>
						            </li>
						            <li class="list-inline-item"> | </li>
						            <li class="list-inline-item">
						            	<form action="/events/${e.id}" method="post">
							  				<input type="hidden" name="_method" value="delete">
							  				<input type="submit" value="Delete" class="btn btn-link btn-sm">
										</form>
					      				<!-- <button type="button" class="btn btn-link btn-sm" data-toggle="modal" data-target="#deleteModal">Delete</button> -->
						            </li>
						        </ul>
					      	</c:when>
					      	<c:when test="${e.attendees.contains(user)}">
					      		<ul class="list-inline">
						            <li class="list-inline-item">
						                Attending
						            </li>
						            <li class="list-inline-item"> | </li>
						            <li class="list-inline-item">
						                <form class="form-inline" method="post" action="/events/${e.id}/leave">
						                	<input type="hidden" name="_method" value="put">
    										<input type="submit" value="Cancel" class="btn btn-link btn-sm">
						                </form>
						            </li>
						        </ul>
					      	</c:when>
							<c:otherwise>
								<ul class="list-inline">
						            <li class="list-inline-item">
						                <form class="form-inline" method="post" action="/events/${e.id}/join">
						                	<input type="hidden" name="_method" value="put">
    										<input type="submit" value="Join" class="btn btn-link btn-sm">
						                </form>
						            </li>
						        </ul>	
							</c:otherwise>
						</c:choose>			      	
					  </td>
				    </tr>
				    </c:when>
				    </c:choose>
				    </c:forEach>
				</tbody>
				</table>
			</div>
		</div>
		<div class="row padding"></div>
		<div class="row">
			<div class="col">
				<h4>Create an Event</h4>
			</div>
		</div>
		<div class="row padding"></div>
		<div class="row">
			<p class="err"><form:errors path="event.*"/></p>
			<p class="err"><c:out value="${stateerr}" /></p>
		</div>
		<div class="row">
			<form:form action="/events" method="post" modelAttribute="event" class="eventform">
				<form:input type="hidden" path="host.id" value="${user.id}"/>
				<div class="col-sm-7">
					<div class="form-row">
						<div class="form-group col-sm-4">
							<form:label path="name">Name:</form:label>
						</div>
						<div class="form-group col-sm-8">
			        		<form:input path="name"  class="form-control" type="text"/>
						</div>
					</div>
					<div class="form-row">
						<div class="form-group col-sm-4">
							<form:label path="eventDate">Date:</form:label>
						</div>
						<div class="form-group col-sm-8">
			        		<form:input path="eventDate"  class="form-control" type="datetime-local"/>
						</div>
					</div>
					<div class="form-row">
						<div class="form-group col-sm-4">
							<form:label path="location">Location:</form:label>
						</div>
						<div class="form-group col-sm-6">
			        		<form:input path="location"  class="form-control" type="text"/>
						</div>
						<div class="form-group col-sm-2">
			        		<form:select path="state" class="form-control" >
					        	<c:forEach items="${states}" var="s">
					        	<c:choose>
					        		<c:when test="${s == user.state }">
					        			<form:option value="${s}" label="${s}" selected="true"/>
					        		</c:when>
					        		<c:otherwise>
					        			<form:option value="${s}" label="${s}"/>
					        		</c:otherwise>
					        	</c:choose>
					        	</c:forEach>
					        </form:select>
						</div>
					</div>
					<div class="row form-group">
						<div class="col text-center">
							<input type="submit" value="Create" class="btn btn-dark"/>
						</div>
					</div>
				</div>
			</form:form>
		</div>
	</div>
	<!-- Modal -->
	<div class="modal fade" id="deleteModal" tabindex="-1" role="dialog">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title">Delete Event</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	        <p>Are you sure you want to cancel this event?</p>
	        <p>You cannot undo this.</p>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
	        <form action="/events/${e.id}" method="post">
  				<input type="hidden" name="_method" value="delete">
  				<input type="submit" value="Delete Event" class="btn btn-dark">
			</form>
	      </div>
	    </div>
	  </div>
	</div>
<script src="/webjars/jquery/3.5.1/jquery.min.js "></script>
<script src="/webjars/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="/webjars/bootstrap/4.5.0/js/bootstrap.min.js"></script>   
</body>
</html>