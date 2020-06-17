<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %> 
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Welcome</title>
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
	    </ul>
	  </div>
	</nav>
	<div class="container">
		<div class="row">
			<div class="col">
				<h3>Welcome</h3>
			</div>
		</div>
		<div class="row">
			<div class="col-7">
				<div class="reg">
					<fieldset class="border">
						<legend class="w-auto">Register</legend>
						<p class="err"><form:errors path="user.*"/></p>
						<p class="err"><c:out value="${emailerr}" /></p>
						<p class="err"><c:out value="${stateerr}" /></p>
						<form:form action="/registration" method="post" modelAttribute="user">
							<div class="col-sm-12">
								<div class="form-row">
									<div class="form-group col-sm-3">
										<form:label path="firstName">First Name:</form:label>
									</div>
									<div class="form-group col-sm-9">
						        		<form:input path="firstName"  class="form-control" type="text"/>
									</div>
								</div>
								<div class="form-row">
									<div class="form-group col-sm-3">
										<form:label path="lastName">Last Name:</form:label>
									</div>
									<div class="form-group col-sm-9">
						        		<form:input path="lastName"  class="form-control" type="text"/>
									</div>
								</div>
								<div class="form-row">
									<div class="form-group col-sm-3">
										<form:label path="location">Location:</form:label>
									</div>
									<div class="form-group col-sm-6">
						        		<form:input path="location"  class="form-control" type="text"/>
									</div>
									<div class="form-group col-sm-3">
						        		<form:select path="state" class="form-control" >
								        	<c:forEach items="${states}" var="s">
								        	<form:option value="${s}"><c:out value="${s}"/></form:option>
								        	</c:forEach>
								        </form:select>
									</div>
								</div>
								<div class="form-row">
									<div class="form-group col-sm-3">
										<form:label path="email">Email:</form:label>
									</div>
									<div class="form-group col-sm-9">
						        		<form:input path="email"  class="form-control" type="email"/>
									</div>
								</div>
								<div class="form-row">
									<div class="form-group col-sm-3">
										<form:label path="password">Password:</form:label>
									</div>
									<div class="form-group col-sm-9">
						        		<form:password path="password" class="form-control"/>
									</div>
								</div>
								<div class="form-row">
									<div class="form-group col-sm-3">
										<form:label path="passwordConfirmation">Confirm Password:</form:label>
									</div>
									<div class="form-group col-sm-9">
						        		<form:password path="passwordConfirmation"  class="form-control"/>
									</div>
								</div>
								<div class="row form-group">
									<div class="col text-center">
										<input type="submit" value="Register" class="btn btn-dark"/>
									</div>
								</div>
							</div>
						</form:form>
					</fieldset>
				</div>
			</div>
			<div class="col-5">
				<div class="login">
					<fieldset class="border">
						<legend class="w-auto">Login</legend>
						<p class="err"><c:out value="${loginerr}" /></p>
						<form method="post" action="/login">
					        <div class="row form-group">
					        	<div class="col-sm-4">
									<label for="logemail">Email</label>
								</div>
								<div class="col-sm-8">
					        		<input type="email" id="logemail" name="logemail" class="form-control"/>
								</div>
					        </div>
					        <div class="row form-group">
					        	<div class="col-sm-4">
									<label for="logpassword">Password</label>
								</div>
								<div class="col-sm-8">
					        		<input type="password" id="logpassword" name="logpassword" class="form-control"/>
								</div>
					        </div>
					        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
					        <input type="submit" value="Login" class="btn btn-dark btn-sm"/>
					    </form>
					</fieldset>
				</div>
			</div>
		</div>
		
	</div>

<script src="/webjars/jquery/3.5.1/jquery.min.js "></script>
<script src="/webjars/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="/webjars/bootstrap/4.5.0/js/bootstrap.min.js"></script>   
</body>
</html>