package com.cankaya.rabbitmqexample;

public record UserRegisteredPayload (String fullName, String emailAddress, int confirmationCode) {

}