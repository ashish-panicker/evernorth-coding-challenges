# Contact Manager Application (Core Java)

A simple, layered **Contact Manager** application built using **Core Java**, designed to practice and demonstrate:

* Java Collections Framework
* Optional (null-safety & API design)
* Validation
* Unit Testing (JUnit 5)
* Clean architecture (Repository + Service)
* Testable, extensible design for adding Exception Handling

This project is intentionally designed as an **interview-grade mini project** and as a foundation for later enhancements (custom exceptions, REST API, persistence, etc.).

---

## Project Objectives

This project focuses on mastering:

### 1. Java Collections

* `Map` for fast lookups (in-memory store)
* `List` for returning collections
* `Stream API` for searching and filtering
* Thread-safe collection usage (`ConcurrentHashMap`)

### 2. Optional Best Practices

* Avoiding `null` in public APIs
* Representing absence using `Optional`
* Safe update and lookup patterns
* Clean handling of “not found” scenarios

### 3. Validation

Basic input validation to ensure:

* Name is not blank
* Email is not blank and follows a basic format
* Phone number is not blank and meets minimum length
* Duplicate emails are detected (optional enhancement)

Validation is handled at the **Service layer** to keep repositories simple.

### 4. Unit Testing

* JUnit 5 based tests
* Testing Optional behavior
* Verifying CRUD operations
* Testing validation and edge cases

---

## Project Structure

```
contact-manager/
 └── src/main/java/com/example/contact/
     ├── model/
     │    └── Contact.java
     ├── repository/
     │    ├── ContactRepository.java
     │    └── InMemoryContactRepository.java
     ├── service/
     │    └── ContactService.java
     ├── validation/
     │    └── ContactValidator.java
     └── app/
          └── ContactManagerApp.java

 └── src/test/java/com/example/contact/
     └── service/
          └── ContactServiceTest.java
```

---

##  Architecture Overview

### Model Layer

* `Contact`
* Represents domain data
* Uses UUID for unique identification
* Implements `equals()` and `hashCode()` for collection usage

### Repository Layer

* `ContactRepository` (interface)
* `InMemoryContactRepository` (Map-based implementation)

Responsibilities:

* Store and retrieve contacts
* No business logic
* No validation
* No exception handling (yet)

### Service Layer

* `ContactService`

Responsibilities:

* Business logic
* Validation
* Duplicate checks
* Returns `Optional` for not-found cases
* Orchestrates repository calls

### Validation Layer

* `ContactValidator`

Responsibilities:

* Centralized input validation
* Keeps service logic clean
* Easy to extend later

---

## Validation Rules

Validation is performed before creating or updating a contact.

### Current Rules

| Field | Rule                                |
| ----- | ----------------------------------- |
| Name  | Must not be null or blank           |
| Email | Must not be null or blank           |
| Email | Must match basic email format       |
| Phone | Must not be null or blank           |
| Phone | Must have minimum length (e.g., 6+) |

## Unit Testing Strategy

The project uses **JUnit 5** to test:

* Contact creation
* Optional-based lookups
* Update behavior
* Delete behavior
* Validation failures

### Key Testing Focus Areas

* `Optional.isPresent()` vs `Optional.isEmpty()`
* Verifying updated state
* Ensuring invalid inputs are rejected
* Ensuring not-found cases are handled safely

Example:

```java
@Test
void shouldReturnEmptyOptionalForInvalidId() {
    var result = service.getContactById("invalid-id");
    assertTrue(result.isEmpty());
}
```
