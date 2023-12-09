package com.cankaya.rabbitmqconsumer;

public record UserRegisteredPayload (String fullName, String emailAddress, int confirmationCode) {

}